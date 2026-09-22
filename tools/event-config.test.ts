import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const read = (file: string) => readFile(new URL(`../${file}`, import.meta.url), 'utf8');

function extractEventIds(source: string, pattern: RegExp): string[] {
  return [...source.matchAll(pattern)].map((match) => match[1]!);
}

test('random event catalogs are host-independent and aligned between main and dev', async () => {
  const [mainConfig, devConfig, candidatePool] = await Promise.all([
    read('src/config/eventConfig.opy'),
    read('src/config/eventConfigDev.opy'),
    read('src/events/allocation/buildCandidatePool.opy')
  ]);
  const configs = [mainConfig, devConfig];
  const effectIds = configs.map((source) =>
    extractEventIds(source, /eventCatalogEffectId\[[^\n]+\]\s*=\s*((?:Buff|Debuff|Mech)EventId\.[A-Z0-9_]+)/g)
  );
  const catalogIds = configs.map((source) =>
    extractEventIds(source, /eventCatalogId\.append\([^\n]*?((?:Buff|Debuff|Mech)EventId\.[A-Z0-9_]+)\)/g)
  );

  for (const [index, source] of configs.entries()) {
    assert.doesNotMatch(source, /createWorkshopSettingBool|goto\s+lbl_|^\s*lbl_[A-Za-z0-9_]+:/m);
    assert.equal(new Set(effectIds[index]).size, effectIds[index].length);
    assert.equal(new Set(catalogIds[index]).size, catalogIds[index].length);
    assert.deepEqual(new Set(catalogIds[index]), new Set(effectIds[index]));
  }

  assert.deepEqual(new Set(effectIds[0]), new Set(effectIds[1]));
  assert.match(candidatePool, /eventCatalogId/);
});
