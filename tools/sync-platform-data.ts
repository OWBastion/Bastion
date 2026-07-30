import { execFile } from 'node:child_process';
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { promisify } from 'node:util';

import {
  DEFAULT_PLATFORM_DATA_BASE_URL,
  PLATFORM_DATA_CONTRACT_VERSION,
  PLATFORM_DATA_TOKEN_ENV,
  PlatformDataClient,
  type PlatformData,
  type PlatformDataClientOptions
} from './platform-data-client.ts';
import { syncTitleData } from './sync-title-data.ts';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const EVENT_PLATFORM_IDS_FILE = path.join(ROOT, 'data/platform-event-ids.json');
const ENV_FILE = path.join(ROOT, 'src/env/env.opy');
const EVENT_MANIFEST_FILE = path.join(ROOT, 'src/constants/event_manifest.opy');
const MAP_SOURCE_DIR = path.join(ROOT, 'src/map');
const EVENT_CONSTANTS_FILE = path.join(ROOT, 'src/constants/event_constants.opy');
const ZH_LOCALE_FILE = path.join(ROOT, 'src/locales/zh-CN.opy');
const EVENT_CONFIG_FILE = path.join(ROOT, 'src/config/eventConfig.opy');
const EVENT_CONFIG_DEV_FILE = path.join(ROOT, 'src/config/eventConfigDev.opy');
const execFileAsync = promisify(execFile);

const EVENT_CATEGORIES = new Map([
  ['增益', 'buff'],
  ['减益', 'debuff'],
  ['机制', 'mech']
] as const);
const PLATFORM_EVENT_CATEGORIES = new Set(['增益', '减益', '机制', '全局']);
const EVENT_STATUSES = new Set(['implemented', 'removed']);
const TITLE_SCOPES = new Set(['global', 'map']);
const TITLE_DISPLAY_KINDS = new Set(['fixed', 'map_pioneer', 'map_name_suffix']);
const MAP_DIFFICULTIES = new Set(['T0', 'T1', 'T2', 'T3', 'T4', 'T5']);
const CHALLENGE_STATUSES = new Set(['scheduled', 'active', 'sunsetting']);
const SUBMISSION_MODES = new Set(['manual', 'automatic']);
const TITLE_SLOTS = new Set(['pioneer', 'conqueror', 'dominator', 'classic']);

type JsonObject = Record<string, any>;
type TitleSource = JsonObject & {
  titles: JsonObject[];
  players: JsonObject[];
  mapTitles: JsonObject[];
};
type EventType = 'buff' | 'debuff' | 'mech';
type EventMacros = { id: string | number; duration: string; weight: string };
type EventEntry = { key: string; type: EventType; platformId: string; macros: EventMacros };

export type PlatformSyncOptions = PlatformDataClientOptions & {
  build?: boolean;
};

function requireString(value: unknown, label: string): string {
  if (typeof value !== 'string' || value.trim() === '') throw new Error(`${label} must be a non-empty string`);
  return value.trim();
}

function requireNumber(value: unknown, label: string): number {
  if (typeof value !== 'number' || !Number.isFinite(value)) throw new Error(`${label} must be a finite number`);
  return value;
}

function parseMainVersion(source: string): string {
  const match = source.match(/^#!define\s+VERSION\s+"([^"]+)"/m);
  if (!match) throw new Error('Unable to parse VERSION from src/env/env.opy');
  return match[1];
}

function platformMapId(mapKey: string): string {
  return `map.${mapKey.replace(/^DATA_/, '').toLocaleLowerCase()}`;
}

function assertUnique(values: string[], label: string) {
  const seen = new Set<string>();
  for (const value of values) {
    if (seen.has(value)) throw new Error(`Duplicate ${label}: ${value}`);
    seen.add(value);
  }
}

function validatePlatformAchievements(platformData: PlatformData, titleKeys: Set<string>, mapIds: Set<string>) {
  const challengeIds = new Set<string>();
  for (const [index, item] of platformData.achievements.entries()) {
    const prefix = `achievements[${index}]`;
    const challengeId = requireString(item.challengeId, `${prefix}.challengeId`);
    const titleKey = requireString(item.titleKey, `${prefix}.titleKey`);
    if (!titleKeys.has(titleKey)) throw new Error(`${prefix} references unknown title ${titleKey}`);
    if (!CHALLENGE_STATUSES.has(item.status)) throw new Error(`${prefix}.status has an unsupported value`);
    if (!SUBMISSION_MODES.has(item.submissionMode)) throw new Error(`${prefix}.submissionMode has an unsupported value`);
    if (item.family === 'achievement' && item.type === 'title_achievement' && item.kind === 'title_achievement') {
      if (!challengeId.startsWith('title.') || challengeId !== `title.${titleKey}`) {
        throw new Error(`${prefix}.challengeId must reference title.${titleKey}`);
      }
    } else if (item.family === 'map' && item.type === 'map_completion' && item.kind === 'map_title_achievement') {
      const mapId = requireString(item.mapId, `${prefix}.mapId`);
      if (!mapIds.has(mapId)) throw new Error(`${prefix} references unknown map ${mapId}`);
      const rule = item.mapTitleRule;
      if (!rule || typeof rule !== 'object' || Array.isArray(rule) || rule.dynamic !== true || typeof rule.ruleId !== 'string' || !TITLE_DISPLAY_KINDS.has(rule.displayKind) || !TITLE_SLOTS.has(rule.slot)) {
        throw new Error(`${prefix} has an invalid dynamic map title rule`);
      }
    } else {
      throw new Error(`${prefix} has an unsupported challenge enum`);
    }
    if (challengeIds.has(challengeId)) throw new Error(`Duplicate challengeId: ${challengeId}`);
    challengeIds.add(challengeId);
  }
  return challengeIds;
}

function validatePlatformMaps(platformData: PlatformData, titleSource: TitleSource) {
  const sourceMapKeys = new Set(titleSource.mapTitles.map((item) => requireString(item.mapKey, 'mapTitles.mapKey')));
  const mapIds = new Set<string>();
  const mapKeyById = new Map<string, string>();
  const platformMapIds = new Set<string>();
  for (const mapKey of sourceMapKeys) {
    const id = platformMapId(mapKey);
    mapIds.add(id);
    mapKeyById.set(id, mapKey);
  }

  for (const [index, item] of platformData.maps.entries()) {
    const prefix = `maps[${index}]`;
    const mapId = requireString(item.mapId, `${prefix}.mapId`);
    if (platformMapIds.has(mapId)) throw new Error(`Duplicate platform map ID: ${mapId}`);
    platformMapIds.add(mapId);
    requireString(item.mapName, `${prefix}.mapName`);
    requireString(item.gameVersion, `${prefix}.gameVersion`);
    if (item.difficultyRating !== null && !MAP_DIFFICULTIES.has(item.difficultyRating)) {
      throw new Error(`${prefix}.difficultyRating has an unsupported value`);
    }
    if (!Array.isArray(item.mechanics) || item.mechanics.some((value: unknown) => typeof value !== 'string' || value.trim() === '')) {
      throw new Error(`${prefix}.mechanics must contain non-empty strings`);
    }
    for (const field of ['coverUrl', 'backgroundUrl']) {
      if (item[field] !== null && typeof item[field] !== 'string') throw new Error(`${prefix}.${field} must be a string or null`);
    }
    if (!mapKeyById.has(mapId)) throw new Error(`${prefix} references unknown Bastion map ${mapId}`);
    mapIds.delete(mapId);
  }
  if (mapIds.size) throw new Error(`Platform maps are missing Bastion maps: ${[...mapIds].join(', ')}`);
  return new Set(platformData.maps.map((item) => requireString(item.mapId, 'mapId')));
}

function validateAndMergeTitles(platformData: PlatformData, titleSource: TitleSource, mapIds: Set<string>) {
  const titles = titleSource.titles.map((item) => ({ ...item }));
  const titleByKey = new Map(titles.map((item) => [requireString(item.key, 'title.key'), item]));
  const seen = new Set<string>();

  for (const [index, item] of platformData.titles.entries()) {
    const prefix = `titles[${index}]`;
    const key = requireString(item.titleKey, `${prefix}.titleKey`);
    if (seen.has(key)) throw new Error(`Duplicate platform title key: ${key}`);
    seen.add(key);
    const local = titleByKey.get(key);
    if (!local) throw new Error(`${prefix} references unknown Bastion title ${key}`);
    if (!TITLE_SCOPES.has(item.scope) || !TITLE_DISPLAY_KINDS.has(item.displayKind)) {
      throw new Error(`${prefix} has an unsupported scope or displayKind`);
    }
    if (item.scope === 'map' && (!item.mapId || !mapIds.has(item.mapId))) {
      throw new Error(`${prefix} references unknown map ${String(item.mapId)}`);
    }
    if (item.scope === 'global' && item.mapId !== undefined) throw new Error(`${prefix} global title cannot reference a map`);
    const previousLabel = requireString(local.label, `${key}.label`);
    const label = requireString(item.label, `${prefix}.label`);
    local.label = label;
    if (item.displayKind === 'fixed' && local.displayExpr === JSON.stringify(previousLabel)) {
      local.displayExpr = JSON.stringify(label);
    }
    local.category = requireString(item.category, `${prefix}.category`);
    local.condition = requireString(item.condition, `${prefix}.condition`);
    local.availability = item.availability;
    if (item.availability !== 'active' && item.availability !== 'retired') throw new Error(`${prefix}.availability has an unsupported value`);
  }
  return titles;
}

function validateAndMergeMaps(platformData: PlatformData, titleSource: TitleSource) {
  const mapLabels = new Map<string, string>();
  for (const item of platformData.maps) mapLabels.set(requireString(item.mapId, 'mapId'), requireString(item.mapName, 'mapName'));
  return titleSource.mapTitles.map((item) => ({
    ...item,
    mapLabel: mapLabels.get(platformMapId(requireString(item.mapKey, 'mapKey'))) ?? item.mapLabel
  }));
}

function titleColorExpr(value: unknown, prefix: string): string | null {
  if (value == null) return null;
  if (!value || typeof value !== 'object') throw new Error(`${prefix}.color must be an object or null`);
  const color = value as Record<string, unknown>;
  if (color.kind === 'heroColor') return `heroColor[${requireNumber(color.index, `${prefix}.color.index`)}]`;
  if (color.kind === 'rgb') {
    if (!Array.isArray(color.value) || color.value.length !== 3 || color.value.some((part) => !Number.isInteger(part) || Number(part) < 0 || Number(part) > 255)) throw new Error(`${prefix}.color.value must be an RGB tuple`);
    return `vect(${color.value.join(', ')})`;
  }
  if (color.kind === 'palette' && ['orange', 'red', 'purple', 'gold', 'blue'].includes(String(color.name))) return `breathPalette.${color.name}`;
  throw new Error(`${prefix}.color has an unsupported value`);
}

function titleDisplayExpr(item: JsonObject, prefix: string): string {
  if (item.displayExpr) return item.displayExpr;
  const label = requireString(item.label, `${prefix}.label`);
  if (item.displayKind === 'fixed') return JSON.stringify(label);
  if (item.displayKind === 'map_pioneer') return `"{0}{1}".format(__currentMapPioneerText___ if __currentMapPioneerText___ != null else getCurrentMap(), __currentPioneerText___ if __currentPioneerText___ != null else ${JSON.stringify(label)})`;
  if (item.displayKind === 'map_name_suffix') return `"{0}${label}".format(__currentMapText___ if __currentMapText___ != null else getCurrentMap())`;
  throw new Error(`${prefix}.displayKind has an unsupported value`);
}

function mapKeyFromPlatformId(mapId: string): string {
  if (!/^map\.[a-z0-9_]+$/.test(mapId)) throw new Error(`Invalid platform map ID: ${mapId}`);
  return `DATA_${mapId.slice(4).toUpperCase()}`;
}

function collectDynamicMapTitleDefinitions(platformData: PlatformData, mapIds: Set<string>) {
  const definitions = new Map<string, string>();
  for (const [index, item] of platformData.achievements.entries()) {
    if (item.family !== 'map' || item.type !== 'map_completion' || item.kind !== 'map_title_achievement') continue;
    const prefix = `achievements[${index}]`;
    const mapId = requireString(item.mapId, `${prefix}.mapId`);
    const titleKey = requireString(item.titleKey, `${prefix}.titleKey`);
    const rule = item.mapTitleRule;
    if (!mapIds.has(mapId) || !rule || typeof rule !== 'object' || Array.isArray(rule) || rule.dynamic !== true || typeof rule.ruleId !== 'string' || !TITLE_DISPLAY_KINDS.has(rule.displayKind) || !TITLE_SLOTS.has(rule.slot)) {
      throw new Error(`${prefix} has an invalid dynamic map title rule`);
    }
    const key = `${mapId}:${titleKey}`;
    if (definitions.has(key)) throw new Error(`Duplicate dynamic map title definition: ${key}`);
    definitions.set(key, rule.slot);
  }
  return definitions;
}

export function buildPlatformTitleSource({ platformData, mapSourceFiles }: { platformData: PlatformData; mapSourceFiles: Array<{ file: string; content: string }> }): TitleSource {
  const mapIds = new Set(platformData.maps.map((item) => requireString(item.mapId, 'mapId')));
  const mapLabels = new Map(platformData.maps.map((item) => [requireString(item.mapId, 'mapId'), requireString(item.mapName, 'mapName')]));
  for (const mapId of mapIds) {
    const mapKey = mapKeyFromPlatformId(mapId);
    if (!mapSourceFiles.some(({ content }) => content.includes(mapKey))) throw new Error(`Unable to find map source for ${mapKey}`);
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
    if (item.availability !== 'active' && item.availability !== 'retired') throw new Error(`${prefix}.availability has an unsupported value`);
    if (item.scope === 'global' && item.mapId !== undefined) throw new Error(`${prefix} global title cannot reference a map`);
    if (item.scope === 'map') {
      const mapId = requireString(item.mapId, `${prefix}.mapId`);
      const dynamicSlot = dynamicMapTitleDefinitions.get(`${mapId}:${key}`);
      const slot = dynamicSlot ?? (key === 'CLASSIC' && item.slot === null ? 'classic' : item.slot);
      if (!mapIds.has(mapId) || !TITLE_SLOTS.has(slot)) throw new Error(`${prefix} has an invalid map or slot reference`);
      if (dynamicSlot && item.slot !== undefined && item.slot !== dynamicSlot) throw new Error(`${prefix}.slot disagrees with the dynamic map title rule`);
      if (slot !== 'classic' && (!Array.isArray(item.pioneerPrefixes) || item.pioneerPrefixes.some((value: unknown) => typeof value !== 'string' || value.trim() === ''))) throw new Error(`${prefix}.pioneerPrefixes must be an array of strings`);
      mapTitleDefinitions.add(`${mapId}:${slot}`);
      mapTitleMetadata.add(`${mapId}:${key}`);
    }
    const previous = titleRecords.get(key);
    if (previous && JSON.stringify({ label: previous.label, category: previous.category, condition: previous.condition, availability: previous.availability, displayKind: previous.displayKind, color: previous.color }) !== JSON.stringify({ label: item.label, category: item.category, condition: item.condition, availability: item.availability, displayKind: item.displayKind, color: item.color })) throw new Error(`Inconsistent platform title definition: ${key}`);
    titleRecords.set(key, previous ?? item);
  }
  if (!titleRecords.has("CLASSIC")) {
    titleRecords.set("CLASSIC", {
      titleKey: "CLASSIC",
      label: "賽檤の盡頭灬只剩莪",
      category: "经典版地图系列",
      condition: "通关对应地图经典版。",
      availability: "active",
      scope: "map",
      displayKind: "fixed",
      displayExpr: "__currentMapClassicText___",
      color: { kind: "heroColor", index: 43 }
    });
  }
  for (const key of dynamicMapTitleDefinitions.keys()) {
    if (!mapTitleMetadata.has(key)) throw new Error(`Missing title metadata for dynamic map title definition: ${key}`);
  }

  const players = new Map<string, JsonObject>();
  for (const [index, item] of platformData.playerTitleGrants.entries()) {
    const prefix = `playerTitleGrants[${index}]`;
    const playerId = requireString(item.playerId, `${prefix}.playerId`); const playerName = requireString(item.playerName, `${prefix}.playerName`);
    if (players.has(playerId)) throw new Error(`Duplicate playerId: ${playerId}`);
    players.set(playerId, { playerId, name: playerName, titleKeys: item.titleKeys, allTitles: item.allTitles === true });
  }
  const titleIds = new Map([...titleRecords.keys()].map((key, index) => [key, index]));
  const playerNames = new Set<string>();
  const normalizedPlayers = [...players.values()].sort((left, right) => String(left.playerId).localeCompare(String(right.playerId))).map((player, index) => {
    if (playerNames.has(player.name)) throw new Error(`Duplicate player name detected: ${player.name}`);
    playerNames.add(player.name);
    if (!Array.isArray(player.titleKeys) || player.titleKeys.some((key: unknown) => typeof key !== 'string' || !titleRecords.has(key))) throw new Error(`Invalid titleKeys for player ${player.name}`);
    return { name: player.name, titleKeys: player.allTitles ? undefined : [...new Set(player.titleKeys as string[])].sort((a, b) => titleIds.get(a)! - titleIds.get(b)!), allTitles: player.allTitles === true, playerId: player.playerId, index };
  });
  const playerById = new Map([...players.entries()].map(([id, player]) => [id, player.name as string]));
  const holdersByMap = new Map<string, { PIONEER: string[]; CONQUEROR: string[]; DOMINATOR: string[]; CLASSIC: string[] }>();
  for (const [index, item] of platformData.mapTitleHolders.entries()) {
    const prefix = `mapTitleHolders[${index}]`; const mapId = requireString(item.mapId, `${prefix}.mapId`); const playerId = requireString(item.playerId, `${prefix}.playerId`); const playerName = requireString(item.playerName, `${prefix}.playerName`);
    const slot = item.slotSemantics === 'named'
      ? requireString(item.slot, `${prefix}.slot`)
      : item.slotSemantics === 'none' && item.slot === null && item.titleKey === 'CLASSIC'
        ? 'classic'
        : (() => { throw new Error(`${prefix} has an invalid slot semantics`); })();
    if (!mapIds.has(mapId) || !TITLE_SLOTS.has(slot) || !mapTitleDefinitions.has(`${mapId}:${slot}`) || !playerById.has(playerId) || playerById.get(playerId) !== playerName) throw new Error(`${prefix} has an invalid map, slot or player reference`);
    const mapKey = mapKeyFromPlatformId(mapId); const holders = holdersByMap.get(mapKey) ?? { PIONEER: [], CONQUEROR: [], DOMINATOR: [], CLASSIC: [] };
    const target = holders[slot.toUpperCase() as 'PIONEER' | 'CONQUEROR' | 'DOMINATOR' | 'CLASSIC']; if (target.includes(playerName)) throw new Error(`Duplicate map holder: ${mapId}/${slot}/${playerId}`); target.push(playerName); holdersByMap.set(mapKey, holders);
  }
  const mapTitles = [...mapIds].sort().map((mapId) => ({ mapKey: mapKeyFromPlatformId(mapId), mapLabel: mapLabels.get(mapId)!, holders: holdersByMap.get(mapKeyFromPlatformId(mapId)) ?? { PIONEER: [], CONQUEROR: [], DOMINATOR: [], CLASSIC: [] } }));
  for (const map of mapTitles) { const conquerors = new Set(map.holders.CONQUEROR); if (map.holders.DOMINATOR.some((name) => !conquerors.has(name))) throw new Error(`${map.mapKey}: DOMINATOR holder must also be CONQUEROR`); }
  const titles = [...titleRecords.values()].map((item) => ({ key: item.titleKey, label: item.label, category: item.category, condition: item.condition, availability: item.availability, displayExpr: item.titleKey === 'CLASSIC' ? '__currentMapClassicText___' : titleDisplayExpr(item, `titles.${item.titleKey}`), colorExpr: titleColorExpr(item.color, `titles.${item.titleKey}`) }));
  return { meta: { sourceLabel: 'OWBastion Agents API' }, titles, players: normalizedPlayers.map(({ name, titleKeys, allTitles }) => allTitles ? { name, allTitles } : { name, titleKeys }), mapTitles };
}

function collectEventEntries(configSources: string[]): Array<{ key: string; type: EventType }> {
  const entries = new Map<string, { key: string; type: EventType }>();
  for (const source of configSources) {
    for (const [type, enumType] of [['buff', 'BuffEventId'], ['debuff', 'DebuffEventId'], ['mech', 'MechEventId']] as const) {
      const pattern = new RegExp(`${type}EventName\\[\\s*${enumType}\\.([A-Z0-9_]+)\\s*\\]\\s*=`, 'g');
      for (const match of source.matchAll(pattern)) entries.set(match[1], { key: match[1], type });
    }
  }
  return [...entries.values()];
}

function validateAndMergeEvents(
  platformData: PlatformData,
  platformIds: Record<string, string>,
  challengeIds: Set<string>,
  eventEntries: Array<{ key: string; type: EventType }>
) {
  const remoteById = new Map<string, JsonObject>();
  const mappedPlatformIds = new Set(Object.values(platformIds));
  for (const [index, item] of platformData.events.entries()) {
    const prefix = `events[${index}]`;
    const id = requireString(item.eventId, `${prefix}.eventId`);
    if (remoteById.has(id)) throw new Error(`Duplicate platform event ID: ${id}`);
    remoteById.set(id, item);
    requireString(item.name, `${prefix}.name`);
    requireString(item.description, `${prefix}.description`);
    if (!PLATFORM_EVENT_CATEGORIES.has(item.category)) throw new Error(`${prefix}.category has an unsupported value`);
    if (!EVENT_STATUSES.has(item.releaseStatus)) throw new Error(`${prefix}.releaseStatus has an unsupported value`);
    if (typeof item.archived !== 'boolean') throw new Error(`${prefix}.archived must be a boolean`);
    if (item.durationSeconds !== null && (requireNumber(item.durationSeconds, `${prefix}.durationSeconds`) < 0)) throw new Error(`${prefix}.durationSeconds must be non-negative`);
    if (item.weight !== null && (requireNumber(item.weight, `${prefix}.weight`) < 0)) throw new Error(`${prefix}.weight must be non-negative`);
    if (!Array.isArray(item.challenges)) throw new Error(`${prefix}.challenges must be an array`);
    for (const challenge of item.challenges) {
      const challengeId = requireString(challenge.challengeId, `${prefix}.challengeId`);
      if (!challengeIds.has(challengeId)) throw new Error(`${prefix} references unknown challenge ${challengeId}`);
    }
    if (mappedPlatformIds.has(id) && !EVENT_CATEGORIES.has(item.category)) {
      throw new Error(`${prefix}.category cannot be mapped to a Bastion event`);
    }
  }

  const mappedIds = Object.entries(platformIds);
  assertUnique(mappedIds.map(([, id]) => requireString(id, 'platform event ID')), 'platform event ID mapping');
  for (const [key, platformId] of mappedIds) {
    const local = eventEntries.find((item) => item.key === key);
    if (!local) throw new Error(`Platform event mapping references unknown Bastion event ${key}`);
    const remote = remoteById.get(platformId);
    if (!remote) throw new Error(`Bastion event ${key} is missing from platform event data: ${platformId}`);
    const expectedType = EVENT_CATEGORIES.get(remote.category);
    if (expectedType !== local.type) throw new Error(`Event ${key} category does not match Bastion type ${local.type}`);
  }
  for (const entry of eventEntries) {
    const platformId = platformIds[entry.key];
    if (!platformId) throw new Error(`Bastion event ${entry.key} is missing a platform event mapping`);
  }
  return eventEntries.map((entry) => ({
    ...entry,
    platformId: platformIds[entry.key]
  }));
}

function replaceOverPyDefine(source: string, name: string, value: string | number): string {
  const pattern = new RegExp(`^#!define\\s+${name.replace(/[.*+?^${}()|[\\]\\]/g, '\\$&')}\\s+.*$`, 'm');
  if (!pattern.test(source)) throw new Error(`Unable to find OverPy define ${name}`);
  return source.replace(pattern, `#!define ${name} ${typeof value === 'number' ? value : JSON.stringify(value)}`);
}

function resolveEventMacros(eventKey: string, eventType: string, configSources: string[]) {
  const type = eventType.toUpperCase();
  const enumType = type === 'BUFF' ? 'BuffEventId' : type === 'DEBUFF' ? 'DebuffEventId' : 'MechEventId';
  const escapedKey = eventKey.replace(/[.*+?^${}()|[\\]\\]/g, '\\$&');
  const titlePattern = new RegExp(
    `(?:buff|debuff|mech)EventName\\[\\s*${enumType}\\.${escapedKey}\\s*\\]\\s*=\\s*STR_EVT_${type}_(\\d+)_TITLE`
  );
  const durationPattern = new RegExp(
    `(?:buff|debuff|mech)EventDuration\\[\\s*${enumType}\\.${escapedKey}\\s*\\]\\s*=\\s*(EVT_[A-Z0-9_]+)`
  );
  const weightPattern = new RegExp(
    `(?:buff|debuff|mech)EventWeight\\[\\s*${enumType}\\.${escapedKey}\\s*\\]\\s*=\\s*(EVT_[A-Z0-9_]+)`
  );
  let id: string | undefined;
  let duration: string | undefined;
  let weight: string | undefined;
  for (const source of configSources) {
    id ??= source.match(titlePattern)?.[1];
    duration ??= source.match(durationPattern)?.[1];
    weight ??= source.match(weightPattern)?.[1];
  }
  if (!id || !duration || !weight) throw new Error(`Unable to resolve OverPy macros for ${eventType}:${eventKey}`);
  return { id, duration, weight };
}

export function mergePlatformEventOverPyData({
  platformData,
  eventEntries,
  constantsSource,
  localeSource
}: {
  platformData: PlatformData;
  eventEntries: EventEntry[];
  constantsSource: string;
  localeSource: string;
}) {
  const remoteById = new Map(platformData.events.map((item) => [requireString(item.eventId, 'eventId'), item]));
  let nextConstantsSource = constantsSource;
  let nextLocaleSource = localeSource;
  for (const eventItem of eventEntries) {
    const remote = remoteById.get(eventItem.platformId);
    if (!remote) throw new Error(`Bastion event ${eventItem.key} is missing from platform event data: ${eventItem.platformId}`);
    const type = eventItem.type.toUpperCase();
    const titleName = `STR_EVT_${type}_${eventItem.macros.id}_TITLE`;
    if (remote.durationSeconds !== null) {
      nextConstantsSource = replaceOverPyDefine(nextConstantsSource, eventItem.macros.duration, requireNumber(remote.durationSeconds, `${eventItem.key}.durationSeconds`));
    }
    if (remote.weight !== null) {
      nextConstantsSource = replaceOverPyDefine(nextConstantsSource, eventItem.macros.weight, requireNumber(remote.weight, `${eventItem.key}.weight`));
    }
    nextLocaleSource = replaceOverPyDefine(nextLocaleSource, titleName, requireString(remote.name, `${eventItem.key}.name`));
  }
  return { constantsSource: nextConstantsSource, localeSource: nextLocaleSource };
}

function parseDefineNumber(source: string, name: string): number {
  const match = source.match(new RegExp(`^#!define\\s+${name.replace(/[.*+?^${}()|[\\]\\]/g, '\\\\$&')}\\s+(-?(?:\\d+\\.?\\d*|\\.\\d+))\\s*$`, 'm'));
  if (!match) throw new Error(`Unable to find numeric OverPy define ${name}`);
  return Number(match[1]);
}

function renderEventManifest(eventEntries: EventEntry[], constantsSource: string, mainVersion: string): string {
  const counts = {
    buff: eventEntries.filter((item) => item.type === 'buff').length,
    debuff: eventEntries.filter((item) => item.type === 'debuff').length,
    mech: eventEntries.filter((item) => item.type === 'mech').length
  };
  const activeWeightSum = Number(
    eventEntries.reduce((sum, item) => sum + parseDefineNumber(constantsSource, item.macros.weight), 0).toFixed(3)
  );
  return [
    '#!mainFile "../main.opy"',
    '',
    '# Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.',
    '#!optimizeStrict',
    '',
    '# BEGIN AUTO-GENERATED EVENT MANIFEST',
    '# Source: OWBastion Agents API',
    '#!define EVENT_MANIFEST_SOURCE_LABEL "OWBastion Agents API"',
    `#!define EVENT_MANIFEST_SOURCE_VERSION "contract-${PLATFORM_DATA_CONTRACT_VERSION}"`,
    `#!define EVENT_MANIFEST_MAIN_VERSION "${mainVersion}"`,
    `#!define EVENT_MANIFEST_TOTAL_EVENTS ${eventEntries.length}`,
    `#!define EVENT_MANIFEST_ACTIVE_EVENTS ${eventEntries.length}`,
    `#!define EVENT_MANIFEST_TOTAL_BUFF_COUNT ${counts.buff}`,
    `#!define EVENT_MANIFEST_TOTAL_DEBUFF_COUNT ${counts.debuff}`,
    `#!define EVENT_MANIFEST_TOTAL_MECH_COUNT ${counts.mech}`,
    `#!define EVENT_MANIFEST_ACTIVE_BUFF_COUNT ${counts.buff}`,
    `#!define EVENT_MANIFEST_ACTIVE_DEBUFF_COUNT ${counts.debuff}`,
    `#!define EVENT_MANIFEST_ACTIVE_MECH_COUNT ${counts.mech}`,
    `#!define EVENT_MANIFEST_ACTIVE_WEIGHT_SUM ${activeWeightSum}`,
    '# END AUTO-GENERATED EVENT MANIFEST',
    ''
  ].join('\n');
}

export function mergePlatformData({
  platformData,
  titleSource,
  eventEntries,
  platformEventIds,
  mapSourceFiles
}: {
  platformData: PlatformData;
  titleSource: TitleSource;
  eventEntries: EventEntry[];
  mapSourceFiles: Array<{ file: string; content: string }>;
}) {
  const sourceMapKeys = new Set(titleSource.mapTitles.map((item) => requireString(item.mapKey, 'mapKey')));
  for (const mapKey of sourceMapKeys) {
    if (!mapSourceFiles.some(({ content }) => content.includes(mapKey))) throw new Error(`Unable to find map source for ${mapKey}`);
  }
  const mapIds = validatePlatformMaps(platformData, titleSource);
  const titleKeys = new Set(titleSource.titles.map((item) => requireString(item.key, 'title.key')));
  const challengeIds = validatePlatformAchievements(platformData, titleKeys, mapIds);
  const mergedTitles = validateAndMergeTitles(platformData, titleSource, mapIds);
  const mergedMapTitles = validateAndMergeMaps(platformData, titleSource);
  const mergedEvents = validateAndMergeEvents(platformData, platformEventIds, challengeIds, eventEntries);
  return {
    titleSource: { ...titleSource, titles: mergedTitles, mapTitles: mergedMapTitles },
    eventEntries: mergedEvents,
    counts: {
      events: platformData.events.length,
      maps: platformData.maps.length,
      achievements: platformData.achievements.length,
      titles: platformData.titles.length,
      ignoredEvents: platformData.events.length - Object.keys(platformEventIds).length
    }
  };
}

async function runBuild() {
  for (const command of ['build:main', 'build:dev']) {
    await execFileAsync('pnpm', ['run', command], { cwd: ROOT, maxBuffer: 20 * 1024 * 1024 });
  }
}

export async function syncPlatformData(options: PlatformSyncOptions = {}) {
  const baseUrl = options.baseUrl ?? process.env.BASTION_PLATFORM_API_URL ?? DEFAULT_PLATFORM_DATA_BASE_URL;
  const accessToken = options.accessToken ?? process.env[PLATFORM_DATA_TOKEN_ENV];
  console.log(`Platform sync: endpoint=${baseUrl}, build token=${accessToken ? 'configured' : 'missing'}`);
  const [platformEventIds, mapSourceFiles, constantsSource, localeSource, eventConfigSource, eventConfigDevSource, envSource] = await Promise.all([
    fs.readFile(EVENT_PLATFORM_IDS_FILE, 'utf8').then((text) => JSON.parse(text) as Record<string, string>),
    fs.readdir(MAP_SOURCE_DIR).then(async (files) => Promise.all(files.filter((file) => file.endsWith('.opy')).map(async (file) => ({ file, content: await fs.readFile(path.join(MAP_SOURCE_DIR, file), 'utf8') })))),
    fs.readFile(EVENT_CONSTANTS_FILE, 'utf8'),
    fs.readFile(ZH_LOCALE_FILE, 'utf8'),
    fs.readFile(EVENT_CONFIG_FILE, 'utf8'),
    fs.readFile(EVENT_CONFIG_DEV_FILE, 'utf8'),
    fs.readFile(ENV_FILE, 'utf8')
  ]);
  const eventEntries = collectEventEntries([eventConfigSource, eventConfigDevSource]).map((entry) => ({
    ...entry,
    platformId: platformEventIds[entry.key] ?? '',
    macros: resolveEventMacros(entry.key, entry.type, [eventConfigSource, eventConfigDevSource])
  }));

  const client = new PlatformDataClient({ ...options, baseUrl, accessToken });
  const emptyData = (): PlatformData => ({ events: [], maps: [], achievements: [], titles: [], playerTitleGrants: [], mapTitleHolders: [] });

  console.log('Platform sync: fetching maps');
  const maps = await client.fetchResource('maps');
  console.log(`Platform sync: fetched ${maps.length} maps`);
  const mapIds = new Set(maps.map((item) => requireString(item.mapId, 'mapId')));
  const orderedMapIds = [...mapIds].sort();
  for (const mapId of mapIds) {
    const mapKey = mapKeyFromPlatformId(mapId);
    if (!mapSourceFiles.some(({ content }) => content.includes(mapKey))) throw new Error(`Unable to find map source for ${mapKey}`);
  }
  console.log('Platform sync: fetching achievements');
  const achievements = await client.fetchResource('achievements');
  console.log('Platform sync: fetching global and map titles');
  const globalTitles = await client.fetchTitles();
  const mapTitlePages: PlatformData['titles'][] = [];
  for (const [index, mapId] of orderedMapIds.entries()) {
    mapTitlePages.push(await client.fetchTitles(mapId));
    if ((index + 1) % 10 === 0 || index + 1 === orderedMapIds.length) console.log(`Platform sync: fetched map titles ${index + 1}/${orderedMapIds.length}`);
  }
  const titles = [...globalTitles, ...mapTitlePages.flat().filter((item) => item.scope === 'map')];
  console.log(`Platform sync: fetched ${titles.length} titles`);
  console.log('Platform sync: fetching title grants and map holders');
  const playerTitleGrants = await client.fetchPlayerTitleGrants();
  const mapTitleHolders: PlatformData['mapTitleHolders'] = [];
  for (const [index, mapId] of orderedMapIds.entries()) {
    mapTitleHolders.push(...await client.fetchMapTitleHolders(mapId));
    if ((index + 1) % 10 === 0 || index + 1 === orderedMapIds.length) console.log(`Platform sync: fetched map title holders ${index + 1}/${orderedMapIds.length}`);
  }
  const titleData = { ...emptyData(), maps, achievements, titles, playerTitleGrants, mapTitleHolders };
  const titleSource = buildPlatformTitleSource({ platformData: titleData, mapSourceFiles });
  const titleKeys = new Set(titleSource.titles.map((item) => requireString(item.key, 'title.key')));
  await syncTitleData({ sourceData: titleSource });

  console.log('Platform sync: fetching events');
  const achievementData = { ...emptyData(), achievements, titles };
  const challengeIds = validatePlatformAchievements(achievementData, titleKeys, mapIds);

  const events = await client.fetchResource('events');
  console.log(`Platform sync: fetched ${achievements.length} achievements and ${events.length} events`);
  const eventData = { ...emptyData(), events, achievements };
  const validatedEventEntries = validateAndMergeEvents(eventData, platformEventIds, challengeIds, eventEntries);
  const platformEventData = mergePlatformEventOverPyData({
    platformData: eventData,
    eventEntries: validatedEventEntries,
    constantsSource,
    localeSource
  });
  await fs.writeFile(EVENT_CONSTANTS_FILE, platformEventData.constantsSource, 'utf8');
  await fs.writeFile(ZH_LOCALE_FILE, platformEventData.localeSource, 'utf8');
  await fs.writeFile(EVENT_MANIFEST_FILE, renderEventManifest(validatedEventEntries, platformEventData.constantsSource, parseMainVersion(envSource)), 'utf8');
  if (options.build !== false) await runBuild();
  const counts = {
    events: events.length,
    maps: maps.length,
    achievements: achievements.length,
    titles: titles.length,
    ignoredEvents: events.length - Object.keys(platformEventIds).length
  };
  console.log(`Synced platform data: ${counts.events} events, ${counts.maps} maps, ${counts.achievements} achievements and ${counts.titles} titles`);
  return counts;
}

if (process.argv[1]?.endsWith('sync-platform-data.ts')) {
  const urlIndex = process.argv.indexOf('--url');
  const baseUrl = urlIndex >= 0 ? process.argv[urlIndex + 1] : undefined;
  syncPlatformData({ baseUrl }).catch((error) => {
    console.error(error instanceof Error ? error.message : String(error));
    process.exitCode = 1;
  });
}
