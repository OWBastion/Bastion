import assert from 'node:assert/strict';
import { readdir, readFile } from 'node:fs/promises';
import test from 'node:test';

const read = (file: string) => readFile(new URL(`../${file}`, import.meta.url), 'utf8');

async function opyFiles(dir: string): Promise<string[]> {
  const out: string[] = [];
  for (const entry of await readdir(new URL(`../${dir}`, import.meta.url), { withFileTypes: true })) {
    if (entry.isDirectory()) {
      out.push(...await opyFiles(`${dir}/${entry.name}`));
    } else if (entry.name.endsWith('.opy')) {
      out.push(`${dir}/${entry.name}`);
    }
  }
  return out;
}

// The unified catalog layout keeps each EventType in one contiguous id section.
// drawForcedEvent derives its scalar ranges from the first member of each section;
// pinning the section boundaries keeps that derivation honest when the enum changes.
test('event id enum keeps Buff -> Debuff -> Mech contiguous sections with stable boundary members', async () => {
  const ids = await read('src/events/event_ids.opy');
  const members = [...ids.matchAll(/^\s{4}([A-Z0-9_]+)(?:\s*=\s*\d+)?\s*$/gm)].map((m) => m[1]);
  const buffStart = members.indexOf('OLIVIA_GIFT');
  const debuffStart = members.indexOf('GRAVITY_ANOMALY');
  const mechStart = members.indexOf('EXTREME_CHALLENGE');
  const count = members.indexOf('COUNT');
  assert.ok(buffStart === 0, 'OLIVIA_GIFT must be the first catalog slot (Buff range starts at 0)');
  assert.ok(buffStart < debuffStart && debuffStart < mechStart && mechStart < count,
    'enum sections must stay ordered Buff < Debuff < Mech < COUNT');
  const debuffHeader = ids.indexOf('# ---- Debuff ----');
  const mechHeader = ids.indexOf('# ---- Mech ----');
  assert.ok(debuffHeader > 0 && mechHeader > debuffHeader, 'enum must keep explicit section headers');
});

test('forced-type contract uses explicit EventType writes, never the legacy roll threshold', async () => {
  const files = await opyFiles('src');
  for (const file of files) {
    const source = await read(file);
    assert.ok(!/eventForceRoll/.test(source), `${file} still references eventForceRoll`);
    assert.ok(!/FORCE_ROLL/.test(source), `${file} still references a FORCE_ROLL constant`);
  }
  const writers = await Promise.all([
    read('src/events/effects/mech/cheat_card_counting.opy'),
    read('src/events/effects/mech/cheat_backroom_deal.opy'),
    read('src/events/effects/mech/thief.opy'),
    read('src/events/effects/mech/gambler_short_investment.opy'),
    read('src/events/effects/mech/gambler_long_investment.opy')
  ]);
  assert.match(writers[0], /eventForceType = EventType\.BUFF/, 'card counting must force Buff');
  assert.match(writers[1], /eventForceType = EventType\.MECH/, 'backroom deal must force Mech');
  assert.match(writers[2], /eventForceType = EventType\.BUFF/, 'thief self-force must force Buff');
  assert.match(writers[3], /eventForceType = EventType\.DEBUFF/, 'short investment must force Debuff');
  assert.match(writers[4], /eventForceType = EventType\.DEBUFF/, 'long investment must force Debuff');
  assert.match(writers[3], /eventForceCount = EVT_MECH_8_FORCE_COUNT/, 'short investment must keep its forced count');
  assert.match(writers[4], /eventForceCount = EVT_MECH_12_FORCE_COUNT/, 'long investment must keep its forced count');
});

test('forced draw is authoritative before the pool path and never leaves the forced type range', async () => {
  const [setEvent, forced, pool] = await Promise.all([
    read('src/events/lifecycle/setPlayerEvent.opy'),
    read('src/events/allocation/drawForcedEvent.opy'),
    read('src/events/allocation/buildCandidatePool.opy')
  ]);

  const forcedGate = setEvent.indexOf('if eventPlayer.eventForceType != -1:');
  const poolCall = setEvent.indexOf('buildCandidatePool()');
  assert.ok(forcedGate > -1 && forcedGate < poolCall, 'setPlayerEvent must try drawForcedEvent before building the pool');
  assert.ok(setEvent.indexOf('drawForcedEvent()') > forcedGate, 'the forced draw must run inside the contract gate');
  assert.match(setEvent, /eventCandidateIndex == -1:\s*\n\s*buildCandidatePool\(\)/,
    'the pool path must stay a fallback for a forced range with no eligible candidate');

  // thiefBuffStolen may only be consumed where its non-Buff filter actually applied
  const thiefConsume = setEvent.indexOf('eventPlayer.thiefBuffStolen = false');
  const reject = setEvent.indexOf('rejecSampling()');
  assert.ok(thiefConsume > reject && thiefConsume > -1, 'thief steal must be consumed only inside the pool path');

  // every forced draw is constrained to the forced type's contiguous id range
  assert.match(forced, /randint\(EventId\.GRAVITY_ANOMALY, EventId\.EXTREME_CHALLENGE - 1\)/);
  assert.match(forced, /randint\(EventId\.EXTREME_CHALLENGE, EventId\.COUNT - 1\)/);
  assert.match(forced, /randint\(0, EventId\.GRAVITY_ANOMALY - 1\)/);
  assert.match(forced, /eventCatalogType\[eventPlayer\.eventForceIndex\] == eventPlayer\.eventForceType/,
    'forced draws must re-validate the sampled type before accepting');
  assert.match(forced, /eventHardEligible\(eventPlayer\.eventForceIndex\)/,
    'forced draws must pass the shared hard-eligibility predicate');
  assert.doesNotMatch(forced, /filter\(lambda/, 'forced selection must not build a type-filtered pool array');

  // the normal pool must not reintroduce category-first selection by contract type
  assert.doesNotMatch(pool, /eventCatalogType\[candidateIndex\] == eventPlayer\.eventForceType/,
    'buildCandidatePool must not filter the unified pool down to the forced type');
  assert.match(setEvent, /eventType == eventPlayer\.eventForceType/,
    'forced counts may only be consumed when the allocated type matches the contract');
});
