import path from 'node:path';
import { fileURLToPath } from 'node:url';
import {
  PLATFORM_DATA_CONTRACT_VERSION,
  assertExactKeys,
  assertUnique,
  requireNumber,
  requireString,
  type JsonObject,
  type PlatformData,
  type TitleSource,
  MAP_DIFFICULTIES,
  CHALLENGE_STATUSES,
  SUBMISSION_MODES,
  TITLE_DISPLAY_KINDS,
  TITLE_SLOTS
} from './platform-data-client.ts';

const MAP_SOURCE_DIR = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../src/map');

export type SpatialPosition = [number, number, number];

export type AlternateStageSetupDetection = { position: SpatialPosition; radius: number };

export type SpatialConfigBase = {
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

export type LegacySpatialConfig = SpatialConfigBase & {
  alternateStages: Array<SpatialConfigBase & { stageId: string; setupDetection: AlternateStageSetupDetection }>;
};

export type CompositeStageControl = {
  centerPositions: SpatialPosition[];
  jumpPositions: [SpatialPosition];
  respawnPositions: [SpatialPosition];
};

export type CompositeSpatialStage = {
  stageId: string;
  setupDetection?: AlternateStageSetupDetection;
  resetPosition?: SpatialPosition;
  endPosition?: SpatialPosition;
  thirdPersonPosition?: SpatialPosition;
  creditsPosition?: SpatialPosition;
  bastionPositions: SpatialPosition[];
  control: CompositeStageControl;
  portalPositions: SpatialPosition[];
  springboardPositions: SpatialPosition[];
};

export type CompositeSpatialConfig = {
  resetPosition: SpatialPosition;
  endPosition: SpatialPosition;
  thirdPersonPosition: SpatialPosition;
  creditsPosition: SpatialPosition;
  control: { respawnAxis: 'x' | 'y' | 'z'; respawnAxisThreshold: number };
  composition: {
    selectionCount: number;
    firstStageSelection: { mode: 'setup_detection'; fallbackStageId: string } | { mode: 'random' };
    remainingStageSelection: 'random_unique' | 'stage_id_cycle';
  };
  stages: CompositeSpatialStage[];
};

export type SpatialConfig = LegacySpatialConfig | CompositeSpatialConfig;

export type ValidatedGameplayRevision = {
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

export type ValidatedPlatformMap = {
  mapId: string;
  mapName: string;
  gameVersion: string;
  difficultyRating: string | null;
  mechanics: string[];
  coverUrl: string | null;
  backgroundUrl: string | null;
  gameplayRevisions: ValidatedGameplayRevision[];
};

export type ValidatedMapCatalog = {
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
        playerId: string | null;
        playerName: string;
      }>;
    }>;
  }>;
};

export function platformMapId(mapKey: string): string {
  return `map.${mapKey.replace(/^DATA_/, '').toLocaleLowerCase()}`;
}

export function validateSpatialPosition(value: unknown, label: string): SpatialPosition {
  if (!Array.isArray(value) || value.length !== 3 || value.some((part) => typeof part !== 'number' || !Number.isFinite(part))) {
    throw new Error(`${label} must be a finite 3D coordinate`);
  }
  return value as SpatialPosition;
}

export function validateSpatialPositions(value: unknown, label: string, required: boolean): SpatialPosition[] {
  if (!Array.isArray(value) || value.length > 128 || (required && value.length < 1)) {
    throw new Error(`${label} must contain ${required ? 'one or more and ' : ''}at most 128 coordinates`);
  }
  return value.map((position, index) => validateSpatialPosition(position, `${label}[${index}]`));
}

export function validateAlternateStageSetupDetection(value: unknown, label: string): AlternateStageSetupDetection {
  assertExactKeys(value, label, ['position', 'radius']);
  const detection = value as Record<string, unknown>;
  const radius = detection.radius;
  if (typeof radius !== 'number' || !Number.isFinite(radius) || radius <= 0) throw new Error(`${label}.radius must be a positive finite number`);
  return { position: validateSpatialPosition(detection.position, `${label}.position`), radius };
}

export const spatialConfigKeys = ['bastionPositions', 'resetPosition', 'endPosition', 'thirdPersonPosition', 'creditsPosition', 'control', 'portalPositions', 'springboardPositions'];

export const compositeSharedSpatialKeys = ['resetPosition', 'endPosition', 'thirdPersonPosition', 'creditsPosition', 'control'];

export const compositeStageSpatialKeys = ['bastionPositions', 'control', 'portalPositions', 'springboardPositions'];

export const compositeStageRouteAnchorKeys = ['resetPosition', 'endPosition', 'thirdPersonPosition', 'creditsPosition'];

export function validateSpatialConfigBase(value: unknown, label: string): SpatialConfigBase {
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

export function validateSpatialConfig(value: unknown, label: string): SpatialConfig {
  if (!value || typeof value !== 'object' || Array.isArray(value)) throw new Error(`${label} must be an object`);
  const config = value as Record<string, unknown>;
  if ('composition' in config || 'stages' in config) {
    assertExactKeys(config, label, [...compositeSharedSpatialKeys, 'composition', 'stages']);
    assertExactKeys(config.composition, `${label}.composition`, ['selectionCount', 'firstStageSelection', 'remainingStageSelection']);
    const rawComposition = config.composition as Record<string, unknown>;
    const selectionCount = rawComposition.selectionCount;
    if (typeof selectionCount !== 'number' || !Number.isInteger(selectionCount) || selectionCount < 2 || selectionCount > 16) {
      throw new Error(`${label}.composition.selectionCount must be an integer from 2 to 16`);
    }
    const remainingStageSelection = rawComposition.remainingStageSelection;
    if (remainingStageSelection !== 'random_unique' && remainingStageSelection !== 'stage_id_cycle') {
      throw new Error(`${label}.composition.remainingStageSelection must be random_unique or stage_id_cycle`);
    }
    const rawFirstStageSelection = rawComposition.firstStageSelection;
    if (!rawFirstStageSelection || typeof rawFirstStageSelection !== 'object' || Array.isArray(rawFirstStageSelection)) {
      throw new Error(`${label}.composition.firstStageSelection must be an object`);
    }
    const firstStageSelectionValue = rawFirstStageSelection as Record<string, unknown>;
    let firstStageSelection: CompositeSpatialConfig['composition']['firstStageSelection'];
    if (firstStageSelectionValue.mode === 'setup_detection') {
      assertExactKeys(firstStageSelectionValue, `${label}.composition.firstStageSelection`, ['mode', 'fallbackStageId']);
      firstStageSelection = {
        mode: 'setup_detection',
        fallbackStageId: requireString(firstStageSelectionValue.fallbackStageId, `${label}.composition.firstStageSelection.fallbackStageId`)
      };
      if (!/^[a-z0-9][a-z0-9_-]*$/.test(firstStageSelection.fallbackStageId) || firstStageSelection.fallbackStageId.length > 64) {
        throw new Error(`${label}.composition.firstStageSelection.fallbackStageId has an unsupported value`);
      }
    } else if (firstStageSelectionValue.mode === 'random') {
      assertExactKeys(firstStageSelectionValue, `${label}.composition.firstStageSelection`, ['mode']);
      firstStageSelection = { mode: 'random' };
    } else {
      throw new Error(`${label}.composition.firstStageSelection.mode has an unsupported value`);
    }
    const rawStages = config.stages;
    if (!Array.isArray(rawStages) || rawStages.length < 2 || rawStages.length > 16) {
      throw new Error(`${label}.stages must contain between 2 and 16 stages`);
    }
    const stageIds = new Set<string>();
    const stages = rawStages.map((rawStage, index) => {
      const stageLabel = `${label}.stages[${index}]`;
      if (!rawStage || typeof rawStage !== 'object' || Array.isArray(rawStage)) throw new Error(`${stageLabel} must be an object`);
      const stage = rawStage as Record<string, unknown>;
      const expectedKeys = ['stageId', ...compositeStageSpatialKeys];
      const allowedKeys = [...expectedKeys, 'setupDetection', ...compositeStageRouteAnchorKeys];
      const actualKeys = Object.keys(stage).sort();
      if (compositeStageSpatialKeys.some((key) => !(key in stage)) || actualKeys.some((key) => !allowedKeys.includes(key))) throw new Error(`${stageLabel} has an invalid shape; expected keys ${allowedKeys.join(', ')}`);
      const stageId = requireString(stage.stageId, `${stageLabel}.stageId`);
      if (!/^[a-z0-9][a-z0-9_-]*$/.test(stageId) || stageId.length > 64) throw new Error(`${stageLabel}.stageId has an unsupported value`);
      if (stageIds.has(stageId)) throw new Error(`Duplicate composite spatial stage ${stageId}`);
      stageIds.add(stageId);
      assertExactKeys(stage.control, `${stageLabel}.control`, ['centerPositions', 'jumpPositions', 'respawnPositions']);
      const rawControl = stage.control as Record<string, unknown>;
      const centerPositions = validateSpatialPositions(rawControl.centerPositions, `${stageLabel}.control.centerPositions`, false);
      const jumpPositions = validateSpatialPositions(rawControl.jumpPositions, `${stageLabel}.control.jumpPositions`, false);
      const respawnPositions = validateSpatialPositions(rawControl.respawnPositions, `${stageLabel}.control.respawnPositions`, false);
      if (jumpPositions.length !== 1 || respawnPositions.length !== 1) throw new Error(`${stageLabel}.control must contain exactly one jump and one respawn position`);
      return {
        stageId,
        ...(stage.setupDetection === undefined ? {} : { setupDetection: validateAlternateStageSetupDetection(stage.setupDetection, `${stageLabel}.setupDetection`) }),
        ...(stage.resetPosition === undefined ? {} : { resetPosition: validateSpatialPosition(stage.resetPosition, `${stageLabel}.resetPosition`) }),
        ...(stage.endPosition === undefined ? {} : { endPosition: validateSpatialPosition(stage.endPosition, `${stageLabel}.endPosition`) }),
        ...(stage.thirdPersonPosition === undefined ? {} : { thirdPersonPosition: validateSpatialPosition(stage.thirdPersonPosition, `${stageLabel}.thirdPersonPosition`) }),
        ...(stage.creditsPosition === undefined ? {} : { creditsPosition: validateSpatialPosition(stage.creditsPosition, `${stageLabel}.creditsPosition`) }),
        bastionPositions: validateSpatialPositions(stage.bastionPositions, `${stageLabel}.bastionPositions`, true),
        control: { centerPositions, jumpPositions: jumpPositions as [SpatialPosition], respawnPositions: respawnPositions as [SpatialPosition] },
        portalPositions: validateSpatialPositions(stage.portalPositions, `${stageLabel}.portalPositions`, false),
        springboardPositions: validateSpatialPositions(stage.springboardPositions, `${stageLabel}.springboardPositions`, false)
      };
    }).sort((left, right) => left.stageId < right.stageId ? -1 : left.stageId > right.stageId ? 1 : 0);
    const routeControlValue = config.control;
    assertExactKeys(routeControlValue, `${label}.control`, ['respawnAxis', 'respawnAxisThreshold']);
    const routeControl = routeControlValue as Record<string, unknown>;
    const respawnAxis = routeControl.respawnAxis;
    if (respawnAxis !== 'x' && respawnAxis !== 'y' && respawnAxis !== 'z') throw new Error(`${label}.control.respawnAxis must be x, y, or z`);
    const respawnAxisThreshold = routeControl.respawnAxisThreshold;
    if (typeof respawnAxisThreshold !== 'number' || !Number.isFinite(respawnAxisThreshold) || respawnAxisThreshold < 0) throw new Error(`${label}.control.respawnAxisThreshold must be a non-negative finite number`);
    if (selectionCount > stages.length) throw new Error(`${label}.composition.selectionCount exceeds the number of stages`);
    if (firstStageSelection.mode === 'setup_detection') {
      const fallback = stages.find((stage) => stage.stageId === firstStageSelection.fallbackStageId);
      if (!fallback) throw new Error(`${label}.composition.firstStageSelection fallback stage does not exist`);
      if (fallback.setupDetection) throw new Error(`${label}.stages.${fallback.stageId}.setupDetection must be omitted for the fallback stage`);
      if (stages.some((stage) => stage.stageId !== fallback.stageId && !stage.setupDetection)) {
        throw new Error(`${label}.stages requires setupDetection for every non-fallback stage`);
      }
    } else if (stages.some((stage) => stage.setupDetection)) {
      throw new Error(`${label}.stages.setupDetection is not supported with random first-stage selection`);
    }
    return {
      resetPosition: validateSpatialPosition(config.resetPosition, `${label}.resetPosition`),
      endPosition: validateSpatialPosition(config.endPosition, `${label}.endPosition`),
      thirdPersonPosition: validateSpatialPosition(config.thirdPersonPosition, `${label}.thirdPersonPosition`),
      creditsPosition: validateSpatialPosition(config.creditsPosition, `${label}.creditsPosition`),
      control: { respawnAxis, respawnAxisThreshold },
      composition: { selectionCount, firstStageSelection, remainingStageSelection },
      stages
    };
  }
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

export function validateMigratedMapSpatialConfig(mapId: string, config: SpatialConfig, label: string) {
  if (mapId === 'map.busan') {
    if ('composition' in config) {
      if (config.stages.some((stage) => stage.control.centerPositions.length !== 1)) {
        throw new Error(`${label}.stages.control must contain one center position per Busan stage`);
      }
      return;
    }
    if (!config.control) throw new Error(`${label}.control is required for map.busan`);
    if (config.control.respawnPositions.length !== 3 || config.control.centerPositions.length !== 3 || config.control.jumpPositions.length !== 2) {
      throw new Error(`${label}.control must contain three center/respawn and two jump positions for map.busan`);
    }
    return;
  }
  if ((mapId === 'map.paraiso' || mapId === 'map.eichenwalde') && ('composition' in config || config.control !== null)) {
    throw new Error(`${label}.control must be null for ${mapId}`);
  }
}

export function validateGameplayRevision(value: unknown, mapId: string, label: string): ValidatedGameplayRevision {
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

export function validatePlatformMaps(platformData: PlatformData, titleSource: TitleSource) {
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

export function mapKeyFromPlatformId(mapId: string): string {
  if (!/^map\.[a-z0-9_]+$/.test(mapId)) throw new Error(`Invalid platform map ID: ${mapId}`);
  return `DATA_${mapId.slice(4).toUpperCase()}`;
}

export function hasMapSource(mapId: string, mapSourceFiles: Array<{ file: string; content: string }>): boolean {
  const revisionMacroMarker = `${mapRevisionStem(mapId)}_DEFAULT()`;
  return mapSourceFiles.some(({ content }) => content.includes(revisionMacroMarker));
}

export const MAP_REVISION_BEGIN = '# BEGIN AUTO-GENERATED PLATFORM MAP REVISION';

export const MAP_REVISION_END = '# END AUTO-GENERATED PLATFORM MAP REVISION';

export function escapeRegex(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

export function replaceManagedBlock(source: string, beginMarker: string, endMarker: string, blockContent: string): string | null {
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
    assertExactKeys(item, prefix, ['mapId', 'gameplayRevisionId', 'titleKey', 'slot', 'slotSemantics', 'playerName'], ['playerId']);
    const mapId = requireString(item.mapId, `${prefix}.mapId`);
    const gameplayRevisionId = requireString(item.gameplayRevisionId, `${prefix}.gameplayRevisionId`);
    const revision = catalog.revisions.get(gameplayRevisionId);
    const titleKey = requireString(item.titleKey, `${prefix}.titleKey`);
    const playerId = item.playerId == null ? null : requireString(item.playerId, `${prefix}.playerId`);
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
    const duplicate = current.some((candidate) => candidate.titleKey === holder.titleKey && candidate.slot === holder.slot && holder.playerId !== null && candidate.playerId === holder.playerId);
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
          titleHolders: (holdersByRevision.get(revision.gameplayRevisionId) ?? []).slice().sort((left, right) => left.titleKey.localeCompare(right.titleKey) || String(left.slot).localeCompare(String(right.slot)) || String(left.playerId ?? '').localeCompare(String(right.playerId ?? '')) || left.playerName.localeCompare(right.playerName))
        }))
    }))
  };
}

export function renderSpatialPosition(position: SpatialPosition): string {
  return `vect(${position.map((part) => Object.is(part, -0) ? '0' : String(part)).join(', ')})`;
}

export function renderVectorAssignment(field: string, positions: SpatialPosition[], indent: string, compressed = false): string[] {
  const opening = compressed ? 'compressed([' : '[';
  const lines = [`${indent}${field} = ${opening}`];
  const itemIndent = `${indent}    `;
  positions.forEach((position, index) => lines.push(`${itemIndent}${renderSpatialPosition(position)}${index === positions.length - 1 ? '' : ','}`));
  lines.push(`${indent}]${compressed ? ')' : ''}`);
  return lines;
}

export function renderPlayerIndexDelimited(names: string[]): string {
  return names.length === 0 ? '[]' : `playerNameToIndexDelimited([${names.map((name) => JSON.stringify(name)).join(', ')}], "-")`;
}

export function mapRevisionStem(mapId: string): string {
  return `platformMapRevision_${mapKeyFromPlatformId(mapId).replace(/^DATA_/, '')}`;
}

export function mapRevisionVariantName(revision: PlatformMapRevisionSource['maps'][number]['revisions'][number]): 'DEFAULT' | 'CLASSIC' {
  return revision.mapVariant === 'classic' ? 'CLASSIC' : 'DEFAULT';
}

export function mapRevisionMacroName(mapId: string, variant: 'DEFAULT' | 'CLASSIC'): string {
  return `${mapRevisionStem(mapId)}_${variant}`;
}

export function stageMacroName(mapId: string, variant: 'DEFAULT' | 'CLASSIC', stageId: string): string {
  const safeStageId = stageId.replace(/[^a-zA-Z0-9_]/g, '_').toUpperCase();
  return `${mapRevisionMacroName(mapId, variant)}_STAGE_${safeStageId}`;
}

export function compositeStageMacroName(mapId: string, variant: 'DEFAULT' | 'CLASSIC', stageIndex: number): string {
  return `${mapRevisionMacroName(mapId, variant)}_COMPOSITE_STAGE_${stageIndex}`;
}

export function compositeRouteScratchNames(mapId: string) {
  const prefix = `${mapRevisionStem(mapId)}_COMPOSITE`;
  return {
    availableStages: `${prefix}_AVAILABLE_STAGE_INDICES`,
    selectedStages: `${prefix}_SELECTED_STAGE_INDICES`,
    selectedStage: `${prefix}_SELECTED_STAGE_INDEX`,
    stageOrder: `${prefix}_STAGE_ORDER`,
    stageBastionPositions: `${prefix}_STAGE_BASTION_POSITIONS`,
    centerPositionsInitialized: `${prefix}_CENTER_POSITIONS_INITIALIZED`
  };
}

export function hasSpawnDetectedCycle(spatialConfig: CompositeSpatialConfig): boolean {
  return spatialConfig.composition.firstStageSelection.mode === 'setup_detection'
    && spatialConfig.composition.remainingStageSelection === 'stage_id_cycle';
}

export function renderSpatialAssignments(lines: string[], config: SpatialConfigBase, compressedBastion = false) {
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

export function renderCompositeStageMacro(
  lines: string[],
  mapId: string,
  variant: 'DEFAULT' | 'CLASSIC',
  stage: CompositeSpatialStage,
  stageIndex: number,
  selectionCount: number
) {
  const macroName = compositeStageMacroName(mapId, variant, stageIndex);
  const { stageBastionPositions: stagePositions, centerPositionsInitialized } = compositeRouteScratchNames(mapId);
  lines.push(`macro ${macroName}(stageOrder):`);
  lines.push(`    ${stagePositions} = compressed([`);
  stage.bastionPositions.forEach((position, index) => lines.push(`        ${renderSpatialPosition(position)}${index === stage.bastionPositions.length - 1 ? '' : ','}`));
  lines.push('    ])');
  lines.push('    if stageOrder == 0:');
  lines.push(`        bastionPosition = ${stagePositions}`);
  lines.push('    else:');
  lines.push(`        bastionPosition.append(${stagePositions})`);

  if (stage.control.centerPositions.length > 0) {
    lines.push(`    if ${centerPositionsInitialized} != true:`);
    lines.push('        controlCenterPosition = []');
    lines.push(`        ${centerPositionsInitialized} = true`);
    stage.control.centerPositions.forEach((position) => lines.push(`    controlCenterPosition.append(${renderSpatialPosition(position)})`));
  }
  lines.push(`    if stageOrder < ${selectionCount - 1}:`);
  lines.push('        controlJumpPosition.append(' + renderSpatialPosition(stage.control.jumpPositions[0]!) + ')');
  lines.push(`    controlRespawnPosition.append(${renderSpatialPosition(stage.control.respawnPositions[0]!)})`);

  if (stage.portalPositions.length > 0) {
    lines.push('    if portalPosition == null:');
    lines.push('        portalPosition = []');
    stage.portalPositions.forEach((position) => lines.push(`    portalPosition.append(${renderSpatialPosition(position)})`));
  }
  if (stage.springboardPositions.length > 0) {
    lines.push('    if springBoardPosition == null:');
    lines.push(`        springBoardPosition = ${renderSpatialPosition(stage.springboardPositions[0]!)}`);
  }
  lines.push('');
}

export function renderCompositeSetupMacro(
  lines: string[],
  mapId: string,
  variant: 'DEFAULT' | 'CLASSIC',
  spatialConfig: CompositeSpatialConfig
) {
  const macroName = mapRevisionMacroName(mapId, variant);
  const stages = spatialConfig.stages;
  const stageIndices = stages.map((_, index) => index);
  const firstSelection = spatialConfig.composition.firstStageSelection;
  const stageName = (index: number) => compositeStageMacroName(mapId, variant, index);
  const { availableStages, selectedStages, selectedStage, stageOrder, stageBastionPositions } = compositeRouteScratchNames(mapId);

  lines.push(`macro ${macroName}_SETUP_ROUTE():`);
  lines.push(`    ${compositeRouteScratchNames(mapId).centerPositionsInitialized} = false`);
  lines.push('    controlJumpPosition = []');
  lines.push('    controlRespawnPosition = []');
  if (firstSelection.mode === 'random' || spatialConfig.composition.remainingStageSelection === 'random_unique') {
    lines.push(`    ${availableStages} = [${stageIndices.join(', ')}]`);
  }
  lines.push(`    ${selectedStages} = []`);
  if (firstSelection.mode === 'random') {
    lines.push(`    ${selectedStage} = random.choice(${availableStages})`);
  } else {
    const fallbackIndex = stages.findIndex((stage) => stage.stageId === firstSelection.fallbackStageId);
    const detectedStages = stages.map((stage, index) => ({ stage, index })).filter(({ stage }) => stage.setupDetection);
    detectedStages.forEach(({ index }, detectionIndex) => {
      lines.push(`    ${detectionIndex === 0 ? 'if' : 'elif'} len(getPlayersInRadius(${macroName}_COMPOSITE_STAGE_${index}_SETUP_POSITION, ${macroName}_COMPOSITE_STAGE_${index}_SETUP_RADIUS, Team.1)) != 0:`);
      lines.push(`        ${selectedStage} = ${index}`);
    });
    lines.push(`${detectedStages.length > 0 ? '    else:' : '    if true:'}`);
    lines.push(`        ${selectedStage} = ${fallbackIndex}`);
  }
  lines.push(`    ${selectedStages}.append(${selectedStage})`);
  if (spatialConfig.composition.remainingStageSelection === 'stage_id_cycle') {
    lines.push(`    for ${stageOrder} in range(${spatialConfig.composition.selectionCount - 1}):`);
    lines.push(`        ${selectedStage} = (${selectedStage} + 1) % ${stages.length}`);
    lines.push(`        ${selectedStages}.append(${selectedStage})`);
  } else {
    lines.push(`    ${availableStages}.remove(${selectedStage})`);
    if (spatialConfig.composition.selectionCount > 2) {
      lines.push(`    for ${stageOrder} in range(${spatialConfig.composition.selectionCount - 1}):`);
      lines.push(`        ${selectedStage} = random.choice(${availableStages})`);
      lines.push(`        ${selectedStages}.append(${selectedStage})`);
      lines.push(`        ${availableStages}.remove(${selectedStage})`);
    } else {
      lines.push(`    ${selectedStage} = random.choice(${availableStages})`);
      lines.push(`    ${selectedStages}.append(${selectedStage})`);
      lines.push(`    ${availableStages}.remove(${selectedStage})`);
    }
  }
  lines.push(`    for ${stageOrder} in range(${spatialConfig.composition.selectionCount}):`);
  stages.forEach((_, index) => {
    lines.push(`        ${index === 0 ? 'if' : 'elif'} ${selectedStages}[${stageOrder}] == ${index}:`);
    lines.push(`            ${stageName(index)}(${stageOrder})`);
  });
  lines.push(`    ${availableStages} = null`);
  lines.push(`    ${selectedStages} = null`);
  lines.push(`    ${selectedStage} = null`);
  lines.push(`    ${stageOrder} = null`);
  lines.push(`    ${stageBastionPositions} = null`);
  lines.push(`    ${compositeRouteScratchNames(mapId).centerPositionsInitialized} = null`);
  lines.push('');
}

export function renderSpawnDetectedCompositeRoutes(
  lines: string[],
  mapId: string,
  variant: 'DEFAULT' | 'CLASSIC',
  spatialConfig: CompositeSpatialConfig
) {
  const mapName = mapRevisionMacroName(mapId, variant);
  const { stages } = spatialConfig;
  const { selectionCount, firstStageSelection } = spatialConfig.composition;
  const fallbackIndex = stages.findIndex((stage) => stage.stageId === firstStageSelection.fallbackStageId);
  const routes = stages.map((_, startIndex) =>
    Array.from({ length: selectionCount }, (_, offset) => stages[(startIndex + offset) % stages.length]!)
  );

  routes.forEach((route, startIndex) => {
    const macroName = `${mapName}_ROUTE_${startIndex}`;
    const firstStage = route[0]!;
    const lastStage = route[route.length - 1]!;
    lines.push(`macro ${macroName}():`);
    lines.push(`    resetPosition = ${renderSpatialPosition(firstStage.resetPosition ?? spatialConfig.resetPosition)}`);
    lines.push(`    endPosition = ${renderSpatialPosition(lastStage.endPosition ?? spatialConfig.endPosition)}`);
    lines.push(`    thirdPersonPosition = ${renderSpatialPosition(firstStage.thirdPersonPosition ?? spatialConfig.thirdPersonPosition)}`);
    lines.push(`    creditsPosition = ${renderSpatialPosition(firstStage.creditsPosition ?? spatialConfig.creditsPosition)}`);
    lines.push(`    controlRespawnAxis = ${{ x: 0, y: 1, z: 2 }[spatialConfig.control.respawnAxis]}`);
    lines.push(`    controlRespawnAxisThreshold = ${spatialConfig.control.respawnAxisThreshold}`);
    lines.push(...renderVectorAssignment('bastionPosition', route.flatMap((stage) => stage.bastionPositions), '    ', true));
    const centerPositions = route.flatMap((stage) => stage.control.centerPositions);
    if (centerPositions.length > 0) lines.push(...renderVectorAssignment('controlCenterPosition', centerPositions, '    '));
    lines.push(...renderVectorAssignment('controlJumpPosition', route.slice(0, -1).flatMap((stage) => stage.control.jumpPositions), '    '));
    lines.push(...renderVectorAssignment('controlRespawnPosition', route.flatMap((stage) => stage.control.respawnPositions), '    '));
    const portals = route.flatMap((stage) => stage.portalPositions);
    if (portals.length > 0) lines.push(...renderVectorAssignment('portalPosition', portals, '    '));
    const springboard = route.find((stage) => stage.springboardPositions.length > 0)?.springboardPositions[0];
    if (springboard) lines.push(`    springBoardPosition = ${renderSpatialPosition(springboard)}`);
    lines.push('');
  });

  lines.push(`macro ${mapName}_SETUP_ROUTE():`);
  const detectedStages = stages.map((stage, index) => ({ stage, index })).filter(({ stage }) => stage.setupDetection);
  detectedStages.forEach(({ stage, index }, detectionIndex) => {
    lines.push(`    ${detectionIndex === 0 ? 'if' : 'elif'} len(getPlayersInRadius(${mapName}_COMPOSITE_STAGE_${index}_SETUP_POSITION, ${mapName}_COMPOSITE_STAGE_${index}_SETUP_RADIUS, Team.1)) != 0:`);
    lines.push(`        ${mapName}_ROUTE_${index}()`);
  });
  lines.push(`${detectedStages.length > 0 ? '    else:' : '    if true:'}`);
  lines.push(`        ${mapName}_ROUTE_${fallbackIndex}()`);
  lines.push('');
}

export function renderMapRevisionBlock(map: PlatformMapRevisionSource['maps'][number]): string {
  const unsupported = map.revisions.filter((revision) => !revision.isDefault && revision.mapVariant !== 'classic');
  if (unsupported.length > 0) throw new Error(`${map.mapId} has selectable revisions that cannot be selected by the compile-time map source: ${unsupported.map((revision) => revision.gameplayRevisionId).join(', ')}`);

  const mapKey = mapKeyFromPlatformId(map.mapId);
  const lines = [
    MAP_REVISION_BEGIN,
    '# Source: OWBastion Agents API',
  ];
  if (map.revisions.some((revision) => 'composition' in revision.spatialConfig && !hasSpawnDetectedCycle(revision.spatialConfig))) {
    lines.push('');
    for (const scratchName of Object.values(compositeRouteScratchNames(map.mapId))) lines.push(`globalvar ${scratchName}`);
    lines.push('');
  }
  if (map.revisions.some((revision) => revision.mapVariant === 'classic')) lines.push('');

  for (const revision of map.revisions) {
    const variant = mapRevisionVariantName(revision);
    const macroName = mapRevisionMacroName(map.mapId, variant);
    const isClassic = variant === 'CLASSIC';
    const isComposite = 'composition' in revision.spatialConfig;
    lines.push(`macro ${macroName}():`);
    const mapText = JSON.stringify(map.mapName);
    lines.push(`    __currentMapText___ = ${isClassic ? `STR_HUD_MAP_CLASSIC_SUFFIX.format(${mapText})` : mapText}`);
    lines.push(`    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format(${mapText})`);
    if (isComposite) {
      const composite = revision.spatialConfig as CompositeSpatialConfig;
      lines.push(`    resetPosition = ${renderSpatialPosition(composite.resetPosition)}`);
      lines.push(`    endPosition = ${renderSpatialPosition(composite.endPosition)}`);
      lines.push(`    thirdPersonPosition = ${renderSpatialPosition(composite.thirdPersonPosition)}`);
      lines.push(`    creditsPosition = ${renderSpatialPosition(composite.creditsPosition)}`);
      lines.push(`    controlRespawnAxis = ${String({ x: 0, y: 1, z: 2 }[composite.control.respawnAxis])}`);
      lines.push(`    controlRespawnAxisThreshold = ${composite.control.respawnAxisThreshold}`);
      lines.push('');
      for (const [stageIndex, stage] of composite.stages.entries()) {
        if (stage.setupDetection) {
          lines.push('');
          lines.push(`#!define ${macroName}_COMPOSITE_STAGE_${stageIndex}_SETUP_POSITION ${renderSpatialPosition(stage.setupDetection.position)}`);
          lines.push(`#!define ${macroName}_COMPOSITE_STAGE_${stageIndex}_SETUP_RADIUS ${stage.setupDetection.radius}`);
        }
      }
      if (hasSpawnDetectedCycle(composite)) {
        renderSpawnDetectedCompositeRoutes(lines, map.mapId, variant, composite);
      } else {
        for (const [stageIndex, stage] of composite.stages.entries()) {
          lines.push('');
          renderCompositeStageMacro(lines, map.mapId, variant, stage, stageIndex, composite.composition.selectionCount);
        }
        renderCompositeSetupMacro(lines, map.mapId, variant, composite);
      }
    } else {
      lines.push('');
      const legacy = revision.spatialConfig as LegacySpatialConfig;
      renderSpatialAssignments(lines, legacy, mapKey === 'DATA_ANTARCTIC_PENINSULA');
      for (const stage of legacy.alternateStages) {
        const setupPositionMacro = `${stageMacroName(map.mapId, variant, stage.stageId)}_SETUP_POSITION`;
        const setupRadiusMacro = `${stageMacroName(map.mapId, variant, stage.stageId)}_SETUP_RADIUS`;
        lines.push('');
        lines.push(`#!define ${setupPositionMacro} ${renderSpatialPosition(stage.setupDetection.position)}`);
        lines.push(`#!define ${setupRadiusMacro} ${stage.setupDetection.radius}`);
        lines.push(`macro ${stageMacroName(map.mapId, variant, stage.stageId)}():`);
        renderSpatialAssignments(lines, stage, false);
      }
      if (legacy.alternateStages.length > 0) {
        lines.push('');
        lines.push(`macro ${macroName}_SETUP_ROUTE():`);
        legacy.alternateStages.forEach((stage, index) => {
          lines.push(`    ${index === 0 ? 'if' : 'elif'} len(getPlayersInRadius(${stageMacroName(map.mapId, variant, stage.stageId)}_SETUP_POSITION, ${stageMacroName(map.mapId, variant, stage.stageId)}_SETUP_RADIUS, Team.1)) != 0:`);
          lines.push(`        ${stageMacroName(map.mapId, variant, stage.stageId)}()`);
        });
        lines.push('');
      }
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
    const generatedBlockEnd = content.indexOf(MAP_REVISION_END) + MAP_REVISION_END.length;
    const mapRuleSource = content.slice(generatedBlockEnd);
    for (const revision of map.revisions) {
      if (!('composition' in revision.spatialConfig)) continue;
      const setupRouteMacro = `${mapRevisionMacroName(map.mapId, mapRevisionVariantName(revision))}_SETUP_ROUTE()`;
      const hasExecutableSetupRouteCall = mapRuleSource.split(/\r?\n/).some((line) => line.split('#', 1)[0]?.trim() === setupRouteMacro);
      if (!hasExecutableSetupRouteCall) {
        throw new Error(`${sourceFile.file} must call ${setupRouteMacro} for composite revision ${revision.gameplayRevisionId}`);
      }
    }
    return { path: path.join(MAP_SOURCE_DIR, sourceFile.file), content };
  });
}

export function validatePlatformAchievements(platformData: PlatformData, titleKeys: Set<string>, catalog: ValidatedMapCatalog) {
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
