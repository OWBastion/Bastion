import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import path from 'node:path';
import os from 'node:os';
import { fileURLToPath } from 'node:url';

import { generateEventQueryData, loadEventSource, syncEventData } from './sync-event-data.ts';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const sourceFile = path.resolve(__dirname, '../data/event-source.json');
const envFile = path.resolve(__dirname, '../src/env/env.opy');

test('loads unified event source shape', async () => {
  const data = await loadEventSource(sourceFile);

  assert.ok(data.events.length > 0);
  assert.ok(data.packs.length > 0);
  assert.equal(data.events[0].key, 'OLIVIA_GIFT');
  assert.equal(data.events.find((eventItem) => eventItem.key === 'TRINITY_SSR')?.type, 'mech');
});

test('validates duplicate event key', async () => {
  const tmpFile = path.join(os.tmpdir(), `event-source-key-dup-${Date.now()}.json`);
  const invalid = {
    meta: { sourceLabel: 'x', sourceVersion: 'v1' },
    packs: [{ id: 1, key: 'p1', labelZh: '随机事件包 1' }],
    events: [
      {
        key: 'A',
        type: 'buff',
        id: 0,
        pack: 1,
        nameZh: 'a',
        descZh: 'a',
        durationSec: 1,
        weight: 1,
        availability: 'active'
      },
      {
        key: 'A',
        type: 'debuff',
        id: 0,
        pack: 1,
        nameZh: 'b',
        descZh: 'b',
        durationSec: 1,
        weight: 1,
        availability: 'active'
      }
    ]
  };
  await fs.writeFile(tmpFile, `${JSON.stringify(invalid, null, 2)}\n`, 'utf8');

  await assert.rejects(() => loadEventSource(tmpFile), /Duplicate event key detected: A/);
});

test('validates duplicate type+id and unknown pack', async () => {
  const tmpFile = path.join(os.tmpdir(), `event-source-id-pack-${Date.now()}.json`);
  const invalid = {
    meta: { sourceLabel: 'x', sourceVersion: 'v1' },
    packs: [{ id: 1, key: 'p1', labelZh: '随机事件包 1' }],
    events: [
      {
        key: 'A',
        type: 'buff',
        id: 0,
        pack: 1,
        nameZh: 'a',
        descZh: 'a',
        durationSec: 1,
        weight: 1,
        availability: 'active'
      },
      {
        key: 'B',
        type: 'buff',
        id: 0,
        pack: 99,
        nameZh: 'b',
        descZh: 'b',
        durationSec: 1,
        weight: 1,
        availability: 'active'
      }
    ]
  };
  await fs.writeFile(tmpFile, `${JSON.stringify(invalid, null, 2)}\n`, 'utf8');

  await assert.rejects(() => loadEventSource(tmpFile), /unknown pack id 99/);
});

test('validates enum parity and missing config registration', async () => {
  const data = JSON.parse(await fs.readFile(sourceFile, 'utf8'));
  const eventIndex = data.events.findIndex((eventItem) => eventItem.key === 'GALE_BLESSING');
  data.events[eventIndex] = {
    ...data.events[eventIndex],
    availability: 'retired'
  };

  const tmpSource = path.join(os.tmpdir(), `event-source-retired-mismatch-${Date.now()}.json`);
  await fs.writeFile(tmpSource, `${JSON.stringify(data, null, 2)}\n`, 'utf8');

  await assert.rejects(() => syncEventData({ sourceFile: tmpSource, dryRun: true }), /registered in config but missing or inactive/);
});

test('generates event web payload and manifest', async () => {
  const tmpWebFile = path.join(os.tmpdir(), `events-${Date.now()}.json`);
  const tmpManifest = path.join(os.tmpdir(), `event-manifest-${Date.now()}.opy`);

  const payload = await generateEventQueryData({
    sourceFile,
    envFile,
    outputFile: tmpWebFile
  });

  assert.ok(payload.events.length > 0);
  assert.ok(payload.packs.length > 0);
  assert.equal(payload.meta.sourceFile, 'data/event-source.json');
  const galeBlessing = payload.events.find((eventItem) => eventItem.key === 'GALE_BLESSING');
  assert.ok(galeBlessing);
  assert.equal(galeBlessing.descZhCompiled, '移动速度提高50%');
  assert.ok(!/\{\d+\}/.test(galeBlessing.descZhCompiled));

  const symbiosis = payload.events.find((eventItem) => eventItem.key === 'SYMBIOSIS');
  assert.ok(symbiosis);
  assert.match(symbiosis.descZhCompiled, /互动键/);

  const syncResult = await syncEventData({
    sourceFile,
    envFile,
    webOutputFile: tmpWebFile,
    manifestOutputFile: tmpManifest
  });

  const manifest = await fs.readFile(tmpManifest, 'utf8');
  assert.match(manifest, /EVENT_MANIFEST_TOTAL_BUFF_COUNT/);
  assert.match(manifest, /EVENT_MANIFEST_ACTIVE_MECH_COUNT/);
  assert.equal(syncResult.webPayload.meta.totalCount, payload.meta.totalCount);
});
