import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const read = (file: string) => readFile(new URL(`../${file}`, import.meta.url), 'utf8');

enum EventType {
  BUFF = 0,
  DEBUFF,
  MECH
}

type EventState = {
  categoryCommitted: boolean;
  isSelected: boolean;
  eventType: EventType;
  eventId: number;
  eventCount: number[];
  eventLucky: number;
};

function commitCategory(event: EventState) {
  if (event.categoryCommitted || !event.isSelected) return;

  if (event.eventType === EventType.BUFF) {
    if (event.eventId !== 0) event.eventCount[EventType.BUFF]++;
    event.eventLucky = event.eventLucky > 0 ? event.eventLucky + 1 : 1;
  } else if (event.eventType === EventType.DEBUFF) {
    event.eventCount[EventType.DEBUFF]++;
    event.eventLucky = event.eventLucky < 0 ? event.eventLucky - 1 : -1;
  } else {
    event.eventCount[EventType.MECH]++;
  }
  event.categoryCommitted = true;
}

function event(type: EventType, eventId = 1): EventState {
  return { categoryCommitted: false, isSelected: true, eventType: type, eventId, eventCount: [0, 0, 0], eventLucky: 0 };
}

test('event category accounting commits each selected category exactly once', () => {
  const buff = event(EventType.BUFF);
  commitCategory(buff);
  commitCategory(buff);
  assert.deepEqual(buff.eventCount, [1, 0, 0]);
  assert.equal(buff.eventLucky, 1);

  const debuff = event(EventType.DEBUFF);
  commitCategory(debuff);
  commitCategory(debuff);
  assert.deepEqual(debuff.eventCount, [0, 1, 0]);
  assert.equal(debuff.eventLucky, -1);

  const mech = event(EventType.MECH);
  commitCategory(mech);
  commitCategory(mech);
  assert.deepEqual(mech.eventCount, [0, 0, 1]);
  assert.equal(mech.eventLucky, 0);
});

test('Buff value zero is committed after selection and never used as unresolved state', async () => {
  const source = await read('src/utilities/event_core/setPlayerEvent.opy');
  const constants = await read('src/constants/event_constants.opy');
  const unselectedBuff = { ...event(EventType.BUFF), isSelected: false };

  commitCategory(unselectedBuff);
  assert.deepEqual(unselectedBuff.eventCount, [0, 0, 0]);
  assert.equal(unselectedBuff.eventLucky, 0);
  assert.match(constants, /BUFF = 0/);
  assert.match(source, /eventCategoryCommitted == true or eventPlayer\.eventIsSelected == false/);
  assert.doesNotMatch(source, /eventPlayer\.eventType == null/);
});
