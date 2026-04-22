import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const SOURCE_FILE = path.resolve(__dirname, '../data/event-source.json');
const ENV_FILE = path.resolve(__dirname, '../src/env/env.opy');
const WEB_OUTPUT_FILE = path.resolve(__dirname, '../web/title-query/public/data/events.json');
const MANIFEST_OUTPUT_FILE = path.resolve(__dirname, '../src/constants/event_manifest.opy');
const EVENT_CONFIG_FILE = path.resolve(__dirname, '../src/config/eventConfig.opy');
const EVENT_CONFIG_DEV_FILE = path.resolve(__dirname, '../src/config/eventConfigDev.opy');
const EVENT_CONSTANTS_FILE = path.resolve(__dirname, '../src/constants/event_constants.opy');
const EVENT_ID_FILES = {
  buff: path.resolve(__dirname, '../src/constants/event_ids_buff.opy'),
  debuff: path.resolve(__dirname, '../src/constants/event_ids_debuff.opy'),
  mech: path.resolve(__dirname, '../src/constants/event_ids_mech.opy')
};
const EVENT_ENUM_NAMES = {
  buff: 'BuffEventId',
  debuff: 'DebuffEventId',
  mech: 'MechEventId'
};
const EVENT_TYPES = ['buff', 'debuff', 'mech'];
const ALLOWED_AVAILABILITY = new Set(['active', 'retired']);
const BUTTON_LABELS_ZH = {
  'Button.RELOAD': '换弹键',
  'Button.INTERACT': '互动键',
  'Button.JUMP': '跳跃键'
};

function ensureString(value, message) {
  if (typeof value !== 'string' || value.trim() === '') {
    throw new Error(message);
  }
}

function ensureInteger(value, message) {
  if (!Number.isInteger(value)) {
    throw new Error(message);
  }
}

function ensureFiniteNumber(value, message) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    throw new Error(message);
  }
}

function ensureNoDuplicate(items, label) {
  const seen = new Set();
  for (const item of items) {
    if (seen.has(item)) {
      throw new Error(`Duplicate ${label}: ${item}`);
    }
    seen.add(item);
  }
}

function parseMainVersion(source) {
  const match = source.match(/^#!define\s+VERSION\s+"([^"]+)"/m);
  if (!match) {
    throw new Error('Unable to parse VERSION from src/env/env.opy');
  }

  return match[1];
}

function parseEventEnumKeys(sourceText, enumName) {
  const marker = `enum ${enumName}:`;
  const start = sourceText.indexOf(marker);
  if (start < 0) {
    throw new Error(`Unable to find ${marker}`);
  }

  const lines = sourceText.slice(start + marker.length).split('\n');
  const keys = [];

  for (const line of lines) {
    const match = line.match(/^\s{4}([A-Z0-9_]+)(?:\s*=\s*\d+)?\s*$/);
    if (!match) {
      if (line.trim().startsWith('#!define')) {
        break;
      }
      continue;
    }

    const key = match[1];
    if (key === 'COUNT') {
      break;
    }
    keys.push(key);
  }

  if (keys.length === 0) {
    throw new Error(`No entries found in enum ${enumName}`);
  }

  return keys;
}

function parseConfigRegistrationKeys(configText) {
  const result = {
    buff: new Set(),
    debuff: new Set(),
    mech: new Set()
  };

  const patterns = [
    { type: 'buff', regex: /buffEvent\[\s*BuffEventId\.([A-Z0-9_]+)\s*\]\s*=/g },
    { type: 'debuff', regex: /debuffEvent\[\s*DebuffEventId\.([A-Z0-9_]+)\s*\]\s*=/g },
    { type: 'mech', regex: /mechEvent\[\s*MechEventId\.([A-Z0-9_]+)\s*\]\s*=/g }
  ];

  for (const { type, regex } of patterns) {
    for (const match of configText.matchAll(regex)) {
      result[type].add(match[1]);
    }
  }

  return result;
}

function splitTopLevelComma(text) {
  const items = [];
  let depthParen = 0;
  let depthBracket = 0;
  let depthBrace = 0;
  let start = 0;

  for (let index = 0; index < text.length; index += 1) {
    const char = text[index];

    if (char === '(') {
      depthParen += 1;
      continue;
    }
    if (char === ')') {
      depthParen = Math.max(0, depthParen - 1);
      continue;
    }
    if (char === '[') {
      depthBracket += 1;
      continue;
    }
    if (char === ']') {
      depthBracket = Math.max(0, depthBracket - 1);
      continue;
    }
    if (char === '{') {
      depthBrace += 1;
      continue;
    }
    if (char === '}') {
      depthBrace = Math.max(0, depthBrace - 1);
      continue;
    }
    if (char === ',' && depthParen === 0 && depthBracket === 0 && depthBrace === 0) {
      items.push(text.slice(start, index).trim());
      start = index + 1;
    }
  }

  const tail = text.slice(start).trim();
  if (tail.length > 0) {
    items.push(tail);
  }
  return items;
}

function parseEventDescriptionFormatArgs(configText) {
  const matchRegex = /(buffEvent|debuffEvent|mechEvent)\[\s*(BuffEventId|DebuffEventId|MechEventId)\.([A-Z0-9_]+)\s*\]\s*=\s*\[([\s\S]*?)\]/g;
  const result = new Map();

  for (const match of configText.matchAll(matchRegex)) {
    const eventKey = match[3];
    const fields = splitTopLevelComma(match[4]);
    if (fields.length < 2) {
      continue;
    }

    const descExpr = fields[1].replace(/\s+/g, ' ').trim();
    if (!descExpr.startsWith('STR_') || !descExpr.includes('_DESC')) {
      continue;
    }

    const formatMatch = descExpr.match(/^STR_[A-Z0-9_]+_DESC\.format\(([\s\S]*)\)$/);
    if (!formatMatch) {
      result.set(eventKey, []);
      continue;
    }

    result.set(eventKey, splitTopLevelComma(formatMatch[1]));
  }

  return result;
}

function parseEventConstantsRawMap(constantsText) {
  const constants = new Map();

  for (const line of constantsText.split('\n')) {
    const match = line.match(/^#!define\s+(EVT_[A-Z0-9_]+)\s+(.+)$/);
    if (!match) {
      continue;
    }

    const key = match[1];
    const expr = match[2].trim();
    constants.set(key, expr);
  }

  return constants;
}

function tokenizeMathExpression(expression) {
  const tokens = [];
  let index = 0;

  while (index < expression.length) {
    const char = expression[index];

    if (/\s/.test(char)) {
      index += 1;
      continue;
    }

    if ('+-*/(),'.includes(char)) {
      tokens.push({ type: char, value: char });
      index += 1;
      continue;
    }

    if (/[0-9.]/.test(char)) {
      let end = index + 1;
      while (end < expression.length && /[0-9.]/.test(expression[end])) {
        end += 1;
      }
      tokens.push({ type: 'number', value: Number(expression.slice(index, end)) });
      index = end;
      continue;
    }

    if (/[A-Za-z_]/.test(char)) {
      let end = index + 1;
      while (end < expression.length && /[A-Za-z0-9_.]/.test(expression[end])) {
        end += 1;
      }
      tokens.push({ type: 'identifier', value: expression.slice(index, end) });
      index = end;
      continue;
    }

    throw new Error(`Unsupported token "${char}" in expression: ${expression}`);
  }

  return tokens;
}

function evaluateNumericExpression(expression, resolveIdentifier) {
  const tokens = tokenizeMathExpression(expression);
  let cursor = 0;

  function peek() {
    return tokens[cursor] || null;
  }

  function consume(type) {
    const token = tokens[cursor];
    if (!token || token.type !== type) {
      throw new Error(`Expected token ${type} in expression: ${expression}`);
    }
    cursor += 1;
    return token;
  }

  function parseExpression() {
    let value = parseTerm();
    while (true) {
      const token = peek();
      if (!token || (token.type !== '+' && token.type !== '-')) {
        break;
      }
      cursor += 1;
      const rhs = parseTerm();
      value = token.type === '+' ? value + rhs : value - rhs;
    }
    return value;
  }

  function parseTerm() {
    let value = parseUnary();
    while (true) {
      const token = peek();
      if (!token || (token.type !== '*' && token.type !== '/')) {
        break;
      }
      cursor += 1;
      const rhs = parseUnary();
      value = token.type === '*' ? value * rhs : value / rhs;
    }
    return value;
  }

  function parseUnary() {
    const token = peek();
    if (token?.type === '+') {
      cursor += 1;
      return parseUnary();
    }
    if (token?.type === '-') {
      cursor += 1;
      return -parseUnary();
    }
    return parsePrimary();
  }

  function parsePrimary() {
    const token = peek();
    if (!token) {
      throw new Error(`Unexpected end of expression: ${expression}`);
    }

    if (token.type === 'number') {
      cursor += 1;
      return token.value;
    }

    if (token.type === '(') {
      consume('(');
      const value = parseExpression();
      consume(')');
      return value;
    }

    if (token.type === 'identifier') {
      cursor += 1;
      const identifier = token.value;
      if (peek()?.type === '(') {
        consume('(');
        const args = [];
        if (peek()?.type !== ')') {
          args.push(parseExpression());
          while (peek()?.type === ',') {
            consume(',');
            args.push(parseExpression());
          }
        }
        consume(')');

        if (identifier === 'percent') {
          if (args.length !== 1) {
            throw new Error(`percent() expects 1 argument: ${expression}`);
          }
          return args[0] * 100;
        }
        if (identifier === 'negToPos') {
          if (args.length !== 1) {
            throw new Error(`negToPos() expects 1 argument: ${expression}`);
          }
          return args[0] * -1;
        }
        throw new Error(`Unsupported function ${identifier} in expression: ${expression}`);
      }

      return resolveIdentifier(identifier);
    }

    throw new Error(`Unexpected token "${token.type}" in expression: ${expression}`);
  }

  const value = parseExpression();
  if (cursor !== tokens.length) {
    throw new Error(`Unexpected trailing tokens in expression: ${expression}`);
  }

  return value;
}

function formatCompiledValue(value) {
  if (typeof value === 'string') {
    return value;
  }

  if (!Number.isFinite(value)) {
    throw new Error(`Invalid numeric value in compiled event description: ${value}`);
  }

  if (Math.abs(value - Math.round(value)) < 1e-9) {
    return String(Math.round(value));
  }

  return value.toFixed(6).replace(/\.?0+$/, '');
}

function buildEventDescriptionCompiler({ eventConfigSource, eventConfigDevSource, eventConstantsSource }) {
  const prodArgs = parseEventDescriptionFormatArgs(eventConfigSource);
  const devArgs = parseEventDescriptionFormatArgs(eventConfigDevSource);
  const argsByEventKey = new Map(devArgs);
  for (const [eventKey, args] of prodArgs.entries()) {
    argsByEventKey.set(eventKey, args);
  }

  const rawConstants = parseEventConstantsRawMap(eventConstantsSource);
  const resolvedConstants = new Map();
  const resolving = new Set();

  function resolveConstant(name) {
    if (resolvedConstants.has(name)) {
      return resolvedConstants.get(name);
    }
    const expr = rawConstants.get(name);
    if (!expr) {
      throw new Error(`Missing constant ${name} required by event description compiler.`);
    }
    if (resolving.has(name)) {
      throw new Error(`Circular constant reference detected: ${name}`);
    }

    resolving.add(name);
    const value = evaluateNumericExpression(expr, (identifier) => {
      if (!identifier.startsWith('EVT_')) {
        throw new Error(`Unsupported identifier ${identifier} in constant ${name}`);
      }
      return resolveConstant(identifier);
    });
    resolving.delete(name);
    resolvedConstants.set(name, value);
    return value;
  }

  function evaluateFormatArgument(rawExpr) {
    const expr = String(rawExpr).trim();
    if (!expr) {
      return '';
    }
    if (BUTTON_LABELS_ZH[expr]) {
      return BUTTON_LABELS_ZH[expr];
    }

    const numericValue = evaluateNumericExpression(expr, (identifier) => {
      if (!identifier.startsWith('EVT_')) {
        throw new Error(`Unsupported identifier ${identifier} in format argument ${expr}`);
      }
      return resolveConstant(identifier);
    });
    return formatCompiledValue(numericValue);
  }

  function applyTemplate(template, eventKey, values) {
    const placeholderRegex = /\{(\d+)\}/g;
    let match;
    while ((match = placeholderRegex.exec(template)) != null) {
      const index = Number(match[1]);
      if (!Number.isInteger(index) || index < 0 || index >= values.length) {
        throw new Error(`Placeholder {${match[1]}} in ${eventKey} exceeds provided format args.`);
      }
    }

    return template.replace(placeholderRegex, (_, indexText) => values[Number(indexText)]);
  }

  return function compileDescription(eventItem) {
    const args = argsByEventKey.get(eventItem.key) ?? [];
    if (args.length === 0) {
      return eventItem.descZh;
    }

    const compiledValues = args.map((arg) => evaluateFormatArgument(arg));
    return applyTemplate(eventItem.descZh, eventItem.key, compiledValues);
  };
}

function normalizeTags(rawTags, eventIndex) {
  if (rawTags == null) {
    return [];
  }

  if (!Array.isArray(rawTags)) {
    throw new Error(`events[${eventIndex}].tags must be an array of non-empty strings when provided.`);
  }

  const tags = rawTags.map((tag, tagIndex) => {
    ensureString(tag, `events[${eventIndex}].tags[${tagIndex}] must be a non-empty string.`);
    return tag.trim();
  });

  ensureNoDuplicate(tags, `tag in events[${eventIndex}]`);
  return tags;
}

function validateEventSourceShape(sourceData) {
  if (!sourceData || typeof sourceData !== 'object') {
    throw new Error('event-source.json must be a JSON object.');
  }

  if (!sourceData.meta || typeof sourceData.meta !== 'object') {
    throw new Error('event-source.json must include a meta object.');
  }

  ensureString(sourceData.meta.sourceLabel, 'meta.sourceLabel is required.');
  ensureString(sourceData.meta.sourceVersion, 'meta.sourceVersion is required.');

  if (!Array.isArray(sourceData.packs) || sourceData.packs.length === 0) {
    throw new Error('event-source.json must include a non-empty packs array.');
  }

  if (!Array.isArray(sourceData.events) || sourceData.events.length === 0) {
    throw new Error('event-source.json must include a non-empty events array.');
  }

  const packIds = new Set();
  const packKeys = new Set();
  const packs = sourceData.packs.map((pack, index) => {
    if (!pack || typeof pack !== 'object') {
      throw new Error(`packs[${index}] must be an object.`);
    }

    ensureInteger(pack.id, `packs[${index}].id must be an integer.`);
    ensureString(pack.key, `packs[${index}].key is required.`);
    ensureString(pack.labelZh, `packs[${index}].labelZh is required.`);

    if (pack.id < 0) {
      throw new Error(`packs[${index}].id must be >= 0.`);
    }

    if (packIds.has(pack.id)) {
      throw new Error(`Duplicate pack id detected: ${pack.id}`);
    }
    if (packKeys.has(pack.key)) {
      throw new Error(`Duplicate pack key detected: ${pack.key}`);
    }
    packIds.add(pack.id);
    packKeys.add(pack.key);

    return {
      id: pack.id,
      key: pack.key.trim(),
      labelZh: pack.labelZh.trim()
    };
  });

  const eventKeySet = new Set();
  const typeIdSet = new Set();
  const events = sourceData.events.map((eventItem, index) => {
    if (!eventItem || typeof eventItem !== 'object') {
      throw new Error(`events[${index}] must be an object.`);
    }

    ensureString(eventItem.key, `events[${index}].key is required.`);
    ensureString(eventItem.type, `events[${index}].type is required.`);
    ensureInteger(eventItem.id, `events[${index}].id must be an integer.`);
    ensureInteger(eventItem.pack, `events[${index}].pack must be an integer.`);
    ensureString(eventItem.nameZh, `events[${index}].nameZh is required.`);
    ensureString(eventItem.descZh, `events[${index}].descZh is required.`);
    ensureFiniteNumber(eventItem.durationSec, `events[${index}].durationSec must be a finite number.`);
    ensureFiniteNumber(eventItem.weight, `events[${index}].weight must be a finite number.`);
    ensureString(eventItem.availability, `events[${index}].availability is required.`);

    if (!EVENT_TYPES.includes(eventItem.type)) {
      throw new Error(`events[${index}].type must be one of ${EVENT_TYPES.join(', ')}.`);
    }
    if (!ALLOWED_AVAILABILITY.has(eventItem.availability)) {
      throw new Error(`events[${index}].availability must be "active" or "retired".`);
    }
    if (!packIds.has(eventItem.pack)) {
      throw new Error(`events[${index}].pack references unknown pack id ${eventItem.pack}.`);
    }
    if (eventItem.id < 0) {
      throw new Error(`events[${index}].id must be >= 0.`);
    }

    const key = eventItem.key.trim();
    if (eventKeySet.has(key)) {
      throw new Error(`Duplicate event key detected: ${key}`);
    }
    eventKeySet.add(key);

    const typeId = `${eventItem.type}:${eventItem.id}`;
    if (typeIdSet.has(typeId)) {
      throw new Error(`Duplicate ${eventItem.type} id detected: ${eventItem.id}`);
    }
    typeIdSet.add(typeId);

    return {
      key,
      type: eventItem.type,
      id: eventItem.id,
      pack: eventItem.pack,
      nameZh: eventItem.nameZh.trim(),
      descZh: eventItem.descZh.trim(),
      durationSec: eventItem.durationSec,
      weight: eventItem.weight,
      availability: eventItem.availability,
      tags: normalizeTags(eventItem.tags, index)
    };
  });

  return {
    meta: {
      sourceLabel: sourceData.meta.sourceLabel.trim(),
      sourceVersion: sourceData.meta.sourceVersion.trim()
    },
    packs,
    events
  };
}

function indexSourceEventsByType(sourceData) {
  const byType = {
    buff: [],
    debuff: [],
    mech: []
  };

  for (const eventItem of sourceData.events) {
    byType[eventItem.type].push(eventItem);
  }

  for (const type of EVENT_TYPES) {
    byType[type].sort((left, right) => left.id - right.id);
  }

  return byType;
}

function ensureSourceMatchesEnums(sourceData, enumKeysByType) {
  const byType = indexSourceEventsByType(sourceData);

  for (const type of EVENT_TYPES) {
    const enumKeys = enumKeysByType[type];
    const sourceEvents = byType[type];

    if (enumKeys.length !== sourceEvents.length) {
      throw new Error(
        `${type}: event-source count (${sourceEvents.length}) does not match ${EVENT_ENUM_NAMES[type]} count (${enumKeys.length}).`
      );
    }

    for (const eventItem of sourceEvents) {
      const expectedKey = enumKeys[eventItem.id];
      if (expectedKey == null) {
        throw new Error(`${type}: event id ${eventItem.id} is out of enum range.`);
      }
      if (expectedKey !== eventItem.key) {
        throw new Error(
          `${type}: event id ${eventItem.id} key mismatch. expected ${expectedKey}, got ${eventItem.key}.`
        );
      }
    }
  }
}

function ensureSourceMatchesConfigRegistrations(sourceData, configRegistrations) {
  const activeByType = {
    buff: new Set(sourceData.events.filter((eventItem) => eventItem.type === 'buff' && eventItem.availability === 'active').map((eventItem) => eventItem.key)),
    debuff: new Set(sourceData.events.filter((eventItem) => eventItem.type === 'debuff' && eventItem.availability === 'active').map((eventItem) => eventItem.key)),
    mech: new Set(sourceData.events.filter((eventItem) => eventItem.type === 'mech' && eventItem.availability === 'active').map((eventItem) => eventItem.key))
  };

  for (const type of EVENT_TYPES) {
    const registered = configRegistrations[type];
    const active = activeByType[type];

    for (const key of registered) {
      if (!active.has(key)) {
        throw new Error(`${type}: ${key} is registered in config but missing or inactive in event-source.`);
      }
    }

    for (const key of active) {
      if (!registered.has(key)) {
        throw new Error(`${type}: ${key} is active in event-source but not registered in config.`);
      }
    }
  }
}

function buildWebPayload(sourceData, sourceVersion, compilerInputs) {
  const compileDescription = buildEventDescriptionCompiler(compilerInputs);
  const packById = new Map(sourceData.packs.map((pack) => [pack.id, pack]));
  const events = sourceData.events.map((eventItem) => ({
    key: eventItem.key,
    type: eventItem.type,
    id: eventItem.id,
    pack: eventItem.pack,
    nameZh: eventItem.nameZh,
    descZh: eventItem.descZh,
    descZhCompiled: compileDescription(eventItem),
    durationSec: eventItem.durationSec,
    weight: eventItem.weight,
    ...(eventItem.tags.length ? { tags: eventItem.tags } : {}),
    availability: eventItem.availability
  }));

  const packs = sourceData.packs
    .map((pack) => ({
      ...pack,
      events: events
        .filter((eventItem) => eventItem.pack === pack.id)
        .sort((left, right) => {
          if (left.type !== right.type) {
            return left.type.localeCompare(right.type);
          }
          return left.id - right.id;
        })
    }))
    .sort((left, right) => left.id - right.id)
    .map((pack) => ({
      id: pack.id,
      key: pack.key,
      labelZh: pack.labelZh,
      eventCount: pack.events.length,
      events: pack.events
    }));

  const activeEvents = events.filter((eventItem) => eventItem.availability === 'active');
  const countByType = (list, type) => list.filter((eventItem) => eventItem.type === type).length;

  return {
    meta: {
      sourceFile: 'data/event-source.json',
      generatedAt: new Date().toISOString(),
      sourceLabel: sourceData.meta.sourceLabel,
      sourceVersion,
      manifestVersion: sourceData.meta.sourceVersion,
      totalCount: events.length,
      activeCount: activeEvents.length,
      buffCount: countByType(events, 'buff'),
      debuffCount: countByType(events, 'debuff'),
      mechCount: countByType(events, 'mech')
    },
    packs,
    events
  };
}

function renderEventManifest(sourceData, sourceVersion) {
  const events = sourceData.events;
  const activeEvents = events.filter((eventItem) => eventItem.availability === 'active');
  const activeWeightSum = Number(
    activeEvents.reduce((sum, eventItem) => sum + eventItem.weight, 0).toFixed(3)
  );
  const totalByType = {
    buff: events.filter((eventItem) => eventItem.type === 'buff').length,
    debuff: events.filter((eventItem) => eventItem.type === 'debuff').length,
    mech: events.filter((eventItem) => eventItem.type === 'mech').length
  };
  const activeByType = {
    buff: activeEvents.filter((eventItem) => eventItem.type === 'buff').length,
    debuff: activeEvents.filter((eventItem) => eventItem.type === 'debuff').length,
    mech: activeEvents.filter((eventItem) => eventItem.type === 'mech').length
  };

  return [
    '#!mainFile "../main.opy"',
    '',
    '# Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.',
    '#!optimizeStrict',
    '',
    '# BEGIN AUTO-GENERATED EVENT MANIFEST',
    '# Source: data/event-source.json',
    `#!define EVENT_MANIFEST_SOURCE_LABEL "${sourceData.meta.sourceLabel}"`,
    `#!define EVENT_MANIFEST_SOURCE_VERSION "${sourceData.meta.sourceVersion}"`,
    `#!define EVENT_MANIFEST_MAIN_VERSION "${sourceVersion}"`,
    `#!define EVENT_MANIFEST_TOTAL_EVENTS ${events.length}`,
    `#!define EVENT_MANIFEST_ACTIVE_EVENTS ${activeEvents.length}`,
    `#!define EVENT_MANIFEST_TOTAL_BUFF_COUNT ${totalByType.buff}`,
    `#!define EVENT_MANIFEST_TOTAL_DEBUFF_COUNT ${totalByType.debuff}`,
    `#!define EVENT_MANIFEST_TOTAL_MECH_COUNT ${totalByType.mech}`,
    `#!define EVENT_MANIFEST_ACTIVE_BUFF_COUNT ${activeByType.buff}`,
    `#!define EVENT_MANIFEST_ACTIVE_DEBUFF_COUNT ${activeByType.debuff}`,
    `#!define EVENT_MANIFEST_ACTIVE_MECH_COUNT ${activeByType.mech}`,
    `#!define EVENT_MANIFEST_ACTIVE_WEIGHT_SUM ${activeWeightSum}`,
    '# END AUTO-GENERATED EVENT MANIFEST',
    ''
  ].join('\n');
}

export async function loadEventSource(sourceFile = SOURCE_FILE) {
  const sourceText = await fs.readFile(sourceFile, 'utf8');
  const sourceData = JSON.parse(sourceText);
  return validateEventSourceShape(sourceData);
}

export async function generateEventQueryData({
  sourceFile = SOURCE_FILE,
  envFile = ENV_FILE,
  eventConfigFile = EVENT_CONFIG_FILE,
  eventConfigDevFile = EVENT_CONFIG_DEV_FILE,
  eventConstantsFile = EVENT_CONSTANTS_FILE,
  outputFile = WEB_OUTPUT_FILE
} = {}) {
  const [sourceData, envSource, eventConfigSource, eventConfigDevSource, eventConstantsSource] = await Promise.all([
    loadEventSource(sourceFile),
    fs.readFile(envFile, 'utf8'),
    fs.readFile(eventConfigFile, 'utf8'),
    fs.readFile(eventConfigDevFile, 'utf8'),
    fs.readFile(eventConstantsFile, 'utf8')
  ]);
  const sourceVersion = parseMainVersion(envSource);
  const webPayload = buildWebPayload(sourceData, sourceVersion, {
    eventConfigSource,
    eventConfigDevSource,
    eventConstantsSource
  });

  await fs.mkdir(path.dirname(outputFile), { recursive: true });
  await fs.writeFile(outputFile, `${JSON.stringify(webPayload, null, 2)}\n`, 'utf8');

  return webPayload;
}

export async function syncEventData({
  sourceFile = SOURCE_FILE,
  envFile = ENV_FILE,
  webOutputFile = WEB_OUTPUT_FILE,
  manifestOutputFile = MANIFEST_OUTPUT_FILE,
  eventConfigFile = EVENT_CONFIG_FILE,
  eventConfigDevFile = EVENT_CONFIG_DEV_FILE,
  eventConstantsFile = EVENT_CONSTANTS_FILE,
  eventIdFiles = EVENT_ID_FILES,
  dryRun = false
} = {}) {
  const [sourceData, envSource, eventConfigSource, eventConfigDevSource, eventConstantsSource, ...eventIdSources] = await Promise.all([
    loadEventSource(sourceFile),
    fs.readFile(envFile, 'utf8'),
    fs.readFile(eventConfigFile, 'utf8'),
    fs.readFile(eventConfigDevFile, 'utf8'),
    fs.readFile(eventConstantsFile, 'utf8'),
    ...EVENT_TYPES.map((type) => fs.readFile(eventIdFiles[type], 'utf8'))
  ]);

  const sourceVersion = parseMainVersion(envSource);
  const enumKeysByType = {
    buff: parseEventEnumKeys(eventIdSources[0], EVENT_ENUM_NAMES.buff),
    debuff: parseEventEnumKeys(eventIdSources[1], EVENT_ENUM_NAMES.debuff),
    mech: parseEventEnumKeys(eventIdSources[2], EVENT_ENUM_NAMES.mech)
  };
  ensureSourceMatchesEnums(sourceData, enumKeysByType);

  const configRegistrationsProd = parseConfigRegistrationKeys(eventConfigSource);
  const configRegistrationsDev = parseConfigRegistrationKeys(eventConfigDevSource);
  const mergedRegistrations = {
    buff: new Set([...configRegistrationsProd.buff, ...configRegistrationsDev.buff]),
    debuff: new Set([...configRegistrationsProd.debuff, ...configRegistrationsDev.debuff]),
    mech: new Set([...configRegistrationsProd.mech, ...configRegistrationsDev.mech])
  };
  ensureSourceMatchesConfigRegistrations(sourceData, mergedRegistrations);

  const webPayload = buildWebPayload(sourceData, sourceVersion, {
    eventConfigSource,
    eventConfigDevSource,
    eventConstantsSource
  });
  const webText = `${JSON.stringify(webPayload, null, 2)}\n`;
  const manifestText = renderEventManifest(sourceData, sourceVersion);

  if (!dryRun) {
    await fs.mkdir(path.dirname(webOutputFile), { recursive: true });
    await fs.writeFile(webOutputFile, webText, 'utf8');
    await fs.writeFile(manifestOutputFile, manifestText, 'utf8');
  }

  return {
    sourceData,
    webPayload,
    manifestText,
    sourceVersion
  };
}

const invokedPath = process.argv[1] ? path.resolve(process.argv[1]) : null;

if (invokedPath === __filename) {
  syncEventData()
    .then(({ webPayload }) => {
      console.log(`Synced ${webPayload.meta.totalCount} events from data/event-source.json`);
    })
    .catch((error) => {
      console.error(error.message);
      process.exitCode = 1;
    });
}
