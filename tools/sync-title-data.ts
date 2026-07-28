import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const TITLE_FILE = path.resolve(__dirname, '../src/title/title-cn.opy');
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
const PLAYER_TITLE_SET_POOL_BEGIN = '# BEGIN AUTO-GENERATED PLAYER_TITLE_SET_POOL';
const PLAYER_TITLE_SET_POOL_END = '# END AUTO-GENERATED PLAYER_TITLE_SET_POOL';
const TITLE_AVAILABILITY = {
  ACTIVE: 'active',
  RETIRED: 'retired'
};
const ALLOWED_TITLE_AVAILABILITY = new Set(Object.values(TITLE_AVAILABILITY));

function escapeRegex(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function ensureString(value, message) {
  if (typeof value !== 'string' || value.trim() === '') {
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
    throw new Error('Platform title data must include a non-empty titles array.');
  }

  if (!Array.isArray(sourceData.players)) {
    throw new Error('Platform title data must include a players array.');
  }

  if (!Array.isArray(sourceData.mapTitles)) {
    throw new Error('Platform title data must include a mapTitles array.');
  }

  if (!sourceData.meta || typeof sourceData.meta !== 'object') {
    throw new Error('Platform title data must include a meta object.');
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

    if (!ALLOWED_TITLE_AVAILABILITY.has(title.availability)) {
      throw new Error(`titles[${index}].availability must be one of: ${Object.values(TITLE_AVAILABILITY).join(', ')}.`);
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

    if (player.allTitles !== undefined && typeof player.allTitles !== 'boolean') {
      throw new Error(`players[${index}].allTitles must be a boolean when provided.`);
    }

    const allTitles = player.allTitles === true;
    if (!allTitles && !Array.isArray(player.titleKeys)) {
      throw new Error(`players[${index}].titleKeys must be an array.`);
    }
    if (allTitles && player.titleKeys !== undefined) {
      throw new Error(`players[${index}] cannot define both allTitles and titleKeys.`);
    }

    const sourceTitleKeys = allTitles ? [...titleKeys] : player.titleKeys;
    ensureNoDuplicate(sourceTitleKeys, `title key in player ${player.name}`);

    const titleKeysForPlayer = sourceTitleKeys.map((key, keyIndex) => {
      ensureString(key, `players[${index}].titleKeys[${keyIndex}] must be a non-empty string.`);

      if (!titleKeys.has(key)) {
        throw new Error(`Unknown title key ${key} in player ${player.name}.`);
      }

      return key;
    });

    return {
      name: player.name,
      titleKeys: titleKeysForPlayer,
      allTitles
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

function buildPlayerTitleSets(titles, players) {
  const titleIdByKey = new Map(titles.map((title) => [title.key, title.id]));
  const titleKeyById = new Map(titles.map((title) => [title.id, title.key]));
  const titleSetIndexByIds = new Map();
  const titleSets = [];
  const playersWithTitleSetIndex = players.map((player) => {
    const sortedTitleIds = player.titleKeys
      .map((key) => titleIdByKey.get(key))
      .sort((left, right) => left - right);
    const titleSetKey = player.allTitles ? 'TP_ALL' : sortedTitleIds.join(',');
    let titleSetIndex = titleSetIndexByIds.get(titleSetKey);

    if (titleSetIndex == null) {
      titleSetIndex = titleSets.length;
      titleSetIndexByIds.set(titleSetKey, titleSetIndex);
      titleSets.push({
        allTitles: player.allTitles,
        titleKeys: sortedTitleIds.map((id) => titleKeyById.get(id))
      });
    }

    return {
      ...player,
      sortedTitleIds,
      titleSetIndex
    };
  });

  return {
    titleSets,
    playersWithTitleSetIndex
  };
}

function renderPlayerTitleSetPool(titles, titleSets) {
  const lines = [];

  lines.push(PLAYER_TITLE_SET_POOL_BEGIN);
  lines.push(`#!define TP_ALL [${titles.map((title) => `TITLE.${title.key}`).join(', ')}]`);
  lines.push('#!define player_title_set_pool [ \\');

  titleSets.forEach((titleSet, index) => {
    const isLast = index === titleSets.length - 1;
    const titleExpr = titleSet.allTitles
      ? 'TP_ALL'
      : titleSet.titleKeys.length
        ? `[${titleSet.titleKeys.map((key) => `TITLE.${key}`).join(', ')}]`
        : '[]';
    lines.push(`    ${titleExpr}${isLast ? ' \\' : ', \\'} `);
  });

  lines.push(']');
  lines.push(PLAYER_TITLE_SET_POOL_END);
  return lines.join('\n');
}

function renderPlayerDatabase(playersWithTitleSetIndex) {
  const lines = [];

  lines.push(PLAYER_DB_BEGIN);
  lines.push('#!define player_database [ \\');

  playersWithTitleSetIndex.forEach((player, index) => {
    const isLast = index === playersWithTitleSetIndex.length - 1;

    lines.push('    { \\');
    lines.push(`        name: "${player.name}", \\`);
    lines.push(`        titleSetIndex: ${player.titleSetIndex} \\`);
    lines.push(isLast ? '    } \\' : '    }, \\');
  });

  lines.push(']');
  lines.push(PLAYER_DB_END);
  return lines.join('\n');
}

function renderAllTitleAssignment(titles) {
  const lines = [];

  lines.push(ALL_TITLE_BEGIN);
  lines.push('    titleText = [');
  titles.forEach((title, index) => {
    const suffix = index === titles.length - 1 ? '' : ',';
    lines.push(`        # ${index}: ${title.key}`);
    lines.push(`        ${title.displayExpr}${suffix}`);
  });
  lines.push('    ]');
  lines.push('    titleColor = [');
  titles.forEach((title, index) => {
    const suffix = index === titles.length - 1 ? '' : ',';
    lines.push(`        # ${index}: ${title.key}`);
    lines.push(`        ${title.colorExpr}${suffix}`);
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
  const { titleSets, playersWithTitleSetIndex } = buildPlayerTitleSets(data.titles, data.players);
  const titleSetPoolBlock = renderPlayerTitleSetPool(data.titles, titleSets);
  const dbBlock = renderPlayerDatabase(playersWithTitleSetIndex);
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
      `${titleSetPoolBlock}\n${dbBlock}\n\n`
    );
  } else {
    next = replacedDb;
  }

  const replacedPool = replaceManagedBlock(next, PLAYER_TITLE_SET_POOL_BEGIN, PLAYER_TITLE_SET_POOL_END, titleSetPoolBlock);
  if (replacedPool === null) {
    next = next.replace(dbBlock, `${titleSetPoolBlock}\n${dbBlock}`);
  } else {
    next = replacedPool;
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

export async function syncTitleData({
  sourceData: providedSourceData,
  titleFile = TITLE_FILE,
  playerNameToIndexFile = PLAYER_NAME_TO_INDEX_FILE,
  playerNameToIndexDelimitedFile = PLAYER_NAME_TO_INDEX_DELIMITED_FILE,
  dryRun = false
} = {}) {
  if (!providedSourceData) throw new Error('Platform title data is required; run sync:platform-data');
  const [sourceData, titleSource, playerNameToIndexSource, playerNameToIndexDelimitedSource] = await Promise.all([
    providedSourceData,
    fs.readFile(titleFile, 'utf8'),
    fs.readFile(playerNameToIndexFile, 'utf8'),
    fs.readFile(playerNameToIndexDelimitedFile, 'utf8')
  ]);

  const nextTitleFile = applyManagedTitleFile(titleSource, sourceData);
  const nextPlayerNameToIndexFile = renderPlayerIndexScript(sourceData.players, { delimited: false });
  const nextPlayerNameToIndexDelimitedFile = renderPlayerIndexScript(sourceData.players, { delimited: true });

  if (!dryRun) {
    await fs.writeFile(titleFile, nextTitleFile, 'utf8');
    await fs.writeFile(playerNameToIndexFile, nextPlayerNameToIndexFile, 'utf8');
    await fs.writeFile(playerNameToIndexDelimitedFile, nextPlayerNameToIndexDelimitedFile, 'utf8');
  }

  return {
    sourceData,
    titleFileChanged: nextTitleFile !== titleSource,
    playerNameToIndexFileChanged: nextPlayerNameToIndexFile !== playerNameToIndexSource,
    playerNameToIndexDelimitedFileChanged: nextPlayerNameToIndexDelimitedFile !== playerNameToIndexDelimitedSource,
    sourceData
  };
}
