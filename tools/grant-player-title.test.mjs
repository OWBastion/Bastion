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
  parseNumberSelection,
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

test('cli args parse direct player mode with general title and fail-on-missing-player', () => {
  const args = parseCliArgs([
    '--player-name',
    '板鸭',
    '--general-title',
    'MANBA',
    '--fail-on-missing-player'
  ]);
  validateCliArgs(args);
  assert.equal(args.playerName, '板鸭');
  assert.deepEqual(args.generalTitles, ['MANBA']);
  assert.equal(args.failOnMissingPlayer, true);
});

test('cli args reject mixing --player-name with --input or --interactive', () => {
  const withInput = parseCliArgs(['--player-name', '板鸭', '--general-title', 'MANBA', '--input', 'req.json']);
  assert.throws(() => validateCliArgs(withInput), /mutually exclusive/);

  const withInteractive = parseCliArgs(['--player-name', '板鸭', '--general-title', 'MANBA', '--interactive']);
  assert.throws(() => validateCliArgs(withInteractive), /mutually exclusive/);
});

test('cli args require --general-title in --player-name mode', () => {
  const args = parseCliArgs(['--player-name', '板鸭']);
  assert.throws(() => validateCliArgs(args), /requires at least one --general-title/);
});

test('parseNumberSelection parses single/multi and deduplicates', () => {
  assert.deepEqual(parseNumberSelection('2', { max: 3 }), [2]);
  assert.deepEqual(parseNumberSelection('1,2,2,3', { max: 3, multi: true }), [1, 2, 3]);
  assert.throws(() => parseNumberSelection('x', { max: 3 }), /无效编号/);
  assert.throws(() => parseNumberSelection('0', { max: 3 }), /不允许选择 0/);
});

test('buildInteractiveRequest supports player mode with option selections', () => {
  const req = buildInteractiveRequest({
    targetType: 'player',
    playerName: '嘤嘤嘤丶',
    generalTitles: ['HACKING', 'MANBA'],
    mapDominators: ['DATA_ROUTE66', 'DATA_VOLSKAYA'],
    options: {
      grantDifficultyFromMaps: false,
      autoMasteryMode: 'check_only'
    }
  });

  assert.equal(req.players.length, 1);
  assert.equal(req.players[0].name, '嘤嘤嘤丶');
  assert.deepEqual(req.players[0].generalTitles, ['HACKING', 'MANBA']);
  assert.deepEqual(req.players[0].mapDominators, ['DATA_ROUTE66', 'DATA_VOLSKAYA']);
  assert.equal(req.options.autoMasteryMode, 'check_only');
});

test('buildInteractiveRequest supports map mode with multi players', () => {
  const req = buildInteractiveRequest({
    targetType: 'map',
    mapKey: 'DATA_VOLSKAYA',
    targetPlayers: ['板鸭', '蝎子莱莱', '嘤嘤嘤丶'],
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
  assert.deepEqual(req.players[0].mapDominators, ['DATA_VOLSKAYA']);
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

test('failOnMissingPlayer rejects unknown players instead of auto-appending', () => {
  const data = buildFixture();

  const req = {
    players: [
      {
        name: '不存在的玩家',
        generalTitles: ['HACKING'],
        mapDominators: []
      }
    ],
    options: {
      grantDifficultyFromMaps: false,
      autoMasteryMode: 'off',
      failOnMissingPlayer: true
    }
  };

  assert.throws(() => applyGrantRequest(data, req), /Player not found in title source/);
  assert.equal(data.players.some((item) => item.name === '不存在的玩家'), false);
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
  assert.deepEqual(result.autoSync, {
    executed: false,
    reason: 'dry_run'
  });
});

test('dry-run does not write source file for interactive-equivalent requestData', async () => {
  const tmpDir = await fs.mkdtemp(path.join(os.tmpdir(), 'grant-title-inline-'));
  const sourceFile = path.join(tmpDir, 'title-source.json');

  const source = buildFixture();
  await fs.writeFile(sourceFile, `${JSON.stringify(source, null, 2)}\n`, 'utf8');

  const requestData = buildInteractiveRequest({
    targetType: 'map',
    mapKey: 'DATA_ROUTE66',
    targetPlayers: ['新玩家', '老玩家'],
    options: { grantDifficultyFromMaps: false, autoMasteryMode: 'check_only' }
  });

  const before = await fs.readFile(sourceFile, 'utf8');
  const result = await grantPlayerTitle({ sourceFile, requestData, dryRun: true });
  const after = await fs.readFile(sourceFile, 'utf8');

  assert.equal(result.changed, true);
  assert.equal(before, after);
  assert.deepEqual(result.autoSync, {
    executed: false,
    reason: 'dry_run'
  });
});

test('non-dry-run with changes triggers title sync once', async () => {
  const tmpDir = await fs.mkdtemp(path.join(os.tmpdir(), 'grant-title-sync-'));
  const sourceFile = path.join(tmpDir, 'title-source.json');

  await fs.writeFile(sourceFile, `${JSON.stringify(buildFixture(), null, 2)}\n`, 'utf8');

  const syncCalls = [];
  const result = await grantPlayerTitle({
    sourceFile,
    requestData: {
      players: [{ name: '新玩家', generalTitles: ['HACKING'], mapDominators: [] }],
      options: { grantDifficultyFromMaps: false, autoMasteryMode: 'off' }
    },
    syncFn: async (options) => {
      syncCalls.push(options);
      return {
        titleFileChanged: true,
        sourceVersion: '1.2.3',
        webPayload: {
          meta: {
            titleCount: 8,
            playerCount: 3,
            mapTitleCount: 3
          }
        }
      };
    }
  });

  const saved = JSON.parse(await fs.readFile(sourceFile, 'utf8'));
  assert.equal(result.changed, true);
  assert.equal(syncCalls.length, 1);
  assert.equal(syncCalls[0].sourceFile, sourceFile);
  assert.equal(saved.players.at(-1).name, '新玩家');
  assert.deepEqual(result.autoSync, {
    executed: true,
    reason: 'source_changed',
    titleFileChanged: true,
    sourceVersion: '1.2.3',
    generated: {
      titleCount: 8,
      playerCount: 3,
      mapTitleCount: 3
    }
  });
});

test('non-dry-run without changes skips title sync', async () => {
  const tmpDir = await fs.mkdtemp(path.join(os.tmpdir(), 'grant-title-noop-'));
  const sourceFile = path.join(tmpDir, 'title-source.json');

  await fs.writeFile(sourceFile, `${JSON.stringify(buildFixture(), null, 2)}\n`, 'utf8');

  let syncCalled = false;
  const result = await grantPlayerTitle({
    sourceFile,
    requestData: {
      players: [{ name: '板鸭', generalTitles: ['MANBA'], mapDominators: [] }],
      options: { grantDifficultyFromMaps: false, autoMasteryMode: 'off' }
    },
    syncFn: async () => {
      syncCalled = true;
      throw new Error('should not run');
    }
  });

  assert.equal(result.changed, false);
  assert.equal(syncCalled, false);
  assert.deepEqual(result.autoSync, {
    executed: false,
    reason: 'no_changes'
  });
});

test('sync failure is surfaced after source write', async () => {
  const tmpDir = await fs.mkdtemp(path.join(os.tmpdir(), 'grant-title-sync-fail-'));
  const sourceFile = path.join(tmpDir, 'title-source.json');

  await fs.writeFile(sourceFile, `${JSON.stringify(buildFixture(), null, 2)}\n`, 'utf8');

  await assert.rejects(
    () =>
      grantPlayerTitle({
        sourceFile,
        requestData: {
          players: [{ name: '新玩家', generalTitles: ['HACKING'], mapDominators: [] }],
          options: { grantDifficultyFromMaps: false, autoMasteryMode: 'off' }
        },
        syncFn: async () => {
          throw new Error('sync failed');
        }
      }),
    /sync failed/
  );

  const saved = JSON.parse(await fs.readFile(sourceFile, 'utf8'));
  assert.equal(saved.players.at(-1).name, '新玩家');
});
