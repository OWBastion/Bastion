import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { PLATFORM_DATA_CONTRACT_VERSION, assertRequiredKeys, requireString, type PlatformData, type TitleSource } from './client.ts';
import type { GeneratedPlatformFile } from '../syncPlatformData.ts';
import {
  mapKeyFromPlatformId,
  mapRevisionStem,
  replaceManagedBlock,
  MAP_REVISION_BEGIN,
  MAP_REVISION_END,
  validatePlatformAchievements,
  validatePlatformMaps,
  type CompositeSpatialConfig,
  type CompositeSpatialStage,
  type LegacySpatialConfig,
  type PlatformMapRevisionSource,
  type SpatialConfigBase,
  type SpatialPosition
} from './mapValidation.ts';

const MAP_SOURCE_DIR = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../../src/map');

export function buildPlatformMapRevisionSource({ platformData }: { platformData: PlatformData }): PlatformMapRevisionSource {
  const syntheticTitleSource = {
    meta: { sourceLabel: 'platform-map-revision-validation' },
    titles: [],
    players: [],
    mapTitles: platformData.maps.map((map) => ({
      mapKey: mapKeyFromPlatformId(requireString(map.mapId, 'mapId')),
      mapLabel: '',
      holders: { PIONEER: [], CONQUEROR: [], DOMINATOR: [], CLASSIC: [] }
    }))
  } satisfies TitleSource;
  const catalog = validatePlatformMaps(platformData, syntheticTitleSource);
  const titleKeys = new Set(platformData.titles.map((item) => requireString(item.titleKey, 'titleKey')));
  validatePlatformAchievements(platformData, titleKeys, catalog);
  const holdersByRevision = new Map<string, PlatformMapRevisionSource['maps'][number]['revisions'][number]['titleHolders']>();
  const holderIdentitiesByRevision = new Map<string, Set<string>>();
  for (const [index, item] of platformData.mapTitleHolders.entries()) {
    const prefix = `mapTitleHolders[${index}]`;
    assertRequiredKeys(item, prefix, ['mapId', 'gameplayRevisionId', 'titleKey', 'slot', 'slotSemantics', 'playerName']);
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

export const MAP_POSITION_POOL_VARIABLE = 'mapPositionPool';

export class SpatialPositionPool {
  private positions: SpatialPosition[] = [];
  private indexByKey = new Map<string, number>();
  private rangeByArrayKey = new Map<string, { start: number; count: number }>();

  private key(position: SpatialPosition): string {
    return position.join(',');
  }

  intern(position: SpatialPosition): number {
    const key = this.key(position);
    const existing = this.indexByKey.get(key);
    if (existing !== undefined) return existing;
    const index = this.positions.length;
    this.positions.push(position);
    this.indexByKey.set(key, index);
    return index;
  }

  internArray(positions: SpatialPosition[]): { start: number; count: number } {
    if (positions.length === 0) return { start: 0, count: 0 };
    const arrayKey = positions.map((position) => this.key(position)).join(';');
    const existing = this.rangeByArrayKey.get(arrayKey);
    if (existing !== undefined) return existing;
    const start = this.positions.length;
    for (const position of positions) {
      const key = this.key(position);
      if (!this.indexByKey.has(key)) this.indexByKey.set(key, this.positions.length);
      this.positions.push(position);
    }
    const range = { start, count: positions.length };
    this.rangeByArrayKey.set(arrayKey, range);
    return range;
  }

  ref(position: SpatialPosition): string {
    return `${MAP_POSITION_POOL_VARIABLE}[${this.intern(position)}]`;
  }

  slice(positions: SpatialPosition[]): string {
    const { start, count } = this.internArray(positions);
    return `${MAP_POSITION_POOL_VARIABLE}.slice(${start}, ${count})`;
  }

  get size(): number {
    return this.positions.length;
  }

  renderBlock(): string {
    const lines = [
      MAP_REVISION_BEGIN,
      '# Source: OWBastion Agents API',
      `globalvar ${MAP_POSITION_POOL_VARIABLE}`,
      '',
      'rule "Initialize map position pool":',
      `    ${MAP_POSITION_POOL_VARIABLE} = compressed([`
    ];
    this.positions.forEach((position, index) => lines.push(`        ${renderSpatialPosition(position)}${index === this.positions.length - 1 ? '' : ','}`));
    lines.push('    ])', MAP_REVISION_END);
    return lines.join('\n');
  }
}

export function renderVectorAssignment(field: string, positions: SpatialPosition[], indent: string, pool: SpatialPositionPool): string[] {
  if (positions.length === 0) return [`${indent}${field} = []`];
  return [`${indent}${field} = ${pool.slice(positions)}`];
}

export function renderPlayerIndexDelimited(names: string[]): string {
  return names.length === 0 ? '[]' : `playerNameToIndexDelimited([${names.map((name) => JSON.stringify(name)).join(', ')}], "-")`;
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

export function renderSpatialAssignments(lines: string[], config: SpatialConfigBase, pool: SpatialPositionPool) {
  lines.push(...renderVectorAssignment('bastionPosition', config.bastionPositions, '    ', pool));
  lines.push(`    resetPosition = ${pool.ref(config.resetPosition)}`);
  lines.push(`    endPosition = ${pool.ref(config.endPosition)}`);
  lines.push(`    thirdPersonPosition = ${pool.ref(config.thirdPersonPosition)}`);
  lines.push(`    creditsPosition = ${pool.ref(config.creditsPosition)}`);
  if (config.control) {
    if (config.control.centerPositions.length > 0) lines.push(...renderVectorAssignment('controlCenterPosition', config.control.centerPositions, '    ', pool));
    if (config.control.jumpPositions.length > 0) lines.push(...renderVectorAssignment('controlJumpPosition', config.control.jumpPositions, '    ', pool));
    if (config.control.respawnPositions.length > 0) lines.push(...renderVectorAssignment('controlRespawnPosition', config.control.respawnPositions, '    ', pool));
    if (config.control.respawnAxis !== null) {
      const axis = { x: 0, y: 1, z: 2 }[config.control.respawnAxis];
      lines.push(`    controlRespawnAxis = ${axis}`);
      lines.push(`    controlRespawnAxisThreshold = ${config.control.respawnAxisThreshold}`);
    }
  }
  if (config.portalPositions.length > 0) lines.push(...renderVectorAssignment('portalPosition', config.portalPositions, '    ', pool));
  if (config.springboardPositions.length > 0) lines.push(`    springBoardPosition = ${pool.ref(config.springboardPositions[0]!)}`);
}

export function renderCompositeStageMacro(
  lines: string[],
  mapId: string,
  variant: 'DEFAULT' | 'CLASSIC',
  stage: CompositeSpatialStage,
  stageIndex: number,
  selectionCount: number,
  pool: SpatialPositionPool
) {
  const macroName = compositeStageMacroName(mapId, variant, stageIndex);
  const { stageBastionPositions: stagePositions, centerPositionsInitialized } = compositeRouteScratchNames(mapId);
  lines.push(`macro ${macroName}(stageOrder):`);
  lines.push(...renderVectorAssignment(stagePositions, stage.bastionPositions, '    ', pool));
  lines.push('    if stageOrder == 0:');
  lines.push(`        bastionPosition = ${stagePositions}`);
  lines.push('    else:');
  lines.push(`        bastionPosition.append(${stagePositions})`);

  if (stage.control.centerPositions.length > 0) {
    lines.push(`    if ${centerPositionsInitialized} != true:`);
    lines.push('        controlCenterPosition = []');
    lines.push(`        ${centerPositionsInitialized} = true`);
    stage.control.centerPositions.forEach((position) => lines.push(`    controlCenterPosition.append(${pool.ref(position)})`));
  }
  lines.push(`    if stageOrder < ${selectionCount - 1}:`);
  lines.push('        controlJumpPosition.append(' + pool.ref(stage.control.jumpPositions[0]!) + ')');
  lines.push(`    controlRespawnPosition.append(${pool.ref(stage.control.respawnPositions[0]!)})`);

  if (stage.portalPositions.length > 0) {
    lines.push('    if portalPosition == null:');
    lines.push('        portalPosition = []');
    stage.portalPositions.forEach((position) => lines.push(`    portalPosition.append(${pool.ref(position)})`));
  }
  if (stage.springboardPositions.length > 0) {
    lines.push('    if springBoardPosition == null:');
    lines.push(`        springBoardPosition = ${pool.ref(stage.springboardPositions[0]!)}`);
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
  spatialConfig: CompositeSpatialConfig,
  pool: SpatialPositionPool
) {
  const mapName = mapRevisionMacroName(mapId, variant);
  const { stages } = spatialConfig;
  const { selectionCount, firstStageSelection } = spatialConfig.composition;
  const fallbackStageId = firstStageSelection.mode === 'setup_detection' ? firstStageSelection.fallbackStageId : undefined;
  const fallbackIndex = stages.findIndex((stage) => stage.stageId === fallbackStageId);
  const routes = stages.map((_, startIndex) =>
    Array.from({ length: selectionCount }, (_, offset) => stages[(startIndex + offset) % stages.length]!)
  );

  const routeAnchorPositions = routes.map((route) => {
    const firstStage = route[0]!;
    const lastStage = route[route.length - 1]!;
    return [
      firstStage.resetPosition ?? spatialConfig.resetPosition,
      lastStage.endPosition ?? spatialConfig.endPosition,
      firstStage.thirdPersonPosition ?? spatialConfig.thirdPersonPosition,
      firstStage.creditsPosition ?? spatialConfig.creditsPosition
    ];
  });
  const sharedAnchors = routeAnchorPositions.every((anchors) => anchors.join(';') === routeAnchorPositions[0]!.join(';'));
  const renderAnchors = (anchors: SpatialPosition[]) => [
    `    resetPosition = ${pool.ref(anchors[0]!)}`,
    `    endPosition = ${pool.ref(anchors[1]!)}`,
    `    thirdPersonPosition = ${pool.ref(anchors[2]!)}`,
    `    creditsPosition = ${pool.ref(anchors[3]!)}`,
    `    controlRespawnAxis = ${{ x: 0, y: 1, z: 2 }[spatialConfig.control.respawnAxis]}`,
    `    controlRespawnAxisThreshold = ${spatialConfig.control.respawnAxisThreshold}`
  ];

  routes.forEach((route, startIndex) => {
    const macroName = `${mapName}_ROUTE_${startIndex}`;
    lines.push(`macro ${macroName}():`);
    if (!sharedAnchors) lines.push(...renderAnchors(routeAnchorPositions[startIndex]!));
    lines.push(...renderVectorAssignment('bastionPosition', route.flatMap((stage) => stage.bastionPositions), '    ', pool));
    const centerPositions = route.flatMap((stage) => stage.control.centerPositions);
    if (centerPositions.length > 0) lines.push(...renderVectorAssignment('controlCenterPosition', centerPositions, '    ', pool));
    lines.push(...renderVectorAssignment('controlJumpPosition', route.slice(0, -1).flatMap((stage) => stage.control.jumpPositions), '    ', pool));
    lines.push(...renderVectorAssignment('controlRespawnPosition', route.flatMap((stage) => stage.control.respawnPositions), '    ', pool));
    const portals = route.flatMap((stage) => stage.portalPositions);
    if (portals.length > 0) lines.push(...renderVectorAssignment('portalPosition', portals, '    ', pool));
    const springboard = route.find((stage) => stage.springboardPositions.length > 0)?.springboardPositions[0];
    if (springboard) lines.push(`    springBoardPosition = ${pool.ref(springboard)}`);
    lines.push('');
  });

  lines.push(`macro ${mapName}_SETUP_ROUTE():`);
  if (sharedAnchors) lines.push(...renderAnchors(routeAnchorPositions[0]!));
  const detectedStages = stages.map((stage, index) => ({ stage, index })).filter(({ stage }) => stage.setupDetection);
  detectedStages.forEach(({ stage, index }, detectionIndex) => {
    lines.push(`    ${detectionIndex === 0 ? 'if' : 'elif'} len(getPlayersInRadius(${mapName}_COMPOSITE_STAGE_${index}_SETUP_POSITION, ${mapName}_COMPOSITE_STAGE_${index}_SETUP_RADIUS, Team.1)) != 0:`);
    lines.push(`        ${mapName}_ROUTE_${index}()`);
  });
  lines.push(`${detectedStages.length > 0 ? '    else:' : '    if true:'}`);
  lines.push(`        ${mapName}_ROUTE_${fallbackIndex}()`);
  lines.push('');
}

export function renderMapRevisionBlock(map: PlatformMapRevisionSource['maps'][number], pool: SpatialPositionPool): string {
  const unsupported = map.revisions.filter((revision) => !revision.isDefault && revision.mapVariant !== 'classic');
  if (unsupported.length > 0) throw new Error(`${map.mapId} has selectable revisions that cannot be selected by the compile-time map source: ${unsupported.map((revision) => revision.gameplayRevisionId).join(', ')}`);

  const lines = [
    MAP_REVISION_BEGIN,
    '# Source: OWBastion Agents API',
  ];
  if (map.revisions.some((revision) => 'composition' in revision.spatialConfig && !hasSpawnDetectedCycle(revision.spatialConfig))) {
    lines.push('');
    for (const scratchName of Object.values(compositeRouteScratchNames(map.mapId))) lines.push(`globalvar ${scratchName}`);
    lines.push('');
  }
  const hasClassicRevision = map.revisions.some((revision) => revision.mapVariant === 'classic');
  if (hasClassicRevision) lines.push('');

  for (const revision of map.revisions) {
    const variant = mapRevisionVariantName(revision);
    const macroName = mapRevisionMacroName(map.mapId, variant);
    const isClassic = variant === 'CLASSIC';
    const isComposite = 'composition' in revision.spatialConfig;
    lines.push(`macro ${macroName}():`);
    const mapText = JSON.stringify(map.mapName);
    lines.push(`    __currentMapText___ = ${isClassic ? `STR_HUD_MAP_CLASSIC_SUFFIX.format(${mapText})` : mapText}`);
    if (hasClassicRevision) lines.push(`    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format(${mapText})`);
    if (isComposite) {
      const composite = revision.spatialConfig as CompositeSpatialConfig;
      lines.push(`    resetPosition = ${pool.ref(composite.resetPosition)}`);
      lines.push(`    endPosition = ${pool.ref(composite.endPosition)}`);
      lines.push(`    thirdPersonPosition = ${pool.ref(composite.thirdPersonPosition)}`);
      lines.push(`    creditsPosition = ${pool.ref(composite.creditsPosition)}`);
      lines.push(`    controlRespawnAxis = ${String({ x: 0, y: 1, z: 2 }[composite.control.respawnAxis])}`);
      lines.push(`    controlRespawnAxisThreshold = ${composite.control.respawnAxisThreshold}`);
      lines.push('');
      for (const [stageIndex, stage] of composite.stages.entries()) {
        if (stage.setupDetection) {
          lines.push('');
          lines.push(`#!define ${macroName}_COMPOSITE_STAGE_${stageIndex}_SETUP_POSITION ${pool.ref(stage.setupDetection.position)}`);
          lines.push(`#!define ${macroName}_COMPOSITE_STAGE_${stageIndex}_SETUP_RADIUS ${stage.setupDetection.radius}`);
        }
      }
      if (hasSpawnDetectedCycle(composite)) {
        renderSpawnDetectedCompositeRoutes(lines, map.mapId, variant, composite, pool);
      } else {
        for (const [stageIndex, stage] of composite.stages.entries()) {
          lines.push('');
          renderCompositeStageMacro(lines, map.mapId, variant, stage, stageIndex, composite.composition.selectionCount, pool);
        }
        renderCompositeSetupMacro(lines, map.mapId, variant, composite);
      }
    } else {
      lines.push('');
      const legacy = revision.spatialConfig as LegacySpatialConfig;
      renderSpatialAssignments(lines, legacy, pool);
      for (const stage of legacy.alternateStages) {
        const setupPositionMacro = `${stageMacroName(map.mapId, variant, stage.stageId)}_SETUP_POSITION`;
        const setupRadiusMacro = `${stageMacroName(map.mapId, variant, stage.stageId)}_SETUP_RADIUS`;
        lines.push('');
        lines.push(`#!define ${setupPositionMacro} ${pool.ref(stage.setupDetection.position)}`);
        lines.push(`#!define ${setupRadiusMacro} ${stage.setupDetection.radius}`);
        lines.push(`macro ${stageMacroName(map.mapId, variant, stage.stageId)}():`);
        renderSpatialAssignments(lines, stage, pool);
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

export const MAP_POSITION_POOL_FILE = 'positionPool.opy';

export function renderPlatformMapRevisionData(source: PlatformMapRevisionSource): string {
  const pool = new SpatialPositionPool();
  const blocks = source.maps.map((map) => renderMapRevisionBlock(map, pool));
  return [pool.renderBlock(), ...blocks].join('\n\n') + '\n';
}

export function renderPlatformMapRevisionMapSources({
  source,
  mapSourceFiles
}: {
  source: PlatformMapRevisionSource;
  mapSourceFiles: Array<{ file: string; content: string }>;
}): GeneratedPlatformFile[] {
  const pool = new SpatialPositionPool();
  const files = source.maps.map((map) => {
    const matches = mapSourceFiles.filter(({ content }) => content.includes(`${mapRevisionStem(map.mapId)}_DEFAULT()`));
    if (matches.length !== 1) throw new Error(`${mapKeyFromPlatformId(map.mapId)} must match exactly one map source for compile-time revision injection`);
    const sourceFile = matches[0]!;
    const content = replaceManagedBlock(sourceFile.content, MAP_REVISION_BEGIN, MAP_REVISION_END, renderMapRevisionBlock(map, pool));
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
  files.push({
    path: path.join(MAP_SOURCE_DIR, MAP_POSITION_POOL_FILE),
    content: `#!mainFile "../main.opy"\n\n#!optimizeStrict\n\n${pool.renderBlock()}\n`
  });
  return files;
}
