import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { generateEventQueryData } from './sync-event-data.ts';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const SOURCE_FILE = path.resolve(__dirname, '../data/effect-glossary-source.json');
const EVENT_SOURCE_FILE = path.resolve(__dirname, '../data/event-source.json');
const ENV_FILE = path.resolve(__dirname, '../src/env/env.opy');
const EVENT_CONFIG_FILE = path.resolve(__dirname, '../src/config/eventConfig.opy');
const EVENT_CONFIG_DEV_FILE = path.resolve(__dirname, '../src/config/eventConfigDev.opy');
const EVENT_CONSTANTS_FILE = path.resolve(__dirname, '../src/constants/event_constants.opy');
const WEB_OUTPUT_FILE = path.resolve(__dirname, '../web/title-query/public/data/glossary.json');

function ensureString(value: unknown, message: string) {
  if (typeof value !== 'string' || value.trim() === '') {
    throw new Error(message);
  }
}

function ensureNoDuplicate(items: string[], label: string) {
  const seen = new Set<string>();
  for (const item of items) {
    if (seen.has(item)) {
      throw new Error(`Duplicate ${label}: ${item}`);
    }
    seen.add(item);
  }
}

function escapeRegExp(text: string) {
  return text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function isAsciiWord(text: string) {
  return /^[A-Za-z0-9_ ]+$/.test(text);
}

function matchAliasInText(haystack: string, alias: string) {
  if (!alias) {
    return false;
  }

  if (isAsciiWord(alias)) {
    const pattern = new RegExp(`(^|[^A-Za-z0-9_])${escapeRegExp(alias)}(?=$|[^A-Za-z0-9_])`, 'i');
    return pattern.test(haystack);
  }

  return haystack.includes(alias);
}

function normalizeAliases(rawAliases: unknown, termIndex: number) {
  if (rawAliases == null) {
    return [];
  }

  if (!Array.isArray(rawAliases)) {
    throw new Error(`terms[${termIndex}].aliases must be an array when provided.`);
  }

  const aliases = rawAliases.map((alias, aliasIndex) => {
    ensureString(alias, `terms[${termIndex}].aliases[${aliasIndex}] must be a non-empty string.`);
    const normalized = alias.trim();
    if (normalized.length <= 1) {
      throw new Error(`terms[${termIndex}].aliases[${aliasIndex}] cannot be a single-character alias.`);
    }
    return normalized;
  });

  ensureNoDuplicate(aliases, `alias in terms[${termIndex}]`);
  return aliases;
}

function normalizeRules(rawRules: unknown, termIndex: number) {
  if (rawRules == null) {
    return [];
  }

  if (!Array.isArray(rawRules)) {
    throw new Error(`terms[${termIndex}].rules must be an array when provided.`);
  }

  return rawRules.map((rule, ruleIndex) => {
    ensureString(rule, `terms[${termIndex}].rules[${ruleIndex}] must be a non-empty string.`);
    return rule.trim();
  });
}

function normalizeManualRelatedEventKeys(rawKeys: unknown, termIndex: number) {
  if (rawKeys == null) {
    return [];
  }

  if (!Array.isArray(rawKeys)) {
    throw new Error(`terms[${termIndex}].manualRelatedEventKeys must be an array when provided.`);
  }

  const keys = rawKeys.map((key, keyIndex) => {
    ensureString(key, `terms[${termIndex}].manualRelatedEventKeys[${keyIndex}] must be a non-empty string.`);
    return key.trim();
  });

  ensureNoDuplicate(keys, `manual related event key in terms[${termIndex}]`);
  return keys;
}

type GlossaryTermSource = {
  key: string;
  nameZh: string;
  aliases: string[];
  category: string;
  summary: string;
  definition: string;
  rules: string[];
  manualRelatedEventKeys: string[];
};

type GlossarySource = {
  meta: {
    sourceLabel: string;
    sourceVersion: string;
    updatedAt: string;
  };
  terms: GlossaryTermSource[];
};

function validateGlossarySourceShape(rawSource: unknown): GlossarySource {
  if (!rawSource || typeof rawSource !== 'object') {
    throw new Error('effect-glossary-source.json must be a JSON object.');
  }

  const source = rawSource as {
    meta?: { sourceLabel?: unknown; sourceVersion?: unknown; updatedAt?: unknown };
    terms?: unknown;
  };
  if (!source.meta || typeof source.meta !== 'object') {
    throw new Error('effect-glossary-source.json must include a meta object.');
  }

  ensureString(source.meta.sourceLabel, 'meta.sourceLabel is required.');
  ensureString(source.meta.sourceVersion, 'meta.sourceVersion is required.');
  ensureString(source.meta.updatedAt, 'meta.updatedAt is required.');

  if (!Array.isArray(source.terms) || source.terms.length === 0) {
    throw new Error('effect-glossary-source.json must include a non-empty terms array.');
  }

  const keys = new Set<string>();
  const names = new Set<string>();
  const terms = source.terms.map((term, index) => {
    if (!term || typeof term !== 'object') {
      throw new Error(`terms[${index}] must be an object.`);
    }

    const termObject = term as {
      key?: unknown;
      nameZh?: unknown;
      aliases?: unknown;
      category?: unknown;
      summary?: unknown;
      definition?: unknown;
      rules?: unknown;
      manualRelatedEventKeys?: unknown;
    };
    ensureString(termObject.key, `terms[${index}].key is required.`);
    ensureString(termObject.nameZh, `terms[${index}].nameZh is required.`);
    ensureString(termObject.category, `terms[${index}].category is required.`);
    ensureString(termObject.summary, `terms[${index}].summary is required.`);
    ensureString(termObject.definition, `terms[${index}].definition is required.`);

    const key = termObject.key.trim();
    const nameZh = termObject.nameZh.trim();
    if (keys.has(key)) {
      throw new Error(`Duplicate term key detected: ${key}`);
    }
    if (names.has(nameZh)) {
      throw new Error(`Duplicate term nameZh detected: ${nameZh}`);
    }
    keys.add(key);
    names.add(nameZh);

    const aliases = normalizeAliases(termObject.aliases, index);
    const rules = normalizeRules(termObject.rules, index);
    const manualRelatedEventKeys = normalizeManualRelatedEventKeys(termObject.manualRelatedEventKeys, index);

    return {
      key,
      nameZh,
      aliases,
      category: termObject.category.trim(),
      summary: termObject.summary.trim(),
      definition: termObject.definition.trim(),
      rules,
      manualRelatedEventKeys
    };
  });

  return {
    meta: {
      sourceLabel: source.meta.sourceLabel.trim(),
      sourceVersion: source.meta.sourceVersion.trim(),
      updatedAt: source.meta.updatedAt.trim()
    },
    terms
  };
}

function buildRelatedPayload(glossarySource: GlossarySource, eventsPayload: Awaited<ReturnType<typeof generateEventQueryData>>) {
  const eventByKey = new Map(eventsPayload.events.map((eventItem) => [eventItem.key, eventItem]));
  const packLabelById = new Map(eventsPayload.packs.map((pack) => [pack.id, pack.labelZh]));

  for (const term of glossarySource.terms) {
    for (const eventKey of term.manualRelatedEventKeys) {
      if (!eventByKey.has(eventKey)) {
        throw new Error(`manualRelatedEventKeys contains unknown event key ${eventKey} in term ${term.key}.`);
      }
    }
  }

  const aliasEntriesByTerm = new Map<string, string[]>();
  for (const term of glossarySource.terms) {
    aliasEntriesByTerm.set(term.key, [term.nameZh, ...term.aliases].sort((left, right) => right.length - left.length));
  }

  const termToEventKeys = new Map<string, Set<string>>();
  const eventToTermKeys = new Map<string, Set<string>>();
  for (const term of glossarySource.terms) {
    termToEventKeys.set(term.key, new Set(term.manualRelatedEventKeys));
  }

  for (const eventItem of eventsPayload.events) {
    const searchableText = [eventItem.nameZh, eventItem.descZhCompiled, ...(eventItem.tags || [])].join(' | ');

    for (const term of glossarySource.terms) {
      const aliases = aliasEntriesByTerm.get(term.key) || [];
      const matched = aliases.some((alias) => matchAliasInText(searchableText, alias));

      if (!matched) {
        continue;
      }

      termToEventKeys.get(term.key)?.add(eventItem.key);
      const bucket = eventToTermKeys.get(eventItem.key);
      if (bucket) {
        bucket.add(term.key);
      } else {
        eventToTermKeys.set(eventItem.key, new Set([term.key]));
      }
    }
  }

  for (const term of glossarySource.terms) {
    for (const eventKey of term.manualRelatedEventKeys) {
      const bucket = eventToTermKeys.get(eventKey);
      if (bucket) {
        bucket.add(term.key);
      } else {
        eventToTermKeys.set(eventKey, new Set([term.key]));
      }
    }
  }

  const terms = glossarySource.terms
    .map((term) => {
      const relatedEvents = [...(termToEventKeys.get(term.key) || [])]
        .map((eventKey) => eventByKey.get(eventKey))
        .filter((eventItem): eventItem is NonNullable<typeof eventItem> => Boolean(eventItem))
        .sort((left, right) => {
          if (left.pack !== right.pack) {
            return left.pack - right.pack;
          }
          if (left.type !== right.type) {
            return left.type.localeCompare(right.type);
          }
          return left.id - right.id;
        })
        .map((eventItem) => ({
          key: eventItem.key,
          type: eventItem.type,
          id: eventItem.id,
          pack: eventItem.pack,
          packLabelZh: packLabelById.get(eventItem.pack) || `随机事件包 ${eventItem.pack}`,
          nameZh: eventItem.nameZh,
          descZhCompiled: eventItem.descZhCompiled,
          durationSec: eventItem.durationSec,
          weight: eventItem.weight,
          availability: eventItem.availability
        }));

      return {
        key: term.key,
        nameZh: term.nameZh,
        aliases: term.aliases,
        category: term.category,
        summary: term.summary,
        definition: term.definition,
        rules: term.rules,
        relatedEvents
      };
    })
    .sort((left, right) => left.nameZh.localeCompare(right.nameZh, 'zh-Hans-CN'));

  const eventTermsIndex = Object.fromEntries(
    [...eventToTermKeys.entries()]
      .map(([eventKey, termKeys]) => [eventKey, [...termKeys].sort((left, right) => left.localeCompare(right))])
      .sort((left, right) => left[0].localeCompare(right[0]))
  );

  return {
    meta: {
      sourceFile: 'data/effect-glossary-source.json',
      generatedAt: new Date().toISOString(),
      sourceLabel: glossarySource.meta.sourceLabel,
      sourceVersion: eventsPayload.meta.sourceVersion,
      glossaryVersion: glossarySource.meta.sourceVersion,
      glossaryUpdatedAt: glossarySource.meta.updatedAt,
      totalTermCount: terms.length,
      linkedEventCount: Object.keys(eventTermsIndex).length
    },
    terms,
    eventTermsIndex
  };
}

export async function loadEffectGlossarySource(sourceFile = SOURCE_FILE) {
  const sourceText = await fs.readFile(sourceFile, 'utf8');
  const sourceData = JSON.parse(sourceText);
  return validateGlossarySourceShape(sourceData);
}

export async function generateEffectGlossaryData({
  sourceFile = SOURCE_FILE,
  eventSourceFile = EVENT_SOURCE_FILE,
  envFile = ENV_FILE,
  eventConfigFile = EVENT_CONFIG_FILE,
  eventConfigDevFile = EVENT_CONFIG_DEV_FILE,
  eventConstantsFile = EVENT_CONSTANTS_FILE,
  outputFile = WEB_OUTPUT_FILE
} = {}) {
  const [glossarySource, eventsPayload] = await Promise.all([
    loadEffectGlossarySource(sourceFile),
    generateEventQueryData({
      sourceFile: eventSourceFile,
      envFile,
      eventConfigFile,
      eventConfigDevFile,
      eventConstantsFile
    })
  ]);

  const payload = buildRelatedPayload(glossarySource, eventsPayload);
  await fs.mkdir(path.dirname(outputFile), { recursive: true });
  await fs.writeFile(outputFile, `${JSON.stringify(payload, null, 2)}\n`, 'utf8');
  return payload;
}

export async function syncEffectGlossaryData({
  sourceFile = SOURCE_FILE,
  eventSourceFile = EVENT_SOURCE_FILE,
  envFile = ENV_FILE,
  eventConfigFile = EVENT_CONFIG_FILE,
  eventConfigDevFile = EVENT_CONFIG_DEV_FILE,
  eventConstantsFile = EVENT_CONSTANTS_FILE,
  outputFile = WEB_OUTPUT_FILE,
  dryRun = false
} = {}) {
  const [glossarySource, eventsPayload] = await Promise.all([
    loadEffectGlossarySource(sourceFile),
    generateEventQueryData({
      sourceFile: eventSourceFile,
      envFile,
      eventConfigFile,
      eventConfigDevFile,
      eventConstantsFile
    })
  ]);
  const payload = buildRelatedPayload(glossarySource, eventsPayload);
  const outputText = `${JSON.stringify(payload, null, 2)}\n`;

  if (!dryRun) {
    await fs.mkdir(path.dirname(outputFile), { recursive: true });
    await fs.writeFile(outputFile, outputText, 'utf8');
  }

  return payload;
}

const invokedPath = process.argv[1] ? path.resolve(process.argv[1]) : null;

if (invokedPath === __filename) {
  syncEffectGlossaryData()
    .then((payload) => {
      console.log(`Synced ${payload.meta.totalTermCount} glossary terms from data/effect-glossary-source.json`);
    })
    .catch((error) => {
      console.error(error.message);
      process.exitCode = 1;
    });
}
