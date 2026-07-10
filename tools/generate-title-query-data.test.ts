import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import path from 'node:path';
import os from 'node:os';
import { fileURLToPath } from 'node:url';

import { generateTitleQueryData, loadTitleSource, syncTitleData } from './sync-title-data.ts';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const sourceFile = path.resolve(__dirname, '../data/title-source.json');
const titleFile = path.resolve(__dirname, '../src/title/title-cn.opy');
const envFile = path.resolve(__dirname, '../src/env/env.opy');

test('loads unified title source shape', async () => {
  const data = await loadTitleSource(sourceFile);

  assert.ok(data.titles.length > 0);
  assert.ok(data.players.length > 0);
  assert.ok(data.mapTitles.length > 0);
  assert.equal(data.titles[0].key, 'PIONEER');
  assert.equal(data.players.find((player) => player.name === '他又')?.allTitles, true);
  assert.equal(data.players.find((player) => player.name === '别感冒')?.titleKeys.length, data.titles.length);
  assert.equal(data.players.find((player) => player.name === '草艮')?.titleKeys.length, 2);
});

test('validates duplicate title keys', async () => {
  const tmpFile = path.join(os.tmpdir(), `title-source-invalid-${Date.now()}.json`);
  const invalid = {
    meta: { sourceLabel: 'x' },
    titles: [
      {
        key: 'A',
        label: 'A',
        category: 'c',
        condition: 'd',
        availability: 'active',
        displayExpr: '"A"',
        colorExpr: 'null'
      },
      {
        key: 'A',
        label: 'B',
        category: 'c',
        condition: 'd',
        availability: 'active',
        displayExpr: '"B"',
        colorExpr: 'null'
      }
    ],
    players: [{ name: 'u', titleKeys: [] }],
    mapTitles: []
  };
  await fs.writeFile(tmpFile, JSON.stringify(invalid), 'utf8');

  await assert.rejects(() => loadTitleSource(tmpFile), /Duplicate title key detected/);
});

test('validates unknown player title keys', async () => {
  const tmpFile = path.join(os.tmpdir(), `title-source-unknown-${Date.now()}.json`);
  const invalid = {
    meta: { sourceLabel: 'x' },
    titles: [
      {
        key: 'A',
        label: 'A',
        category: 'c',
        condition: 'd',
        availability: 'active',
        displayExpr: '"A"',
        colorExpr: 'null'
      }
    ],
    players: [{ name: 'u', titleKeys: ['UNKNOWN'] }],
    mapTitles: []
  };
  await fs.writeFile(tmpFile, JSON.stringify(invalid), 'utf8');

  await assert.rejects(() => loadTitleSource(tmpFile), /Unknown title key UNKNOWN in player u/);
});

test('rejects ambiguous all-title player records', async () => {
  const tmpFile = path.join(os.tmpdir(), `title-source-all-titles-${Date.now()}.json`);
  const invalid = {
    meta: { sourceLabel: 'x' },
    titles: [
      {
        key: 'A',
        label: 'A',
        category: 'c',
        condition: 'd',
        availability: 'active',
        displayExpr: '"A"',
        colorExpr: 'null'
      }
    ],
    players: [{ name: 'u', allTitles: true, titleKeys: ['A'] }],
    mapTitles: []
  };
  await fs.writeFile(tmpFile, JSON.stringify(invalid), 'utf8');

  await assert.rejects(() => loadTitleSource(tmpFile), /cannot define both allTitles and titleKeys/);
});

test('validates duplicate player names', async () => {
  const tmpFile = path.join(os.tmpdir(), `title-source-player-dup-${Date.now()}.json`);
  const invalid = {
    meta: { sourceLabel: 'x' },
    titles: [
      {
        key: 'A',
        label: 'A',
        category: 'c',
        condition: 'd',
        availability: 'active',
        displayExpr: '"A"',
        colorExpr: 'null'
      }
    ],
    players: [
      { name: 'u', titleKeys: ['A'] },
      { name: 'u', titleKeys: [] }
    ],
    mapTitles: []
  };
  await fs.writeFile(tmpFile, JSON.stringify(invalid), 'utf8');

  await assert.rejects(() => loadTitleSource(tmpFile), /Duplicate player name detected: u/);
});

test('validates title availability enum values', async () => {
  const tmpFile = path.join(os.tmpdir(), `title-source-availability-${Date.now()}.json`);
  const invalid = {
    meta: { sourceLabel: 'x' },
    titles: [
      {
        key: 'A',
        label: 'A',
        category: 'c',
        condition: 'd',
        availability: 'paused',
        displayExpr: '"A"',
        colorExpr: 'null'
      }
    ],
    players: [{ name: 'u', titleKeys: ['A'] }],
    mapTitles: []
  };
  await fs.writeFile(tmpFile, JSON.stringify(invalid), 'utf8');

  await assert.rejects(() => loadTitleSource(tmpFile), /availability must be one of: active, retired/);
});

test('validates duplicate title keys inside a player', async () => {
  const tmpFile = path.join(os.tmpdir(), `title-source-player-title-dup-${Date.now()}.json`);
  const invalid = {
    meta: { sourceLabel: 'x' },
    titles: [
      {
        key: 'A',
        label: 'A',
        category: 'c',
        condition: 'd',
        availability: 'active',
        displayExpr: '"A"',
        colorExpr: 'null'
      }
    ],
    players: [{ name: 'u', titleKeys: ['A', 'A'] }],
    mapTitles: []
  };
  await fs.writeFile(tmpFile, JSON.stringify(invalid), 'utf8');

  await assert.rejects(() => loadTitleSource(tmpFile), /Duplicate title key in player u: A/);
});

test('validates duplicate map keys and unknown map holders', async () => {
  const tmpFile = path.join(os.tmpdir(), `title-source-map-invalid-${Date.now()}.json`);
  const invalid = {
    meta: { sourceLabel: 'x' },
    titles: [
      {
        key: 'A',
        label: 'A',
        category: 'c',
        condition: 'd',
        availability: 'active',
        displayExpr: '"A"',
        colorExpr: 'null'
      }
    ],
    players: [{ name: 'u', titleKeys: ['A'] }],
    mapTitles: [
      {
        mapKey: 'DATA_X',
        mapLabel: 'X',
        holders: { PIONEER: ['u'], CONQUEROR: ['u'], DOMINATOR: ['u'] }
      },
      {
        mapKey: 'DATA_X',
        mapLabel: 'Y',
        holders: { PIONEER: ['ghost'], CONQUEROR: [], DOMINATOR: [] }
      }
    ]
  };
  await fs.writeFile(tmpFile, JSON.stringify(invalid), 'utf8');

  await assert.rejects(() => loadTitleSource(tmpFile), /Duplicate map key detected: DATA_X/);
});

test('validates DOMINATOR subset of CONQUEROR', async () => {
  const tmpFile = path.join(os.tmpdir(), `title-source-map-subset-${Date.now()}.json`);
  const invalid = {
    meta: { sourceLabel: 'x' },
    titles: [
      {
        key: 'A',
        label: 'A',
        category: 'c',
        condition: 'd',
        availability: 'active',
        displayExpr: '"A"',
        colorExpr: 'null'
      }
    ],
    players: [{ name: 'u', titleKeys: ['A'] }],
    mapTitles: [
      {
        mapKey: 'DATA_X',
        mapLabel: 'X',
        holders: { PIONEER: [], CONQUEROR: [], DOMINATOR: ['u'] }
      }
    ]
  };
  await fs.writeFile(tmpFile, JSON.stringify(invalid), 'utf8');

  await assert.rejects(() => loadTitleSource(tmpFile), /must also be in CONQUEROR/);
});

test('generates web payload with source version metadata', async () => {
  const outputFile = path.join(os.tmpdir(), `titles-meta-${Date.now()}.json`);
  const [data, envSource] = await Promise.all([
    generateTitleQueryData({ sourceFile, envFile, outputFile }),
    fs.readFile(envFile, 'utf8')
  ]);

  const versionMatch = envSource.match(/^#!define\s+VERSION\s+"([^"]+)"/m);

  assert.ok(versionMatch);
  assert.equal(data.meta.sourceLabel, '躲避堡垒3');
  assert.equal(data.meta.sourceVersion, versionMatch[1]);
});

test('sync can run in dry-run mode with existing files', async () => {
  const result = await syncTitleData({ sourceFile, titleFile, envFile, dryRun: true });

  assert.equal(result.webPayload.titles.length, result.sourceData.titles.length);
  assert.equal(result.webPayload.players.length, result.sourceData.players.length);
  assert.equal(result.webPayload.mapTitles.length, result.sourceData.mapTitles.length);
  assert.equal(typeof result.playerNameToIndexFileChanged, 'boolean');
  assert.equal(typeof result.playerNameToIndexDelimitedFileChanged, 'boolean');
});

test('sync generates map DATA macros from mapTitles', async () => {
  const tmpTitleFile = path.join(os.tmpdir(), `title-sync-${Date.now()}.opy`);
  const tmpWebFile = path.join(os.tmpdir(), `titles-sync-${Date.now()}.json`);
  const tmpPlayerNameToIndexFile = path.join(os.tmpdir(), `playerNameToIndex-${Date.now()}.js`);
  const tmpPlayerNameToIndexDelimitedFile = path.join(os.tmpdir(), `playerNameToIndexDelimited-${Date.now()}.js`);
  await fs.copyFile(titleFile, tmpTitleFile);
  await fs.copyFile(path.resolve(__dirname, '../src/tools/playerNameToIndex.js'), tmpPlayerNameToIndexFile);
  await fs.copyFile(path.resolve(__dirname, '../src/tools/playerNameToIndexDelimited.js'), tmpPlayerNameToIndexDelimitedFile);

  await syncTitleData({
    sourceFile,
    titleFile: tmpTitleFile,
    envFile,
    webOutputFile: tmpWebFile,
    playerNameToIndexFile: tmpPlayerNameToIndexFile,
    playerNameToIndexDelimitedFile: tmpPlayerNameToIndexDelimitedFile
  });

  const generatedTitle = await fs.readFile(tmpTitleFile, 'utf8');
  const generatedWeb = JSON.parse(await fs.readFile(tmpWebFile, 'utf8'));
  const generatedPlayerNameToIndex = await fs.readFile(tmpPlayerNameToIndexFile, 'utf8');
  const generatedPlayerNameToIndexDelimited = await fs.readFile(tmpPlayerNameToIndexDelimitedFile, 'utf8');

  assert.match(generatedTitle, /# BEGIN AUTO-GENERATED MAP_TITLE_DATA/);
  assert.match(generatedTitle, /# BEGIN AUTO-GENERATED PLAYER_TITLE_SET_POOL/);
  assert.match(generatedTitle, /titleSetIndex:/);
  assert.match(generatedTitle, /#!define DATA_BLIZZARD_WORLD/);
  assert.match(generatedTitle, /playerNameToIndexDelimited\(\["他又"/);
  assert.match(generatedPlayerNameToIndex, /"一杯美式"/);
  assert.match(generatedPlayerNameToIndexDelimited, /"云雀"/);
  assert.ok(generatedWeb.players[0].mapTitleStatus);
  assert.ok(generatedWeb.mapTitles.find((item) => item.mapKey === 'DATA_BLIZZARD_WORLD'));
});

test('sync keeps late-added map title holders in generated player index scripts', async () => {
  const fixture = {
    meta: { sourceLabel: 'x' },
    titles: [
      {
        key: 'PIONEER',
        label: '开拓者',
        category: 'c',
        condition: 'd',
        availability: 'active',
        displayExpr: '"开拓者"',
        colorExpr: 'null'
      }
    ],
    players: Array.from({ length: 41 }, (_, index) => ({
      name: `玩家${index}`,
      titleKeys: []
    })),
    mapTitles: [
      {
        mapKey: 'DATA_TEST_MAP',
        mapLabel: '测试地图',
        holders: {
          PIONEER: ['玩家40'],
          CONQUEROR: ['玩家40'],
          DOMINATOR: []
        }
      }
    ]
  };
  const tmpSourceFile = path.join(os.tmpdir(), `title-source-late-holder-${Date.now()}.json`);
  const tmpTitleFile = path.join(os.tmpdir(), `title-sync-late-holder-${Date.now()}.opy`);
  const tmpWebFile = path.join(os.tmpdir(), `title-sync-late-holder-${Date.now()}.json`);
  const tmpPlayerNameToIndexFile = path.join(os.tmpdir(), `playerNameToIndex-late-holder-${Date.now()}.js`);
  const tmpPlayerNameToIndexDelimitedFile = path.join(os.tmpdir(), `playerNameToIndexDelimited-late-holder-${Date.now()}.js`);
  await fs.writeFile(tmpSourceFile, `${JSON.stringify(fixture, null, 2)}\n`, 'utf8');
  await fs.copyFile(titleFile, tmpTitleFile);
  await fs.copyFile(path.resolve(__dirname, '../src/tools/playerNameToIndex.js'), tmpPlayerNameToIndexFile);
  await fs.copyFile(path.resolve(__dirname, '../src/tools/playerNameToIndexDelimited.js'), tmpPlayerNameToIndexDelimitedFile);

  await syncTitleData({
    sourceFile: tmpSourceFile,
    titleFile: tmpTitleFile,
    envFile,
    webOutputFile: tmpWebFile,
    playerNameToIndexFile: tmpPlayerNameToIndexFile,
    playerNameToIndexDelimitedFile: tmpPlayerNameToIndexDelimitedFile
  });

  const generatedTitle = await fs.readFile(tmpTitleFile, 'utf8');
  const generatedPlayerNameToIndex = await fs.readFile(tmpPlayerNameToIndexFile, 'utf8');

  assert.match(generatedTitle, /playerNameToIndexDelimited\(\["玩家40"\], "-"\)/);
  assert.match(generatedPlayerNameToIndex, /"玩家40"/);
});

test('sync pools sorted player title sets transparently', async () => {
  const fixture = {
    meta: { sourceLabel: 'x' },
    titles: [
      {
        key: 'A',
        label: 'A',
        category: 'c',
        condition: 'd',
        availability: 'active',
        displayExpr: '"A"',
        colorExpr: 'null'
      },
      {
        key: 'B',
        label: 'B',
        category: 'c',
        condition: 'd',
        availability: 'active',
        displayExpr: '"B"',
        colorExpr: 'null'
      },
      {
        key: 'C',
        label: 'C',
        category: 'c',
        condition: 'd',
        availability: 'active',
        displayExpr: '"C"',
        colorExpr: 'null'
      }
    ],
    players: [
      { name: 'p1', titleKeys: ['C', 'A'] },
      { name: 'p2', titleKeys: ['A', 'C'] },
      { name: 'p3', titleKeys: ['B'] }
    ],
    mapTitles: []
  };
  const tmpSourceFile = path.join(os.tmpdir(), `title-source-pool-${Date.now()}.json`);
  const tmpTitleFile = path.join(os.tmpdir(), `title-sync-pool-${Date.now()}.opy`);
  const tmpWebFile = path.join(os.tmpdir(), `title-sync-pool-${Date.now()}.json`);
  const tmpPlayerNameToIndexFile = path.join(os.tmpdir(), `playerNameToIndex-pool-${Date.now()}.js`);
  const tmpPlayerNameToIndexDelimitedFile = path.join(os.tmpdir(), `playerNameToIndexDelimited-pool-${Date.now()}.js`);
  await fs.writeFile(tmpSourceFile, `${JSON.stringify(fixture, null, 2)}\n`, 'utf8');
  await fs.copyFile(titleFile, tmpTitleFile);
  await fs.copyFile(path.resolve(__dirname, '../src/tools/playerNameToIndex.js'), tmpPlayerNameToIndexFile);
  await fs.copyFile(path.resolve(__dirname, '../src/tools/playerNameToIndexDelimited.js'), tmpPlayerNameToIndexDelimitedFile);

  await syncTitleData({
    sourceFile: tmpSourceFile,
    titleFile: tmpTitleFile,
    envFile,
    webOutputFile: tmpWebFile,
    playerNameToIndexFile: tmpPlayerNameToIndexFile,
    playerNameToIndexDelimitedFile: tmpPlayerNameToIndexDelimitedFile
  });

  const generatedTitle = await fs.readFile(tmpTitleFile, 'utf8');
  const generatedWeb = JSON.parse(await fs.readFile(tmpWebFile, 'utf8'));

  assert.match(generatedTitle, /#!define player_title_set_pool \[/);
  assert.match(generatedTitle, /\[TITLE\.A, TITLE\.C\]/);
  assert.match(generatedTitle, /name: "p1", \\\n        titleSetIndex: 0/);
  assert.match(generatedTitle, /name: "p2", \\\n        titleSetIndex: 0/);
  assert.match(generatedTitle, /name: "p3", \\\n        titleSetIndex: 1/);

  const player1 = generatedWeb.players.find((player) => player.name === 'p1');
  const player2 = generatedWeb.players.find((player) => player.name === 'p2');
  assert.deepEqual(player1.titleIds, [0, 2]);
  assert.deepEqual(player2.titleIds, [0, 2]);
});
