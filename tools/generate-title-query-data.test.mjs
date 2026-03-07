import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import path from 'node:path';
import os from 'node:os';
import { fileURLToPath } from 'node:url';

import { generateTitleQueryData, parseTitleSource } from './generate-title-query-data.mjs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const sourceFile = path.resolve(__dirname, '../src/title/title-cn.opy');
const envFile = path.resolve(__dirname, '../src/env/env.opy');

async function loadData() {
  const source = await fs.readFile(sourceFile, 'utf8');
  return parseTitleSource(source);
}

test('parses current title dataset shape', async () => {
  const data = await loadData();

  assert.equal(data.meta.titleCount, 49);
  assert.equal(data.meta.playerCount, 41);
});

test('includes source label and main version metadata', async () => {
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

test('extracts labels from allTitle with dynamic fallback handling', async () => {
  const data = await loadData();

  assert.deepEqual(
    data.titles.slice(0, 3),
    [
      {
        id: 0,
        key: 'PIONEER',
        label: '开拓者',
        category: '社区贡献系列',
        condition: '在新地图内测/公测中完成对应地图地狱通关（群内审核发放）。'
      },
      {
        id: 1,
        key: 'TEST_LONG',
        label: '这是一个超长的称号测试字段如果到这里还没有被截断说明确实很长你说得对但是广告位招租啊哈大OW是我的家乡',
        category: '开发保留',
        condition: '测试占位称号，不对外发放。'
      },
      {
        id: 2,
        key: 'NOT_MY_MAP',
        label: '地图不是我做的',
        category: '开发保留',
        condition: '开发/管理用途，文档未提供公开挑战条件。'
      }
    ]
  );
});

test('maps representative players to the expected title ids', async () => {
  const data = await loadData();
  const byName = new Map(data.players.map((player) => [player.name, player]));

  assert.deepEqual(byName.get('草艮'), {
    name: '草艮',
    titleIds: [12, 13],
    titleCount: 2
  });

  assert.deepEqual(byName.get('卖核弹的小女孩'), {
    name: '卖核弹的小女孩',
    titleIds: [19, 16, 12, 13, 22, 27, 28, 29, 33, 37, 43, 36, 44, 45, 47, 14],
    titleCount: 16
  });
});
