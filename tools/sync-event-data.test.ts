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
  assert.match(galeBlessing.descZhCompiled, /50%/);
  assert.ok(!/\{\d+\}/.test(galeBlessing.descZhCompiled));

  const konamiCode = payload.events.find((eventItem) => eventItem.key === 'KONAMI_CODE');
  assert.ok(konamiCode);
  assert.match(konamiCode.descZhCompiled, /复活/);

  const syncResult = await syncEventData({
    sourceFile,
    envFile,
    webOutputFile: tmpWebFile,
    manifestOutputFile: tmpManifest
  });

  const manifest = await fs.readFile(tmpManifest, 'utf8');
  assert.match(manifest, /EVENT_MANIFEST_TOTAL_BUFF_COUNT/);
  assert.match(manifest, /EVENT_MANIFEST_ACTIVE_MECH_COUNT/);
  const activeWeightSumMatch = manifest.match(/EVENT_MANIFEST_ACTIVE_WEIGHT_SUM ([\d.]+)/);
  assert.ok(activeWeightSumMatch);
  const expectedActiveWeightSum = Number(
    syncResult.webPayload.events
      .filter((eventItem) => eventItem.availability === 'active')
      .reduce((sum, eventItem) => sum + eventItem.weight, 0)
      .toFixed(3)
  );
  assert.equal(Number(activeWeightSumMatch[1]), expectedActiveWeightSum);
  assert.equal(syncResult.webPayload.meta.totalCount, payload.meta.totalCount);
});

test('syncs weights from event constants into source and manifest', async () => {
  const stamp = Date.now();
  const tmpSourceFile = path.join(os.tmpdir(), `event-source-weight-sync-${stamp}.json`);
  const tmpConstantsFile = path.join(os.tmpdir(), `event-constants-weight-sync-${stamp}.opy`);
  const tmpWebFile = path.join(os.tmpdir(), `events-weight-sync-${stamp}.json`);
  const tmpManifestFile = path.join(os.tmpdir(), `event-manifest-weight-sync-${stamp}.opy`);

  const source = JSON.parse(await fs.readFile(sourceFile, 'utf8'));
  const constantsSource = await fs.readFile(path.resolve(__dirname, '../src/constants/event_constants.opy'), 'utf8');
  const targetKey = 'MOON_ROCKET';
  const sourceEventIndex = source.events.findIndex((eventItem) => eventItem.key === targetKey);
  assert.ok(sourceEventIndex >= 0);
  source.events[sourceEventIndex].weight = 9.99;
  await fs.writeFile(tmpSourceFile, `${JSON.stringify(source, null, 2)}\n`, 'utf8');

  const patchedConstants = constantsSource.replace(
    /#!define EVT_DEBUFF_20_WEIGHT [0-9.]+/,
    '#!define EVT_DEBUFF_20_WEIGHT 1.33'
  );
  await fs.writeFile(tmpConstantsFile, patchedConstants, 'utf8');

  await syncEventData({
    sourceFile: tmpSourceFile,
    envFile,
    eventConstantsFile: tmpConstantsFile,
    webOutputFile: tmpWebFile,
    manifestOutputFile: tmpManifestFile
  });

  const syncedSource = JSON.parse(await fs.readFile(tmpSourceFile, 'utf8'));
  const syncedEvent = syncedSource.events.find((eventItem) => eventItem.key === targetKey);
  assert.ok(syncedEvent);
  assert.equal(syncedEvent.weight, 1.33);

  const manifest = await fs.readFile(tmpManifestFile, 'utf8');
  const activeWeightSumMatch = manifest.match(/EVENT_MANIFEST_ACTIVE_WEIGHT_SUM ([\d.]+)/);
  assert.ok(activeWeightSumMatch);
  const expectedActiveWeightSum = Number(
    syncedSource.events
      .filter((eventItem) => eventItem.availability === 'active')
      .reduce((sum, eventItem) => sum + eventItem.weight, 0)
      .toFixed(3)
  );
  assert.equal(Number(activeWeightSumMatch[1]), expectedActiveWeightSum);
});

test('fails when registered event is missing weight constant', async () => {
  const stamp = Date.now();
  const tmpConstantsFile = path.join(os.tmpdir(), `event-constants-missing-weight-${stamp}.opy`);
  const constantsSource = await fs.readFile(path.resolve(__dirname, '../src/constants/event_constants.opy'), 'utf8');
  const patchedConstants = constantsSource.replace(/^#!define EVT_DEBUFF_20_WEIGHT [0-9.]+\n/m, '');
  await fs.writeFile(tmpConstantsFile, patchedConstants, 'utf8');

  await assert.rejects(
    () =>
      syncEventData({
        sourceFile,
        envFile,
        eventConstantsFile: tmpConstantsFile,
        dryRun: true
      }),
    /missing EVT_DEBUFF_20_WEIGHT/
  );
});
