import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const read = (file: string) => readFile(new URL(`../${file}`, import.meta.url), 'utf8');

type Candidate = {
  id: string;
  type: 'BUFF' | 'DEBUFF' | 'MECH';
  weight?: number;
};

type CandidatePoolState = {
  thiefBuffStolen?: boolean;
  eventForceRoll?: number | null;
  supportsPhaseTrigger?: boolean;
  temperHeartCompleted?: boolean;
  heartsteelStacks?: number;
  gamblerHeartsteelJackpot?: number;
  hasNegativePermanentStat?: boolean;
  recentIds?: string[];
};

function buildCandidatePool(catalog: Candidate[], state: CandidatePoolState) {
  let hard = catalog.filter((candidate) => (candidate.weight ?? 1) > 0);
  const forceRoll = state.eventForceRoll ?? null;

  if (state.thiefBuffStolen) {
    hard = hard.filter((candidate) => candidate.type !== 'BUFF');
  } else if (forceRoll != null) {
    const type = forceRoll < 42.5 ? 'BUFF' : forceRoll < 80 ? 'DEBUFF' : 'MECH';
    hard = hard.filter((candidate) => candidate.type === type);
  }

  const excluded = new Set<string>();
  if (!state.supportsPhaseTrigger) {
    excluded.add('PHASE_SURGE');
    excluded.add('BODYGUARD');
  }
  if (state.temperHeartCompleted) {
    excluded.add('TEMPER_HEART');
  }
  if (forceRoll === 50) {
    excluded.add('SELFLESS_GIVEAWAY');
  }
  if ((state.heartsteelStacks ?? 0) <= 0) {
    excluded.add('GAMBLER_SPEED_CHALLENGE');
    excluded.add('GAMBLER_HEART_OF_STEEL');
    excluded.add('GAMBLER_ALL_IN_ART_5');
  }
  if ((state.gamblerHeartsteelJackpot ?? 0) < 8 || (state.heartsteelStacks ?? 0) < 4) {
    excluded.add('GAMBLER_WINNER_TAKE_ALL');
  }
  if (!state.hasNegativePermanentStat) {
    excluded.add('MIRROR_INVERSION');
  }
  hard = hard.filter((candidate) => !excluded.has(candidate.id));

  const strict = hard.filter((candidate) => !state.recentIds?.includes(candidate.id));
  return strict.length > 0 ? strict : hard;
}

test('Thief excludes buffs and dedup fallback restores only hard-eligible candidates', () => {
  const candidates = buildCandidatePool(
    [
      { id: 'BUFF', type: 'BUFF' },
      { id: 'DEBUFF', type: 'DEBUFF' },
      { id: 'MECH', type: 'MECH' },
      { id: 'GAMBLER_SPEED_CHALLENGE', type: 'MECH' }
    ],
    {
      thiefBuffStolen: true,
      heartsteelStacks: 0,
      recentIds: ['DEBUFF', 'MECH']
    }
  );

  assert.deepEqual(candidates.map((candidate) => candidate.id), ['DEBUFF', 'MECH']);
});

test('forced categories and event-specific eligibility preserve valid candidates', () => {
  const catalog = [
    { id: 'TEMPER_HEART', type: 'BUFF' as const },
    { id: 'SELFLESS_GIVEAWAY', type: 'DEBUFF' as const },
    { id: 'DEBUFF', type: 'DEBUFF' as const }
  ];

  assert.deepEqual(
    buildCandidatePool(catalog, { eventForceRoll: 50 }).map((candidate) => candidate.id),
    ['DEBUFF']
  );
  assert.deepEqual(
    buildCandidatePool(catalog, { eventForceRoll: 0, temperHeartCompleted: false }).map((candidate) => candidate.id),
    ['TEMPER_HEART']
  );
  assert.deepEqual(
    buildCandidatePool(catalog, { eventForceRoll: 0, temperHeartCompleted: true }).map((candidate) => candidate.id),
    []
  );
});

test('hard eligibility excludes only candidates whose prerequisites are unmet', () => {
  const candidates = buildCandidatePool(
    [
      { id: 'PHASE_SURGE', type: 'BUFF' },
      { id: 'BODYGUARD', type: 'BUFF' },
      { id: 'TEMPER_HEART', type: 'BUFF' },
      { id: 'GAMBLER_SPEED_CHALLENGE', type: 'MECH' },
      { id: 'GAMBLER_HEART_OF_STEEL', type: 'MECH' },
      { id: 'GAMBLER_ALL_IN_ART_5', type: 'MECH' },
      { id: 'GAMBLER_WINNER_TAKE_ALL', type: 'MECH' },
      { id: 'MIRROR_INVERSION', type: 'MECH' },
      { id: 'SELFLESS_GIVEAWAY', type: 'DEBUFF' },
      { id: 'ELIGIBLE', type: 'BUFF' }
    ],
    {
      supportsPhaseTrigger: false,
      temperHeartCompleted: true,
      heartsteelStacks: 0,
      gamblerHeartsteelJackpot: 0,
      hasNegativePermanentStat: false
    }
  );

  assert.deepEqual(candidates.map((candidate) => candidate.id), ['SELFLESS_GIVEAWAY', 'ELIGIBLE']);
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
