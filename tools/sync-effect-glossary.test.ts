import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { loadEffectGlossarySource, syncEffectGlossaryData } from './sync-effect-glossary.ts';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const sourceFile = path.resolve(__dirname, '../data/effect-glossary-source.json');
const eventSourceFile = path.resolve(__dirname, '../data/event-source.json');
const envFile = path.resolve(__dirname, '../src/env/env.opy');
const eventConfigFile = path.resolve(__dirname, '../src/config/eventConfig.opy');
const eventConfigDevFile = path.resolve(__dirname, '../src/config/eventConfigDev.opy');
const eventConstantsFile = path.resolve(__dirname, '../src/constants/event_constants.opy');

test('loads glossary source shape', async () => {
  const source = await loadEffectGlossarySource(sourceFile);
  assert.ok(source.terms.length > 0);
  assert.ok(source.terms.find((term) => term.key === 'INVULNERABLE'));
});

test('rejects single-character aliases', async () => {
  const invalidFile = path.join(os.tmpdir(), `effect-glossary-alias-${Date.now()}.json`);
  const invalid = {
    meta: { sourceLabel: 'x', sourceVersion: 'v1', updatedAt: '2026-04-09' },
    terms: [
      {
        key: 'X',
        nameZh: '测试词条',
        aliases: ['a'],
        category: '测试',
        summary: 'x',
        definition: 'x'
      }
    ]
  };
  await fs.writeFile(invalidFile, `${JSON.stringify(invalid, null, 2)}\n`, 'utf8');
  await assert.rejects(() => loadEffectGlossarySource(invalidFile), /single-character alias/);
});

test('generates glossary payload with auto and manual relations', async () => {
  const outputFile = path.join(os.tmpdir(), `effect-glossary-${Date.now()}.json`);
  const payload = await syncEffectGlossaryData({
    sourceFile,
    eventSourceFile,
    envFile,
    eventConfigFile,
    eventConfigDevFile,
    eventConstantsFile,
    outputFile
  });

  assert.ok(payload.terms.length > 0);
  assert.ok(payload.meta.totalTermCount > 0);
  assert.ok(payload.meta.linkedEventCount > 0);

  const invulnerable = payload.terms.find((term) => term.key === 'INVULNERABLE');
  assert.ok(invulnerable);
  assert.ok(invulnerable.relatedEvents.some((eventItem) => eventItem.key === 'REGROUP_CALL'));

  const possession = payload.terms.find((term) => term.key === 'POSSESSION');
  assert.ok(possession);
  assert.ok(possession.relatedEvents.some((eventItem) => eventItem.key === 'SYMBIOSIS'));

  assert.ok(payload.eventTermsIndex.SYMBIOSIS.includes('POSSESSION'));
});
