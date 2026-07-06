import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import path from 'node:path';
import os from 'node:os';
import { fileURLToPath } from 'node:url';

import { analyzeScenarioEventAllocation, analyzeStaticEventAllocation } from './analyze-event-allocation.ts';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const sourceFile = path.resolve(__dirname, '../data/event-source.json');
const constantsFile = path.resolve(__dirname, '../src/constants/event_constants.opy');

async function writeScenarioFile(data: object) {
  const file = path.join(os.tmpdir(), `event-allocation-scenario-${Date.now()}-${Math.random()}.json`);
  await fs.writeFile(file, `${JSON.stringify(data, null, 2)}\n`, 'utf8');
  return file;
}

test('static report exposes all three event types', async () => {
  const report = await analyzeStaticEventAllocation({ sourceFile, constantsFile });

  assert.equal(report.reports.length, 3);
  assert.equal(report.eventWeight, 2.5);
  assert.equal(report.recentDedupCount, 10);
  assert.ok(report.reports.every((item) => item.candidateCount > 0));
});

test('current allocator slightly lifts low-weight events via fallback mass', async () => {
  const scenarioFile = await writeScenarioFile({
    enabledEventKeys: ['OLIVIA_GIFT', 'GALE_BLESSING', 'HEALING_TOWER_PROMAX'],
    playerState: {
      categoryRoll: 20,
      categoryRollSnapshot: 20
    }
  });

  const report = await analyzeScenarioEventAllocation(scenarioFile, { sourceFile, constantsFile });
  const olivia = report.probabilities.topRows.find((item) => item.key === 'OLIVIA_GIFT');
  const low = report.probabilities.lowWeightRows.find((item) => item.key === 'HEALING_TOWER_PROMAX');
  assert.ok(olivia);
  assert.ok(low);
  assert.ok(low.currentProbability > low.referenceProbability);
  assert.ok(olivia.currentProbability < olivia.referenceProbability);
});

test('recent dedup falls back only after strict pool is exhausted', async () => {
  const scenarioFile = await writeScenarioFile({
    playerState: {
      categoryRoll: 20,
      categoryRollSnapshot: 20,
      eventLastKeys: [
        'buff:OLIVIA_GIFT',
        'buff:GALE_BLESSING',
        'buff:IRON_BULWARK',
        'buff:KONAMI_CODE',
        'buff:LIFE_SPRING',
        'buff:BLACK_FANS_ASSAULT',
        'buff:SPEED_STACK',
        'buff:FLESH_REGEN',
        'buff:HEART_OF_STEEL',
        'buff:DEATH_DELAY'
      ]
    }
  });

  const report = await analyzeScenarioEventAllocation(scenarioFile, { sourceFile, constantsFile });

  assert.equal(report.candidatePool.fallbackStage, 'strict');
  assert.ok(!report.candidatePool.candidateKeys.includes('OLIVIA_GIFT'));
  assert.ok(report.candidatePool.filtered.some((item) => item.key === 'OLIVIA_GIFT' && item.reasons.includes('recent-dedup')));
});

test('temper heart once-state removes it from buff candidates', async () => {
  const scenarioFile = await writeScenarioFile({
    enabledEventKeys: ['TEMPER_HEART', 'GALE_BLESSING'],
    playerState: {
      categoryRoll: 20,
      categoryRollSnapshot: 20,
      temperHeartUsed: true
    }
  });

  const report = await analyzeScenarioEventAllocation(scenarioFile, { sourceFile, constantsFile });

  assert.deepEqual(report.candidatePool.candidateKeys, ['GALE_BLESSING']);
  assert.ok(report.candidatePool.filtered.some((item) => item.key === 'TEMPER_HEART' && item.reasons.includes('temper-heart-used')));
});

test('mech category roll persistence lasts one round', async () => {
  const scenarioFile = await writeScenarioFile({
    enabledEventKeys: ['GAMBLER', 'MINI_FORM'],
    playerState: {
      categoryRoll: 90,
      categoryRollSnapshot: 10
    },
    seed: 7
  });

  const report = await analyzeScenarioEventAllocation(scenarioFile, { sourceFile, constantsFile });

  assert.deepEqual(report.candidatePool.candidateKeys, ['GAMBLER', 'MINI_FORM']);
  assert.equal(report.categoryTransitions[0].type, 'mech');
  assert.equal(report.categoryTransitions[1].type, 'mech');
  assert.equal(report.categoryTransitions[1].source, 'category-roll');
  assert.equal(report.categoryTransitions[2].source, 'rerolled');
});

test('debuff force-roll fallback can restore selfless giveaway only after second fallback', async () => {
  const scenarioFile = await writeScenarioFile({
    enabledEventKeys: ['SELFLESS_GIVEAWAY'],
    playerState: {
      categoryRoll: 50,
      categoryRollSnapshot: 50,
      eventForceRoll: 50
    }
  });

  const report = await analyzeScenarioEventAllocation(scenarioFile, { sourceFile, constantsFile });

  assert.equal(report.candidatePool.fallbackStage, 'force-roll-fallback');
  assert.deepEqual(report.candidatePool.candidateKeys, ['SELFLESS_GIVEAWAY']);
  assert.ok(
    report.candidatePool.filtered.some(
      (item) => item.key === 'SELFLESS_GIVEAWAY' && item.reasons.includes('force-roll-selfless-gated')
    )
  );
});

test('winner takes all stays out of the mech pool when jackpot is below threshold', async () => {
  const scenarioFile = await writeScenarioFile({
    enabledEventKeys: ['GAMBLER_WINNER_TAKE_ALL', 'MINI_FORM'],
    jackpotStacks: 7,
    playerState: {
      categoryRoll: 90,
      categoryRollSnapshot: 90,
      heartsteelStacks: 8
    }
  });

  const report = await analyzeScenarioEventAllocation(scenarioFile, { sourceFile, constantsFile });

  assert.deepEqual(report.candidatePool.candidateKeys, ['MINI_FORM']);
  assert.ok(
    report.candidatePool.filtered.some(
      (item) => item.key === 'GAMBLER_WINNER_TAKE_ALL' && item.reasons.includes('gambler-jackpot-too-small')
    )
  );
});

test('winner takes all stays out of the mech pool when player heartsteel is below threshold', async () => {
  const scenarioFile = await writeScenarioFile({
    enabledEventKeys: ['GAMBLER_WINNER_TAKE_ALL', 'MINI_FORM'],
    jackpotStacks: 8,
    playerState: {
      categoryRoll: 90,
      categoryRollSnapshot: 90,
      heartsteelStacks: 3
    }
  });

  const report = await analyzeScenarioEventAllocation(scenarioFile, { sourceFile, constantsFile });

  assert.deepEqual(report.candidatePool.candidateKeys, ['MINI_FORM']);
  assert.ok(
    report.candidatePool.filtered.some(
      (item) => item.key === 'GAMBLER_WINNER_TAKE_ALL' && item.reasons.includes('gambler-heartsteel-too-low')
    )
  );
});

test('winner takes all enters the mech pool once both thresholds are met', async () => {
  const scenarioFile = await writeScenarioFile({
    enabledEventKeys: ['GAMBLER_WINNER_TAKE_ALL', 'MINI_FORM'],
    jackpotStacks: 8,
    playerState: {
      categoryRoll: 90,
      categoryRollSnapshot: 90,
      heartsteelStacks: 4
    }
  });

  const report = await analyzeScenarioEventAllocation(scenarioFile, { sourceFile, constantsFile });

  assert.deepEqual(report.candidatePool.candidateKeys, ['MINI_FORM', 'GAMBLER_WINNER_TAKE_ALL']);
});
