import {
  PLATFORM_DATA_CONTRACT_VERSION,
  assertRequiredKeys,
  requireString,
  type PlatformData,
  type TitleSource,
  TITLE_DISPLAY_KINDS,
  TITLE_SLOTS
} from './client.ts';

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
  assertRequiredKeys(value, label, ['position', 'radius']);
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
  assertRequiredKeys(value, label, spatialConfigKeys);
  const config = value as Record<string, unknown>;
  let control: SpatialConfigBase['control'] = null;
  if (config.control !== null) {
    assertRequiredKeys(config.control, `${label}.control`, ['centerPositions', 'jumpPositions', 'respawnPositions', 'respawnAxis', 'respawnAxisThreshold']);
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
    assertRequiredKeys(config, label, [...compositeSharedSpatialKeys, 'composition', 'stages']);
    assertRequiredKeys(config.composition, `${label}.composition`, ['selectionCount', 'firstStageSelection', 'remainingStageSelection']);
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
      assertRequiredKeys(firstStageSelectionValue, `${label}.composition.firstStageSelection`, ['mode', 'fallbackStageId']);
      firstStageSelection = {
        mode: 'setup_detection',
        fallbackStageId: requireString(firstStageSelectionValue.fallbackStageId, `${label}.composition.firstStageSelection.fallbackStageId`)
      };
      if (!/^[a-z0-9][a-z0-9_-]*$/.test(firstStageSelection.fallbackStageId) || firstStageSelection.fallbackStageId.length > 64) {
        throw new Error(`${label}.composition.firstStageSelection.fallbackStageId has an unsupported value`);
      }
    } else if (firstStageSelectionValue.mode === 'random') {
      assertRequiredKeys(firstStageSelectionValue, `${label}.composition.firstStageSelection`, ['mode']);
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
      assertRequiredKeys(stage.control, `${stageLabel}.control`, ['centerPositions', 'jumpPositions', 'respawnPositions']);
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
    assertRequiredKeys(routeControlValue, `${label}.control`, ['respawnAxis', 'respawnAxisThreshold']);
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
    assertRequiredKeys(rawStage, stageLabel, ['stageId', 'setupDetection', ...spatialConfigKeys]);
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
  assertRequiredKeys(value, label, ['gameplayRevisionId', 'mapId', 'mapVariant', 'lifecycle', 'enabled', 'isDefault', 'isSelectable', 'gameVersion', 'spatialConfig', 'challengeRefs']);
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
    assertRequiredKeys(rawRef, refLabel, ['family', 'challengeId']);
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

export function mapRevisionStem(mapId: string): string {
  return `platformMapRevision_${mapKeyFromPlatformId(mapId).replace(/^DATA_/, '')}`;
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

export function validatePlatformAchievements(platformData: PlatformData, titleKeys: Set<string>, catalog: ValidatedMapCatalog) {
  const challengeIds = new Set<string>();
  const challengeIdentities = new Set<string>();
  for (const [index, item] of platformData.achievements.entries()) {
    const prefix = `achievements[${index}]`;
    const challengeId = requireString(item.challengeId, `${prefix}.challengeId`);
    const titleKey = requireString(item.titleKey, `${prefix}.titleKey`);
    if (!titleKeys.has(titleKey)) throw new Error(`${prefix} references unknown title ${titleKey}`);
    if (item.family === 'achievement' && item.type === 'title_achievement' && item.kind === 'title_achievement') {
      if (challengeId !== `title.${titleKey}` && !challengeId.startsWith(`title.${titleKey}.`)) {
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
