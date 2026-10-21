import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

import { buildPlatformMapRevisionSource, renderPlatformMapRevisionData, renderPlatformMapRevisionMapSources } from './platform/mapRevision.ts';
import { validateRevisionAwareMapSources } from './platform/mapValidation.ts';
import { mergePlatformEventOverPyData } from './platform/events.ts';
import { applyTitleColorFallback, buildPlatformTitleSource, preservePlatformTitleOrder, syncTitleData } from './platform/titles.ts';
import { mergePlatformData, prepareGeneratedPlatformFiles, syncPlatformData } from './syncPlatformData.ts';
import type { PlatformData } from './platform/client.ts';

const titleSource = {
  meta: { sourceLabel: 'titles' },
  titles: [{ key: 'TITLE_ONE', label: '旧称号', category: '旧分类', condition: '旧条件', displayExpr: '"旧称号"', colorExpr: 'null' }],
  players: [{ name: '玩家', titleKeys: ['TITLE_ONE'] }],
  mapTitles: [{ mapKey: 'DATA_TEST_MAP', mapLabel: '旧地图', holders: { PIONEER: ['玩家'], CONQUEROR: [], DOMINATOR: [], CLASSIC: [] } }]
};

function mapSource(mapKey: string): string {
  return [
    '# BEGIN AUTO-GENERATED PLATFORM MAP REVISION',
    `macro platformMapRevision_${mapKey}_DEFAULT():`,
    '# END AUTO-GENERATED PLATFORM MAP REVISION'
  ].join('\n');
}

const testMapSource = mapSource('TEST_MAP');

const eventEntries = [{
  key: 'EVENT_ONE',
  type: 'buff' as const,
  platformId: 'event.one',
  macros: { id: 0, duration: 'EVT_BUFF_0_DURATION', weight: 'EVT_BUFF_0_WEIGHT' }
}];

const spatialConfig = {
  bastionPositions: [[1, 2, 3]],
  resetPosition: [4, 5, 6],
  endPosition: [7, 8, 9],
  thirdPersonPosition: [10, 11, 12],
  creditsPosition: [13, 14, 15],
  control: null,
  portalPositions: [],
  springboardPositions: []
};

const busanSpatialConfig = {
  ...spatialConfig,
  control: {
    centerPositions: [[16, 17, 18], [19, 20, 21], [22, 23, 24]],
    jumpPositions: [[25, 26, 27], [28, 29, 30]],
    respawnPositions: [[31, 32, 33], [34, 35, 36], [37, 38, 39]],
    respawnAxis: 'x' as const,
    respawnAxisThreshold: 40
  }
};

function compositeStage(stageId: string, offset: number, setupDetection?: { position: [number, number, number]; radius: number }) {
  return {
    stageId,
    ...(setupDetection ? { setupDetection } : {}),
    bastionPositions: [[offset + 1, offset + 2, offset + 3]],
    control: {
      centerPositions: [[offset + 4, offset + 5, offset + 6]],
      jumpPositions: [[offset + 7, offset + 8, offset + 9]],
      respawnPositions: [[offset + 10, offset + 11, offset + 12]]
    },
    portalPositions: [],
    springboardPositions: []
  };
}

const compositeSpatialConfig = {
  resetPosition: [904, 905, 906],
  endPosition: [907, 908, 909],
  thirdPersonPosition: [910, 911, 912],
  creditsPosition: [913, 914, 915],
  control: { respawnAxis: 'z' as const, respawnAxisThreshold: 40 },
  composition: {
    selectionCount: 2,
    firstStageSelection: { mode: 'setup_detection', fallbackStageId: 'base' },
    remainingStageSelection: 'random_unique'
  },
  stages: [
    compositeStage('laboratory', 300, { position: [930, 931, 932], radius: 30 }),
    compositeStage('base', 100),
    compositeStage('icebreaker', 200, { position: [820, 821, 822], radius: 30 })
  ]
};

const defaultGameplayRevision = {
  gameplayRevisionId: 'revision:map.test_map:default',
  mapId: 'map.test_map',
  mapVariant: null,
  lifecycle: 'default',
  enabled: true,
  isDefault: true,
  isSelectable: false,
  gameVersion: '2026.07.15',
  spatialConfig,
  challengeRefs: []
};

const classicGameplayRevision = {
  ...defaultGameplayRevision,
  gameplayRevisionId: 'revision:map.test_map:classic',
  mapVariant: 'classic',
  lifecycle: 'selectable',
  isDefault: false,
  isSelectable: true
};

const platformData: PlatformData = {
  events: [{ eventId: 'event.one', name: '新事件', category: '增益', rarity: 'R', description: '新描述', durationSeconds: 20, weight: 2, archived: false, releaseStatus: 'implemented', challenges: [] }],
  maps: [{ mapId: 'map.test_map', mapName: '新地图', gameVersion: '2026.07.15', difficultyRating: 'T1', mechanics: [], coverUrl: null, backgroundUrl: null, gameplayRevisions: [defaultGameplayRevision] }],
  achievements: [{ challengeId: 'title.TITLE_ONE', family: 'achievement', type: 'title_achievement', kind: 'title_achievement', titleKey: 'TITLE_ONE', status: 'active', submissionMode: 'manual' }],
  titles: [{ titleKey: 'TITLE_ONE', label: '新称号', icon: 'trophy', category: '新分类', condition: '新条件', scope: 'global', displayKind: 'fixed', gameVersion: '2026.07.15' }]
  ,playerTitleGrants: [], mapTitleHolders: []
};

function merge(overrides: Partial<PlatformData> = {}, source = titleSource) {
  return mergePlatformData({
    platformData: { ...platformData, ...overrides },
    titleSource: source,
    eventEntries,
    platformEventIds: { EVENT_ONE: 'event.one' },
    mapSourceFiles: [{ file: 'test_map.opy', content: testMapSource }]
  });
}

test('merges current platform fields by stable IDs and preserves OverPy structure', () => {
  const result = merge();
  assert.equal(result.titleSource.titles[0].label, '新称号');
  assert.equal(result.titleSource.titles[0].displayExpr, '"新称号"');
  assert.equal(result.titleSource.titles[0].colorExpr, 'null');
  assert.deepEqual(result.titleSource.players, titleSource.players);
  assert.equal(result.titleSource.mapTitles[0].mapLabel, '新地图');
  assert.deepEqual(result.titleSource.mapTitles[0].holders, titleSource.mapTitles[0].holders);
  assert.deepEqual(result.eventEntries, eventEntries);
  assert.deepEqual(result.counts, { events: 1, maps: 1, achievements: 1, titles: 1, ignoredEvents: 0 });
});

test('preserves dynamic map title expressions when platform label changes', () => {
  const result = merge({
    titles: [{ ...platformData.titles[0], scope: 'map', displayKind: 'map_pioneer', mapId: 'map.test_map', label: '新地图开拓者' }]
  });
  assert.equal(result.titleSource.titles[0].label, '新地图开拓者');
  assert.equal(result.titleSource.titles[0].displayExpr, '"旧称号"');
});

test('rejects an event mapping that is missing from the platform', () => {
  assert.throws(() => merge({ events: [] }), /missing from platform event data/);
});

test('rejects an event category that disagrees with the Bastion enum', () => {
  assert.throws(() => merge({ events: [{ ...platformData.events[0], category: '减益' }] }), /does not match Bastion type buff/);
});

test('rejects unknown challenge references', () => {
  assert.throws(() => merge({ events: [{ ...platformData.events[0], challenges: [{ family: 'achievement', challengeId: 'title.UNKNOWN' }] }] }), /unknown challenge title.UNKNOWN/);
});

test('accepts map classic achievements that reuse the global title challenge ID', () => {
  const result = merge({
    maps: [{ ...platformData.maps[0], gameplayRevisions: [defaultGameplayRevision, classicGameplayRevision] }],
    achievements: [
      { challengeId: 'title.CLASSIC', family: 'map', gameplayRevisionId: 'revision:map.test_map:classic', type: 'map_completion', kind: 'map_title_achievement', titleKey: 'CLASSIC', mapId: 'map.test_map', mapVariant: 'classic', status: 'active', submissionMode: 'manual', gameVersion: '2026.07.15' },
      { challengeId: 'title.CLASSIC', family: 'achievement', type: 'title_achievement', kind: 'title_achievement', titleKey: 'CLASSIC', status: 'active', submissionMode: 'manual' }
    ],
    titles: [
      platformData.titles[0],
      { ...platformData.titles[0], titleKey: 'CLASSIC', label: '老兵' }
    ]
  }, {
    ...titleSource,
    titles: [...titleSource.titles, { key: 'CLASSIC', label: '老兵', category: '地图精通系列', condition: '通关经典版地图', displayExpr: '__currentMapClassicText___', colorExpr: 'null' }]
  });
  assert.equal(result.counts.achievements, 2);
});

test('ignores platform title availability whether it is active, retired, or absent', async () => {
  const mapSourceFiles = [{ file: 'test_map.opy', content: testMapSource }];
  const shapes = [
    platformData.titles[0],
    { ...platformData.titles[0], availability: 'active' },
    { ...platformData.titles[0], availability: 'retired' }
  ];
  const sources = shapes.map((title) => buildPlatformTitleSource({
    platformData: { ...platformData, titles: [title] },
    mapSourceFiles
  }));
  assert.deepEqual(sources[1], sources[0]);
  assert.deepEqual(sources[2], sources[0]);
  assert.ok(!('availability' in sources[0].titles[0]));

  const generated = [];
  for (const source of sources) {
    const result = await syncTitleData({ sourceData: source, dryRun: true });
    generated.push(result.generatedFiles.map((file) => file.content));
  }
  assert.deepEqual(generated[1], generated[0]);
  assert.deepEqual(generated[2], generated[0]);
});

test('rejects unknown platform title IDs', () => {
  assert.throws(() => merge({ titles: [{ ...platformData.titles[0], titleKey: 'TITLE_UNKNOWN' }] }), /unknown Bastion title TITLE_UNKNOWN/);
});

test('rejects unsupported platform enums', () => {
  assert.throws(() => merge({ titles: [{ ...platformData.titles[0], displayKind: 'unknown' }] }), /unsupported scope or displayKind/);
  assert.throws(() => merge({ events: [{ ...platformData.events[0], category: '未知' }] }), /cannot be mapped to a Bastion event/);
});

test('ignores unmapped platform events regardless of their shape', () => {
  const result = merge({
    events: [
      platformData.events[0],
      { eventId: 'event.history', name: '历史事件', category: '未来类别', releaseStatus: 'future', challenges: [{ challengeId: 'unknown' }] }
    ]
  });
  assert.equal(result.counts.ignoredEvents, 1);
});

test('writes platform event values to OverPy constants and title locale while preserving description templates', () => {
  const result = mergePlatformEventOverPyData({
    platformData,
    eventEntries,
    constantsSource: '#!define EVT_BUFF_0_DURATION 10\n#!define EVT_BUFF_0_WEIGHT 1\n',
    localeSource: '#!define STR_EVT_BUFF_0_TITLE "旧事件"\n#!define STR_EVT_BUFF_0_DESC "旧描述 {0}"\n'
  });
  assert.match(result.constantsSource, /EVT_BUFF_0_DURATION 20/);
  assert.match(result.constantsSource, /EVT_BUFF_0_WEIGHT 2/);
  assert.match(result.localeSource, /STR_EVT_BUFF_0_TITLE "新事件"/);
  assert.match(result.localeSource, /STR_EVT_BUFF_0_DESC "旧描述 \{0\}"/);
});

test('builds player and map title generation input from public player names', () => {
  const source = buildPlatformTitleSource({
    platformData: {
      ...platformData,
      maps: [{ ...platformData.maps[0], mapId: 'map.test_map', mapName: '新地图' }],
      titles: [{ ...platformData.titles[0], color: { kind: 'heroColor', index: 12 }, scope: 'map', displayKind: 'map_pioneer', mapId: 'map.test_map', slot: 'pioneer', pioneerPrefixes: ['新地图'] }],
      playerTitleGrants: [{ playerName: '玩家改名', titleKeys: [], allTitles: false }],
      mapTitleHolders: [{ mapId: 'map.test_map', gameplayRevisionId: 'revision:map.test_map:default', titleKey: 'TITLE_ONE', slot: 'pioneer', slotSemantics: 'named', playerId: 'player-1', playerName: '玩家改名' }]
    },
    mapSourceFiles: [{ file: 'test_map.opy', content: testMapSource }]
  });
  assert.deepEqual(source.players, [{ name: '玩家改名', titleKeys: [] }]);
  assert.deepEqual(source.mapTitles[0].holders, { PIONEER: ['玩家改名'], CONQUEROR: [], DOMINATOR: [], CLASSIC: [] });
  assert.match(source.titles[0].displayExpr, /__currentMapPioneerText___/);
  assert.equal(source.titles[0].colorExpr, '[heroColor[12]]');
});

test('recognizes revision-aware map sources without legacy DATA macros', () => {
  const source = buildPlatformTitleSource({
    platformData: {
      ...platformData,
      maps: [{
        ...platformData.maps[0],
        mapId: 'map.paraiso',
        mapName: 'Paraíso',
        gameplayRevisions: [{ ...defaultGameplayRevision, gameplayRevisionId: 'revision:map.paraiso:default', mapId: 'map.paraiso' }]
      }]
    },
    mapSourceFiles: [{ file: 'paraiso.opy', content: mapSource('PARAISO') }]
  });

  assert.equal(source.mapTitles[0]?.mapKey, 'DATA_PARAISO');
});

test('maps the platform scoped CLASSIC title to the internal classic slot', () => {
  const source = buildPlatformTitleSource({
    platformData: {
      ...platformData,
      maps: [{ ...platformData.maps[0], mapId: 'map.test_map', mapName: '新地图', gameplayRevisions: [defaultGameplayRevision, classicGameplayRevision] }],
      achievements: [{ challengeId: 'title.CLASSIC', family: 'map', gameplayRevisionId: 'revision:map.test_map:classic', type: 'map_completion', kind: 'map_title_achievement', titleKey: 'CLASSIC', mapId: 'map.test_map', mapVariant: 'classic', status: 'active', submissionMode: 'manual', gameVersion: '2026.07.15' }],
      titles: [{ ...platformData.titles[0], titleKey: 'CLASSIC', label: '老兵', scope: 'map', displayKind: 'fixed', mapId: 'map.test_map' }],
      playerTitleGrants: [{ playerName: '经典玩家', titleKeys: [], allTitles: false }],
      mapTitleHolders: [{ mapId: 'map.test_map', gameplayRevisionId: classicGameplayRevision.gameplayRevisionId, titleKey: 'CLASSIC', slot: null, slotSemantics: 'none', playerId: 'player-2', playerName: '经典玩家' }]
    },
    mapSourceFiles: [{ file: 'test_map.opy', content: testMapSource }]
  });

  assert.deepEqual(source.mapTitles[0].holders, { PIONEER: [], CONQUEROR: [], DOMINATOR: [], CLASSIC: ['经典玩家'] });
  assert.equal(source.titles[0].displayExpr, '__currentMapClassicText___');
});

test('uses dynamic map-title achievements as the authoritative slot projection', () => {
  const source = buildPlatformTitleSource({
    platformData: {
      ...platformData,
      maps: [{ ...platformData.maps[0], mapId: 'map.test_map', mapName: '新地图' }],
      achievements: [{ challengeId: 'map.test_map.conqueror', family: 'map', gameplayRevisionId: 'revision:map.test_map:default', type: 'map_completion', kind: 'map_title_achievement', titleKey: 'CONQUEROR', mapId: 'map.test_map', status: 'active', submissionMode: 'manual', gameVersion: '2026.07.15', mapTitleRule: { ruleId: 'rule.conqueror', kind: 'conqueror', displayKind: 'map_name_suffix', slot: 'conqueror', dynamic: true } }],
      titles: [{ ...platformData.titles[0], titleKey: 'CONQUEROR', scope: 'map', displayKind: 'map_name_suffix', mapId: 'map.test_map', slot: 'conqueror', pioneerPrefixes: ['新地图'] }],
      playerTitleGrants: [{ playerName: '征服者', titleKeys: [], allTitles: false }],
      mapTitleHolders: [{ mapId: 'map.test_map', gameplayRevisionId: 'revision:map.test_map:default', titleKey: 'CONQUEROR', slot: 'conqueror', slotSemantics: 'named', playerId: 'player-3', playerName: '征服者' }]
    },
    mapSourceFiles: [{ file: 'test_map.opy', content: testMapSource }]
  });

  assert.deepEqual(source.mapTitles[0].holders, { PIONEER: [], CONQUEROR: ['征服者'], DOMINATOR: [], CLASSIC: [] });
});

test('derives map title bindings from dynamic rules when no map title record exists', () => {
  const dynamicRule = (titleKey: string, kind: string) => ({
    challengeId: `map.test_map.${kind}`, family: 'map' as const, gameplayRevisionId: 'revision:map.test_map:default',
    type: 'map_completion', kind: 'map_title_achievement', titleKey, mapId: 'map.test_map',
    status: 'active', submissionMode: 'manual', gameVersion: '2026.07.15',
    mapTitleRule: { ruleId: `rule.${kind}`, kind, displayKind: 'map_name_suffix', slot: kind, dynamic: true }
  });
  const titles = [
    { ...platformData.titles[0], titleKey: 'CONQUEROR', scope: 'global' },
    { ...platformData.titles[0], titleKey: 'DOMINATOR', scope: 'global' }
  ];
  const source = buildPlatformTitleSource({
    platformData: {
      ...platformData,
      achievements: [dynamicRule('CONQUEROR', 'conqueror'), dynamicRule('DOMINATOR', 'dominator')],
      titles,
      playerTitleGrants: [],
      mapTitleHolders: [{ mapId: 'map.test_map', gameplayRevisionId: 'revision:map.test_map:default', titleKey: 'CONQUEROR', slot: 'conqueror', slotSemantics: 'named', playerId: 'player-7', playerName: '征服者' }]
    },
    mapSourceFiles: [{ file: 'test_map.opy', content: testMapSource }]
  });
  assert.deepEqual(source.mapTitles[0].holders, { PIONEER: [], CONQUEROR: ['征服者'], DOMINATOR: [], CLASSIC: [] });
  assert.throws(() => buildPlatformTitleSource({
    platformData: { ...platformData, achievements: [dynamicRule('TITLE_UNKNOWN', 'conqueror')], titles },
    mapSourceFiles: [{ file: 'test_map.opy', content: testMapSource }]
  }), /Missing title metadata for dynamic map title definition: map\.test_map:TITLE_UNKNOWN/);
});

test('rejects map holders that omit the explicit slot semantics', () => {
  assert.throws(() => buildPlatformTitleSource({
    platformData: {
      ...platformData,
      maps: [{ ...platformData.maps[0], mapId: 'map.test_map' }],
      titles: [{ ...platformData.titles[0], color: null, scope: 'map', displayKind: 'map_pioneer', mapId: 'map.test_map', slot: 'pioneer', pioneerPrefixes: [] }],
      playerTitleGrants: [{ playerName: '玩家', titleKeys: [], allTitles: false }],
      mapTitleHolders: [{ mapId: 'map.test_map', gameplayRevisionId: 'revision:map.test_map:default', titleKey: 'TITLE_ONE', slot: 'pioneer', playerId: 'player-4', playerName: '玩家' }]
    },
    mapSourceFiles: [{ file: 'test_map.opy', content: testMapSource }]
  }), /invalid slot semantics/);
});

test('generates the all-titles player entry without title keys', async () => {
  const source = buildPlatformTitleSource({
    platformData: {
      ...platformData,
      titles: [{ ...platformData.titles[0], color: null }],
      playerTitleGrants: [{ playerId: '123', playerName: '全称号玩家', titleKeys: [], allTitles: true }]
    },
    mapSourceFiles: [{ file: 'test_map.opy', content: testMapSource }]
  });

  const result = await syncTitleData({ sourceData: source, dryRun: true });
  assert.equal(result.sourceData.players[0].allTitles, true);
});

test('prepares every generated file before any replacement is attempted', async () => {
  const titleFile = new URL('../src/title/title-cn.opy', import.meta.url);
  const before = await readFile(titleFile, 'utf8');
  const source = buildPlatformTitleSource({
    platformData,
    mapSourceFiles: [{ file: 'test_map.opy', content: testMapSource }]
  });

  await assert.rejects(() => prepareGeneratedPlatformFiles({
    titleSource: source,
    mapRevisionSource: null as never,
    mapSourceFiles: [],
    platformEventData: { constantsSource: '#!define EVT_BUFF_0_DURATION 20\n', localeSource: '#!define STR_EVT_BUFF_0_TITLE "事件"\n' },
    validatedEventEntries: eventEntries,
    envSource: '#!define VERSION "2026.08.13"\n',
  }));
  assert.equal(await readFile(titleFile, 'utf8'), before);
});

test('does not write files after an unavailable holder projection', async () => {
  const titleFile = new URL('../src/title/title-cn.opy', import.meta.url);
  const before = await readFile(titleFile, 'utf8');
  const page = (items: unknown[]) => new Response(JSON.stringify({ contractVersion: '1', items, page: 1, pageSize: 100, total: items.length, hasMore: false }), { headers: { 'content-type': 'application/json' } });
  const fakeFetch: typeof globalThis.fetch = async (input) => {
    const url = input instanceof URL ? input : new URL(typeof input === 'string' ? input : input.url);
    if (url.pathname.endsWith('/maps')) return page([{ mapId: 'map.aatlis' }]);
    if (url.pathname.endsWith('/achievements') || url.pathname.endsWith('/titles') || url.pathname.endsWith('/player-title-grants')) return page([]);
    if (url.pathname.endsWith('/map-title-holders')) return new Response(JSON.stringify({ error: { code: 'AGENT_MAP_TITLE_PROJECTION_UNAVAILABLE' } }), { status: 503, statusText: 'Unavailable' });
    throw new Error(`Unexpected fake platform request: ${url.pathname}`);
  };

  await assert.rejects(() => syncPlatformData({
    fetch: fakeFetch
  }), /HTTP 503/);
  assert.equal(await readFile(titleFile, 'utf8'), before);
});

test('sync skips unsupported maps and their challenges without requesting their titles or holders', async () => {
  const titleFile = new URL('../src/title/title-cn.opy', import.meta.url);
  const before = await readFile(titleFile, 'utf8');
  const requestedMapIds: string[] = [];
  let eventsReached = false;
  const page = (items: unknown[]) => new Response(JSON.stringify({ contractVersion: '1', items, page: 1, pageSize: 100, total: items.length, hasMore: false }));
  const fakeFetch: typeof globalThis.fetch = async (input) => {
    const url = input instanceof URL ? input : new URL(typeof input === 'string' ? input : input.url);
    const mapId = url.searchParams.get('mapId');
    if (mapId) requestedMapIds.push(mapId);
    if (url.pathname.endsWith('/maps')) return page([
      { ...platformData.maps[0], mapId: 'map.aatlis', gameplayRevisions: [{ ...defaultGameplayRevision, mapId: 'map.aatlis', gameplayRevisionId: 'revision:map.aatlis:default' }] },
      { ...platformData.maps[0], mapId: 'map.not_implemented', mapName: '未接入地图', gameplayRevisions: [{ ...defaultGameplayRevision, mapId: 'map.not_implemented', spatialConfig: null }] }
    ]);
    if (url.pathname.endsWith('/achievements')) return page([
      { challengeId: 'title.UNSUPPORTED', family: 'map', mapId: 'map.not_implemented', titleKey: 'UNSUPPORTED', mapTitleRule: { dynamic: true } }
    ]);
    if (url.pathname.endsWith('/titles')) return page(mapId ? [] : platformData.titles);
    if (url.pathname.endsWith('/player-title-grants')) return page([{ playerName: '测试玩家', titleKeys: ['TITLE_ONE'] }]);
    if (url.pathname.endsWith('/map-title-holders')) return page([]);
    if (url.pathname.endsWith('/events')) {
      eventsReached = true;
      return new Response('Unavailable', { status: 503, statusText: 'Unavailable' });
    }
    throw new Error(`Unexpected fake platform request: ${url.pathname}`);
  };

  await assert.rejects(() => syncPlatformData({
    fetch: fakeFetch
  }), /HTTP 503/);
  assert.equal(eventsReached, true, 'supported map data and global title grants must pass generation validation');
  assert.deepEqual(new Set(requestedMapIds), new Set(['map.aatlis']));
  assert.equal(await readFile(titleFile, 'utf8'), before);
});

test('sync still rejects missing spatial configuration for a supported map', async () => {
  const titleFile = new URL('../src/title/title-cn.opy', import.meta.url);
  const before = await readFile(titleFile, 'utf8');
  const page = (items: unknown[]) => new Response(JSON.stringify({ contractVersion: '1', items, page: 1, pageSize: 100, total: items.length, hasMore: false }));
  const fakeFetch: typeof globalThis.fetch = async (input) => {
    const url = input instanceof URL ? input : new URL(typeof input === 'string' ? input : input.url);
    if (url.pathname.endsWith('/maps')) return page([
      { ...platformData.maps[0], mapId: 'map.aatlis', gameplayRevisions: [{ ...defaultGameplayRevision, mapId: 'map.aatlis', spatialConfig: null }] }
    ]);
    return page([]);
  };
  await assert.rejects(() => syncPlatformData({
    fetch: fakeFetch
  }), /spatialConfig/);
  assert.equal(await readFile(titleFile, 'utf8'), before);
});

test('keeps the generated title color only when the platform omits it', () => {
  const generated = `    # BEGIN AUTO-GENERATED ALL_TITLE\n    titleColor = [\n        # 0: TITLE_ONE\n        heroColor[12]\n    ]\n    # END AUTO-GENERATED ALL_TITLE`;
  const withColor = (colorExpr: string | null) => applyTitleColorFallback({ ...titleSource, titles: [{ ...titleSource.titles[0], colorExpr }] }, generated);
  assert.equal(withColor(null).titles[0].colorExpr, '[heroColor[12]]');
  assert.equal(withColor('[vect(1, 2, 3)]').titles[0].colorExpr, '[vect(1, 2, 3)]');
});

test('preserves existing title and player IDs while appending new entries', () => {
  const ordered = preservePlatformTitleOrder(
    {
      meta: { sourceLabel: 'titles' },
      titles: [{ key: 'NEW_TITLE' }, { key: 'PIONEER' }].map((item) => ({ ...item, label: '', category: '', condition: '', displayExpr: '""', colorExpr: null })),
      players: [{ name: '新玩家' }, { name: '他又' }],
      mapTitles: []
    },
    `# BEGIN AUTO-GENERATED TITLE ENUM\nenum TITLE:\n    PIONEER, # 0\n    REMOVED, # 1\n# END AUTO-GENERATED TITLE ENUM`,
    `const TITLE_PLAYER_NAMES = [\n  "他又",\n  "已移除玩家"\n];`
  );

  assert.deepEqual(ordered.titles.map((title) => title.key), ['PIONEER', 'NEW_TITLE']);
  assert.deepEqual(ordered.players.map((player) => player.name), ['他又', '新玩家']);
});

test('accepts map holders without playerId from the public Agents view', () => {
  const source = buildPlatformTitleSource({
    platformData: {
      ...platformData,
      maps: [{ ...platformData.maps[0], mapId: 'map.test_map' }],
      titles: [{ ...platformData.titles[0], color: null, scope: 'map', displayKind: 'map_pioneer', mapId: 'map.test_map', slot: 'pioneer', pioneerPrefixes: [] }],
      playerTitleGrants: [],
      mapTitleHolders: [{ mapId: 'map.test_map', gameplayRevisionId: 'revision:map.test_map:default', titleKey: 'TITLE_ONE', slot: 'pioneer', slotSemantics: 'named', playerName: '玩家' }]
    },
    mapSourceFiles: [{ file: 'test_map.opy', content: testMapSource }]
  });
  assert.deepEqual(source.mapTitles[0]?.holders.PIONEER, ['玩家']);
  assert.deepEqual(source.players, [{ name: '玩家', titleKeys: [] }]);
});

test('projects revision holders whose title is a global dynamic map title', () => {
  const holder = { mapId: 'map.test_map', gameplayRevisionId: 'revision:map.test_map:default', titleKey: 'CONQUEROR', slot: 'conqueror' as const, slotSemantics: 'named' as const, playerName: '征服者' };
  const source = buildPlatformMapRevisionSource({ platformData: { ...platformData, achievements: [], mapTitleHolders: [holder] } });
  assert.deepEqual(source.maps[0]?.revisions[0]?.titleHolders.map((item) => item.playerName), ['征服者']);
});

test('accepts revision holders without playerId and still dedupes by name', () => {
  const mapTitle = { ...platformData.titles[0], scope: 'map' as const, displayKind: 'map_pioneer' as const, mapId: 'map.test_map', slot: 'pioneer' as const, pioneerPrefixes: [] };
  const anonymousHolder = (playerName: string) => ({ mapId: 'map.test_map', gameplayRevisionId: 'revision:map.test_map:default', titleKey: 'TITLE_ONE', slot: 'pioneer' as const, slotSemantics: 'named' as const, playerName });
  const source = buildPlatformMapRevisionSource({
    platformData: {
      ...platformData,
      titles: [mapTitle],
      mapTitleHolders: [anonymousHolder('玩家一'), anonymousHolder('玩家二')]
    }
  });
  const holders = source.maps[0]?.revisions[0]?.titleHolders ?? [];
  assert.deepEqual(holders.map((holder) => holder.playerName).sort(), ['玩家一', '玩家二']);
  assert.ok(holders.every((holder) => holder.playerId === null));
  assert.throws(() => buildPlatformMapRevisionSource({
    platformData: {
      ...platformData,
      titles: [mapTitle],
      mapTitleHolders: [anonymousHolder('玩家一'), anonymousHolder('玩家一')]
    }
  }), /Duplicate map holder/);
});

test('rejects an empty revision projection before generated source is accepted', () => {
  const incompleteData = { ...platformData, maps: [{ ...platformData.maps[0], gameplayRevisions: [] }] };
  assert.throws(() => merge({ maps: incompleteData.maps }), /exactly one default revision/);
  assert.throws(() => buildPlatformTitleSource({
    platformData: incompleteData,
    mapSourceFiles: [{ file: 'test_map.opy', content: testMapSource }]
  }), /exactly one default revision/);
});

test('accepts the same title key across map projections when presentation agrees', () => {
  const secondMap = {
    ...platformData.maps[0],
    mapId: 'map.second_map',
    mapName: '第二地图',
    gameplayRevisions: [{ ...defaultGameplayRevision, gameplayRevisionId: 'revision:map.second_map:default', mapId: 'map.second_map' }]
  };
  const firstTitle = { ...platformData.titles[0], scope: 'map', displayKind: 'map_pioneer', mapId: 'map.test_map', slot: 'pioneer', pioneerPrefixes: [] };
  const secondTitle = { ...firstTitle, mapId: 'map.second_map' };
  const result = mergePlatformData({
    platformData: { ...platformData, maps: [platformData.maps[0], secondMap], titles: [firstTitle, secondTitle] },
    titleSource: {
      ...titleSource,
      mapTitles: [
        ...titleSource.mapTitles,
        { mapKey: 'DATA_SECOND_MAP', mapLabel: '旧第二地图', holders: { PIONEER: [], CONQUEROR: [], DOMINATOR: [], CLASSIC: [] } }
      ]
    },
    eventEntries,
    platformEventIds: { EVENT_ONE: 'event.one' },
    mapSourceFiles: [
      { file: 'test_map.opy', content: testMapSource },
      { file: 'second_map.opy', content: mapSource('SECOND_MAP') }
    ]
  });
  assert.equal(result.titleSource.titles[0]?.label, '新称号');
});

test('validates the migrated Busan control-map shape before generation', () => {
  const busanRevision = {
    ...defaultGameplayRevision,
    gameplayRevisionId: 'revision:map.busan:default',
    mapId: 'map.busan',
    spatialConfig: busanSpatialConfig
  };
  const busanPlatformData = {
    ...platformData,
    maps: [{ ...platformData.maps[0], mapId: 'map.busan', gameplayRevisions: [busanRevision] }]
  };
  const source = buildPlatformMapRevisionSource({ platformData: busanPlatformData });
  assert.match(renderPlatformMapRevisionData(source), /platformMapRevision_BUSAN_DEFAULT/);
  assert.throws(() => buildPlatformMapRevisionSource({
    platformData: {
      ...busanPlatformData,
      maps: [{ ...busanPlatformData.maps[0], gameplayRevisions: [{ ...busanRevision, spatialConfig: { ...busanSpatialConfig, control: null } }] }]
    }
  }), /control is required for map.busan/);
  assert.throws(() => buildPlatformMapRevisionSource({
    platformData: {
      ...busanPlatformData,
      maps: [{ ...busanPlatformData.maps[0], gameplayRevisions: [{ ...busanRevision, spatialConfig: { ...busanSpatialConfig, control: { ...busanSpatialConfig.control, jumpPositions: [[25, 26, 27]] } } }] }]
    }
  }), /three center\/respawn and two jump/);
});

test('accepts random-first composites and rejects invalid composition constraints', () => {
  const randomFirstConfig = {
    ...compositeSpatialConfig,
    composition: { ...compositeSpatialConfig.composition, firstStageSelection: { mode: 'random' } },
    stages: [compositeStage('beta', 500), compositeStage('alpha', 400)]
  };
  const randomOutput = renderPlatformMapRevisionData(buildPlatformMapRevisionSource({
    platformData: { ...platformData, maps: [{ ...platformData.maps[0], gameplayRevisions: [{ ...defaultGameplayRevision, spatialConfig: randomFirstConfig }] }] }
  }));
  assert.match(randomOutput, /platformMapRevision_TEST_MAP_COMPOSITE_SELECTED_STAGE_INDEX = random\.choice\(platformMapRevision_TEST_MAP_COMPOSITE_AVAILABLE_STAGE_INDICES\)/);
  assert.doesNotMatch(randomOutput, /COMPOSITE_STAGE_0_SETUP_POSITION/);
  const threeStageOutput = renderPlatformMapRevisionData(buildPlatformMapRevisionSource({
    platformData: {
      ...platformData,
      maps: [{ ...platformData.maps[0], gameplayRevisions: [{ ...defaultGameplayRevision, spatialConfig: {
        ...compositeSpatialConfig,
        composition: { ...compositeSpatialConfig.composition, selectionCount: 3 }
      } }] }]
    }
  }));
  assert.match(threeStageOutput, /for platformMapRevision_TEST_MAP_COMPOSITE_STAGE_ORDER in range\(2\):[\s\S]*COMPOSITE_AVAILABLE_STAGE_INDICES\.remove\(platformMapRevision_TEST_MAP_COMPOSITE_SELECTED_STAGE_INDEX\)[\s\S]*for platformMapRevision_TEST_MAP_COMPOSITE_STAGE_ORDER in range\(3\):/);

  const withConfig = (spatialConfig: unknown) => ({
    ...platformData,
    maps: [{ ...platformData.maps[0], gameplayRevisions: [{ ...defaultGameplayRevision, spatialConfig }] }]
  });
  assert.throws(() => buildPlatformMapRevisionSource({ platformData: withConfig({
    ...compositeSpatialConfig,
    composition: { ...compositeSpatialConfig.composition, selectionCount: 4 }
  }) }), /selectionCount exceeds the number of stages/);
  assert.throws(() => buildPlatformMapRevisionSource({ platformData: withConfig({
    ...compositeSpatialConfig,
    composition: { ...compositeSpatialConfig.composition, firstStageSelection: { mode: 'setup_detection', fallbackStageId: 'missing' } }
  }) }), /fallback stage does not exist/);
  assert.throws(() => buildPlatformMapRevisionSource({ platformData: withConfig({
    ...compositeSpatialConfig,
    stages: [compositeStage('base', 100), compositeStage('base', 200)]
  }) }), /Duplicate composite spatial stage base/);
  assert.throws(() => buildPlatformMapRevisionSource({ platformData: withConfig({
    ...compositeSpatialConfig,
    stages: [compositeStage('base', 100), compositeStage('other', 200)]
  }) }), /requires setupDetection for every non-fallback stage/);
  assert.throws(() => buildPlatformMapRevisionSource({ platformData: withConfig({
    ...compositeSpatialConfig,
    stages: [{ ...compositeStage('base', 100), control: null }, compositeStage('icebreaker', 200, { position: [820, 821, 822], radius: 30 })]
  }) }), /stages\[0\]\.control must be an object/);
  assert.throws(() => buildPlatformMapRevisionSource({ platformData: withConfig({
    ...compositeSpatialConfig,
    stages: [
      { ...compositeStage('base', 100), control: { ...compositeStage('base', 100).control, jumpPositions: [[1, 2, 3], [4, 5, 6]], respawnPositions: [[7, 8, 9], [10, 11, 12]] } },
      compositeStage('icebreaker', 200, { position: [820, 821, 822], radius: 30 })
    ]
  }) }), /must contain exactly one jump and one respawn position/);
  assert.throws(() => buildPlatformMapRevisionSource({ platformData: withConfig({
    ...compositeSpatialConfig,
    control: { respawnAxis: 'x', respawnAxisThreshold: null }
  }) }), /respawnAxisThreshold must be a non-negative finite number/);
});

test('requires composite setup routes to be executable rather than commented out', () => {
  const source = buildPlatformMapRevisionSource({
    platformData: {
      ...platformData,
      maps: [{ ...platformData.maps[0], gameplayRevisions: [{ ...defaultGameplayRevision, spatialConfig: compositeSpatialConfig }] }]
    }
  });
  const routeCall = 'platformMapRevision_TEST_MAP_DEFAULT_SETUP_ROUTE()';
  const renderSource = (call: string) => renderPlatformMapRevisionMapSources({
    source,
    mapSourceFiles: [{ file: 'test_map.opy', content: `${testMapSource}\nrule "test":\n    ${call}\n` }]
  });

  assert.doesNotThrow(() => renderSource(routeCall));
  assert.throws(() => renderSource(`# ${routeCall}`), /must call platformMapRevision_TEST_MAP_DEFAULT_SETUP_ROUTE\(\)/);
});

test('requires each map source to declare its generated revision macro block', () => {
  const source = { file: 'test_map.opy', content: testMapSource };
  assert.doesNotThrow(() => validateRevisionAwareMapSources({ mapIds: ['map.test_map'], mapSourceFiles: [source] }));
  assert.doesNotThrow(() => validateRevisionAwareMapSources({ mapIds: ['map.test_map'], mapSourceFiles: [{ ...source, content: `${source.content}\nbastionPosition = vect(1, 2, 3)\n` }] }));
  assert.throws(() => validateRevisionAwareMapSources({ mapIds: ['map.test_map'], mapSourceFiles: [{ ...source, content: 'bastionPosition = vect(1, 2, 3)\n' }] }), /exactly one revision-aware map source/);
});

test('accepts only the control roles required by a supported map implementation', () => {
  const aatlisRevision = {
    ...defaultGameplayRevision,
    gameplayRevisionId: 'revision:map.aatlis:initial',
    mapId: 'map.aatlis',
    spatialConfig: {
      ...spatialConfig,
      control: {
        centerPositions: [],
        jumpPositions: [],
        respawnPositions: [[16, 17, 18]],
        respawnAxis: 'z' as const,
        respawnAxisThreshold: 30
      }
    }
  };
  const aatlisPlatformData = {
    ...platformData,
    maps: [{ ...platformData.maps[0], mapId: 'map.aatlis', gameplayRevisions: [aatlisRevision] }]
  };
  assert.match(renderPlatformMapRevisionData(buildPlatformMapRevisionSource({ platformData: aatlisPlatformData })), /platformMapRevision_AATLIS_DEFAULT/);
  assert.throws(() => buildPlatformMapRevisionSource({
    platformData: {
      ...aatlisPlatformData,
      maps: [{ ...aatlisPlatformData.maps[0], gameplayRevisions: [{ ...aatlisRevision, spatialConfig: { ...aatlisRevision.spatialConfig, control: { ...aatlisRevision.spatialConfig.control, respawnPositions: [] } } }] }]
    }
  }), /axis requires a respawn position/);
});

test('rejects invalid revision lifecycle, defaults, spatial data, and challenge references before generation', () => {
  const withRevision = (revision: Record<string, unknown>) => ({ ...platformData, maps: [{ ...platformData.maps[0], gameplayRevisions: [revision] }] });
  assert.throws(() => buildPlatformMapRevisionSource({ platformData: withRevision({ ...defaultGameplayRevision, lifecycle: 'historical' }) }), /lifecycle must be default or selectable/);
  assert.throws(() => buildPlatformMapRevisionSource({ platformData: { ...platformData, maps: [{ ...platformData.maps[0], gameplayRevisions: [defaultGameplayRevision, { ...defaultGameplayRevision, gameplayRevisionId: 'revision:map.test_map:another-default' }] }] } }), /exactly one default revision/);
  assert.throws(() => buildPlatformMapRevisionSource({ platformData: withRevision({ ...defaultGameplayRevision, spatialConfig: { ...spatialConfig, resetPosition: [1, 2] } }) }), /resetPosition must be a finite 3D coordinate/);
  assert.throws(() => buildPlatformMapRevisionSource({ platformData: withRevision({ ...defaultGameplayRevision, spatialConfig: { ...spatialConfig, alternateStages: [{ stageId: 'missing-selector', ...spatialConfig }] } }) }), /setupDetection/);
  assert.throws(() => buildPlatformMapRevisionSource({ platformData: withRevision({ ...defaultGameplayRevision, spatialConfig: { ...spatialConfig, alternateStages: [{ stageId: 'invalid-selector', ...spatialConfig, setupDetection: { position: [1, 2, 3], radius: 0 } }] } }) }), /radius must be a positive finite number/);
  assert.throws(() => buildPlatformMapRevisionSource({ platformData: withRevision({ ...defaultGameplayRevision, challengeRefs: [{ family: 'map', challengeId: 'missing.challenge' }] }) }), /references unknown challenge missing.challenge/);
});
