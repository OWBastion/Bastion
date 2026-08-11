import assert from 'node:assert/strict';
import test from 'node:test';

import { buildPlatformMapRevisionSource, buildPlatformTitleSource, mergePlatformData, mergePlatformEventOverPyData, renderPlatformMapRevisionData } from './sync-platform-data.ts';
import { applyTitleColorFallback, preservePlatformTitleOrder, syncTitleData } from './sync-title-data.ts';
import type { PlatformData } from './platform-data-client.ts';

const titleSource = {
  meta: { sourceLabel: 'titles' },
  titles: [{ key: 'TITLE_ONE', label: '旧称号', category: '旧分类', condition: '旧条件', availability: 'active', displayExpr: '"旧称号"', colorExpr: 'null' }],
  players: [{ name: '玩家', titleKeys: ['TITLE_ONE'] }],
  mapTitles: [{ mapKey: 'DATA_TEST_MAP', mapLabel: '旧地图', holders: { PIONEER: ['玩家'], CONQUEROR: [], DOMINATOR: [], CLASSIC: [] } }]
};

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
    jumpPositions: [[25, 26, 27], [28, 29, 30], [40, 41, 42]],
    respawnPositions: [[31, 32, 33], [34, 35, 36], [37, 38, 39]],
    respawnAxis: 'x' as const,
    respawnAxisThreshold: 40
  }
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

const selectableGameplayRevision = {
  ...defaultGameplayRevision,
  gameplayRevisionId: 'revision:map.test_map:selectable',
  lifecycle: 'selectable',
  isDefault: false,
  isSelectable: true
};

const platformData: PlatformData = {
  events: [{ eventId: 'event.one', name: '新事件', category: '增益', rarity: 'R', description: '新描述', durationSeconds: 20, weight: 2, archived: false, releaseStatus: 'implemented', challenges: [] }],
  maps: [{ mapId: 'map.test_map', mapName: '新地图', gameVersion: '2026.07.15', difficultyRating: 'T1', mechanics: [], coverUrl: null, backgroundUrl: null, gameplayRevisions: [defaultGameplayRevision] }],
  achievements: [{ challengeId: 'title.TITLE_ONE', family: 'achievement', type: 'title_achievement', kind: 'title_achievement', titleKey: 'TITLE_ONE', status: 'active', submissionMode: 'manual' }],
  titles: [{ titleKey: 'TITLE_ONE', label: '新称号', icon: 'trophy', category: '新分类', condition: '新条件', availability: 'active', scope: 'global', displayKind: 'fixed', gameVersion: '2026.07.15' }]
  ,playerTitleGrants: [], mapTitleHolders: []
};

function merge(overrides: Partial<PlatformData> = {}, source = titleSource) {
  return mergePlatformData({
    platformData: { ...platformData, ...overrides },
    titleSource: source,
    eventEntries,
    platformEventIds: { EVENT_ONE: 'event.one' },
    mapSourceFiles: [{ file: 'test_map.opy', content: 'DATA_TEST_MAP' }]
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
    titles: [...titleSource.titles, { key: 'CLASSIC', label: '老兵', category: '地图精通系列', condition: '通关经典版地图', availability: 'active', displayExpr: '__currentMapClassicText___', colorExpr: 'null' }]
  });
  assert.equal(result.counts.achievements, 2);
});

test('rejects unknown platform title IDs', () => {
  assert.throws(() => merge({ titles: [{ ...platformData.titles[0], titleKey: 'TITLE_UNKNOWN' }] }), /unknown Bastion title TITLE_UNKNOWN/);
});

test('rejects unsupported platform enums', () => {
  assert.throws(() => merge({ maps: [{ ...platformData.maps[0], difficultyRating: 'T9' }] }), /difficultyRating has an unsupported value/);
  assert.throws(() => merge({ titles: [{ ...platformData.titles[0], displayKind: 'unknown' }] }), /unsupported scope or displayKind/);
  assert.throws(() => merge({ achievements: [{ ...platformData.achievements[0], status: 'draft' }] }), /status has an unsupported value/);
  assert.throws(() => merge({ events: [{ ...platformData.events[0], category: '未知' }] }), /category has an unsupported value/);
});

test('ignores unmapped historical events while validating their platform category', () => {
  const result = merge({
    events: [
      platformData.events[0],
      { ...platformData.events[0], eventId: 'event.history', category: '全局', name: '历史事件' }
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
    mapSourceFiles: [{ file: 'test_map.opy', content: 'DATA_TEST_MAP' }]
  });
  assert.deepEqual(source.players, [{ name: '玩家改名', titleKeys: ['TITLE_ONE'] }]);
  assert.deepEqual(source.mapTitles[0].holders, { PIONEER: ['玩家改名'], CONQUEROR: [], DOMINATOR: [], CLASSIC: [] });
  assert.match(source.titles[0].displayExpr, /__currentMapPioneerText___/);
  assert.equal(source.titles[0].colorExpr, 'heroColor[12]');
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
    mapSourceFiles: [{ file: 'paraiso.opy', content: 'platformMapRevisionMapId = "map.paraiso"' }]
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
      mapTitleHolders: [{ mapId: 'map.test_map', gameplayRevisionId: 'revision:map.test_map:default', titleKey: 'CLASSIC', slot: null, slotSemantics: 'none', playerId: 'player-2', playerName: '经典玩家' }]
    },
    mapSourceFiles: [{ file: 'test_map.opy', content: 'DATA_TEST_MAP' }]
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
    mapSourceFiles: [{ file: 'test_map.opy', content: 'DATA_TEST_MAP' }]
  });

  assert.deepEqual(source.mapTitles[0].holders, { PIONEER: [], CONQUEROR: ['征服者'], DOMINATOR: [], CLASSIC: [] });
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
    mapSourceFiles: [{ file: 'test_map.opy', content: 'DATA_TEST_MAP' }]
  }), /invalid slot semantics/);
});

test('generates the all-titles player entry without title keys', async () => {
  const source = buildPlatformTitleSource({
    platformData: {
      ...platformData,
      titles: [{ ...platformData.titles[0], color: null }],
      playerTitleGrants: [{ playerId: '123', playerName: '全称号玩家', titleKeys: [], allTitles: true }]
    },
    mapSourceFiles: [{ file: 'test_map.opy', content: 'DATA_TEST_MAP' }]
  });

  const result = await syncTitleData({ sourceData: source, dryRun: true });
  assert.equal(result.sourceData.players[0].allTitles, true);
});

test('falls back to the existing generated title color when the platform omits it', () => {
  const source = {
    ...titleSource,
    titles: [{ ...titleSource.titles[0], colorExpr: null }]
  };
  const result = applyTitleColorFallback(source, `    # BEGIN AUTO-GENERATED ALL_TITLE\n    titleColor = [\n        # 0: TITLE_ONE\n        heroColor[12]\n    ]\n    # END AUTO-GENERATED ALL_TITLE`);
  assert.equal(result.titles[0].colorExpr, 'heroColor[12]');
});

test('uses the platform title color when it is present', () => {
  const result = applyTitleColorFallback({
    ...titleSource,
    titles: [{ ...titleSource.titles[0], colorExpr: 'vect(1, 2, 3)' }]
  }, `    # BEGIN AUTO-GENERATED ALL_TITLE\n    titleColor = [\n        # 0: TITLE_ONE\n        heroColor[12]\n    ]\n    # END AUTO-GENERATED ALL_TITLE`);
  assert.equal(result.titles[0].colorExpr, 'vect(1, 2, 3)');
});

test('preserves existing title and player IDs while appending new entries', () => {
  const ordered = preservePlatformTitleOrder(
    {
      meta: { sourceLabel: 'titles' },
      titles: [{ key: 'NEW_TITLE' }, { key: 'PIONEER' }],
      players: [{ name: '新玩家' }, { name: '他又' }],
      mapTitles: []
    },
    `# BEGIN AUTO-GENERATED TITLE ENUM\nenum TITLE:\n    PIONEER, # 0\n    REMOVED, # 1\n# END AUTO-GENERATED TITLE ENUM`,
    `const TITLE_PLAYER_NAMES = [\n  "他又",\n  "已移除玩家"\n];`
  );

  assert.deepEqual(ordered.titles.map((title) => title.key), ['PIONEER', 'NEW_TITLE']);
  assert.deepEqual(ordered.players.map((player) => player.name), ['他又', '新玩家']);
});

test('rejects map holders that reference a player without an active grant', () => {
  assert.throws(() => buildPlatformTitleSource({
    platformData: {
      ...platformData,
      maps: [{ ...platformData.maps[0], mapId: 'map.test_map' }],
      titles: [{ ...platformData.titles[0], color: null, scope: 'map', displayKind: 'map_pioneer', mapId: 'map.test_map', slot: 'pioneer', pioneerPrefixes: [] }],
      playerTitleGrants: [],
      mapTitleHolders: [{ mapId: 'map.test_map', gameplayRevisionId: 'revision:map.test_map:default', titleKey: 'TITLE_ONE', slot: 'pioneer', slotSemantics: 'named', playerName: '玩家' }]
    },
    mapSourceFiles: [{ file: 'test_map.opy', content: 'DATA_TEST_MAP' }]
  }), /playerId/);
});

test('generates deterministic revision-scoped map data for default and selectable revisions', () => {
  const source = buildPlatformMapRevisionSource({
    platformData: {
      ...platformData,
      maps: [{ ...platformData.maps[0], gameplayRevisions: [selectableGameplayRevision, defaultGameplayRevision] }],
      achievements: [{ challengeId: 'map.test_map.pioneer', family: 'map', gameplayRevisionId: selectableGameplayRevision.gameplayRevisionId, type: 'map_completion', kind: 'map_title_achievement', titleKey: 'TITLE_ONE', mapId: 'map.test_map', status: 'active', submissionMode: 'manual', gameVersion: '2026.07.15', mapTitleRule: { ruleId: 'rule.pioneer', kind: 'pioneer', displayKind: 'map_pioneer', slot: 'pioneer', dynamic: true } }],
      titles: [{ ...platformData.titles[0], scope: 'map', displayKind: 'map_pioneer', mapId: 'map.test_map', slot: 'pioneer', pioneerPrefixes: ['新地图'] }],
      mapTitleHolders: [
        { mapId: 'map.test_map', gameplayRevisionId: defaultGameplayRevision.gameplayRevisionId, titleKey: 'TITLE_ONE', slot: 'pioneer', slotSemantics: 'named', playerId: 'player-6', playerName: '默认玩家' },
        { mapId: 'map.test_map', gameplayRevisionId: selectableGameplayRevision.gameplayRevisionId, titleKey: 'TITLE_ONE', slot: 'pioneer', slotSemantics: 'named', playerId: 'player-5', playerName: '修订玩家' }
      ]
    }
  });
  assert.deepEqual(source.maps[0]?.revisions.map((revision) => revision.gameplayRevisionId), [defaultGameplayRevision.gameplayRevisionId, selectableGameplayRevision.gameplayRevisionId]);
  assert.equal(source.maps[0]?.revisions[0]?.titleHolders[0]?.playerName, '默认玩家');
  assert.equal(source.maps[0]?.revisions[1]?.titleHolders[0]?.playerName, '修订玩家');
  const output = renderPlatformMapRevisionData(source);
  assert.match(output, /PLATFORM_MAP_REVISION_CONTRACT_VERSION "1"/);
  assert.match(output, /vect\(1, 2, 3\)/);
  assert.match(output, /PLATFORM_MAP_REVISION_FIELD_GAMEPLAY_REVISION_ID 2/);
  assert.match(output, /\["map.test_map", "新地图", "revision:map.test_map:default"/);
  assert.match(output, /\["map.test_map", "新地图", "revision:map.test_map:default"[\s\S]*\[\["默认玩家"\], \[\], \[\], \[\]\]\]/);
  assert.match(output, /\[\["修订玩家"\], \[\], \[\], \[\]\]\]/);
  assert.equal(output, renderPlatformMapRevisionData(JSON.parse(JSON.stringify(source))));
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
  assert.match(renderPlatformMapRevisionData(source), /map.busan/);
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
  }), /matching lengths/);
});

test('rejects invalid revision lifecycle, defaults, spatial data, and challenge references before generation', () => {
  const withRevision = (revision: Record<string, unknown>) => ({ ...platformData, maps: [{ ...platformData.maps[0], gameplayRevisions: [revision] }] });
  assert.throws(() => buildPlatformMapRevisionSource({ platformData: withRevision({ ...defaultGameplayRevision, lifecycle: 'historical' }) }), /lifecycle must be default or selectable/);
  assert.throws(() => buildPlatformMapRevisionSource({ platformData: { ...platformData, maps: [{ ...platformData.maps[0], gameplayRevisions: [defaultGameplayRevision, { ...defaultGameplayRevision, gameplayRevisionId: 'revision:map.test_map:another-default' }] }] } }), /exactly one default revision/);
  assert.throws(() => buildPlatformMapRevisionSource({ platformData: withRevision({ ...defaultGameplayRevision, spatialConfig: { ...spatialConfig, resetPosition: [1, 2] } }) }), /resetPosition must be a finite 3D coordinate/);
  assert.throws(() => buildPlatformMapRevisionSource({ platformData: withRevision({ ...defaultGameplayRevision, challengeRefs: [{ family: 'map', challengeId: 'missing.challenge' }] }) }), /references unknown challenge missing.challenge/);
});
