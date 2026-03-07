import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const SOURCE_FILE = path.resolve(__dirname, '../data/title-source.json');
const TITLE_FILE = path.resolve(__dirname, '../src/title/title-cn.opy');
const ENV_FILE = path.resolve(__dirname, '../src/env/env.opy');
const WEB_OUTPUT_FILE = path.resolve(__dirname, '../web/title-query/public/data/titles.json');

const ENUM_BEGIN = '# BEGIN AUTO-GENERATED TITLE ENUM';
const ENUM_END = '# END AUTO-GENERATED TITLE ENUM';
const PLAYER_DB_BEGIN = '# BEGIN AUTO-GENERATED TITLE PLAYER DATABASE';
const PLAYER_DB_END = '# END AUTO-GENERATED TITLE PLAYER DATABASE';
const ALL_TITLE_BEGIN = '    # BEGIN AUTO-GENERATED ALL_TITLE';
const ALL_TITLE_END = '    # END AUTO-GENERATED ALL_TITLE';

function escapeRegex(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function ensureString(value, message) {
  if (typeof value !== 'string' || value.trim() === '') {
    throw new Error(message);
  }
}

function parseMainVersion(source) {
  const match = source.match(/^#!define\s+VERSION\s+"([^"]+)"/m);
  if (!match) {
    throw new Error('Unable to parse VERSION from src/env/env.opy');
  }

  return match[1];
}

function validateSourceShape(sourceData) {
  if (!sourceData || typeof sourceData !== 'object') {
    throw new Error('Title source must be a JSON object.');
  }

  if (!Array.isArray(sourceData.titles) || sourceData.titles.length === 0) {
    throw new Error('title-source.json must include a non-empty titles array.');
  }

  if (!Array.isArray(sourceData.players)) {
    throw new Error('title-source.json must include a players array.');
  }

  if (!sourceData.meta || typeof sourceData.meta !== 'object') {
    throw new Error('title-source.json must include a meta object.');
  }

  ensureString(sourceData.meta.sourceLabel, 'meta.sourceLabel is required.');

  const titleKeys = new Set();
  const titles = sourceData.titles.map((title, index) => {
    if (!title || typeof title !== 'object') {
      throw new Error(`titles[${index}] must be an object.`);
    }

    ensureString(title.key, `titles[${index}].key is required.`);
    ensureString(title.label, `titles[${index}].label is required.`);
    ensureString(title.category, `titles[${index}].category is required.`);
    ensureString(title.condition, `titles[${index}].condition is required.`);
    ensureString(title.displayExpr, `titles[${index}].displayExpr is required.`);
    ensureString(title.colorExpr, `titles[${index}].colorExpr is required.`);

    if (!['active', 'retired'].includes(title.availability)) {
      throw new Error(`titles[${index}].availability must be "active" or "retired".`);
    }

    if (titleKeys.has(title.key)) {
      throw new Error(`Duplicate title key detected: ${title.key}`);
    }

    titleKeys.add(title.key);

    return {
      id: index,
      key: title.key,
      label: title.label,
      category: title.category,
      condition: title.condition,
      availability: title.availability,
      displayExpr: title.displayExpr,
      colorExpr: title.colorExpr
    };
  });

  const playersByName = new Set();
  const players = sourceData.players.map((player, index) => {
    if (!player || typeof player !== 'object') {
      throw new Error(`players[${index}] must be an object.`);
    }

    ensureString(player.name, `players[${index}].name is required.`);

    if (playersByName.has(player.name)) {
      throw new Error(`Duplicate player name detected: ${player.name}`);
    }
    playersByName.add(player.name);

    if (!Array.isArray(player.titleKeys)) {
      throw new Error(`players[${index}].titleKeys must be an array.`);
    }

    const seen = new Set();
    const titleKeysForPlayer = player.titleKeys.map((key, keyIndex) => {
      ensureString(key, `players[${index}].titleKeys[${keyIndex}] must be a non-empty string.`);

      if (!titleKeys.has(key)) {
        throw new Error(`Unknown title key ${key} in player ${player.name}.`);
      }

      if (seen.has(key)) {
        throw new Error(`Duplicate title key ${key} in player ${player.name}.`);
      }
      seen.add(key);

      return key;
    });

    return {
      name: player.name,
      titleKeys: titleKeysForPlayer
    };
  });

  return {
    meta: {
      sourceLabel: sourceData.meta.sourceLabel
    },
    titles,
    players
  };
}

function renderTitleEnum(titles) {
  const lines = [];
  lines.push(ENUM_BEGIN);
  lines.push('enum TITLE:');

  for (let index = 0; index < titles.length; index += 1) {
    const title = titles[index];
    const suffix = index === titles.length - 1 ? '' : ',';
    lines.push(`    ${title.key}${suffix.padEnd(Math.max(1, 18 - title.key.length), ' ')}# ${index} ${title.label}`);
  }

  lines.push(ENUM_END);
  return lines.join('\n');
}

function renderPlayerDatabase(titles, players) {
  const allKeys = titles.map((title) => `TITLE.${title.key}`).join(', ');
  const lines = [];

  lines.push(PLAYER_DB_BEGIN);
  lines.push(`#!define TP_ALL [${allKeys}]`);
  lines.push('#!define player_database [ \\');

  players.forEach((player, index) => {
    const isLast = index === players.length - 1;
    const titleExpr = player.titleKeys.length ? `[${player.titleKeys.map((key) => `TITLE.${key}`).join(', ')}]` : '[]';

    lines.push('    { \\');
    lines.push(`        name: "${player.name}", \\`);
    lines.push(`        titles: ${titleExpr} \\`);
    lines.push(isLast ? '    } \\' : '    }, \\');
  });

  lines.push(']');
  lines.push(PLAYER_DB_END);
  return lines.join('\n');
}

function renderAllTitleAssignment(titles) {
  const lines = [];

  lines.push(ALL_TITLE_BEGIN);
  lines.push('    allTitle = [');
  titles.forEach((title, index) => {
    const suffix = index === titles.length - 1 ? '' : ',';
    lines.push(`        # ${index}: ${title.key}`);
    lines.push(`        [${title.displayExpr}, ${title.colorExpr}]${suffix}`);
  });
  lines.push('    ]');
  lines.push(ALL_TITLE_END);

  return lines.join('\n');
}

function replaceManagedBlock(source, beginMarker, endMarker, blockContent) {
  const pattern = new RegExp(`${escapeRegex(beginMarker)}[\\s\\S]*?${escapeRegex(endMarker)}`);

  if (!pattern.test(source)) {
    return null;
  }

  return source.replace(pattern, blockContent);
}

function applyManagedTitleFile(source, data) {
  const enumBlock = renderTitleEnum(data.titles);
  const dbBlock = renderPlayerDatabase(data.titles, data.players);
  const allTitleBlock = renderAllTitleAssignment(data.titles);

  let next = source;

  const replacedEnum = replaceManagedBlock(next, ENUM_BEGIN, ENUM_END, enumBlock);
  if (replacedEnum === null) {
    next = next.replace(/enum TITLE:[\s\S]*?(?=\nenum MapTITLEKey:)/, `${enumBlock}\n\n`);
  } else {
    next = replacedEnum;
  }

  const replacedDb = replaceManagedBlock(next, PLAYER_DB_BEGIN, PLAYER_DB_END, dbBlock);
  if (replacedDb === null) {
    next = next.replace(
      /#!define TP_ALL[\s\S]*?(?=\n\n# ------------------------------\n# 3\. 定义地图数据宏 \(Map Macros\))/,
      `${dbBlock}\n\n`
    );
  } else {
    next = replacedDb;
  }

  const replacedAllTitle = replaceManagedBlock(next, ALL_TITLE_BEGIN, ALL_TITLE_END, allTitleBlock);
  if (replacedAllTitle === null) {
    next = next.replace(/\n    allTitle = \[[\s\S]*?\n    \]\n(?=    splitDictArray\()/, `\n${allTitleBlock}\n`);
  } else {
    next = replacedAllTitle;
  }

  return next;
}

function buildWebPayload(data, sourceVersion) {
  const titleIdByKey = new Map(data.titles.map((title) => [title.key, title.id]));
  const players = [...data.players]
    .sort((left, right) => left.name.localeCompare(right.name, 'zh-Hans-CN'))
    .map((player) => {
      const titleIds = player.titleKeys.map((key) => titleIdByKey.get(key));
      return {
        name: player.name,
        titleIds,
        titleCount: titleIds.length
      };
    });

  return {
    titles: data.titles.map((title) => ({
      id: title.id,
      key: title.key,
      label: title.label,
      category: title.category,
      condition: title.condition,
      availability: title.availability
    })),
    players,
    meta: {
      sourceFile: 'data/title-source.json',
      generatedAt: new Date().toISOString(),
      titleCount: data.titles.length,
      playerCount: players.length,
      sourceLabel: data.meta.sourceLabel,
      sourceVersion
    }
  };
}

export async function loadTitleSource(sourceFile = SOURCE_FILE) {
  const sourceText = await fs.readFile(sourceFile, 'utf8');
  const sourceData = JSON.parse(sourceText);
  return validateSourceShape(sourceData);
}

export async function syncTitleData({
  sourceFile = SOURCE_FILE,
  titleFile = TITLE_FILE,
  envFile = ENV_FILE,
  webOutputFile = WEB_OUTPUT_FILE,
  dryRun = false
} = {}) {
  const [sourceData, titleSource, envSource] = await Promise.all([
    loadTitleSource(sourceFile),
    fs.readFile(titleFile, 'utf8'),
    fs.readFile(envFile, 'utf8')
  ]);

  const sourceVersion = parseMainVersion(envSource);
  const nextTitleFile = applyManagedTitleFile(titleSource, sourceData);
  const webPayload = buildWebPayload(sourceData, sourceVersion);
  const webText = `${JSON.stringify(webPayload, null, 2)}\n`;

  if (!dryRun) {
    await fs.writeFile(titleFile, nextTitleFile, 'utf8');
    await fs.mkdir(path.dirname(webOutputFile), { recursive: true });
    await fs.writeFile(webOutputFile, webText, 'utf8');
  }

  return {
    sourceData,
    webPayload,
    titleFileChanged: nextTitleFile !== titleSource,
    sourceVersion
  };
}

export async function generateTitleQueryData({
  sourceFile = SOURCE_FILE,
  envFile = ENV_FILE,
  outputFile = WEB_OUTPUT_FILE
} = {}) {
  const data = await loadTitleSource(sourceFile);
  const envSource = await fs.readFile(envFile, 'utf8');
  const sourceVersion = parseMainVersion(envSource);
  const payload = buildWebPayload(data, sourceVersion);

  await fs.mkdir(path.dirname(outputFile), { recursive: true });
  await fs.writeFile(outputFile, `${JSON.stringify(payload, null, 2)}\n`, 'utf8');

  return payload;
}

const invokedPath = process.argv[1] ? path.resolve(process.argv[1]) : null;

if (invokedPath === __filename) {
  syncTitleData()
    .then(({ webPayload }) => {
      console.log(
        `Synced ${webPayload.meta.playerCount} players and ${webPayload.meta.titleCount} titles from data/title-source.json`
      );
    })
    .catch((error) => {
      console.error(error.message);
      process.exitCode = 1;
    });
}
