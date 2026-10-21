import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import {
  requireNumber,
  requireString,
  type JsonObject,
  type MapTitleEntry,
  type MapTitleSlot,
  type PlatformData,
  type PlayerEntry,
  type TitleEntry,
  type TitleSource,
  TITLE_SCOPES,
  TITLE_DISPLAY_KINDS,
  TITLE_SLOTS
} from './client.ts';
import { hasMapSource, mapKeyFromPlatformId, platformMapId, validateGameplayRevision, type ValidatedGameplayRevision } from './mapValidation.ts';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const TITLE_FILE = path.resolve(__dirname, '../../src/title/title-cn.opy');
const PLAYER_NAME_TO_INDEX_FILE = path.resolve(__dirname, '../../src/title/playerNameToIndex.js');
const PLAYER_NAME_TO_INDEX_DELIMITED_FILE = path.resolve(__dirname, '../../src/title/playerNameToIndexDelimited.js');

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
function escapeRegex(value: string) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

export function readGeneratedTitleOrder(source: string) {
  const match = source.match(new RegExp(`${escapeRegex(ENUM_BEGIN)}[\\s\\S]*?enum TITLE:\\n([\\s\\S]*?)${escapeRegex(ENUM_END)}`));
  if (!match) return [];
  return [...match[1].matchAll(/^\s+([A-Z0-9_]+),?\s*#/gm)].map((item) => item[1]);
}

export function readGeneratedPlayerOrder(source: string): string[] {
  const match = source.match(/const TITLE_PLAYER_NAMES = \[([\s\S]*?)\];/);
  if (!match) return [];
  try {
    return JSON.parse(`[${match[1]}]`);
  } catch {
    throw new Error('Unable to parse TITLE_PLAYER_NAMES from generated player index');
  }
}

export function readGeneratedTitleColors(source: string) {
  const match = source.match(new RegExp(`${escapeRegex(ALL_TITLE_BEGIN)}[\\s\\S]*?    titleColor = \\[([\\s\\S]*?)    \\]`));
  if (!match) return new Map();

  const colors = new Map<string, string>();
  const lines = match[1].split('\n');
  for (let index = 0; index < lines.length; index += 1) {
    const keyMatch = lines[index].match(/^\s*# \d+: ([A-Z0-9_]+)\s*$/);
    if (!keyMatch) continue;
    const expression = lines[index + 1]?.trim().replace(/,$/, '');
    if (expression) colors.set(keyMatch[1], expression);
  }
  return colors;
}

export function normalizeTitleColorExpr(expr: string | null | undefined) {
  if (expr == null || expr === 'null' || expr.startsWith('[') || expr.startsWith('breathPalette.')) return expr;
  return `[${expr}]`;
}

export function applyTitleColorFallback(sourceData: TitleSource, titleFileSource: string): TitleSource {
  const fallbackColors = readGeneratedTitleColors(titleFileSource);
  return {
    ...sourceData,
    titles: sourceData.titles.map((title) => ({
      ...title,
      colorExpr: normalizeTitleColorExpr(title.colorExpr ?? fallbackColors.get(title.key)) ?? null
    }))
  };
}

function preserveGeneratedOrder<T>(items: T[], historicalKeys: string[], keyOf: (item: T) => string): T[] {
  const byKey = new Map(items.map((item) => [keyOf(item), item]));
  const historicalKeySet = new Set(historicalKeys);
  const preserved = historicalKeys.flatMap((key) => {
    const item = byKey.get(key);
    return item ? [item] : [];
  });
  const appended = items.filter((item) => !historicalKeySet.has(keyOf(item)));
  return [...preserved, ...appended];
}

export function preservePlatformTitleOrder(sourceData: TitleSource, titleFileSource: string, playerIndexSource: string): TitleSource {
  return {
    ...sourceData,
    titles: preserveGeneratedOrder(sourceData.titles, readGeneratedTitleOrder(titleFileSource), (title) => title.key),
    players: preserveGeneratedOrder(sourceData.players, readGeneratedPlayerOrder(playerIndexSource), (player) => player.name)
  };
}

function renderTitleEnum(titles: TitleEntry[]) {
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

function buildPlayerTitleSets(titles: TitleEntry[], players: PlayerEntry[]) {
  const titleIdByKey = new Map(titles.map((title, index) => [title.key, index]));
  const titleKeyById = new Map(titles.map((title, index) => [index, title.key]));
  const titleSetIndexByIds = new Map<string, number>();
  const titleSets: Array<{ allTitles: boolean; titleKeys: string[] }> = [];
  const playersWithTitleSetIndex = players.map((player) => {
    const sortedTitleIds = player.allTitles ? [] : (player.titleKeys ?? [])
      .map((key) => titleIdByKey.get(key)!)
      .sort((left, right) => left - right);
    const titleSetKey = player.allTitles ? 'TP_ALL' : sortedTitleIds.join(',');
    let titleSetIndex = titleSetIndexByIds.get(titleSetKey);

    if (titleSetIndex == null) {
      titleSetIndex = titleSets.length;
      titleSetIndexByIds.set(titleSetKey, titleSetIndex);
      titleSets.push({
        allTitles: player.allTitles === true,
        titleKeys: sortedTitleIds.map((id) => titleKeyById.get(id)!)
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

function renderPlayerTitleSetPool(titles: TitleEntry[], titleSets: Array<{ allTitles: boolean; titleKeys: string[] }>) {
  const titleIdByKey = new Map(titles.map((title, index) => [title.key, index]));
  const flat: number[] = [];
  const offsets = [0];

  titleSets.forEach((titleSet) => {
    const ids = titleSet.allTitles
      ? titles.map((_, index) => index)
      : titleSet.titleKeys.map((key) => titleIdByKey.get(key)!);
    flat.push(...ids);
    offsets.push(offsets[offsets.length - 1] + ids.length);
  });

  const lines = [];
  lines.push(PLAYER_TITLE_SET_POOL_BEGIN);
  lines.push(`#!define player_title_set_flat compressed([${flat.join(', ')}])`);
  lines.push(`#!define player_title_set_off [${offsets.join(', ')}]`);
  lines.push(PLAYER_TITLE_SET_POOL_END);
  return lines.join('\n');
}

function renderPlayerDatabase(playersWithTitleSetIndex: Array<{ name: string; titleSetIndex: number }>) {
  const names = playersWithTitleSetIndex.map((player) => player.name);
  for (const name of names) {
    if (/["\\‖\n]/.test(name)) {
      throw new Error(`player name ${name} contains a character unsafe for packed-string encoding`);
    }
  }

  const lines = [];
  lines.push(PLAYER_DB_BEGIN);
  lines.push(`#!define player_name_list ${JSON.stringify(names.join('‖'))}`);
  lines.push(`#!define player_title_set_index [${playersWithTitleSetIndex.map((player) => player.titleSetIndex).join(', ')}]`);
  lines.push(PLAYER_DB_END);
  return lines.join('\n');
}

function renderAllTitleAssignment(titles: TitleEntry[]) {
  const lines = [];

  lines.push(ALL_TITLE_BEGIN);

  // 纯字符串称号文本打包进一个分隔符字符串再 split，表达式条目保持字面量。
  const PLAIN_TEXT = /^"[^"\\\n‖]*"$/;
  const titleTextParts: string[] = [];
  let titleTextPending: string[] = [];
  const flushTitleText = () => {
    if (titleTextPending.length) {
      titleTextParts.push(`"${titleTextPending.join('‖')}".split("‖")`);
      titleTextPending = [];
    }
  };
  titles.forEach((title) => {
    const expr = title.displayExpr.trim();
    const plain = PLAIN_TEXT.test(expr) && !expr.slice(1, -1).includes('\\') ? expr.slice(1, -1) : null;
    if (plain === null) {
      flushTitleText();
      titleTextParts.push(`[${expr}]`);
    } else {
      titleTextPending.push(plain);
    }
  });
  flushTitleText();
  lines.push(`    titleText = ${titleTextParts[0]}${titleTextParts.slice(1).map((part) => `.concat(${part})`).join('')}`);
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

function renderDelimitedNames(names: string[]) {
  if (!names.length) {
    return '[]';
  }

  const quoted = names.map((name) => JSON.stringify(name)).join(', ');
  return `playerNameToIndexDelimited([${quoted}], "-")`;
}

function packHolderIndices(names: string[], indexByName: Map<string, number>) {
  return names
    .map((name) => indexByName.get(name))
    .filter((index) => index !== undefined)
    .join('-');
}

function renderMapTitleData(mapTitles: MapTitleEntry[], indexByName: Map<string, number>) {
  const lines = [];
  lines.push('# 地图数据块 (Data Blocks)');
  lines.push(MAP_DATA_BEGIN);

  mapTitles.forEach((mapItem, index) => {
    if (index > 0) {
      lines.push('');
    }

    const packedRow = (['PIONEER', 'CONQUEROR', 'DOMINATOR', 'CLASSIC'] as MapTitleSlot[])
      .map((slot) => packHolderIndices(mapItem.holders[slot] ?? [], indexByName))
      .join('|');

    lines.push(`# ${mapItem.mapLabel}`);
    lines.push(`#!define ${mapItem.mapKey} [ \\`);
    lines.push(`   ${renderDelimitedNames(mapItem.holders.PIONEER)}, \\`);
    lines.push(`   ${renderDelimitedNames(mapItem.holders.CONQUEROR)}, \\`);
    lines.push(`   ${renderDelimitedNames(mapItem.holders.DOMINATOR)}, \\`);
    lines.push(`   ${renderDelimitedNames(mapItem.holders.CLASSIC)}\\`);
    lines.push(']');
    lines.push(`#!define ${mapItem.mapKey}_PACKED ${JSON.stringify(packedRow)}`);
  });

  lines.push(MAP_DATA_END);
  return lines.join('\n');
}

function renderPlayerIndexScript(players: PlayerEntry[], { delimited }: { delimited: boolean }) {
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

function replaceManagedBlock(source: string, beginMarker: string, endMarker: string, blockContent: string) {
  const pattern = new RegExp(`${escapeRegex(beginMarker)}[\\s\\S]*?${escapeRegex(endMarker)}`);

  if (!pattern.test(source)) {
    return null;
  }

  return source.replace(pattern, blockContent);
}

function applyManagedTitleFile(source: string, data: TitleSource) {
  const enumBlock = renderTitleEnum(data.titles);
  const { titleSets, playersWithTitleSetIndex } = buildPlayerTitleSets(data.titles, data.players);
  const titleSetPoolBlock = renderPlayerTitleSetPool(data.titles, titleSets);
  const dbBlock = renderPlayerDatabase(playersWithTitleSetIndex);
  const allTitleBlock = renderAllTitleAssignment(data.titles);
  const indexByName = new Map(data.players.map((player, index) => [player.name, index]));
  const mapDataBlock = renderMapTitleData(data.mapTitles, indexByName);

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
}: {
  sourceData: TitleSource;
  titleFile?: string;
  playerNameToIndexFile?: string;
  playerNameToIndexDelimitedFile?: string;
  dryRun?: boolean;
}) {
  if (!providedSourceData) throw new Error('Platform title data is required; run sync:platform-data');
  const [rawSourceData, titleSource, playerNameToIndexSource, playerNameToIndexDelimitedSource] = await Promise.all([
    providedSourceData,
    fs.readFile(titleFile, 'utf8'),
    fs.readFile(playerNameToIndexFile, 'utf8'),
    fs.readFile(playerNameToIndexDelimitedFile, 'utf8')
  ]);

  const sourceData = applyTitleColorFallback(
    preservePlatformTitleOrder(rawSourceData, titleSource, playerNameToIndexSource),
    titleSource
  );

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
    generatedFiles: [
      { path: titleFile, content: nextTitleFile },
      { path: playerNameToIndexFile, content: nextPlayerNameToIndexFile },
      { path: playerNameToIndexDelimitedFile, content: nextPlayerNameToIndexDelimitedFile },
    ],
  };
}

export function validateAndMergeTitles(platformData: PlatformData, titleSource: TitleSource, mapIds: Set<string>) {
  const titles = titleSource.titles.map((item) => ({ ...item }));
  const titleByKey = new Map(titles.map((item) => [requireString(item.key, 'title.key'), item]));
  const seenDefinitions = new Map<string, string>();

  for (const [index, item] of platformData.titles.entries()) {
    const prefix = `titles[${index}]`;
    const key = requireString(item.titleKey, `${prefix}.titleKey`);
    const local = titleByKey.get(key);
    if (!local) throw new Error(`${prefix} references unknown Bastion title ${key}`);
    if (!TITLE_SCOPES.has(item.scope) || !TITLE_DISPLAY_KINDS.has(item.displayKind)) {
      throw new Error(`${prefix} has an unsupported scope or displayKind`);
    }
    if (item.scope === 'map' && (!item.mapId || !mapIds.has(item.mapId))) {
      throw new Error(`${prefix} references unknown map ${String(item.mapId)}`);
    }
    if (item.scope === 'global' && item.mapId !== undefined) throw new Error(`${prefix} global title cannot reference a map`);
    const label = requireString(item.label, `${prefix}.label`);
    const category = requireString(item.category, `${prefix}.category`);
    const condition = requireString(item.condition, `${prefix}.condition`);
    const definition = JSON.stringify({ label, category, condition, displayKind: item.displayKind, color: item.color });
    const previousDefinition = seenDefinitions.get(key);
    if (previousDefinition !== undefined && previousDefinition !== definition) throw new Error(`Inconsistent platform title definition: ${key}`);
    seenDefinitions.set(key, definition);
    const previousLabel = requireString(local.label, `${key}.label`);
    local.label = label;
    if (item.displayKind === 'fixed' && local.displayExpr === JSON.stringify(previousLabel)) {
      local.displayExpr = JSON.stringify(label);
    }
    local.category = category;
    local.condition = condition;
  }
  return titles;
}

export function validateAndMergeMaps(platformData: PlatformData, titleSource: TitleSource) {
  const mapLabels = new Map<string, string>();
  for (const item of platformData.maps) mapLabels.set(requireString(item.mapId, 'mapId'), requireString(item.mapName, 'mapName'));
  return titleSource.mapTitles.map((item) => ({
    ...item,
    mapLabel: mapLabels.get(platformMapId(requireString(item.mapKey, 'mapKey'))) ?? item.mapLabel
  }));
}

export function titleColorExpr(value: unknown, prefix: string): string | null {
  if (value == null) return null;
  if (!value || typeof value !== 'object') throw new Error(`${prefix}.color must be an object or null`);
  const color = value as Record<string, unknown>;
  if (color.kind === 'heroColor') return `[heroColor[${requireNumber(color.index, `${prefix}.color.index`)}]]`;
  if (color.kind === 'rgb') {
    if (!Array.isArray(color.value) || color.value.length !== 3 || color.value.some((part) => !Number.isInteger(part) || Number(part) < 0 || Number(part) > 255)) throw new Error(`${prefix}.color.value must be an RGB tuple`);
    return `[vect(${color.value.join(', ')})]`;
  }
  if (color.kind === 'palette' && ['orange', 'red', 'purple', 'gold', 'blue'].includes(String(color.name))) return `breathPalette.${color.name}`;
  throw new Error(`${prefix}.color has an unsupported value`);
}

export function titleDisplayExpr(item: JsonObject, prefix: string): string {
  if (item.displayExpr) return item.displayExpr;
  const label = requireString(item.label, `${prefix}.label`);
  if (item.displayKind === 'fixed') return JSON.stringify(label);
  if (item.displayKind === 'map_pioneer') return `"{0}{1}".format(__currentMapPioneerText___ if __currentMapPioneerText___ != null else getCurrentMap(), __currentPioneerText___ if __currentPioneerText___ != null else ${JSON.stringify(label)})`;
  if (item.displayKind === 'map_name_suffix') return `"{0}${label}".format(__currentMapText___ if __currentMapText___ != null else getCurrentMap())`;
  throw new Error(`${prefix}.displayKind has an unsupported value`);
}

export function collectDynamicMapTitleDefinitions(platformData: PlatformData, mapIds: Set<string>) {
  const definitions = new Map<string, string>();
  for (const [index, item] of platformData.achievements.entries()) {
    if (item.family !== 'map' || item.type !== 'map_completion' || item.kind !== 'map_title_achievement') continue;
    if (item.mapVariant === 'classic') continue;
    const prefix = `achievements[${index}]`;
    const mapId = requireString(item.mapId, `${prefix}.mapId`);
    const titleKey = requireString(item.titleKey, `${prefix}.titleKey`);
    const rule = item.mapTitleRule;
    if (!mapIds.has(mapId) || !rule || typeof rule !== 'object' || Array.isArray(rule) || rule.dynamic !== true || typeof rule.ruleId !== 'string' || !TITLE_DISPLAY_KINDS.has(rule.displayKind) || !TITLE_SLOTS.has(rule.slot)) {
      throw new Error(`${prefix} has an invalid dynamic map title rule`);
    }
    const key = `${mapId}:${titleKey}`;
    const previous = definitions.get(key);
    if (previous !== undefined && previous !== rule.slot) throw new Error(`Inconsistent dynamic map title definition: ${key}`);
    definitions.set(key, rule.slot);
  }
  return definitions;
}

export function buildPlatformTitleSource({ platformData, mapSourceFiles }: { platformData: PlatformData; mapSourceFiles: Array<{ file: string; content: string }> }): TitleSource {
  const mapIds = new Set(platformData.maps.map((item) => requireString(item.mapId, 'mapId')));
  const mapLabels = new Map(platformData.maps.map((item) => [requireString(item.mapId, 'mapId'), requireString(item.mapName, 'mapName')]));
  for (const mapId of mapIds) {
    if (!hasMapSource(mapId, mapSourceFiles)) throw new Error(`Unable to find map source for ${mapKeyFromPlatformId(mapId)}`);
  }

  const dynamicMapTitleDefinitions = collectDynamicMapTitleDefinitions(platformData, mapIds);
  const titleRecords = new Map<string, JsonObject>();
  const mapTitleDefinitions = new Set<string>();
  const mapTitleMetadata = new Set<string>();
  for (const [index, item] of platformData.titles.entries()) {
    const prefix = `titles[${index}]`;
    const key = requireString(item.titleKey, `${prefix}.titleKey`);
    if (!TITLE_SCOPES.has(item.scope) || !TITLE_DISPLAY_KINDS.has(item.displayKind)) throw new Error(`${prefix} has an unsupported scope or displayKind`);
    requireString(item.category, `${prefix}.category`); requireString(item.condition, `${prefix}.condition`);
    if (item.scope === 'global' && item.mapId !== undefined) throw new Error(`${prefix} global title cannot reference a map`);
    if (item.scope === 'map') {
      const mapId = requireString(item.mapId, `${prefix}.mapId`);
      const dynamicSlot = dynamicMapTitleDefinitions.get(`${mapId}:${key}`);
      const slot = dynamicSlot ?? (key === 'CLASSIC' && item.slot == null ? 'classic' : item.slot);
      if (!mapIds.has(mapId) || !TITLE_SLOTS.has(slot)) throw new Error(`${prefix} has an invalid map or slot reference`);
      if (dynamicSlot && item.slot !== undefined && item.slot !== dynamicSlot) throw new Error(`${prefix}.slot disagrees with the dynamic map title rule`);
      if (slot !== 'classic' && (!Array.isArray(item.pioneerPrefixes) || item.pioneerPrefixes.some((value: unknown) => typeof value !== 'string' || value.trim() === ''))) throw new Error(`${prefix}.pioneerPrefixes must be an array of strings`);
      mapTitleDefinitions.add(`${mapId}:${slot}`);
      mapTitleMetadata.add(`${mapId}:${key}`);
    }
    const previous = titleRecords.get(key);
    if (previous && JSON.stringify({ label: previous.label, category: previous.category, condition: previous.condition, displayKind: previous.displayKind, color: previous.color }) !== JSON.stringify({ label: item.label, category: item.category, condition: item.condition, displayKind: item.displayKind, color: item.color })) throw new Error(`Inconsistent platform title definition: ${key}`);
    titleRecords.set(key, previous ?? item);
  }
  if (!titleRecords.has("CLASSIC")) {
    titleRecords.set("CLASSIC", {
      titleKey: "CLASSIC",
      label: "賽檤の盡頭灬只剩莪",
      category: "经典版地图系列",
      condition: "通关对应地图经典版。",
      scope: "map",
      displayKind: "fixed",
      displayExpr: "__currentMapClassicText___",
      color: { kind: "heroColor", index: 43 }
    });
  }
  for (const [key, slot] of dynamicMapTitleDefinitions) {
    if (mapTitleMetadata.has(key)) continue;
    const separator = key.indexOf(':');
    const titleKey = key.slice(separator + 1);
    if (!titleRecords.has(titleKey)) throw new Error(`Missing title metadata for dynamic map title definition: ${key}`);
    mapTitleDefinitions.add(`${key.slice(0, separator)}:${slot}`);
    mapTitleMetadata.add(key);
  }

  const players = new Map<string, JsonObject>();
  for (const [index, item] of platformData.playerTitleGrants.entries()) {
    const prefix = `playerTitleGrants[${index}]`;
    const playerName = requireString(item.playerName, `${prefix}.playerName`);
    if (players.has(playerName)) throw new Error(`Duplicate player name: ${playerName}`);
    players.set(playerName, { name: playerName, titleKeys: item.titleKeys, allTitles: item.allTitles === true });
  }
  const revisionsById = new Map<string, ValidatedGameplayRevision>();
  for (const map of platformData.maps) {
    const mapId = requireString(map.mapId, 'mapId');
    if (!Array.isArray(map.gameplayRevisions)) throw new Error(`maps.${mapId}.gameplayRevisions must be an array`);
    const revisions = map.gameplayRevisions.map((revision, index) => validateGameplayRevision(revision, mapId, `maps.${mapId}.gameplayRevisions[${index}]`));
    if (revisions.filter((revision) => revision.isDefault).length !== 1) throw new Error(`maps.${mapId}.gameplayRevisions must contain exactly one default revision`);
    for (const revision of revisions) {
      if (revisionsById.has(revision.gameplayRevisionId)) throw new Error(`Duplicate gameplay revision ID: ${revision.gameplayRevisionId}`);
      revisionsById.set(revision.gameplayRevisionId, revision);
    }
  }
  const holdersByMap = new Map<string, { PIONEER: string[]; CONQUEROR: string[]; DOMINATOR: string[]; CLASSIC: string[] }>();
  for (const [index, item] of platformData.mapTitleHolders.entries()) {
    const prefix = `mapTitleHolders[${index}]`; const mapId = requireString(item.mapId, `${prefix}.mapId`); const gameplayRevisionId = requireString(item.gameplayRevisionId, `${prefix}.gameplayRevisionId`); const playerName = requireString(item.playerName, `${prefix}.playerName`); const titleKey = requireString(item.titleKey, `${prefix}.titleKey`);
    const revision = revisionsById.get(gameplayRevisionId);
    const slot = item.slotSemantics === 'named'
      ? requireString(item.slot, `${prefix}.slot`)
      : item.slotSemantics === 'none' && item.slot === null && titleKey === 'CLASSIC'
        ? 'classic'
        : (() => { throw new Error(`${prefix} has an invalid slot semantics`); })();
    if (!mapIds.has(mapId) || !revision || revision.mapId !== mapId || !TITLE_SLOTS.has(slot) || !mapTitleDefinitions.has(`${mapId}:${slot}`) || !mapTitleMetadata.has(`${mapId}:${titleKey}`)) throw new Error(`${prefix} has an invalid map, revision, slot or title reference`);
    const player = players.get(playerName);
    if (!player) players.set(playerName, { name: playerName, titleKeys: [], allTitles: false });
    if (slot !== 'classic' && !revision.isDefault) continue;
    const mapKey = mapKeyFromPlatformId(mapId); const holders = holdersByMap.get(mapKey) ?? { PIONEER: [], CONQUEROR: [], DOMINATOR: [], CLASSIC: [] };
    const target = holders[slot.toUpperCase() as 'PIONEER' | 'CONQUEROR' | 'DOMINATOR' | 'CLASSIC']; if (target.includes(playerName)) throw new Error(`Duplicate map holder: ${mapId}/${slot}/${playerName}`); target.push(playerName); holdersByMap.set(mapKey, holders);
  }
  const titleIds = new Map([...titleRecords.keys()].map((key, index) => [key, index]));
  const normalizedPlayers = [...players.values()].sort((left, right) => String(left.name).localeCompare(String(right.name))).map((player) => {
    if (!Array.isArray(player.titleKeys) || player.titleKeys.some((key: unknown) => typeof key !== 'string' || !titleRecords.has(key))) throw new Error(`Invalid titleKeys for player ${player.name}`);
    return { name: player.name, titleKeys: player.allTitles ? undefined : [...new Set(player.titleKeys as string[])].sort((a, b) => titleIds.get(a)! - titleIds.get(b)!), allTitles: player.allTitles === true };
  });
  const mapTitles = [...mapIds].sort().map((mapId) => ({ mapKey: mapKeyFromPlatformId(mapId), mapLabel: mapLabels.get(mapId)!, holders: holdersByMap.get(mapKeyFromPlatformId(mapId)) ?? { PIONEER: [], CONQUEROR: [], DOMINATOR: [], CLASSIC: [] } }));
  const titles = [...titleRecords.values()].map((item) => ({ key: item.titleKey, label: item.label, category: item.category, condition: item.condition, displayExpr: item.titleKey === 'CLASSIC' ? '__currentMapClassicText___' : titleDisplayExpr(item, `titles.${item.titleKey}`), colorExpr: titleColorExpr(item.color, `titles.${item.titleKey}`) }));
  return { meta: { sourceLabel: 'OWBastion Agents API' }, titles, players: normalizedPlayers.map(({ name, titleKeys, allTitles }) => allTitles ? { name, allTitles } : { name, titleKeys }), mapTitles };
}
