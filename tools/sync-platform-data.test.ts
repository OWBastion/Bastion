import assert from 'node:assert/strict';
import test from 'node:test';

import { mergePlatformData, mergePlatformEventOverPyData } from './sync-platform-data.ts';
import type { PlatformData } from './platform-data-client.ts';

const titleSource = {
  meta: { sourceLabel: 'titles' },
  titles: [{ key: 'TITLE_ONE', label: '旧称号', category: '旧分类', condition: '旧条件', availability: 'active', displayExpr: '"旧称号"', colorExpr: 'null' }],
  players: [{ name: '玩家', titleKeys: ['TITLE_ONE'] }],
  mapTitles: [{ mapKey: 'DATA_TEST_MAP', mapLabel: '旧地图', holders: { PIONEER: ['玩家'], CONQUEROR: [], DOMINATOR: [] } }]
};

const eventEntries = [{
  key: 'EVENT_ONE',
  type: 'buff' as const,
  platformId: 'event.one',
  macros: { id: 0, duration: 'EVT_BUFF_0_DURATION', weight: 'EVT_BUFF_0_WEIGHT' }
}];

const platformData: PlatformData = {
  events: [{ eventId: 'event.one', name: '新事件', category: '增益', rarity: 'R', description: '新描述', durationSeconds: 20, weight: 2, archived: false, releaseStatus: 'implemented', challenges: [] }],
  maps: [{ mapId: 'map.test_map', mapName: '新地图', gameVersion: '2026.07.15', difficultyRating: 'T1', mechanics: [], coverUrl: null, backgroundUrl: null }],
  achievements: [{ challengeId: 'title.TITLE_ONE', family: 'achievement', type: 'title_achievement', kind: 'title_achievement', titleKey: 'TITLE_ONE', status: 'active', submissionMode: 'manual' }],
  titles: [{ titleKey: 'TITLE_ONE', label: '新称号', icon: 'trophy', category: '新分类', condition: '新条件', availability: 'active', scope: 'global', displayKind: 'fixed', gameVersion: '2026.07.15' }]
};

function merge(overrides: Partial<PlatformData> = {}) {
  return mergePlatformData({
    platformData: { ...platformData, ...overrides },
    titleSource,
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
