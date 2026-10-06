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

import {
  buildPlatformMapRevisionSource,
  hasMapSource,
  mapKeyFromPlatformId,
  platformMapId,
  validatePlatformAchievements,
  type PlatformMapRevisionSource,
  renderPlatformMapRevisionMapSources,
  validatePlatformMaps,
  validateRevisionAwareMapSources
} from './sync-map-data.ts';
import {
  buildPlatformTitleSource,
  validateAndMergeMaps,
  validateAndMergeTitles
} from './sync-title-data.ts';
import {
  collectEventEntries,
  mergePlatformEventOverPyData,
  renderEventManifest,
  resolveEventMacros,
  validateAndMergeEvents,
  type EventEntry
} from './sync-event-data.ts';
import {
  assertUnique,
  requireNumber,
  requireString,
  type JsonObject,
  type TitleSource
} from './platform-data-client.ts';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const EVENT_PLATFORM_IDS_FILE = path.join(ROOT, 'data/platform-event-ids.json');
const ENV_FILE = path.join(ROOT, 'src/env/env.opy');
const EVENT_MANIFEST_FILE = path.join(ROOT, 'src/constants/event_manifest.opy');
const MAP_SOURCE_DIR = path.join(ROOT, 'src/map');
const EVENT_CONSTANTS_FILE = path.join(ROOT, 'src/constants/event_constants.opy');
const ZH_LOCALE_FILE = path.join(ROOT, 'src/locales/zh-CN.opy');
const EVENT_CATALOG_FILE = path.join(ROOT, 'src/config/eventCatalog.opy');
const execFileAsync = promisify(execFile);

export type PlatformSyncOptions = PlatformDataClientOptions & {
  build?: boolean;
  buildRunner?: () => Promise<void>;
};

export type GeneratedPlatformFile = { path: string; content: string };

function parseMainVersion(source: string): string {
  const match = source.match(/^#!define\s+VERSION\s+"([^"]+)"/m);
  if (!match) throw new Error('Unable to parse VERSION from src/env/env.opy');
  return match[1];
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
    if (!hasMapSource(platformMapId(mapKey), mapSourceFiles)) throw new Error(`Unable to find map source for ${mapKey}`);
  }
  const mapCatalog = validatePlatformMaps(platformData, titleSource);
  const mapIds = new Set(mapCatalog.maps.keys());
  const titleKeys = new Set(titleSource.titles.map((item) => requireString(item.key, 'title.key')));
  const challengeIds = validatePlatformAchievements(platformData, titleKeys, mapCatalog);
  const mergedTitles = validateAndMergeTitles(platformData, titleSource, mapIds);
  const mergedMapTitles = validateAndMergeMaps(platformData, titleSource);
  const mergedEvents = validateAndMergeEvents(platformData, platformEventIds, challengeIds, eventEntries);
  return {
    titleSource: { ...titleSource, titles: mergedTitles, mapTitles: mergedMapTitles },
    mapRevisionSource: buildPlatformMapRevisionSource({ platformData }),
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
  for (const command of ['build:cn:zh', 'build:dev:cn:zh', 'build:external:en', 'build:external:zh']) {
    await execFileAsync('pnpm', ['run', command], { cwd: ROOT, maxBuffer: 20 * 1024 * 1024 });
  }
}

export async function prepareGeneratedPlatformFiles({
  titleSource,
  mapRevisionSource,
  mapSourceFiles,
  platformEventData,
  validatedEventEntries,
  envSource,
}: {
  titleSource: TitleSource;
  mapRevisionSource: PlatformMapRevisionSource;
  mapSourceFiles: Array<{ file: string; content: string }>;
  platformEventData: { constantsSource: string; localeSource: string };
  validatedEventEntries: EventEntry[];
  envSource: string;
}): Promise<GeneratedPlatformFile[]> {
  const titleSync = await syncTitleData({ sourceData: titleSource, dryRun: true });
  return [
    ...titleSync.generatedFiles,
    ...renderPlatformMapRevisionMapSources({ source: mapRevisionSource, mapSourceFiles }),
    { path: EVENT_CONSTANTS_FILE, content: platformEventData.constantsSource },
    { path: ZH_LOCALE_FILE, content: platformEventData.localeSource },
    { path: EVENT_MANIFEST_FILE, content: renderEventManifest(validatedEventEntries, platformEventData.constantsSource, parseMainVersion(envSource)) },
  ];
}

async function writeGeneratedPlatformFiles(files: GeneratedPlatformFile[]) {
  await Promise.all(files.map(({ path: filePath, content }) => fs.writeFile(filePath, content, 'utf8')));
}

export async function syncPlatformData(options: PlatformSyncOptions = {}) {
  const baseUrl = options.baseUrl ?? process.env.BASTION_PLATFORM_API_URL ?? DEFAULT_PLATFORM_DATA_BASE_URL;
  const accessToken = options.accessToken ?? process.env[PLATFORM_DATA_TOKEN_ENV];
  console.log(`Platform sync: endpoint=${baseUrl}, build token=${accessToken ? 'configured' : 'missing'}`);
  const [platformEventIds, mapSourceFiles, constantsSource, localeSource, eventCatalogSource, envSource] = await Promise.all([
    fs.readFile(EVENT_PLATFORM_IDS_FILE, 'utf8').then((text) => JSON.parse(text) as Record<string, string>),
    fs.readdir(MAP_SOURCE_DIR).then(async (files) => Promise.all(files.filter((file) => file.endsWith('.opy')).map(async (file) => ({ file, content: await fs.readFile(path.join(MAP_SOURCE_DIR, file), 'utf8') })))),
    fs.readFile(EVENT_CONSTANTS_FILE, 'utf8'),
    fs.readFile(ZH_LOCALE_FILE, 'utf8'),
    fs.readFile(EVENT_CATALOG_FILE, 'utf8'),
    fs.readFile(ENV_FILE, 'utf8')
  ]);
  const eventEntries = collectEventEntries(eventCatalogSource).map((entry) => ({
    ...entry,
    platformId: platformEventIds[entry.key] ?? '',
    macros: resolveEventMacros(entry.key, entry.type, eventCatalogSource)
  }));

  const client = new PlatformDataClient({ ...options, baseUrl, accessToken });
  const emptyData = (): PlatformData => ({ events: [], maps: [], achievements: [], titles: [], playerTitleGrants: [], mapTitleHolders: [] });

  console.log('Platform sync: fetching maps');
  const maps = await client.fetchResource('maps');
  console.log(`Platform sync: fetched ${maps.length} maps`);
  const mapIds = new Set(maps.map((item) => requireString(item.mapId, 'mapId')));
  const orderedMapIds = [...mapIds].sort();
  for (const mapId of mapIds) {
    if (!hasMapSource(mapId, mapSourceFiles)) throw new Error(`Unable to find map source for ${mapKeyFromPlatformId(mapId)}`);
  }
  validateRevisionAwareMapSources({ mapIds: orderedMapIds, mapSourceFiles });
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

  console.log('Platform sync: fetching events');
  const events = await client.fetchResource('events');
  console.log(`Platform sync: fetched ${achievements.length} achievements and ${events.length} events`);
  const platformData = { ...titleData, events };
  const merged = mergePlatformData({ platformData, titleSource, eventEntries, platformEventIds, mapSourceFiles });
  const mapRevisionSource = merged.mapRevisionSource;
  const eventData = { ...emptyData(), events, achievements, titles };
  const validatedEventEntries = merged.eventEntries;
  const platformEventData = mergePlatformEventOverPyData({
    platformData: eventData,
    eventEntries: validatedEventEntries,
    constantsSource,
    localeSource
  });
  const generatedFiles = await prepareGeneratedPlatformFiles({
    titleSource: merged.titleSource,
    mapRevisionSource,
    mapSourceFiles,
    platformEventData,
    validatedEventEntries,
    envSource,
  });
  await writeGeneratedPlatformFiles(generatedFiles);
  if (options.build !== false) await (options.buildRunner ?? runBuild)();
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
