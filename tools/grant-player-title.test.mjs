import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';

import {
  applyGrantRequest,
  buildInteractiveRequest,
  collectInteractiveRequest,
  createAnsi,
  createInteractiveRenderer,
  grantPlayerTitle,
  parseCliArgs,
  parseNumberSelection,
  parseTitleIndexSelection,
  resolvePlayerNameFromPlayerId,
  resolveTitleKeyFromLabel,
  validateCliArgs
} from './grant-player-title.mjs';

function buildFixture() {
  return {
    meta: { sourceLabel: 'x' },
    titles: [
      { key: 'PIONEER', label: '开拓者', category: 'c', condition: 'd', availability: 'active', displayExpr: '"a"', colorExpr: 'null' },
      {
        key: 'CHALLENGER_LEGEND',
        label: '难度挑战',
        category: 'c',
        condition: 'd',
        availability: 'active',
        displayExpr: '"a"',
        colorExpr: 'vect(1, 2, 3)'
      },
      { key: 'DODGE_ULTIMATE', label: '终极闪避', category: 'c', condition: 'd', availability: 'active', displayExpr: '"a"', colorExpr: 'null' },
      { key: 'TRAVELER_HELL', label: '地狱行者', category: 'c', condition: 'd', availability: 'active', displayExpr: '"a"', colorExpr: 'null' },
      { key: 'ALL_IN_ONE', label: '全图征服', category: 'c', condition: 'd', availability: 'active', displayExpr: '"a"', colorExpr: 'breathRed' },
      { key: 'SKY', label: '全图主宰', category: 'c', condition: 'd', availability: 'active', displayExpr: '"a"', colorExpr: 'breathPurple' },
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

function createScriptedReadline(answers) {
  const queue = [...answers];
  return {
    async question() {
      if (queue.length === 0) {
        throw new Error('No scripted answer left for readline question');
      }
      return queue.shift();
    },
    close() {}
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

test('cli args parse player-id mode with chinese title label', () => {
  const args = parseCliArgs(['--player-id', '12', '--general-title-label', '幸运星']);
  validateCliArgs(args);
  assert.equal(args.playerId, '12');
  assert.deepEqual(args.generalTitleLabels, ['幸运星']);
});

test('cli args reject mixing --player-name with --input or --interactive', () => {
  const withInput = parseCliArgs(['--player-name', '板鸭', '--general-title', 'MANBA', '--input', 'req.json']);
  assert.throws(() => validateCliArgs(withInput), /mutually exclusive/);

  const withInteractive = parseCliArgs(['--player-name', '板鸭', '--general-title', 'MANBA', '--interactive']);
  assert.throws(() => validateCliArgs(withInteractive), /mutually exclusive/);
});

test('cli args reject mixing --player-name and --player-id', () => {
  const args = parseCliArgs(['--player-name', '板鸭', '--player-id', '1', '--general-title', 'MANBA']);
  assert.throws(() => validateCliArgs(args), /mutually exclusive/);
});

test('cli args require --general-title in --player-name mode', () => {
  const args = parseCliArgs(['--player-name', '板鸭']);
  assert.throws(() => validateCliArgs(args), /Direct player mode requires/);
});

test('cli args require title input in --player-id mode', () => {
  const args = parseCliArgs(['--player-id', '0']);
  assert.throws(() => validateCliArgs(args), /Direct player mode requires/);
});

test('parseNumberSelection parses single/multi and deduplicates', () => {
  assert.deepEqual(parseNumberSelection('2', { max: 3 }), [2]);
  assert.deepEqual(parseNumberSelection('1,2,2,3', { max: 3, multi: true }), [1, 2, 3]);
  assert.throws(() => parseNumberSelection('x', { max: 3 }), /无效编号/);
  assert.throws(() => parseNumberSelection('0', { max: 3 }), /不允许选择 0/);
});

test('parseTitleIndexSelection parses zero-based multi and deduplicates', () => {
  assert.deepEqual(parseTitleIndexSelection('14,20,14', { maxIndex: 25 }), [14, 20]);
  assert.deepEqual(parseTitleIndexSelection('', { maxIndex: 25, allowEmpty: true }), []);
  assert.throws(() => parseTitleIndexSelection('x', { maxIndex: 25 }), /无效索引/);
  assert.throws(() => parseTitleIndexSelection('26', { maxIndex: 25 }), /索引超出范围/);
});

test('buildInteractiveRequest supports player mode with option selections', () => {
  const req = buildInteractiveRequest({
    targetType: 'player',
    playerName: '嘤嘤嘤丶',
    generalTitles: ['HACKING', 'MANBA'],
    mapDominators: ['DATA_ROUTE66', 'DATA_VOLSKAYA'],
    mapPioneers: ['DATA_HORIZON_LUNAR_COLONY'],
    options: {
      grantDifficultyFromMaps: false,
      autoMasteryMode: 'check_only'
    }
  });

  assert.equal(req.players.length, 1);
  assert.equal(req.players[0].name, '嘤嘤嘤丶');
  assert.deepEqual(req.players[0].generalTitles, ['HACKING', 'MANBA']);
  assert.deepEqual(req.players[0].mapDominators, ['DATA_ROUTE66', 'DATA_VOLSKAYA']);
  assert.deepEqual(req.players[0].mapPioneers, ['DATA_HORIZON_LUNAR_COLONY']);
  assert.equal(req.options.autoMasteryMode, 'check_only');
});

test('cli args parse direct player mode with --map-pioneer', () => {
  const args = parseCliArgs(['--player-name', '板鸭', '--map-pioneer', '66号公路', '--map-pioneer', 'DATA_VOLSKAYA']);
  validateCliArgs(args);
  assert.deepEqual(args.mapPioneers, ['66号公路', 'DATA_VOLSKAYA']);
});

test('cli args reject --map-pioneer outside direct player mode', () => {
  const args = parseCliArgs(['--input', 'req.json', '--map-pioneer', 'DATA_ROUTE66']);
  assert.throws(() => validateCliArgs(args), /can only be used in direct player mode/);
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
  assert.deepEqual(req.players[0].mapPioneers, []);
});

test('buildInteractiveRequest supports map mode pioneer switch', () => {
  const req = buildInteractiveRequest({
    targetType: 'map',
    mapKey: 'DATA_VOLSKAYA',
    targetPlayers: ['板鸭'],
    mapPioneersByMapMode: true,
    options: {
      grantDifficultyFromMaps: false,
      autoMasteryMode: 'off'
    }
  });

  assert.deepEqual(req.players, [{ name: '板鸭', generalTitles: [], mapDominators: [], mapPioneers: ['DATA_VOLSKAYA'] }]);
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

test('resolve player name from player id index', () => {
  const data = buildFixture();
  assert.equal(resolvePlayerNameFromPlayerId(data, '0'), '老玩家');
  assert.equal(resolvePlayerNameFromPlayerId(data, 1), '板鸭');
  assert.throws(() => resolvePlayerNameFromPlayerId(data, 'x'), /Invalid player id/);
  assert.throws(() => resolvePlayerNameFromPlayerId(data, '3'), /out of range/);
});

test('resolve title key from chinese label', () => {
  const data = buildFixture();
  assert.equal(resolveTitleKeyFromLabel(data, '幸运星'), 'LUCKY_STAR');
  assert.equal(resolveTitleKeyFromLabel(data, 'What can i say'), 'MANBA');
  assert.throws(() => resolveTitleKeyFromLabel(data, '不存在的称号'), /Unknown title label/);
});

test('blocks restricted title key grant for restricted set', () => {
  const data = buildFixture();
  const req = {
    players: [{ name: '老玩家', generalTitles: ['CHALLENGER_LEGEND'], mapDominators: [] }],
    options: { grantDifficultyFromMaps: false, autoMasteryMode: 'off' }
  };
  assert.throws(() => applyGrantRequest(data, req), /Restricted general title cannot be granted/);
});

test('blocks restricted title label grant for restricted set', () => {
  const data = buildFixture();
  const req = {
    players: [{ name: '老玩家', generalTitles: ['难度挑战'], mapDominators: [] }],
    options: { grantDifficultyFromMaps: false, autoMasteryMode: 'off' }
  };
  assert.throws(() => applyGrantRequest(data, req), /Restricted general title cannot be granted/);
});

test('allows DODGE_ULTIMATE general title grant by key', () => {
  const data = buildFixture();
  const req = {
    players: [{ name: '老玩家', generalTitles: ['DODGE_ULTIMATE'], mapDominators: [] }],
    options: { grantDifficultyFromMaps: false, autoMasteryMode: 'off' }
  };
  const { sourceData, summary } = applyGrantRequest(data, req);
  const player = sourceData.players.find((item) => item.name === '老玩家');

  assert.equal(player.titleKeys.includes('DODGE_ULTIMATE'), true);
  assert.deepEqual(summary.generalTitleAdds['老玩家'], ['DODGE_ULTIMATE']);
});

test('allows DODGE_ULTIMATE general title grant by label', () => {
  const data = buildFixture();
  const req = {
    players: [{ name: '老玩家', generalTitles: ['终极闪避'], mapDominators: [] }],
    options: { grantDifficultyFromMaps: false, autoMasteryMode: 'off' }
  };
  const { sourceData, summary } = applyGrantRequest(data, req);
  const player = sourceData.players.find((item) => item.name === '老玩家');

  assert.equal(player.titleKeys.includes('DODGE_ULTIMATE'), true);
  assert.deepEqual(summary.generalTitleAdds['老玩家'], ['DODGE_ULTIMATE']);
});

test('blocks pioneer as general title and suggests --map-pioneer', () => {
  const data = buildFixture();
  const req = {
    players: [{ name: '老玩家', generalTitles: ['PIONEER'], mapDominators: [] }],
    options: { grantDifficultyFromMaps: false, autoMasteryMode: 'off' }
  };
  assert.throws(() => applyGrantRequest(data, req), /Use --map-pioneer <MAP_KEY_OR_LABEL> instead/);
});

test('grants map pioneer by map key or label and deduplicates', () => {
  const data = buildFixture();
  const req = {
    players: [
      { name: '老玩家', generalTitles: [], mapDominators: [], mapPioneers: ['DATA_ROUTE66', '66号公路'] },
      { name: '板鸭', generalTitles: [], mapDominators: [], mapPioneers: ['66号公路'] }
    ],
    options: { grantDifficultyFromMaps: false, autoMasteryMode: 'off' }
  };

  const { sourceData, summary } = applyGrantRequest(data, req);
  const route66 = sourceData.mapTitles.find((item) => item.mapKey === 'DATA_ROUTE66');
  assert.deepEqual(route66.holders.PIONEER, ['老玩家', '板鸭']);
  assert.deepEqual(route66.holders.DOMINATOR, ['老玩家', '板鸭']);
  assert.deepEqual(route66.holders.CONQUEROR, ['老玩家', '板鸭']);
  assert.deepEqual(summary.mapAdds.DATA_ROUTE66.PIONEER, ['老玩家', '板鸭']);
  assert.deepEqual(summary.mapAdds.DATA_ROUTE66.DOMINATOR, ['老玩家', '板鸭']);
  assert.deepEqual(summary.mapAdds.DATA_ROUTE66.CONQUEROR, ['板鸭']);
});

test('map pioneer grant only backfills missing dominator/conqueror slots', () => {
  const data = buildFixture();
  data.mapTitles[0].holders.DOMINATOR = ['老玩家'];
  data.mapTitles[0].holders.CONQUEROR = ['老玩家'];

  const req = {
    players: [{ name: '老玩家', generalTitles: [], mapDominators: [], mapPioneers: ['DATA_ROUTE66'] }],
    options: { grantDifficultyFromMaps: false, autoMasteryMode: 'off' }
  };

  const { summary } = applyGrantRequest(data, req);
  assert.deepEqual(summary.mapAdds.DATA_ROUTE66.PIONEER, ['老玩家']);
  assert.deepEqual(summary.mapAdds.DATA_ROUTE66.DOMINATOR, []);
  assert.deepEqual(summary.mapAdds.DATA_ROUTE66.CONQUEROR, []);
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

test('reorders breath titles before non-animated titles for requested players only', () => {
  const data = buildFixture();
  data.players[0].titleKeys = ['MANBA', 'ALL_IN_ONE', 'HACKING', 'SKY', 'CHALLENGER_LEGEND'];
  data.players[1].titleKeys = ['MANBA', 'ALL_IN_ONE', 'HACKING', 'SKY'];
  data.mapTitles = data.mapTitles.map((mapItem) => ({
    ...mapItem,
    holders: {
      ...mapItem.holders,
      CONQUEROR: [...new Set([...mapItem.holders.CONQUEROR, '老玩家', '板鸭'])],
      DOMINATOR: [...new Set([...mapItem.holders.DOMINATOR, '老玩家', '板鸭'])]
    }
  }));

  const req = {
    players: [{ name: '老玩家', generalTitles: [], mapDominators: [] }],
    options: {
      grantDifficultyFromMaps: false,
      autoMasteryMode: 'off'
    }
  };

  const { sourceData } = applyGrantRequest(data, req);
  const requested = sourceData.players.find((item) => item.name === '老玩家');
  const notRequested = sourceData.players.find((item) => item.name === '板鸭');

  assert.deepEqual(requested.titleKeys, ['ALL_IN_ONE', 'SKY', 'MANBA', 'HACKING', 'CHALLENGER_LEGEND']);
  assert.deepEqual(notRequested.titleKeys, ['MANBA', 'ALL_IN_ONE', 'HACKING', 'SKY']);
});

test('exempt players keep original title order even when requested', () => {
  const data = buildFixture();
  data.players.push({ name: '他又', titleKeys: ['MANBA', 'ALL_IN_ONE', 'HACKING', 'SKY'] });

  const req = {
    players: [{ name: '他又', generalTitles: [], mapDominators: [] }],
    options: {
      grantDifficultyFromMaps: false,
      autoMasteryMode: 'off'
    }
  };

  const { sourceData } = applyGrantRequest(data, req);
  const exempt = sourceData.players.find((item) => item.name === '他又');

  assert.deepEqual(exempt.titleKeys, ['MANBA', 'ALL_IN_ONE', 'HACKING', 'SKY']);
});

test('full-scan mastery reconciliation removes stale ALL_IN_ONE and SKY globally', () => {
  const data = buildFixture();
  data.players.push({ name: '历史玩家', titleKeys: ['ALL_IN_ONE', 'SKY'] });

  const req = {
    players: [
      {
        name: '老玩家',
        generalTitles: ['HACKING'],
        mapDominators: []
      }
    ],
    options: {
      grantDifficultyFromMaps: false,
      autoMasteryMode: 'off'
    }
  };

  const { sourceData, summary } = applyGrantRequest(data, req);
  const stalePlayer = sourceData.players.find((item) => item.name === '历史玩家');

  assert.deepEqual(stalePlayer.titleKeys, []);
  assert.deepEqual(summary.masteryTitleRemovals['历史玩家'], ['ALL_IN_ONE', 'SKY']);
});

test('full-scan mastery reconciliation skips exempt players', () => {
  const data = buildFixture();
  data.players.push({ name: '他又', titleKeys: ['ALL_IN_ONE', 'SKY'] });
  data.players.push({ name: '别感冒', titleKeys: ['ALL_IN_ONE', 'SKY'] });

  const req = {
    players: [
      {
        name: '老玩家',
        generalTitles: ['HACKING'],
        mapDominators: []
      }
    ],
    options: {
      grantDifficultyFromMaps: false,
      autoMasteryMode: 'off'
    }
  };

  const { sourceData, summary } = applyGrantRequest(data, req);
  const exemptA = sourceData.players.find((item) => item.name === '他又');
  const exemptB = sourceData.players.find((item) => item.name === '别感冒');

  assert.equal(exemptA.titleKeys.includes('ALL_IN_ONE'), true);
  assert.equal(exemptA.titleKeys.includes('SKY'), true);
  assert.equal(exemptB.titleKeys.includes('ALL_IN_ONE'), true);
  assert.equal(exemptB.titleKeys.includes('SKY'), true);
  assert.equal(summary.masteryTitleRemovals['他又'], undefined);
  assert.equal(summary.masteryTitleRemovals['别感冒'], undefined);
  assert.deepEqual(summary.masteryPruneSkipped.sort(), ['他又', '别感冒'].sort());
});

test('autoMasteryMode=grant re-grants eligible mastery titles after reconciliation', () => {
  const data = buildFixture();
  data.mapTitles = data.mapTitles.map((mapItem) => ({
    ...mapItem,
    holders: {
      ...mapItem.holders,
      CONQUEROR: [...new Set([...mapItem.holders.CONQUEROR, '老玩家'])],
      DOMINATOR: [...new Set([...mapItem.holders.DOMINATOR, '老玩家'])]
    }
  }));
  data.players[0].titleKeys = ['ALL_IN_ONE', 'SKY'];

  const req = {
    players: [
      {
        name: '老玩家',
        generalTitles: [],
        mapDominators: []
      }
    ],
    options: {
      grantDifficultyFromMaps: false,
      autoMasteryMode: 'grant'
    }
  };

  const { sourceData, summary } = applyGrantRequest(data, req);
  const player = sourceData.players.find((item) => item.name === '老玩家');

  assert.equal(player.titleKeys.includes('ALL_IN_ONE'), true);
  assert.equal(player.titleKeys.includes('SKY'), true);
  assert.equal(summary.masteryTitleRemovals['老玩家'], undefined);
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

test('dry-run preview includes masteryTitleRemovals for stale holders', async () => {
  const tmpDir = await fs.mkdtemp(path.join(os.tmpdir(), 'grant-title-prune-dry-'));
  const sourceFile = path.join(tmpDir, 'title-source.json');

  const source = buildFixture();
  source.players.push({ name: '历史玩家', titleKeys: ['ALL_IN_ONE', 'SKY'] });
  source.players.push({ name: '他又', titleKeys: ['ALL_IN_ONE', 'SKY'] });
  await fs.writeFile(sourceFile, `${JSON.stringify(source, null, 2)}\n`, 'utf8');

  const before = await fs.readFile(sourceFile, 'utf8');
  const result = await grantPlayerTitle({
    sourceFile,
    requestData: {
      players: [{ name: '老玩家', generalTitles: [], mapDominators: [] }],
      options: { grantDifficultyFromMaps: false, autoMasteryMode: 'off' }
    },
    dryRun: true
  });
  const after = await fs.readFile(sourceFile, 'utf8');

  assert.equal(before, after);
  assert.deepEqual(result.preview.masteryTitleRemovals['历史玩家'], ['ALL_IN_ONE', 'SKY']);
  assert.equal(result.preview.masteryTitleRemovals['他又'], undefined);
  assert.equal(result.preview.masteryPruneSkipped.includes('他又'), true);
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

test('interactive enter-to-skip uses fixed options defaults', async () => {
  const sourceData = buildFixture();
  const readline = createScriptedReadline(['1', '1', '', '1', '']);
  const output = { isTTY: false };

  const request = await collectInteractiveRequest(sourceData, { readline, output });

  assert.deepEqual(request.options, {
    grantDifficultyFromMaps: true,
    autoMasteryMode: 'grant',
    failOnMissingPlayer: false
  });
  assert.deepEqual(request.players, [
    { name: '老玩家', generalTitles: [], mapDominators: ['DATA_ROUTE66'], mapPioneers: [] }
  ]);
});

test('interactive player mode reads general titles by TITLE index (0-based)', async () => {
  const sourceData = {
    meta: { sourceLabel: 'x' },
    titles: Array.from({ length: 21 }, (_, index) => ({
      key: `TITLE_${index}`,
      label: `称号${index}`,
      category: 'c',
      condition: 'd',
      availability: 'active',
      displayExpr: '"a"',
      colorExpr: 'null'
    })),
    players: [{ name: '老玩家', titleKeys: [] }],
    mapTitles: [
      {
        mapKey: 'DATA_ROUTE66',
        mapLabel: '66号公路',
        holders: { PIONEER: [], CONQUEROR: [], DOMINATOR: [] }
      }
    ]
  };
  sourceData.titles[14].key = 'DODGE_ULTIMATE';
  sourceData.titles[14].label = '终极闪避';
  sourceData.titles[20].key = 'DODGE_GOD';
  sourceData.titles[20].label = '闪避の神';

  const readline = createScriptedReadline(['1', '1', '14,20', '', '']);
  const output = { isTTY: false };

  const request = await collectInteractiveRequest(sourceData, { readline, output });

  assert.deepEqual(request.players, [
    { name: '老玩家', generalTitles: ['DODGE_ULTIMATE', 'DODGE_GOD'], mapDominators: [], mapPioneers: [] }
  ]);
});

test('interactive map flow keeps pioneer choice while using fixed options', async () => {
  const sourceData = buildFixture();
  const readline = createScriptedReadline(['2', '1', '1', '', '2']);
  const output = { isTTY: false };

  const request = await collectInteractiveRequest(sourceData, { readline, output });

  assert.deepEqual(request.options, {
    grantDifficultyFromMaps: true,
    autoMasteryMode: 'grant',
    failOnMissingPlayer: false
  });
  assert.deepEqual(request.players, [
    { name: '老玩家', generalTitles: [], mapDominators: [], mapPioneers: ['DATA_ROUTE66'] }
  ]);
});

test('interactive renderer rewinds and redraws the same block in tty mode', () => {
  const writes = [];
  const output = {
    isTTY: true,
    write(chunk) {
      writes.push(chunk);
    }
  };

  const renderer = createInteractiveRenderer(output, { enabled: true });
  renderer.render(['第一屏', '  1) 选项A']);
  renderer.render(['第二屏', '  1) 选项B']);

  assert.equal(
    writes.join(''),
    '第一屏\n  1) 选项A\n\u001b[3F\u001b[2K\u001b[1E\u001b[2K\u001b[1E\u001b[2K\r第二屏\n  1) 选项B\n'
  );
});

test('interactive renderer stays disabled for non-tty output', () => {
  const writes = [];
  const output = {
    isTTY: false,
    write(chunk) {
      writes.push(chunk);
    }
  };

  const renderer = createInteractiveRenderer(output);
  assert.equal(renderer.enabled, false);
  renderer.render(['不会输出']);
  renderer.clear();
  assert.deepEqual(writes, []);
});

test('createAnsi does not inject escape codes when color is disabled', () => {
  const ansi = createAnsi({ enabled: false });
  assert.equal(ansi.accent('提示'), '提示');
  assert.equal(ansi.error('错误'), '错误');
  assert.equal(ansi.contrast('预览'), '预览');
});
