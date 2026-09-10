import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const read = (file: string) => readFile(new URL(`../${file}`, import.meta.url), 'utf8');

test('Thief constrains the victim candidate pool before sampling', async () => {
  const [pool, setEvent] = await Promise.all([
    read('src/events/allocation/buildCandidatePool.opy'),
    read('src/utilities/event_core/setPlayerEvent.opy')
  ]);

  assert.equal((pool.match(/eventPlayer\.thiefBuffStolen != true or eventCatalogType\[candidateIndex\] != EventType\.BUFF/g) ?? []).length, 2);
  assert.equal((pool.match(/eventPlayer\.thiefBuffStolen == true or eventPlayer\.eventForceRoll == null/g) ?? []).length, 2);
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
