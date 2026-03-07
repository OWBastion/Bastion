import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import path from 'node:path';
import os from 'node:os';
import { fileURLToPath } from 'node:url';

import { generateTitleQueryData, loadTitleSource, syncTitleData } from './sync-title-data.mjs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const sourceFile = path.resolve(__dirname, '../data/title-source.json');
const titleFile = path.resolve(__dirname, '../src/title/title-cn.opy');
const envFile = path.resolve(__dirname, '../src/env/env.opy');

test('loads unified title source shape', async () => {
  const data = await loadTitleSource(sourceFile);

  assert.equal(data.titles.length, 49);
  assert.equal(data.players.length, 41);
  assert.equal(data.titles[0].key, 'PIONEER');
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
    players: [{ name: 'u', titleKeys: [] }]
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
    players: [{ name: 'u', titleKeys: ['UNKNOWN'] }]
  };
  await fs.writeFile(tmpFile, JSON.stringify(invalid), 'utf8');

  await assert.rejects(() => loadTitleSource(tmpFile), /Unknown title key UNKNOWN in player u/);
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
    ]
  };
  await fs.writeFile(tmpFile, JSON.stringify(invalid), 'utf8');

  await assert.rejects(() => loadTitleSource(tmpFile), /Duplicate player name detected: u/);
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
    players: [{ name: 'u', titleKeys: ['A', 'A'] }]
  };
  await fs.writeFile(tmpFile, JSON.stringify(invalid), 'utf8');

  await assert.rejects(() => loadTitleSource(tmpFile), /Duplicate title key A in player u/);
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

  assert.equal(result.sourceData.titles.length, 49);
  assert.equal(result.webPayload.players.length, 41);
});
