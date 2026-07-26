import { execFile } from 'node:child_process';
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { promisify } from 'node:util';

import {
  DEFAULT_PLATFORM_DATA_BASE_URL,
  PlatformDataClient,
  type PlatformData,
  type PlatformDataClientOptions
} from './platform-data-client.ts';
import { syncEventData } from './sync-event-data.ts';
import { syncGrantGeneralTitleWorkflow } from './sync-grant-general-title-workflow.ts';
import { loadTitleSource, syncTitleData } from './sync-title-data.ts';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const TITLE_SOURCE_FILE = path.join(ROOT, 'data/title-source.json');
const EVENT_SOURCE_FILE = path.join(ROOT, 'data/event-source.json');
const EVENT_PLATFORM_IDS_FILE = path.join(ROOT, 'data/platform-event-ids.json');
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

type JsonObject = Record<string, any>;
type TitleSource = JsonObject & {
  titles: JsonObject[];
  players: JsonObject[];
  mapTitles: JsonObject[];
};
type EventSource = JsonObject & {
  packs: JsonObject[];
  events: JsonObject[];
};

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

function writeJson(file: string, value: unknown) {
  return fs.writeFile(file, `${JSON.stringify(value, null, 2)}\n`, 'utf8');
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
    if (item.family !== 'achievement' || item.type !== 'title_achievement' || item.kind !== 'title_achievement') {
      throw new Error(`${prefix} has an unsupported challenge enum`);
    }
    if (!challengeId.startsWith('title.') || challengeId !== `title.${titleKey}`) {
      throw new Error(`${prefix}.challengeId must reference title.${titleKey}`);
    }
    if (!titleKeys.has(titleKey)) throw new Error(`${prefix} references unknown title ${titleKey}`);
    if (!CHALLENGE_STATUSES.has(item.status)) throw new Error(`${prefix}.status has an unsupported value`);
    if (!SUBMISSION_MODES.has(item.submissionMode)) throw new Error(`${prefix}.submissionMode has an unsupported value`);
    if (item.mapId !== undefined && (!requireString(item.mapId, `${prefix}.mapId`) || !mapIds.has(item.mapId))) {
      throw new Error(`${prefix} references unknown map ${String(item.mapId)}`);
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
    local.label = requireString(item.label, `${prefix}.label`);
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

function validateAndMergeEvents(platformData: PlatformData, eventSource: EventSource, platformIds: Record<string, string>, challengeIds: Set<string>) {
  const events = eventSource.events.map((item) => ({ ...item }));
  const eventByKey = new Map(events.map((item) => [requireString(item.key, 'event.key'), item]));
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
    const local = eventByKey.get(key);
    if (!local) throw new Error(`Platform event mapping references unknown Bastion event ${key}`);
    const remote = remoteById.get(platformId);
    if (!remote) throw new Error(`Bastion event ${key} is missing from platform event data: ${platformId}`);
    const expectedType = EVENT_CATEGORIES.get(remote.category);
    if (expectedType !== local.type) throw new Error(`Event ${key} category does not match Bastion type ${local.type}`);
  }
  return events;
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
  eventSource,
  platformEventIds,
  eventMacros,
  constantsSource,
  localeSource
}: {
  platformData: PlatformData;
  eventSource: EventSource;
  platformEventIds: Record<string, string>;
  eventMacros: Record<string, { id: string | number; duration: string; weight: string }>;
  constantsSource: string;
  localeSource: string;
}) {
  const remoteById = new Map(platformData.events.map((item) => [requireString(item.eventId, 'eventId'), item]));
  let nextConstantsSource = constantsSource;
  let nextLocaleSource = localeSource;
  const nextEventSource = {
    ...eventSource,
    events: eventSource.events.map((eventItem) => {
      const platformId = platformEventIds[requireString(eventItem.key, 'event.key')];
      if (!platformId) return { ...eventItem };
      const remote = remoteById.get(platformId);
      if (!remote) throw new Error(`Bastion event ${eventItem.key} is missing from platform event data: ${platformId}`);
      const type = requireString(eventItem.type, 'event.type').toUpperCase();
      const macros = eventMacros[eventItem.key];
      if (!macros) throw new Error(`Unable to resolve OverPy macros for ${eventItem.type}:${eventItem.key}`);
      const titleName = `STR_EVT_${type}_${macros.id}_TITLE`;
      const descriptionName = `STR_EVT_${type}_${macros.id}_DESC`;
      if (remote.durationSeconds !== null) {
        nextConstantsSource = replaceOverPyDefine(nextConstantsSource, macros.duration, requireNumber(remote.durationSeconds, `${eventItem.key}.durationSeconds`));
      }
      if (remote.weight !== null) {
        nextConstantsSource = replaceOverPyDefine(nextConstantsSource, macros.weight, requireNumber(remote.weight, `${eventItem.key}.weight`));
      }
      nextLocaleSource = replaceOverPyDefine(nextLocaleSource, titleName, requireString(remote.name, `${eventItem.key}.name`));
      nextLocaleSource = replaceOverPyDefine(nextLocaleSource, descriptionName, requireString(remote.description, `${eventItem.key}.description`));
      return {
        ...eventItem,
        ...(remote.durationSeconds !== null ? { durationSec: remote.durationSeconds } : {}),
        ...(remote.weight !== null ? { weight: remote.weight } : {})
      };
    })
  };
  return { eventSource: nextEventSource, constantsSource: nextConstantsSource, localeSource: nextLocaleSource };
}

export function mergePlatformData({
  platformData,
  titleSource,
  eventSource,
  platformEventIds,
  mapSourceFiles
}: {
  platformData: PlatformData;
  titleSource: TitleSource;
  eventSource: EventSource;
  platformEventIds: Record<string, string>;
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
  const mergedEvents = validateAndMergeEvents(platformData, eventSource, platformEventIds, challengeIds);
  return {
    titleSource: { ...titleSource, titles: mergedTitles, mapTitles: mergedMapTitles },
    eventSource: { ...eventSource, events: mergedEvents },
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
  const [rawTitleSource, titleSource, eventSource, platformEventIds, mapSourceFiles, constantsSource, localeSource, eventConfigSource, eventConfigDevSource] = await Promise.all([
    fs.readFile(TITLE_SOURCE_FILE, 'utf8').then((text) => JSON.parse(text) as TitleSource),
    loadTitleSource(TITLE_SOURCE_FILE),
    fs.readFile(EVENT_SOURCE_FILE, 'utf8').then((text) => JSON.parse(text) as EventSource),
    fs.readFile(EVENT_PLATFORM_IDS_FILE, 'utf8').then((text) => JSON.parse(text) as Record<string, string>),
    fs.readdir(MAP_SOURCE_DIR).then(async (files) => Promise.all(files.filter((file) => file.endsWith('.opy')).map(async (file) => ({ file, content: await fs.readFile(path.join(MAP_SOURCE_DIR, file), 'utf8') })))),
    fs.readFile(EVENT_CONSTANTS_FILE, 'utf8'),
    fs.readFile(ZH_LOCALE_FILE, 'utf8'),
    fs.readFile(EVENT_CONFIG_FILE, 'utf8'),
    fs.readFile(EVENT_CONFIG_DEV_FILE, 'utf8')
  ]);

  const client = new PlatformDataClient({ ...options, baseUrl });
  const emptyData = (): PlatformData => ({ events: [], maps: [], achievements: [], titles: [] });

  const maps = await client.fetchResource('maps');
  const mapData = { ...emptyData(), maps };
  const mapIds = validatePlatformMaps(mapData, titleSource);
  let mergedTitleSource = {
    ...titleSource,
    mapTitles: validateAndMergeMaps(mapData, titleSource)
  };
  let mergedRawTitleSource = {
    ...rawTitleSource,
    mapTitles: validateAndMergeMaps(mapData, rawTitleSource)
  };
  await writeJson(TITLE_SOURCE_FILE, mergedRawTitleSource);
  let titleResult = await syncTitleData({ sourceData: mergedTitleSource });

  const titles = await client.fetchResource('titles');
  const titleData = { ...emptyData(), titles };
  const titleKeys = new Set(titleSource.titles.map((item) => requireString(item.key, 'title.key')));
  mergedTitleSource = {
    ...mergedTitleSource,
    titles: validateAndMergeTitles(titleData, mergedTitleSource, mapIds)
  };
  mergedRawTitleSource = {
    ...mergedRawTitleSource,
    titles: validateAndMergeTitles(titleData, mergedRawTitleSource, mapIds)
  };
  await writeJson(TITLE_SOURCE_FILE, mergedRawTitleSource);
  titleResult = await syncTitleData({ sourceData: mergedTitleSource });

  const achievements = await client.fetchResource('achievements');
  const achievementData = { ...emptyData(), achievements };
  const challengeIds = validatePlatformAchievements(achievementData, titleKeys, mapIds);

  const events = await client.fetchResource('events');
  const eventData = { ...emptyData(), events };
  const validatedEventSource = {
    ...eventSource,
    events: validateAndMergeEvents(eventData, eventSource, platformEventIds, challengeIds)
  };
  const platformEventData = mergePlatformEventOverPyData({
    platformData: eventData,
    eventSource: validatedEventSource,
    platformEventIds,
    eventMacros: Object.fromEntries(
      validatedEventSource.events.map((eventItem) => [
        eventItem.key,
        resolveEventMacros(eventItem.key, eventItem.type, [eventConfigSource, eventConfigDevSource])
      ])
    ),
    constantsSource,
    localeSource
  });
  await fs.writeFile(EVENT_CONSTANTS_FILE, platformEventData.constantsSource, 'utf8');
  await fs.writeFile(ZH_LOCALE_FILE, platformEventData.localeSource, 'utf8');
  await syncEventData({
    sourceData: platformEventData.eventSource,
    syncWeightsFromConstants: false,
    writeSourceFile: false
  });
  await syncGrantGeneralTitleWorkflow({ sourceData: titleResult.sourceData });
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
