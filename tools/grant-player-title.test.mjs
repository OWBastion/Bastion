import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';

import {
  applyGrantRequest,
  buildInteractiveRequest,
  grantPlayerTitle,
  parseCliArgs,
  validateCliArgs
} from './grant-player-title.mjs';

function buildFixture() {
  return {
    meta: { sourceLabel: 'x' },
    titles: [
      { key: 'CHALLENGER_LEGEND', label: '难度挑战', category: 'c', condition: 'd', availability: 'active', displayExpr: '"a"', colorExpr: 'null' },
      { key: 'TRAVELER_HELL', label: '地狱行者', category: 'c', condition: 'd', availability: 'active', displayExpr: '"a"', colorExpr: 'null' },
      { key: 'ALL_IN_ONE', label: '全图征服', category: 'c', condition: 'd', availability: 'active', displayExpr: '"a"', colorExpr: 'null' },
      { key: 'SKY', label: '全图主宰', category: 'c', condition: 'd', availability: 'active', displayExpr: '"a"', colorExpr: 'null' },
      { key: 'MANBA', label: 'What can i say', category: 'c', condition: 'd', availability: 'active', displayExpr: '"a"', colorExpr: 'null' },
      { key: 'UNLUCKY', label: '倒霉蛋', category: 'c', condition: 'd', availability: 'active', displayExpr: '"a"', colorExpr: 'null' },
      { key: 'HACKING', label: '开了', category: 'c', condition: 'd', availability: 'active', displayExpr: '"a"', colorExpr: 'null' },
      { key: 'LUCKY_STAR', label: '幸运星', category: 'c', condition: 'd', availability: 'active', displayExpr: '"a"', colorExpr: 'null' }
    ],
    players: [
      { name: '老玩家', titleKeys: [] },
      { name: '板鸭', titleKeys: ['MANBA'] }
    ],
    mapTitles: [
      {
        mapKey: 'DATA_ROUTE66',
        mapLabel: '66号公路',
        holders: { PIONEER: [], CONQUEROR: ['老玩家'], DOMINATOR: [] }
      },
      {
        mapKey: 'DATA_VOLSKAYA',
        mapLabel: '沃斯卡娅工业区',
        holders: { PIONEER: [], CONQUEROR: [], DOMINATOR: [] }
      },
      {
        mapKey: 'DATA_HORIZON_LUNAR_COLONY',
        mapLabel: '月球基地',
        holders: { PIONEER: [], CONQUEROR: [], DOMINATOR: [] }
      }
    ]
  };
}

test('cli args enforce mutual exclusivity between --interactive and --input', () => {
  const args = parseCliArgs(['--interactive', '--input', 'req.json']);
  assert.throws(() => validateCliArgs(args), /mutually exclusive/);
});

test('buildInteractiveRequest supports player mode', () => {
  const req = buildInteractiveRequest({
    targetType: 'player',
    playerName: '嘤嘤嘤丶',
    generalTitles: 'TITLE.HACKING,what can i say',
    mapDominators: '66号公路,DATA_VOLSKAYA',
    options: {
      grantDifficultyFromMaps: false,
      autoMasteryMode: 'check_only'
    }
  });

  assert.equal(req.players.length, 1);
  assert.equal(req.players[0].name, '嘤嘤嘤丶');
  assert.deepEqual(req.players[0].generalTitles, ['TITLE.HACKING', 'what can i say']);
  assert.deepEqual(req.players[0].mapDominators, ['66号公路', 'DATA_VOLSKAYA']);
  assert.equal(req.options.autoMasteryMode, 'check_only');
});

test('buildInteractiveRequest supports map mode with multi players', () => {
  const req = buildInteractiveRequest({
    targetType: 'map',
    mapKey: '沃斯卡娅工业区',
    targetPlayers: '板鸭, 蝎子莱莱 , 嘤嘤嘤丶',
    options: {
      grantDifficultyFromMaps: true,
      autoMasteryMode: 'off'
    }
  });

  assert.equal(req.players.length, 3);
  assert.deepEqual(
    req.players.map((item) => item.name),
    ['板鸭', '蝎子莱莱', '嘤嘤嘤丶']
  );
  assert.deepEqual(req.players[0].mapDominators, ['沃斯卡娅工业区']);
});

test('adds missing players at tail and deduplicates general titles', () => {
  const data = buildFixture();

  const req = {
    players: [
      {
        name: '新玩家',
        generalTitles: ['TITLE.HACKING', 'HACKING', '倒霉蛋'],
        mapDominators: []
      }
    ],
    options: {
      grantDifficultyFromMaps: false,
      autoMasteryMode: 'off'
    }
  };

  const { sourceData, summary } = applyGrantRequest(data, req);
  const newPlayer = sourceData.players[sourceData.players.length - 1];

  assert.equal(newPlayer.name, '新玩家');
  assert.deepEqual(newPlayer.titleKeys, ['HACKING', 'UNLUCKY']);
  assert.deepEqual(summary.addedPlayers, ['新玩家']);
});

test('maps alias to map key and auto-adds CONQUEROR when granting DOMINATOR', () => {
  const data = buildFixture();

  const req = {
    players: [
      {
        name: '老玩家',
        generalTitles: [],
        mapDominators: ['沃斯卡娅工业区']
      }
    ],
    options: {
      grantDifficultyFromMaps: false,
      autoMasteryMode: 'off'
    }
  };

  const { sourceData } = applyGrantRequest(data, req);
  const map = sourceData.mapTitles.find((item) => item.mapKey === 'DATA_VOLSKAYA');

  assert.equal(map.holders.DOMINATOR.includes('老玩家'), true);
  assert.equal(map.holders.CONQUEROR.includes('老玩家'), true);
});

test('supports mixed aliases for title and map', () => {
  const data = buildFixture();

  const req = {
    players: [
      {
        name: '板鸭',
        generalTitles: ['what can i say', '幸运星'],
        mapDominators: ['66号公路', 'DATA_HORIZON_LUNAR_COLONY']
      }
    ],
    options: {
      grantDifficultyFromMaps: false,
      autoMasteryMode: 'check_only'
    }
  };

  const { sourceData } = applyGrantRequest(data, req);
  const player = sourceData.players.find((item) => item.name === '板鸭');

  assert.deepEqual(player.titleKeys, ['MANBA', 'LUCKY_STAR']);

  const route66 = sourceData.mapTitles.find((item) => item.mapKey === 'DATA_ROUTE66');
  const lunar = sourceData.mapTitles.find((item) => item.mapKey === 'DATA_HORIZON_LUNAR_COLONY');

  assert.equal(route66.holders.DOMINATOR.includes('板鸭'), true);
  assert.equal(lunar.holders.DOMINATOR.includes('板鸭'), true);
});

test('grantDifficultyFromMaps and autoMasteryMode grant behave as expected', () => {
  const data = buildFixture();

  const req = {
    players: [
      {
        name: '老玩家',
        generalTitles: [],
        mapDominators: ['DATA_ROUTE66', 'DATA_VOLSKAYA', 'DATA_HORIZON_LUNAR_COLONY']
      }
    ],
    options: {
      grantDifficultyFromMaps: true,
      autoMasteryMode: 'grant'
    }
  };

  const { sourceData, summary } = applyGrantRequest(data, req);
  const player = sourceData.players.find((item) => item.name === '老玩家');

  assert.equal(player.titleKeys.includes('CHALLENGER_LEGEND'), true);
  assert.equal(player.titleKeys.includes('TRAVELER_HELL'), true);
  assert.equal(player.titleKeys.includes('ALL_IN_ONE'), true);
  assert.equal(player.titleKeys.includes('SKY'), true);

  assert.equal(summary.masteryCheck['老玩家'].allConqueror, true);
  assert.equal(summary.masteryCheck['老玩家'].allDominator, true);
});

test('dry-run does not write source file for input mode', async () => {
  const tmpDir = await fs.mkdtemp(path.join(os.tmpdir(), 'grant-title-'));
  const sourceFile = path.join(tmpDir, 'title-source.json');
  const requestFile = path.join(tmpDir, 'request.json');

  const source = buildFixture();
  await fs.writeFile(sourceFile, `${JSON.stringify(source, null, 2)}\n`, 'utf8');
  await fs.writeFile(
    requestFile,
    JSON.stringify(
      {
        players: [
          { name: '新玩家', generalTitles: ['HACKING'], mapDominators: ['66号公路'] }
        ],
        options: { grantDifficultyFromMaps: false, autoMasteryMode: 'off' }
      },
      null,
      2
    ),
    'utf8'
  );

  const before = await fs.readFile(sourceFile, 'utf8');
  const result = await grantPlayerTitle({ sourceFile, inputFile: requestFile, dryRun: true });
  const after = await fs.readFile(sourceFile, 'utf8');

  assert.equal(result.changed, true);
  assert.equal(before, after);
});

test('dry-run does not write source file for interactive-equivalent requestData', async () => {
  const tmpDir = await fs.mkdtemp(path.join(os.tmpdir(), 'grant-title-inline-'));
  const sourceFile = path.join(tmpDir, 'title-source.json');

  const source = buildFixture();
  await fs.writeFile(sourceFile, `${JSON.stringify(source, null, 2)}\n`, 'utf8');

  const requestData = buildInteractiveRequest({
    targetType: 'map',
    mapKey: '66号公路',
    targetPlayers: '新玩家,老玩家',
    options: { grantDifficultyFromMaps: false, autoMasteryMode: 'check_only' }
  });

  const before = await fs.readFile(sourceFile, 'utf8');
  const result = await grantPlayerTitle({ sourceFile, requestData, dryRun: true });
  const after = await fs.readFile(sourceFile, 'utf8');

  assert.equal(result.changed, true);
  assert.equal(before, after);
});
