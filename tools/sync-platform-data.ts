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
type SpatialPosition = [number, number, number];
type AlternateStageSetupDetection = { position: SpatialPosition; radius: number };
type SpatialConfigBase = {
  bastionPositions: SpatialPosition[];
  resetPosition: SpatialPosition;
  endPosition: SpatialPosition;
  thirdPersonPosition: SpatialPosition;
  creditsPosition: SpatialPosition;
  control: {
    centerPositions: SpatialPosition[];
    jumpPositions: SpatialPosition[];
    respawnPositions: SpatialPosition[];
    respawnAxis: 'x' | 'y' | 'z' | null;
    respawnAxisThreshold: number | null;
  } | null;
  portalPositions: SpatialPosition[];
  springboardPositions: SpatialPosition[];
};
type SpatialConfig = SpatialConfigBase & {
  alternateStages: Array<SpatialConfigBase & { stageId: string; setupDetection: AlternateStageSetupDetection }>;
};
type ValidatedGameplayRevision = {
  gameplayRevisionId: string;
  mapId: string;
  mapVariant: 'classic' | null;
  lifecycle: 'default' | 'selectable';
  enabled: true;
  isDefault: boolean;
  isSelectable: boolean;
  gameVersion: string;
  spatialConfig: SpatialConfig;
  challengeRefs: Array<{ family: 'map'; challengeId: string }>;
};
type ValidatedPlatformMap = {
  mapId: string;
  mapName: string;
  gameVersion: string;
  difficultyRating: string | null;
  mechanics: string[];
  coverUrl: string | null;
  backgroundUrl: string | null;
  gameplayRevisions: ValidatedGameplayRevision[];
};
type ValidatedMapCatalog = {
  maps: Map<string, ValidatedPlatformMap>;
  revisions: Map<string, ValidatedGameplayRevision>;
};
export type PlatformMapRevisionSource = {
  contractVersion: typeof PLATFORM_DATA_CONTRACT_VERSION;
  maps: Array<{
    mapId: string;
    mapName: string;
    revisions: Array<ValidatedGameplayRevision & {
      titleHolders: Array<{
        titleKey: string;
        slot: 'pioneer' | 'conqueror' | 'dominator' | null;
        slotSemantics: 'named' | 'none';
        playerId: string;
        playerName: string;
      }>;
    }>;
  }>;
};

export type PlatformSyncOptions = PlatformDataClientOptions & {
  build?: boolean;
  buildRunner?: () => Promise<void>;
};

export type GeneratedPlatformFile = { path: string; content: string };

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

function assertExactKeys(value: unknown, label: string, expectedKeys: string[]) {
  if (!value || typeof value !== 'object' || Array.isArray(value)) throw new Error(`${label} must be an object`);
  const actualKeys = Object.keys(value).sort();
  const expected = [...expectedKeys].sort();
  if (actualKeys.length !== expected.length || actualKeys.some((key, index) => key !== expected[index])) {
    throw new Error(`${label} has an invalid shape; expected keys ${expected.join(', ')}`);
  }
}

function validateSpatialPosition(value: unknown, label: string): SpatialPosition {
  if (!Array.isArray(value) || value.length !== 3 || value.some((part) => typeof part !== 'number' || !Number.isFinite(part))) {
    throw new Error(`${label} must be a finite 3D coordinate`);
  }
  return value as SpatialPosition;
}

function validateSpatialPositions(value: unknown, label: string, required: boolean): SpatialPosition[] {
  if (!Array.isArray(value) || value.length > 128 || (required && value.length < 1)) {
    throw new Error(`${label} must contain ${required ? 'one or more and ' : ''}at most 128 coordinates`);
  }
  return value.map((position, index) => validateSpatialPosition(position, `${label}[${index}]`));
}

function validateAlternateStageSetupDetection(value: unknown, label: string): AlternateStageSetupDetection {
  assertExactKeys(value, label, ['position', 'radius']);
  const detection = value as Record<string, unknown>;
  const radius = detection.radius;
  if (typeof radius !== 'number' || !Number.isFinite(radius) || radius <= 0) throw new Error(`${label}.radius must be a positive finite number`);
  return { position: validateSpatialPosition(detection.position, `${label}.position`), radius };
}

const spatialConfigKeys = ['bastionPositions', 'resetPosition', 'endPosition', 'thirdPersonPosition', 'creditsPosition', 'control', 'portalPositions', 'springboardPositions'];

function validateSpatialConfigBase(value: unknown, label: string): SpatialConfigBase {
  assertExactKeys(value, label, spatialConfigKeys);
  const config = value as Record<string, unknown>;
  let control: SpatialConfigBase['control'] = null;
  if (config.control !== null) {
    assertExactKeys(config.control, `${label}.control`, ['centerPositions', 'jumpPositions', 'respawnPositions', 'respawnAxis', 'respawnAxisThreshold']);
    const rawControl = config.control as Record<string, unknown>;
    const centerPositions = validateSpatialPositions(rawControl.centerPositions, `${label}.control.centerPositions`, false);
    const jumpPositions = validateSpatialPositions(rawControl.jumpPositions, `${label}.control.jumpPositions`, false);
    const respawnPositions = validateSpatialPositions(rawControl.respawnPositions, `${label}.control.respawnPositions`, false);
    const respawnAxis = rawControl.respawnAxis;
    if (respawnAxis !== null && respawnAxis !== 'x' && respawnAxis !== 'y' && respawnAxis !== 'z') throw new Error(`${label}.control.respawnAxis has an unsupported value`);
    const threshold = rawControl.respawnAxisThreshold;
    if (threshold !== null && (typeof threshold !== 'number' || !Number.isFinite(threshold) || threshold < 0)) throw new Error(`${label}.control.respawnAxisThreshold must be a non-negative finite number or null`);
    if ((respawnAxis === null) !== (threshold === null)) throw new Error(`${label}.control axis and threshold must be provided together`);
    if (respawnAxis !== null && respawnPositions.length === 0) throw new Error(`${label}.control axis requires a respawn position`);
    control = { centerPositions, jumpPositions, respawnPositions, respawnAxis, respawnAxisThreshold: threshold };
  }
  return {
    bastionPositions: validateSpatialPositions(config.bastionPositions, `${label}.bastionPositions`, true),
    resetPosition: validateSpatialPosition(config.resetPosition, `${label}.resetPosition`),
    endPosition: validateSpatialPosition(config.endPosition, `${label}.endPosition`),
    thirdPersonPosition: validateSpatialPosition(config.thirdPersonPosition, `${label}.thirdPersonPosition`),
    creditsPosition: validateSpatialPosition(config.creditsPosition, `${label}.creditsPosition`),
    control,
    portalPositions: validateSpatialPositions(config.portalPositions, `${label}.portalPositions`, false),
    springboardPositions: validateSpatialPositions(config.springboardPositions, `${label}.springboardPositions`, false)
  };
}

function validateSpatialConfig(value: unknown, label: string): SpatialConfig {
  if (!value || typeof value !== 'object' || Array.isArray(value)) throw new Error(`${label} must be an object`);
  const config = value as Record<string, unknown>;
  const actualKeys = Object.keys(config).sort();
  const expectedKeys = [...spatialConfigKeys, 'alternateStages'].sort();
  const missingKeys = spatialConfigKeys.filter((key) => !(key in config));
  if (missingKeys.length || actualKeys.some((key) => !expectedKeys.includes(key))) {
    throw new Error(`${label} has an invalid shape; expected keys ${expectedKeys.join(', ')}`);
  }
  const base = validateSpatialConfigBase(Object.fromEntries(spatialConfigKeys.map((key) => [key, config[key]])), label);
  const rawAlternateStages = config.alternateStages ?? [];
  if (!Array.isArray(rawAlternateStages) || rawAlternateStages.length > 15) throw new Error(`${label}.alternateStages must contain at most 15 stages`);
  const stageIds = new Set<string>();
  const alternateStages = rawAlternateStages.map((rawStage, index) => {
    const stageLabel = `${label}.alternateStages[${index}]`;
    assertExactKeys(rawStage, stageLabel, ['stageId', 'setupDetection', ...spatialConfigKeys]);
    const stage = rawStage as Record<string, unknown>;
    const stageId = requireString(stage.stageId, `${stageLabel}.stageId`);
    if (!/^[a-z0-9][a-z0-9_-]*$/.test(stageId) || stageId.length > 64) throw new Error(`${stageLabel}.stageId has an unsupported value`);
    if (stageIds.has(stageId)) throw new Error(`Duplicate alternate spatial stage ${stageId}`);
    stageIds.add(stageId);
    return {
      stageId,
      setupDetection: validateAlternateStageSetupDetection(stage.setupDetection, `${stageLabel}.setupDetection`),
      ...validateSpatialConfigBase(Object.fromEntries(spatialConfigKeys.map((key) => [key, stage[key]])), stageLabel)
    };
  }).sort((left, right) => left.stageId.localeCompare(right.stageId));
  return { ...base, alternateStages };
}

function validateMigratedMapSpatialConfig(mapId: string, config: SpatialConfig, label: string) {
  if (mapId === 'map.busan') {
    if (!config.control) throw new Error(`${label}.control is required for map.busan`);
    if (config.control.respawnPositions.length !== 3 || config.control.centerPositions.length !== 3 || config.control.jumpPositions.length !== 2) {
      throw new Error(`${label}.control must contain three center/respawn and two jump positions for map.busan`);
    }
    return;
  }
  if ((mapId === 'map.paraiso' || mapId === 'map.eichenwalde') && config.control !== null) {
    throw new Error(`${label}.control must be null for ${mapId}`);
  }
}

function validateGameplayRevision(value: unknown, mapId: string, label: string): ValidatedGameplayRevision {
  assertExactKeys(value, label, ['gameplayRevisionId', 'mapId', 'mapVariant', 'lifecycle', 'enabled', 'isDefault', 'isSelectable', 'gameVersion', 'spatialConfig', 'challengeRefs']);
  const revision = value as Record<string, unknown>;
  const gameplayRevisionId = requireString(revision.gameplayRevisionId, `${label}.gameplayRevisionId`);
  if (requireString(revision.mapId, `${label}.mapId`) !== mapId) throw new Error(`${label}.mapId does not match ${mapId}`);
  if (revision.mapVariant !== null && revision.mapVariant !== 'classic') throw new Error(`${label}.mapVariant has an unsupported value`);
  if (revision.lifecycle !== 'default' && revision.lifecycle !== 'selectable') throw new Error(`${label}.lifecycle must be default or selectable`);
  if (revision.enabled !== true || typeof revision.isDefault !== 'boolean' || typeof revision.isSelectable !== 'boolean') throw new Error(`${label} has invalid enabled/default/selectable flags`);
  if (revision.lifecycle === 'default' && (revision.isDefault !== true || revision.isSelectable !== false || revision.mapVariant === 'classic')) throw new Error(`${label} has invalid default revision semantics`);
  if (revision.lifecycle === 'selectable' && (revision.isDefault !== false || revision.isSelectable !== true)) throw new Error(`${label} has invalid selectable revision semantics`);
  const gameVersion = requireString(revision.gameVersion, `${label}.gameVersion`);
  const spatialConfig = validateSpatialConfig(revision.spatialConfig, `${label}.spatialConfig`);
  validateMigratedMapSpatialConfig(mapId, spatialConfig, `${label}.spatialConfig`);
  if (!Array.isArray(revision.challengeRefs) || revision.challengeRefs.length > 256) throw new Error(`${label}.challengeRefs must contain at most 256 references`);
  const challengeIds = new Set<string>();
  const challengeRefs = revision.challengeRefs.map((rawRef, index) => {
    const refLabel = `${label}.challengeRefs[${index}]`;
    assertExactKeys(rawRef, refLabel, ['family', 'challengeId']);
    const ref = rawRef as Record<string, unknown>;
    if (ref.family !== 'map') throw new Error(`${refLabel}.family must be map`);
    const challengeId = requireString(ref.challengeId, `${refLabel}.challengeId`);
    if (challengeIds.has(challengeId)) throw new Error(`Duplicate challenge reference ${mapId}/${gameplayRevisionId}/${challengeId}`);
    challengeIds.add(challengeId);
    return { family: 'map' as const, challengeId };
  }).sort((left, right) => left.challengeId.localeCompare(right.challengeId));
  return { gameplayRevisionId, mapId, mapVariant: revision.mapVariant, lifecycle: revision.lifecycle, enabled: true, isDefault: revision.isDefault, isSelectable: revision.isSelectable, gameVersion, spatialConfig, challengeRefs };
}

function validatePlatformAchievements(platformData: PlatformData, titleKeys: Set<string>, catalog: ValidatedMapCatalog) {
  const challengeIds = new Set<string>();
  const challengeIdentities = new Set<string>();
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
      const gameplayRevisionId = requireString(item.gameplayRevisionId, `${prefix}.gameplayRevisionId`);
      const revision = catalog.revisions.get(gameplayRevisionId);
      if (!revision || revision.mapId !== mapId) throw new Error(`${prefix} references unknown map revision ${mapId}/${gameplayRevisionId}`);
      if (item.mapVariant !== undefined && item.mapVariant !== revision.mapVariant) throw new Error(`${prefix}.mapVariant disagrees with ${gameplayRevisionId}`);
      if (item.gameVersion !== revision.gameVersion) throw new Error(`${prefix}.gameVersion disagrees with ${gameplayRevisionId}`);
      const rule = item.mapTitleRule;
      if (item.mapVariant === 'classic') {
        if (titleKey !== 'CLASSIC') throw new Error(`${prefix}.mapVariant classic must reference CLASSIC`);
      } else if (!rule || typeof rule !== 'object' || Array.isArray(rule) || rule.dynamic !== true || typeof rule.ruleId !== 'string' || !TITLE_DISPLAY_KINDS.has(rule.displayKind) || !TITLE_SLOTS.has(rule.slot)) {
        throw new Error(`${prefix} has an invalid dynamic map title rule`);
      }
      const challengeIdentity = `${challengeId}:${mapId}:${gameplayRevisionId}`;
      if (challengeIdentities.has(challengeIdentity)) throw new Error(`Duplicate challengeId: ${challengeId}`);
      challengeIdentities.add(challengeIdentity);
    } else {
      throw new Error(`${prefix} has an unsupported challenge enum`);
    }
    if (item.family !== 'map') {
      if (challengeIdentities.has(challengeId)) throw new Error(`Duplicate challengeId: ${challengeId}`);
      challengeIdentities.add(challengeId);
    }
    challengeIds.add(challengeId);
  }
  for (const revision of catalog.revisions.values()) {
    for (const challengeRef of revision.challengeRefs) {
      const referenced = platformData.achievements.some((item) => item.family === 'map'
        && item.mapId === revision.mapId
        && item.gameplayRevisionId === revision.gameplayRevisionId
        && item.challengeId === challengeRef.challengeId);
      if (!referenced) throw new Error(`Map revision ${revision.mapId}/${revision.gameplayRevisionId} references unknown challenge ${challengeRef.challengeId}`);
    }
  }
  return challengeIds;
}

function validatePlatformMaps(platformData: PlatformData, titleSource: TitleSource) {
  const sourceMapKeys = new Set(titleSource.mapTitles.map((item) => requireString(item.mapKey, 'mapTitles.mapKey')));
  const mapIds = new Set<string>();
  const mapKeyById = new Map<string, string>();
  const platformMapIds = new Set<string>();
  const maps = new Map<string, ValidatedPlatformMap>();
  const revisions = new Map<string, ValidatedGameplayRevision>();
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
    if (!Array.isArray(item.mechanics) || item.mechanics.length > 16 || item.mechanics.some((value: unknown) => typeof value !== 'string' || value.trim() === '')) {
      throw new Error(`${prefix}.mechanics must contain non-empty strings`);
    }
    for (const field of ['coverUrl', 'backgroundUrl']) {
      if (item[field] !== null && (typeof item[field] !== 'string' || !/^https?:\/\//.test(item[field]))) throw new Error(`${prefix}.${field} must be a valid URL or null`);
    }
    if (!mapKeyById.has(mapId)) throw new Error(`${prefix} references unknown Bastion map ${mapId}`);
    if (!Array.isArray(item.gameplayRevisions) || item.gameplayRevisions.length > 32) throw new Error(`${prefix}.gameplayRevisions must contain at most 32 revisions`);
    const gameplayRevisions = item.gameplayRevisions.map((revision, revisionIndex) => validateGameplayRevision(revision, mapId, `${prefix}.gameplayRevisions[${revisionIndex}]`));
    const defaultRevisions = gameplayRevisions.filter((revision) => revision.isDefault);
    if (defaultRevisions.length !== 1) throw new Error(`${prefix}.gameplayRevisions must contain exactly one default revision`);
    for (const revision of gameplayRevisions) {
      if (revisions.has(revision.gameplayRevisionId)) throw new Error(`Duplicate gameplay revision ID: ${revision.gameplayRevisionId}`);
      revisions.set(revision.gameplayRevisionId, revision);
    }
    maps.set(mapId, {
      mapId,
      mapName: requireString(item.mapName, `${prefix}.mapName`),
      gameVersion: requireString(item.gameVersion, `${prefix}.gameVersion`),
      difficultyRating: item.difficultyRating as string | null,
      mechanics: item.mechanics as string[],
      coverUrl: item.coverUrl as string | null,
      backgroundUrl: item.backgroundUrl as string | null,
      gameplayRevisions
    });
    mapIds.delete(mapId);
  }
  if (mapIds.size) throw new Error(`Platform maps are missing Bastion maps: ${[...mapIds].join(', ')}`);
  return { maps, revisions } satisfies ValidatedMapCatalog;
}

function validateAndMergeTitles(platformData: PlatformData, titleSource: TitleSource, mapIds: Set<string>) {
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
    const definition = JSON.stringify({ label, category, condition, availability: item.availability, displayKind: item.displayKind, color: item.color });
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

function hasMapSource(mapId: string, mapSourceFiles: Array<{ file: string; content: string }>): boolean {
  const revisionMacroMarker = `${mapRevisionStem(mapId)}_DEFAULT()`;
  return mapSourceFiles.some(({ content }) => content.includes(revisionMacroMarker));
}

const MAP_REVISION_BEGIN = '# BEGIN AUTO-GENERATED PLATFORM MAP REVISION';
const MAP_REVISION_END = '# END AUTO-GENERATED PLATFORM MAP REVISION';

function escapeRegex(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function replaceManagedBlock(source: string, beginMarker: string, endMarker: string, blockContent: string): string | null {
  const pattern = new RegExp(`${escapeRegex(beginMarker)}[\\s\\S]*?${escapeRegex(endMarker)}`);
  return pattern.test(source) ? source.replace(pattern, blockContent) : null;
}

export function validateRevisionAwareMapSources({ mapIds, mapSourceFiles }: { mapIds: string[]; mapSourceFiles: Array<{ file: string; content: string }> }) {
  for (const mapId of mapIds) {
    const mapKey = mapKeyFromPlatformId(mapId).replace(/^DATA_/, '');
    const marker = `platformMapRevision_${mapKey}_DEFAULT()`;
    const matches = mapSourceFiles.filter(({ content }) => content.includes(marker));
    if (matches.length !== 1) throw new Error(`${mapKeyFromPlatformId(mapId)} must declare exactly one revision-aware map source`);
    const source = matches[0]!;
    if (!source.content.includes(MAP_REVISION_BEGIN) || !source.content.includes(MAP_REVISION_END)) throw new Error(`${source.file} must contain the generated platform revision macro block`);
  }
}

function collectDynamicMapTitleDefinitions(platformData: PlatformData, mapIds: Set<string>) {
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
    if (item.availability !== 'active' && item.availability !== 'retired') throw new Error(`${prefix}.availability has an unsupported value`);
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
    const playerName = requireString(item.playerName, `${prefix}.playerName`);
    if (players.has(playerName)) throw new Error(`Duplicate player name: ${playerName}`);
    players.set(playerName, { name: playerName, titleKeys: item.titleKeys, allTitles: item.allTitles === true });
  }
  const revisionsById = new Map<string, ValidatedGameplayRevision>();
  const defaultRevisionByMap = new Map<string, string>();
  for (const map of platformData.maps) {
    const mapId = requireString(map.mapId, 'mapId');
    if (!Array.isArray(map.gameplayRevisions)) throw new Error(`maps.${mapId}.gameplayRevisions must be an array`);
    const revisions = map.gameplayRevisions.map((revision, index) => validateGameplayRevision(revision, mapId, `maps.${mapId}.gameplayRevisions[${index}]`));
    if (revisions.filter((revision) => revision.isDefault).length !== 1) throw new Error(`maps.${mapId}.gameplayRevisions must contain exactly one default revision`);
    for (const revision of revisions) {
      if (revisionsById.has(revision.gameplayRevisionId)) throw new Error(`Duplicate gameplay revision ID: ${revision.gameplayRevisionId}`);
      revisionsById.set(revision.gameplayRevisionId, revision);
      if (revision.isDefault) defaultRevisionByMap.set(mapId, revision.gameplayRevisionId);
    }
  }
  const holdersByMap = new Map<string, { PIONEER: string[]; CONQUEROR: string[]; DOMINATOR: string[]; CLASSIC: string[] }>();
  for (const [index, item] of platformData.mapTitleHolders.entries()) {
    const prefix = `mapTitleHolders[${index}]`; const mapId = requireString(item.mapId, `${prefix}.mapId`); const gameplayRevisionId = requireString(item.gameplayRevisionId, `${prefix}.gameplayRevisionId`); const playerName = requireString(item.playerName, `${prefix}.playerName`); requireString(item.playerId, `${prefix}.playerId`); const titleKey = requireString(item.titleKey, `${prefix}.titleKey`);
    const revision = revisionsById.get(gameplayRevisionId);
    const slot = item.slotSemantics === 'named'
      ? requireString(item.slot, `${prefix}.slot`)
      : item.slotSemantics === 'none' && item.slot === null && titleKey === 'CLASSIC'
        ? 'classic'
        : (() => { throw new Error(`${prefix} has an invalid slot semantics`); })();
    if (!mapIds.has(mapId) || !revision || revision.mapId !== mapId || !TITLE_SLOTS.has(slot) || !mapTitleDefinitions.has(`${mapId}:${slot}`) || !mapTitleMetadata.has(`${mapId}:${titleKey}`)) throw new Error(`${prefix} has an invalid map, revision, slot or title reference`);
    const player = players.get(playerName);
    if (player?.allTitles !== true) {
      if (!player) players.set(playerName, { name: playerName, titleKeys: [titleKey], allTitles: false });
      else if (Array.isArray(player.titleKeys) && !player.titleKeys.includes(titleKey)) player.titleKeys.push(titleKey);
    }
    if (defaultRevisionByMap.get(mapId) !== gameplayRevisionId) continue;
    const mapKey = mapKeyFromPlatformId(mapId); const holders = holdersByMap.get(mapKey) ?? { PIONEER: [], CONQUEROR: [], DOMINATOR: [], CLASSIC: [] };
    const target = holders[slot.toUpperCase() as 'PIONEER' | 'CONQUEROR' | 'DOMINATOR' | 'CLASSIC']; if (target.includes(playerName)) throw new Error(`Duplicate map holder: ${mapId}/${slot}/${playerName}`); target.push(playerName); holdersByMap.set(mapKey, holders);
  }
  const titleIds = new Map([...titleRecords.keys()].map((key, index) => [key, index]));
  const normalizedPlayers = [...players.values()].sort((left, right) => String(left.name).localeCompare(String(right.name))).map((player) => {
    if (!Array.isArray(player.titleKeys) || player.titleKeys.some((key: unknown) => typeof key !== 'string' || !titleRecords.has(key))) throw new Error(`Invalid titleKeys for player ${player.name}`);
    return { name: player.name, titleKeys: player.allTitles ? undefined : [...new Set(player.titleKeys as string[])].sort((a, b) => titleIds.get(a)! - titleIds.get(b)!), allTitles: player.allTitles === true };
  });
  const mapTitles = [...mapIds].sort().map((mapId) => ({ mapKey: mapKeyFromPlatformId(mapId), mapLabel: mapLabels.get(mapId)!, holders: holdersByMap.get(mapKeyFromPlatformId(mapId)) ?? { PIONEER: [], CONQUEROR: [], DOMINATOR: [], CLASSIC: [] } }));
  for (const map of mapTitles) { const conquerors = new Set(map.holders.CONQUEROR); if (map.holders.DOMINATOR.some((name) => !conquerors.has(name))) throw new Error(`${map.mapKey}: DOMINATOR holder must also be CONQUEROR`); }
  const titles = [...titleRecords.values()].map((item) => ({ key: item.titleKey, label: item.label, category: item.category, condition: item.condition, availability: item.availability, displayExpr: item.titleKey === 'CLASSIC' ? '__currentMapClassicText___' : titleDisplayExpr(item, `titles.${item.titleKey}`), colorExpr: titleColorExpr(item.color, `titles.${item.titleKey}`) }));
  return { meta: { sourceLabel: 'OWBastion Agents API' }, titles, players: normalizedPlayers.map(({ name, titleKeys, allTitles }) => allTitles ? { name, allTitles } : { name, titleKeys }), mapTitles };
}

export function buildPlatformMapRevisionSource({ platformData }: { platformData: PlatformData }): PlatformMapRevisionSource {
  const syntheticTitleSource = {
    meta: { sourceLabel: 'platform-map-revision-validation' },
    titles: [],
    players: [],
    mapTitles: platformData.maps.map((map) => ({ mapKey: mapKeyFromPlatformId(requireString(map.mapId, 'mapId')) }))
  } as TitleSource;
  const catalog = validatePlatformMaps(platformData, syntheticTitleSource);
  const titleKeys = new Set(platformData.titles.map((item) => requireString(item.titleKey, 'titleKey')));
  validatePlatformAchievements(platformData, titleKeys, catalog);
  const holdersByRevision = new Map<string, PlatformMapRevisionSource['maps'][number]['revisions'][number]['titleHolders']>();
  const holderIdentitiesByRevision = new Map<string, Set<string>>();
  for (const [index, item] of platformData.mapTitleHolders.entries()) {
    const prefix = `mapTitleHolders[${index}]`;
    assertExactKeys(item, prefix, ['mapId', 'gameplayRevisionId', 'titleKey', 'slot', 'slotSemantics', 'playerId', 'playerName']);
    const mapId = requireString(item.mapId, `${prefix}.mapId`);
    const gameplayRevisionId = requireString(item.gameplayRevisionId, `${prefix}.gameplayRevisionId`);
    const revision = catalog.revisions.get(gameplayRevisionId);
    const titleKey = requireString(item.titleKey, `${prefix}.titleKey`);
    const playerId = requireString(item.playerId, `${prefix}.playerId`);
    const playerName = requireString(item.playerName, `${prefix}.playerName`);
    if (!revision || revision.mapId !== mapId) throw new Error(`${prefix} references unknown map revision ${mapId}/${gameplayRevisionId}`);
    if (item.slotSemantics !== 'named' && item.slotSemantics !== 'none') throw new Error(`${prefix}.slotSemantics has an unsupported value`);
    if (item.slotSemantics === 'named' && !['pioneer', 'conqueror', 'dominator'].includes(String(item.slot))) throw new Error(`${prefix} has an invalid named slot`);
    if (item.slotSemantics === 'none' && (item.slot !== null || titleKey !== 'CLASSIC')) throw new Error(`${prefix} has an invalid none slot reference`);
    const title = platformData.titles.find((candidate) => candidate.titleKey === titleKey && candidate.scope === 'map' && candidate.mapId === mapId);
    if (!title) throw new Error(`${prefix} references unknown map title ${mapId}/${titleKey}`);
    const holder = { titleKey, slot: item.slotSemantics === 'none' ? null : item.slot as 'pioneer' | 'conqueror' | 'dominator', slotSemantics: item.slotSemantics, playerId, playerName };
    const identity = `${titleKey}:${holder.slot ?? 'classic'}:${playerName}`;
    const identities = holderIdentitiesByRevision.get(gameplayRevisionId) ?? new Set<string>();
    if (identities.has(identity)) throw new Error(`Duplicate map holder: ${mapId}/${gameplayRevisionId}/${identity}`);
    identities.add(identity);
    holderIdentitiesByRevision.set(gameplayRevisionId, identities);
    const current = holdersByRevision.get(gameplayRevisionId) ?? [];
    const duplicate = current.some((candidate) => candidate.titleKey === holder.titleKey && candidate.slot === holder.slot && candidate.playerId === holder.playerId);
    if (duplicate) throw new Error(`Duplicate map holder: ${mapId}/${gameplayRevisionId}/${titleKey}/${playerId}`);
    current.push(holder);
    holdersByRevision.set(gameplayRevisionId, current);
  }
  return {
    contractVersion: PLATFORM_DATA_CONTRACT_VERSION,
    maps: [...catalog.maps.values()].sort((left, right) => left.mapId.localeCompare(right.mapId)).map((map) => ({
      mapId: map.mapId,
      mapName: map.mapName,
      revisions: map.gameplayRevisions
        .slice()
        .sort((left, right) => Number(right.isDefault) - Number(left.isDefault) || left.gameplayRevisionId.localeCompare(right.gameplayRevisionId))
        .map((revision) => ({
          ...revision,
          spatialConfig: revision.spatialConfig,
          challengeRefs: revision.challengeRefs.slice().sort((left, right) => left.challengeId.localeCompare(right.challengeId)),
          titleHolders: (holdersByRevision.get(revision.gameplayRevisionId) ?? []).slice().sort((left, right) => left.titleKey.localeCompare(right.titleKey) || String(left.slot).localeCompare(String(right.slot)) || left.playerId.localeCompare(right.playerId) || left.playerName.localeCompare(right.playerName))
        }))
    }))
  };
}

function renderSpatialPosition(position: SpatialPosition): string {
  return `vect(${position.map((part) => Object.is(part, -0) ? '0' : String(part)).join(', ')})`;
}

function renderVectorAssignment(field: string, positions: SpatialPosition[], indent: string, compressed = false): string[] {
  const opening = compressed ? 'compressed([' : '[';
  const lines = [`${indent}${field} = ${opening}`];
  const itemIndent = `${indent}    `;
  positions.forEach((position, index) => lines.push(`${itemIndent}${renderSpatialPosition(position)}${index === positions.length - 1 ? '' : ','}`));
  lines.push(`${indent}]${compressed ? ')' : ''}`);
  return lines;
}

function renderPlayerIndexDelimited(names: string[]): string {
  return names.length === 0 ? '[]' : `playerNameToIndexDelimited([${names.map((name) => JSON.stringify(name)).join(', ')}], "-")`;
}

function mapRevisionStem(mapId: string): string {
  return `platformMapRevision_${mapKeyFromPlatformId(mapId).replace(/^DATA_/, '')}`;
}

function mapRevisionVariantName(revision: PlatformMapRevisionSource['maps'][number]['revisions'][number]): 'DEFAULT' | 'CLASSIC' {
  return revision.mapVariant === 'classic' ? 'CLASSIC' : 'DEFAULT';
}

function mapRevisionMacroName(mapId: string, variant: 'DEFAULT' | 'CLASSIC'): string {
  return `${mapRevisionStem(mapId)}_${variant}`;
}

function stageMacroName(mapId: string, variant: 'DEFAULT' | 'CLASSIC', stageId: string): string {
  const safeStageId = stageId.replace(/[^a-zA-Z0-9_]/g, '_').toUpperCase();
  return `${mapRevisionMacroName(mapId, variant)}_STAGE_${safeStageId}`;
}

function renderSpatialAssignments(lines: string[], config: SpatialConfigBase, compressedBastion = false) {
  lines.push(...renderVectorAssignment('bastionPosition', config.bastionPositions, '    ', compressedBastion));
  lines.push(`    resetPosition = ${renderSpatialPosition(config.resetPosition)}`);
  lines.push(`    endPosition = ${renderSpatialPosition(config.endPosition)}`);
  lines.push(`    thirdPersonPosition = ${renderSpatialPosition(config.thirdPersonPosition)}`);
  lines.push(`    creditsPosition = ${renderSpatialPosition(config.creditsPosition)}`);
  if (config.control) {
    if (config.control.centerPositions.length > 0) lines.push(...renderVectorAssignment('controlCenterPosition', config.control.centerPositions, '    '));
    if (config.control.jumpPositions.length > 0) lines.push(...renderVectorAssignment('controlJumpPosition', config.control.jumpPositions, '    '));
    if (config.control.respawnPositions.length > 0) lines.push(...renderVectorAssignment('controlRespawnPosition', config.control.respawnPositions, '    '));
    if (config.control.respawnAxis !== null) {
      const axis = { x: 0, y: 1, z: 2 }[config.control.respawnAxis];
      lines.push(`    controlRespawnAxis = ${axis}`);
      lines.push(`    controlRespawnAxisThreshold = ${config.control.respawnAxisThreshold}`);
    }
  }
  if (config.portalPositions.length > 0) lines.push(...renderVectorAssignment('portalPosition', config.portalPositions, '    '));
  if (config.springboardPositions.length > 0) lines.push(`    springBoardPosition = ${renderSpatialPosition(config.springboardPositions[0]!)}`);
}

function renderRevisionTitleHolderExpression(revision: PlatformMapRevisionSource['maps'][number]['revisions'][number]) {
  const classicHolders = revision.titleHolders
    .filter((holder) => (holder.slotSemantics === 'none' ? 'classic' : holder.slot) === 'classic')
    .map((holder) => holder.playerName);
  return renderPlayerIndexDelimited(classicHolders);
}

function renderMapRevisionBlock(map: PlatformMapRevisionSource['maps'][number]): string {
  const unsupported = map.revisions.filter((revision) => !revision.isDefault && revision.mapVariant !== 'classic');
  if (unsupported.length > 0) throw new Error(`${map.mapId} has selectable revisions that cannot be selected by the compile-time map source: ${unsupported.map((revision) => revision.gameplayRevisionId).join(', ')}`);

  const mapKey = mapKeyFromPlatformId(map.mapId);
  const lines = [
    MAP_REVISION_BEGIN,
    '# Source: OWBastion Agents API',
  ];
  const titleMacros = new Map<string, string>();
  for (const revision of map.revisions) {
    if (revision.mapVariant === 'classic') titleMacros.set(mapRevisionVariantName(revision), renderRevisionTitleHolderExpression(revision));
  }
  if (titleMacros.size > 0) lines.push('');

  for (const revision of map.revisions) {
    const variant = mapRevisionVariantName(revision);
    const macroName = mapRevisionMacroName(map.mapId, variant);
    const isClassic = variant === 'CLASSIC';
    lines.push(`macro ${macroName}():`);
    lines.push(`    platformMapRevisionId = ${JSON.stringify(revision.gameplayRevisionId)}`);
    lines.push(`    platformMapRevisionVariant = ${JSON.stringify(isClassic ? 'classic' : null)}`);
    const mapText = JSON.stringify(map.mapName);
    lines.push(`    __currentMapText___ = ${isClassic ? `STR_HUD_MAP_CLASSIC_SUFFIX.format(${mapText})` : mapText}`);
    lines.push(`    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format(${mapText})`);
    lines.push('    __currentMapPioneerText___ = __currentMapText___');
    lines.push('');
    renderSpatialAssignments(lines, revision.spatialConfig, mapKey === 'DATA_ANTARCTIC_PENINSULA');
    lines.push('');
    if (isClassic) {
      lines.push('    mapTitlePlayersByKey = [');
      lines.push('        [],');
      lines.push('        [],');
      lines.push('        [],');
      lines.push(`        ${titleMacros.get(variant)}`);
      lines.push('    ]');
    } else {
      lines.push('    mapTitlePlayersByKey = [');
      lines.push(`        ${mapKey}[0].split("-"),`);
      lines.push(`        ${mapKey}[1].split("-"),`);
      lines.push(`        ${mapKey}[2].split("-")`);
      lines.push('    ]');
    }
    for (const stage of revision.spatialConfig.alternateStages) {
      const setupPositionMacro = `${stageMacroName(map.mapId, variant, stage.stageId)}_SETUP_POSITION`;
      const setupRadiusMacro = `${stageMacroName(map.mapId, variant, stage.stageId)}_SETUP_RADIUS`;
      lines.push('');
      lines.push(`#!define ${setupPositionMacro} ${renderSpatialPosition(stage.setupDetection.position)}`);
      lines.push(`#!define ${setupRadiusMacro} ${stage.setupDetection.radius}`);
      lines.push(`macro ${stageMacroName(map.mapId, variant, stage.stageId)}():`);
      renderSpatialAssignments(lines, stage, false);
    }
    lines.push('');
  }
  lines.push(MAP_REVISION_END);
  return lines.join('\n');
}

export function renderPlatformMapRevisionData(source: PlatformMapRevisionSource): string {
  return source.maps.map((map) => renderMapRevisionBlock(map)).join('\n\n') + '\n';
}

export function renderPlatformMapRevisionMapSources({
  source,
  mapSourceFiles
}: {
  source: PlatformMapRevisionSource;
  mapSourceFiles: Array<{ file: string; content: string }>;
}): GeneratedPlatformFile[] {
  return source.maps.map((map) => {
    const matches = mapSourceFiles.filter(({ content }) => content.includes(`${mapRevisionStem(map.mapId)}_DEFAULT()`));
    if (matches.length !== 1) throw new Error(`${mapKeyFromPlatformId(map.mapId)} must match exactly one map source for compile-time revision injection`);
    const sourceFile = matches[0]!;
    const content = replaceManagedBlock(sourceFile.content, MAP_REVISION_BEGIN, MAP_REVISION_END, renderMapRevisionBlock(map));
    if (content === null) throw new Error(`${sourceFile.file} must contain the generated platform revision macro block`);
    return { path: path.join(MAP_SOURCE_DIR, sourceFile.file), content };
  });
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
  for (const command of ['build:main', 'build:dev']) {
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
