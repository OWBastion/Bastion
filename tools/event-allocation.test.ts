import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const read = (file: string) => readFile(new URL(`../${file}`, import.meta.url), 'utf8');

test('candidate-pool hard eligibility is built once before recent-event fallback', async () => {
  const [pool, setEvent] = await Promise.all([
    read('src/events/allocation/buildCandidatePool.opy'),
    read('src/utilities/event_core/setPlayerEvent.opy')
  ]);

  assert.match(pool, /if eventPlayer\.thiefBuffStolen == true:\n        eventPlayer\.eventTempIndex = eventPlayer\.eventTempIndex\.filter\(lambda candidateIndex: eventCatalogType\[candidateIndex\] != EventType\.BUFF\)/);
  assert.match(pool, /eventPlayer\.eventHardCandidateIndex = eventPlayer\.eventTempIndex/);
  assert.match(pool, /eventPlayer\.eventTempIndex = eventPlayer\.eventTempIndex\.filter\(lambda candidateIndex: candidateIndex not in eventPlayer\.eventLastId\)/);
  assert.match(pool, /if len\(eventPlayer\.eventTempIndex\) <= 0:\n        eventPlayer\.eventTempIndex = eventPlayer\.eventHardCandidateIndex/);
  assert.equal((pool.match(/eventCatalogId\.filter/g) ?? []).length, 1);
  assert.doesNotMatch(setEvent, /eventTempIndex = eventPlayer\.eventTempIndex\.filter/);
  assert.match(setEvent, /if eventPlayer\.thiefBuffStolen == true:\n        eventPlayer\.thiefBuffStolen = false/);
});

test('category offsets are derived from event ID counts', async () => {
  const [mainConfig, devConfig, constants] = await Promise.all([
    read('src/config/eventConfig.opy'),
    read('src/config/eventConfigDev.opy'),
    read('src/constants/event_constants.opy')
  ]);

  for (const config of [mainConfig, devConfig]) {
    assert.match(config, /BUFF_EVENT_ID_COUNT \+ DebuffEventId\./);
    assert.match(config, /BUFF_EVENT_ID_COUNT \+ DEBUFF_EVENT_ID_COUNT \+ MechEventId\./);
  }
  assert.doesNotMatch(constants, /EVENT_(DEBUFF|MECH)_OFFSET/);
});
