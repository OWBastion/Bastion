import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const SOURCE_FILE = path.resolve(__dirname, '../data/title-source.json');
const TITLE_FILE = path.resolve(__dirname, '../src/title/title-cn.opy');
const ENV_FILE = path.resolve(__dirname, '../src/env/env.opy');
const WEB_OUTPUT_FILE = path.resolve(__dirname, '../web/title-query/public/data/titles.json');
const PLAYER_NAME_TO_INDEX_FILE = path.resolve(__dirname, '../src/tools/playerNameToIndex.js');
const PLAYER_NAME_TO_INDEX_DELIMITED_FILE = path.resolve(__dirname, '../src/tools/playerNameToIndexDelimited.js');

const ENUM_BEGIN = '# BEGIN AUTO-GENERATED TITLE ENUM';
const ENUM_END = '# END AUTO-GENERATED TITLE ENUM';
const PLAYER_DB_BEGIN = '# BEGIN AUTO-GENERATED TITLE PLAYER DATABASE';
const PLAYER_DB_END = '# END AUTO-GENERATED TITLE PLAYER DATABASE';
const ALL_TITLE_BEGIN = '    # BEGIN AUTO-GENERATED ALL_TITLE';
const ALL_TITLE_END = '    # END AUTO-GENERATED ALL_TITLE';
const MAP_DATA_BEGIN = '# BEGIN AUTO-GENERATED MAP_TITLE_DATA';
const MAP_DATA_END = '# END AUTO-GENERATED MAP_TITLE_DATA';

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

function ensureNoDuplicate(items, label) {
  const seen = new Set();
  for (const item of items) {
    if (seen.has(item)) {
      throw new Error(`Duplicate ${label}: ${item}`);
    }
    seen.add(item);
  }
}

function normalizeTitleTags(tags, index) {
  if (tags == null) {
    return [];
  }

  if (!Array.isArray(tags)) {
    throw new Error(`titles[${index}].tags must be an array of non-empty strings when provided.`);
  }

  const normalizedTags = tags.map((tag, tagIndex) => {
    ensureString(tag, `titles[${index}].tags[${tagIndex}] must be a non-empty string.`);
    return tag.trim();
  });

  ensureNoDuplicate(normalizedTags, `tag in titles[${index}]`);
  return normalizedTags;
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

  if (!Array.isArray(sourceData.mapTitles)) {
    throw new Error('title-source.json must include a mapTitles array.');
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
    const tags = normalizeTitleTags(title.tags, index);

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
      tags,
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

    ensureNoDuplicate(player.titleKeys, `title key in player ${player.name}`);

    const titleKeysForPlayer = player.titleKeys.map((key, keyIndex) => {
      ensureString(key, `players[${index}].titleKeys[${keyIndex}] must be a non-empty string.`);

      if (!titleKeys.has(key)) {
        throw new Error(`Unknown title key ${key} in player ${player.name}.`);
      }

      return key;
    });

    return {
      name: player.name,
      titleKeys: titleKeysForPlayer
    };
  });

  const playerNameSet = new Set(players.map((player) => player.name));
  const mapKeySet = new Set();
  const mapTitles = sourceData.mapTitles.map((mapItem, index) => {
    if (!mapItem || typeof mapItem !== 'object') {
      throw new Error(`mapTitles[${index}] must be an object.`);
    }

    ensureString(mapItem.mapKey, `mapTitles[${index}].mapKey is required.`);
    ensureString(mapItem.mapLabel, `mapTitles[${index}].mapLabel is required.`);

    if (!/^DATA_[A-Z0-9_]+$/.test(mapItem.mapKey)) {
      throw new Error(`mapTitles[${index}].mapKey must match DATA_*: ${mapItem.mapKey}`);
    }

    if (mapKeySet.has(mapItem.mapKey)) {
      throw new Error(`Duplicate map key detected: ${mapItem.mapKey}`);
    }
    mapKeySet.add(mapItem.mapKey);

    const holders = mapItem.holders;
    if (!holders || typeof holders !== 'object') {
      throw new Error(`mapTitles[${index}].holders must be an object.`);
    }

    const slots = ['PIONEER', 'CONQUEROR', 'DOMINATOR'];
    const normalizedHolders = {};

    for (const slot of slots) {
      if (!Array.isArray(holders[slot])) {
        throw new Error(`mapTitles[${index}].holders.${slot} must be an array.`);
      }

      const slotNames = holders[slot].map((name, slotIndex) => {
        ensureString(name, `mapTitles[${index}].holders.${slot}[${slotIndex}] must be a non-empty string.`);

        if (!playerNameSet.has(name)) {
          throw new Error(`Unknown player ${name} in ${mapItem.mapKey}.${slot}`);
        }

        return name;
      });

      ensureNoDuplicate(slotNames, `player name in ${mapItem.mapKey}.${slot}`);
      normalizedHolders[slot] = slotNames;
    }

    const conquerorSet = new Set(normalizedHolders.CONQUEROR);
    for (const dominatorName of normalizedHolders.DOMINATOR) {
      if (!conquerorSet.has(dominatorName)) {
        throw new Error(`${mapItem.mapKey}: DOMINATOR holder ${dominatorName} must also be in CONQUEROR.`);
      }
    }

    return {
      mapKey: mapItem.mapKey,
      mapLabel: mapItem.mapLabel,
      holders: normalizedHolders
    };
  });

  return {
    meta: {
      sourceLabel: sourceData.meta.sourceLabel
    },
    titles,
    players,
    mapTitles
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

function renderDelimitedNames(names) {
  if (!names.length) {
    return '[]';
  }

  const quoted = names.map((name) => JSON.stringify(name)).join(', ');
  return `playerNameToIndexDelimited([${quoted}], "-")`;
}

function renderMapTitleData(mapTitles) {
  const lines = [];
  lines.push('# 地图数据块 (Data Blocks)');
  lines.push(MAP_DATA_BEGIN);

  mapTitles.forEach((mapItem, index) => {
    if (index > 0) {
      lines.push('');
    }

    lines.push(`# ${mapItem.mapLabel}`);
    lines.push(`#!define ${mapItem.mapKey} [ \\`);
    lines.push(`   ${renderDelimitedNames(mapItem.holders.PIONEER)}, \\`);
    lines.push(`   ${renderDelimitedNames(mapItem.holders.CONQUEROR)}, \\`);
    lines.push(`   ${renderDelimitedNames(mapItem.holders.DOMINATOR)}\\`);
    lines.push(']');
  });

  lines.push(MAP_DATA_END);
  return lines.join('\n');
}

function renderPlayerIndexScript(players, { delimited }) {
  const names = players.map((player) => player.name);
  const quotedNames = names.map((name) => `  ${JSON.stringify(name)}`).join(',\n');
  const lines = [];

  lines.push('const TITLE_PLAYER_NAMES = [');
  lines.push(quotedNames);
  lines.push('];');
  lines.push('');
  lines.push('const titleIndexByName = Object.fromEntries(');
  lines.push('  TITLE_PLAYER_NAMES.map((name, index) => [name, index])');
  lines.push(');');
  lines.push('');
  lines.push('const indices = names');
  lines.push('  .map((name) => titleIndexByName[name])');
  lines.push(`  .filter((index) => index !== undefined)${delimited ? '' : '.sort((left, right) => left - right);'}`);

  if (!delimited) {
    lines.push('');
    lines.push('JSON.stringify(indices);');
    return `${lines.join('\n')}\n`;
  }
  lines.push('');
  lines.push('const delimiter = sep == null || sep === "" ? "-" : sep;');
  lines.push('');
  lines.push('JSON.stringify(indices.join(delimiter));');

  return `${lines.join('\n')}\n`;
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
  const mapDataBlock = renderMapTitleData(data.mapTitles);

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

  const replacedMap = replaceManagedBlock(next, MAP_DATA_BEGIN, MAP_DATA_END, mapDataBlock);
  if (replacedMap === null) {
    next = next.replace(
      /# 地图数据块 \(Data Blocks\)[\s\S]*?(?=\n\n# ------------------------------\n# 4\. 初始化变量)/,
      mapDataBlock
    );
  } else {
    next = replacedMap;
  }
  next = next.replace(/(?:# 地图数据块 \(Data Blocks\)\n){2,}/g, '# 地图数据块 (Data Blocks)\n');

  const replacedAllTitle = replaceManagedBlock(next, ALL_TITLE_BEGIN, ALL_TITLE_END, allTitleBlock);
  if (replacedAllTitle === null) {
    next = next.replace(/\n    allTitle = \[[\s\S]*?\n    \]\n(?=    splitDictArray\()/, `\n${allTitleBlock}\n`);
  } else {
    next = replacedAllTitle;
  }

  return next;
}

function buildMapTitleStatus(mapTitles, playerName) {
  const status = {};

  for (const mapItem of mapTitles) {
    status[mapItem.mapKey] = {
      PIONEER: mapItem.holders.PIONEER.includes(playerName),
      CONQUEROR: mapItem.holders.CONQUEROR.includes(playerName),
      DOMINATOR: mapItem.holders.DOMINATOR.includes(playerName)
    };
  }

  return status;
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
        titleCount: titleIds.length,
        mapTitleStatus: buildMapTitleStatus(data.mapTitles, player.name)
      };
    });

  return {
    titles: data.titles.map((title) => ({
      id: title.id,
      key: title.key,
      label: title.label,
      category: title.category,
      condition: title.condition,
      ...(title.tags.length ? { tags: title.tags } : {}),
      availability: title.availability
    })),
    players,
    mapTitles: data.mapTitles.map((mapItem) => ({
      mapKey: mapItem.mapKey,
      mapLabel: mapItem.mapLabel,
      holders: mapItem.holders
    })),
    meta: {
      sourceFile: 'data/title-source.json',
      generatedAt: new Date().toISOString(),
      titleCount: data.titles.length,
      playerCount: players.length,
      mapTitleCount: data.mapTitles.length,
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
  playerNameToIndexFile = PLAYER_NAME_TO_INDEX_FILE,
  playerNameToIndexDelimitedFile = PLAYER_NAME_TO_INDEX_DELIMITED_FILE,
  dryRun = false
} = {}) {
  const [sourceData, titleSource, envSource, playerNameToIndexSource, playerNameToIndexDelimitedSource] = await Promise.all([
    loadTitleSource(sourceFile),
    fs.readFile(titleFile, 'utf8'),
    fs.readFile(envFile, 'utf8'),
    fs.readFile(playerNameToIndexFile, 'utf8'),
    fs.readFile(playerNameToIndexDelimitedFile, 'utf8')
  ]);

  const sourceVersion = parseMainVersion(envSource);
  const nextTitleFile = applyManagedTitleFile(titleSource, sourceData);
  const webPayload = buildWebPayload(sourceData, sourceVersion);
  const webText = `${JSON.stringify(webPayload, null, 2)}\n`;
  const nextPlayerNameToIndexFile = renderPlayerIndexScript(sourceData.players, { delimited: false });
  const nextPlayerNameToIndexDelimitedFile = renderPlayerIndexScript(sourceData.players, { delimited: true });

  if (!dryRun) {
    await fs.writeFile(titleFile, nextTitleFile, 'utf8');
    await fs.mkdir(path.dirname(webOutputFile), { recursive: true });
    await fs.writeFile(webOutputFile, webText, 'utf8');
    await fs.writeFile(playerNameToIndexFile, nextPlayerNameToIndexFile, 'utf8');
    await fs.writeFile(playerNameToIndexDelimitedFile, nextPlayerNameToIndexDelimitedFile, 'utf8');
  }

  return {
    sourceData,
    webPayload,
    titleFileChanged: nextTitleFile !== titleSource,
    playerNameToIndexFileChanged: nextPlayerNameToIndexFile !== playerNameToIndexSource,
    playerNameToIndexDelimitedFileChanged: nextPlayerNameToIndexDelimitedFile !== playerNameToIndexDelimitedSource,
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
        `Synced ${webPayload.meta.playerCount} players, ${webPayload.meta.titleCount} titles and ${webPayload.meta.mapTitleCount} map title sets from data/title-source.json`
      );
    })
    .catch((error) => {
      console.error(error.message);
      process.exitCode = 1;
    });
}
