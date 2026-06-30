import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { loadEventSource } from './sync-event-data.ts';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const SOURCE_FILE = path.resolve(__dirname, '../data/event-source.json');
const CONSTANTS_FILE = path.resolve(__dirname, '../src/constants/event_constants.opy');

const EVENT_TYPE_INDEX = {
  buff: 0,
  debuff: 1,
  mech: 2
} as const;

const BRAVE_ACT_STATE = {
  NEW: 0,
  DRAWN: 1,
  ACCEPTED: 2
} as const;

type EventType = keyof typeof EVENT_TYPE_INDEX;

type EventItem = {
  key: string;
  type: EventType;
  id: number;
  weight: number;
  availability: string;
};

type ScenarioInput = {
  enabledEventKeys?: string[];
  playerState?: {
    heroNumber?: number;
    eventLastKeys?: string[];
    temperHeartUsed?: boolean;
    braveActState?: number;
    categoryRoll?: number | null;
    categoryRollSnapshot?: number | null;
    eventForceRoll?: number | null;
    eventForceCount?: number | null;
  };
  iterations?: number;
  seed?: number;
};

type FilterReason = {
  key: string;
  reasons: string[];
};

type CandidatePoolResult = {
  type: EventType;
  fallbackStage: 'strict' | 'dedup-fallback' | 'force-roll-fallback';
  candidates: EventItem[];
  filtered: FilterReason[];
};

type CategoryOutcome = {
  source: 'force-roll' | 'category-roll' | 'random-roll';
  roll: number;
  type: EventType;
};

type CategoryTransition = {
  stage: 'current' | 'next' | 'nextNext';
  source: 'force-roll' | 'category-roll' | 'rerolled';
  roll: number;
  type: EventType;
  categoryRoll: number;
  categoryRollSnapshot: number;
};

type ProbabilityRow = {
  key: string;
  id: number;
  weight: number;
  currentProbability: number;
  referenceProbability: number;
  deltaProbability: number;
  fallbackProbability: number;
};

type StaticTypeReport = {
  type: EventType;
  eventWeight: number;
  candidateCount: number;
  acceptanceAverage: number;
  fallbackStage: CandidatePoolResult['fallbackStage'];
  topRows: ProbabilityRow[];
  lowWeightRows: ProbabilityRow[];
};

type ScenarioReport = {
  scenarioPath: string | null;
  iterations: number;
  seed: number;
  playerState: Required<NonNullable<ScenarioInput['playerState']>>;
  categoryTransitions: CategoryTransition[];
  selectedType: EventType;
  candidatePool: {
    type: EventType;
    fallbackStage: CandidatePoolResult['fallbackStage'];
    candidateKeys: string[];
    filtered: FilterReason[];
  };
  probabilities: {
    topRows: ProbabilityRow[];
    lowWeightRows: ProbabilityRow[];
  };
};

type StaticReport = {
  sourceFile: string;
  constantsFile: string;
  eventWeight: number;
  recentDedupCount: number;
  braveActMaxHeroOrderExclusive: number;
  reports: StaticTypeReport[];
};

type AnalyzeOptions = {
  report: 'static' | 'scenario';
  scenarioFile?: string;
  sourceFile?: string;
  constantsFile?: string;
};

function parseArgs(rawArgs: string[]): AnalyzeOptions {
  let report: AnalyzeOptions['report'] = 'static';
  let scenarioFile: string | undefined;
  let sourceFile: string | undefined;
  let constantsFile: string | undefined;

  for (let index = 0; index < rawArgs.length; index += 1) {
    const arg = rawArgs[index];
    if (arg === '--report') {
      const value = rawArgs[index + 1];
      if (value !== 'static' && value !== 'scenario') {
        throw new Error(`--report expects static or scenario, got: ${String(value ?? '')}`);
      }
      report = value;
      index += 1;
      continue;
    }
    if (arg === '--scenario') {
      scenarioFile = rawArgs[index + 1];
      if (!scenarioFile) {
        throw new Error('--scenario expects a file path');
      }
      index += 1;
      continue;
    }
    if (arg === '--source-file') {
      sourceFile = rawArgs[index + 1];
      if (!sourceFile) {
        throw new Error('--source-file expects a file path');
      }
      index += 1;
      continue;
    }
    if (arg === '--constants-file') {
      constantsFile = rawArgs[index + 1];
      if (!constantsFile) {
        throw new Error('--constants-file expects a file path');
      }
      index += 1;
      continue;
    }
    throw new Error(`Unknown argument: ${arg}`);
  }

  if (report === 'scenario' && !scenarioFile) {
    throw new Error('--scenario is required when --report scenario');
  }

  return {
    report,
    scenarioFile,
    sourceFile,
    constantsFile
  };
}

function parseDefineNumber(source: string, name: string): number {
  const match = source.match(new RegExp(`^#!define\\s+${name}\\s+([0-9.]+)\\s*$`, 'm'));
  if (!match) {
    throw new Error(`Unable to parse ${name} from event constants`);
  }
  return Number(match[1]);
}

function toAbsolute(basePath: string, candidatePath: string | undefined, fallback: string) {
  if (!candidatePath) {
    return fallback;
  }
  if (path.isAbsolute(candidatePath)) {
    return candidatePath;
  }
  return path.resolve(path.dirname(basePath), candidatePath);
}

function createRng(seed: number) {
  let state = (Math.trunc(seed) >>> 0) || 1;
  return () => {
    state ^= state << 13;
    state ^= state >>> 17;
    state ^= state << 5;
    return (state >>> 0) / 4294967296;
  };
}

function normalizeProbabilityWeight(weight: number, eventWeight: number) {
  if (eventWeight <= 0) {
    return 0;
  }
  return Math.max(0, Math.min(1, weight / eventWeight));
}

function classifyCategory(roll: number): EventType {
  if (roll < 42.5) {
    return 'buff';
  }
  if (roll < 80) {
    return 'debuff';
  }
  return 'mech';
}

function resolveCategoryOutcome(playerState: Required<NonNullable<ScenarioInput['playerState']>>, rng: () => number): CategoryOutcome {
  if (playerState.eventForceRoll != null) {
    return {
      source: 'force-roll',
      roll: playerState.eventForceRoll,
      type: classifyCategory(playerState.eventForceRoll)
    };
  }
  if (playerState.categoryRoll != null) {
    return {
      source: 'category-roll',
      roll: playerState.categoryRoll,
      type: classifyCategory(playerState.categoryRoll)
    };
  }
  const roll = rng() * 100;
  return {
    source: 'random-roll',
    roll,
    type: classifyCategory(roll)
  };
}

function applyClearPlayerEventCategoryUpdate(
  categoryRoll: number | null,
  categoryRollSnapshot: number | null,
  rng: () => number
) {
  if (categoryRollSnapshot == null) {
    const rerolled = rng() * 100;
    return {
      categoryRoll: rerolled,
      categoryRollSnapshot: rerolled,
      source: 'rerolled' as const
    };
  }
  if (categoryRoll === categoryRollSnapshot) {
    const rerolled = rng() * 100;
    return {
      categoryRoll: rerolled,
      categoryRollSnapshot: rerolled,
      source: 'rerolled' as const
    };
  }
  return {
    categoryRoll: categoryRoll ?? categoryRollSnapshot,
    categoryRollSnapshot: categoryRoll ?? categoryRollSnapshot,
    source: 'category-roll' as const
  };
}

function buildTransitions(playerState: Required<NonNullable<ScenarioInput['playerState']>>, seed: number): CategoryTransition[] {
  const rng = createRng(seed);
  const current = resolveCategoryOutcome(playerState, rng);
  const transitions: CategoryTransition[] = [
    {
      stage: 'current',
      source: current.source,
      roll: current.roll,
      type: current.type,
      categoryRoll: current.roll,
      categoryRollSnapshot: playerState.categoryRollSnapshot ?? current.roll
    }
  ];

  const firstClear = applyClearPlayerEventCategoryUpdate(playerState.categoryRoll, playerState.categoryRollSnapshot, rng);
  transitions.push({
    stage: 'next',
    source: firstClear.source,
    roll: firstClear.categoryRoll,
    type: classifyCategory(firstClear.categoryRoll),
    categoryRoll: firstClear.categoryRoll,
    categoryRollSnapshot: firstClear.categoryRollSnapshot
  });

  const secondClear = applyClearPlayerEventCategoryUpdate(firstClear.categoryRoll, firstClear.categoryRollSnapshot, rng);
  transitions.push({
    stage: 'nextNext',
    source: secondClear.source,
    roll: secondClear.categoryRoll,
    type: classifyCategory(secondClear.categoryRoll),
    categoryRoll: secondClear.categoryRoll,
    categoryRollSnapshot: secondClear.categoryRollSnapshot
  });

  return transitions;
}

function makeRecentKey(type: EventType, id: number, dedupMultiplier: number) {
  return EVENT_TYPE_INDEX[type] * dedupMultiplier + id;
}

function summarizeReasonMap(reasonMap: Map<string, Set<string>>): FilterReason[] {
  return Array.from(reasonMap.entries())
    .map(([key, reasons]) => ({ key, reasons: Array.from(reasons).sort() }))
    .filter((item) => item.reasons.length > 0)
    .sort((left, right) => left.key.localeCompare(right.key));
}

function buildCandidatePool(
  events: EventItem[],
  type: EventType,
  playerState: Required<NonNullable<ScenarioInput['playerState']>>,
  enabledEventKeys: Set<string> | null,
  config: {
    dedupMultiplier: number;
    braveActMaxHeroOrderExclusive: number;
    forceRollSelflessGiveaway: number;
  }
): CandidatePoolResult {
  const typedEvents = events
    .filter((eventItem) => eventItem.type === type)
    .sort((left, right) => left.id - right.id);
  const reasonMap = new Map<string, Set<string>>();
  const recentKeys = new Set(
    playerState.eventLastKeys.map((item) => {
      const [eventType, key] = item.split(':', 2);
      const matched = events.find((eventItem) => eventItem.type === eventType && eventItem.key === key);
      if (!matched) {
        throw new Error(`Unknown eventLastKeys entry: ${item}`);
      }
      return makeRecentKey(matched.type, matched.id, config.dedupMultiplier);
    })
  );

  function addReason(key: string, reason: string) {
    if (!reasonMap.has(key)) {
      reasonMap.set(key, new Set());
    }
    reasonMap.get(key)?.add(reason);
  }

  function passesBaseFilters(eventItem: EventItem) {
    if (enabledEventKeys != null && !enabledEventKeys.has(eventItem.key)) {
      addReason(eventItem.key, 'disabled-by-scenario');
      return false;
    }
    if (eventItem.availability !== 'active') {
      addReason(eventItem.key, 'inactive-source');
      return false;
    }
    if (!(eventItem.weight > 0)) {
      addReason(eventItem.key, 'nonpositive-weight');
      return false;
    }
    if (type === 'buff' && eventItem.key === 'TEMPER_HEART' && playerState.temperHeartUsed) {
      addReason(eventItem.key, 'temper-heart-used');
      return false;
    }
    if (
      type === 'mech' &&
      eventItem.key === 'BRAVE_ACT' &&
      (playerState.heroNumber + 1 >= config.braveActMaxHeroOrderExclusive || playerState.braveActState !== BRAVE_ACT_STATE.NEW)
    ) {
      addReason(
        eventItem.key,
        playerState.heroNumber + 1 >= config.braveActMaxHeroOrderExclusive ? 'brave-act-hero-gated' : 'brave-act-once-state-gated'
      );
      return false;
    }
    return true;
  }

  function passesStrictFilters(eventItem: EventItem) {
    if (!passesBaseFilters(eventItem)) {
      return false;
    }
    const recentKey = makeRecentKey(type, eventItem.id, config.dedupMultiplier);
    if (recentKeys.has(recentKey)) {
      addReason(eventItem.key, 'recent-dedup');
      return false;
    }
    if (type === 'debuff' && playerState.eventForceRoll === config.forceRollSelflessGiveaway && eventItem.key === 'SELFLESS_GIVEAWAY') {
      addReason(eventItem.key, 'force-roll-selfless-gated');
      return false;
    }
    return true;
  }

  function passesDedupFallback(eventItem: EventItem) {
    if (!passesBaseFilters(eventItem)) {
      return false;
    }
    if (type === 'debuff' && playerState.eventForceRoll === config.forceRollSelflessGiveaway && eventItem.key === 'SELFLESS_GIVEAWAY') {
      addReason(eventItem.key, 'force-roll-selfless-gated');
      return false;
    }
    return true;
  }

  const strictCandidates = typedEvents.filter(passesStrictFilters);
  if (strictCandidates.length > 0) {
    return {
      type,
      fallbackStage: 'strict',
      candidates: strictCandidates,
      filtered: summarizeReasonMap(reasonMap)
    };
  }

  const dedupFallbackCandidates = typedEvents.filter(passesDedupFallback);
  if (dedupFallbackCandidates.length > 0) {
    return {
      type,
      fallbackStage: 'dedup-fallback',
      candidates: dedupFallbackCandidates,
      filtered: summarizeReasonMap(reasonMap)
    };
  }

  if (type === 'debuff') {
    const finalCandidates = typedEvents.filter(passesBaseFilters);
    return {
      type,
      fallbackStage: 'force-roll-fallback',
      candidates: finalCandidates,
      filtered: summarizeReasonMap(reasonMap)
    };
  }

  return {
    type,
    fallbackStage: 'dedup-fallback',
    candidates: dedupFallbackCandidates,
    filtered: summarizeReasonMap(reasonMap)
  };
}

function computeProbabilityRows(candidates: EventItem[], eventWeight: number, loopCount = 8): ProbabilityRow[] {
  if (candidates.length === 0) {
    return [];
  }

  const acceptanceWeights = candidates.map((eventItem) => normalizeProbabilityWeight(eventItem.weight, eventWeight));
  const averageAcceptance = acceptanceWeights.reduce((sum, value) => sum + value, 0) / candidates.length;
  const failureRate = 1 - averageAcceptance;
  const geometricFactor =
    averageAcceptance === 0 ? 0 : (1 - failureRate ** loopCount) / averageAcceptance;
  const totalReferenceWeight = candidates.reduce((sum, eventItem) => sum + Math.max(0, eventItem.weight), 0);

  return candidates
    .map((eventItem, index) => {
      const acceptance = acceptanceWeights[index];
      const currentProbability =
        averageAcceptance === 0
          ? 1 / candidates.length
          : (acceptance * geometricFactor + failureRate ** (loopCount - 1) * (1 - acceptance)) / candidates.length;
      const referenceProbability = totalReferenceWeight === 0 ? 1 / candidates.length : Math.max(0, eventItem.weight) / totalReferenceWeight;
      const fallbackProbability = (failureRate ** (loopCount - 1) * (1 - acceptance)) / candidates.length;
      return {
        key: eventItem.key,
        id: eventItem.id,
        weight: eventItem.weight,
        currentProbability,
        referenceProbability,
        deltaProbability: currentProbability - referenceProbability,
        fallbackProbability
      };
    })
    .sort((left, right) => right.currentProbability - left.currentProbability || left.id - right.id);
}

function takeRows(rows: ProbabilityRow[], count: number, order: 'top' | 'low') {
  const sorted =
    order === 'top'
      ? [...rows]
      : [...rows].sort((left, right) => left.weight - right.weight || right.deltaProbability - left.deltaProbability || left.id - right.id);
  return sorted.slice(0, count);
}

function buildStaticTypeReport(
  events: EventItem[],
  type: EventType,
  constants: {
    eventWeight: number;
    recentDedupCount: number;
    braveActMaxHeroOrderExclusive: number;
    dedupMultiplier: number;
    forceRollSelflessGiveaway: number;
  }
): StaticTypeReport {
  const playerState = {
    heroNumber: 0,
    eventLastKeys: [] as string[],
    temperHeartUsed: false,
    braveActState: BRAVE_ACT_STATE.NEW,
    categoryRoll: null,
    categoryRollSnapshot: null,
    eventForceRoll: null,
    eventForceCount: null
  };
  const pool = buildCandidatePool(events, type, playerState, null, constants);
  const probabilities = computeProbabilityRows(pool.candidates, constants.eventWeight);
  const acceptanceAverage =
    pool.candidates.length === 0
      ? 0
      : pool.candidates.reduce((sum, eventItem) => sum + normalizeProbabilityWeight(eventItem.weight, constants.eventWeight), 0) /
        pool.candidates.length;

  return {
    type,
    eventWeight: constants.eventWeight,
    candidateCount: pool.candidates.length,
    acceptanceAverage,
    fallbackStage: pool.fallbackStage,
    topRows: takeRows(probabilities, 5, 'top'),
    lowWeightRows: takeRows(probabilities, 5, 'low')
  };
}

export async function analyzeStaticEventAllocation(options: { sourceFile?: string; constantsFile?: string } = {}): Promise<StaticReport> {
  const sourceFile = options.sourceFile ?? SOURCE_FILE;
  const constantsFile = options.constantsFile ?? CONSTANTS_FILE;
  const [sourceData, constantsSource] = await Promise.all([loadEventSource(sourceFile), fs.readFile(constantsFile, 'utf8')]);
  const events = sourceData.events as EventItem[];
  const constants = {
    eventWeight: parseDefineNumber(constantsSource, 'EVT_INIT_EVENT_WEIGHT'),
    recentDedupCount: parseDefineNumber(constantsSource, 'EVT_RECENT_EVENT_DEDUP_COUNT'),
    braveActMaxHeroOrderExclusive: parseDefineNumber(constantsSource, 'EVT_MECH_21_MAX_HERO_ORDER_EXCLUSIVE'),
    dedupMultiplier: parseDefineNumber(constantsSource, 'EVT_DEDUP_TYPE_MULTIPLIER'),
    forceRollSelflessGiveaway: parseDefineNumber(constantsSource, 'EVT_MECH_8_FORCE_ROLL')
  };

  return {
    sourceFile: path.relative(path.resolve(__dirname, '..'), sourceFile),
    constantsFile: path.relative(path.resolve(__dirname, '..'), constantsFile),
    eventWeight: constants.eventWeight,
    recentDedupCount: constants.recentDedupCount,
    braveActMaxHeroOrderExclusive: constants.braveActMaxHeroOrderExclusive,
    reports: ['buff', 'debuff', 'mech'].map((type) => buildStaticTypeReport(events, type, constants))
  };
}

export async function analyzeScenarioEventAllocation(
  scenarioFile: string,
  options: { sourceFile?: string; constantsFile?: string } = {}
): Promise<ScenarioReport> {
  const sourceFile = options.sourceFile ?? SOURCE_FILE;
  const constantsFile = options.constantsFile ?? CONSTANTS_FILE;
  const [scenarioSource, sourceData, constantsSource] = await Promise.all([
    fs.readFile(scenarioFile, 'utf8'),
    loadEventSource(sourceFile),
    fs.readFile(constantsFile, 'utf8')
  ]);
  const scenario = JSON.parse(scenarioSource) as ScenarioInput;
  const playerState = {
    heroNumber: scenario.playerState?.heroNumber ?? 0,
    eventLastKeys: scenario.playerState?.eventLastKeys ?? [],
    temperHeartUsed: scenario.playerState?.temperHeartUsed ?? false,
    braveActState: scenario.playerState?.braveActState ?? BRAVE_ACT_STATE.NEW,
    categoryRoll: scenario.playerState?.categoryRoll ?? null,
    categoryRollSnapshot: scenario.playerState?.categoryRollSnapshot ?? null,
    eventForceRoll: scenario.playerState?.eventForceRoll ?? null,
    eventForceCount: scenario.playerState?.eventForceCount ?? null
  };
  const seed = scenario.seed ?? 1;
  const iterations = scenario.iterations ?? 200000;
  const constants = {
    eventWeight: parseDefineNumber(constantsSource, 'EVT_INIT_EVENT_WEIGHT'),
    recentDedupCount: parseDefineNumber(constantsSource, 'EVT_RECENT_EVENT_DEDUP_COUNT'),
    braveActMaxHeroOrderExclusive: parseDefineNumber(constantsSource, 'EVT_MECH_21_MAX_HERO_ORDER_EXCLUSIVE'),
    dedupMultiplier: parseDefineNumber(constantsSource, 'EVT_DEDUP_TYPE_MULTIPLIER'),
    forceRollSelflessGiveaway: parseDefineNumber(constantsSource, 'EVT_MECH_8_FORCE_ROLL')
  };

  const enabledEventKeys = scenario.enabledEventKeys ? new Set(scenario.enabledEventKeys) : null;
  const transitions = buildTransitions(playerState, seed);
  const selectedType = transitions[0].type;
  const events = sourceData.events as EventItem[];
  const candidatePool = buildCandidatePool(events, selectedType, playerState, enabledEventKeys, constants);
  const probabilities = computeProbabilityRows(candidatePool.candidates, constants.eventWeight);

  return {
    scenarioPath: path.relative(path.resolve(__dirname, '..'), scenarioFile),
    iterations,
    seed,
    playerState,
    categoryTransitions: transitions,
    selectedType,
    candidatePool: {
      type: candidatePool.type,
      fallbackStage: candidatePool.fallbackStage,
      candidateKeys: candidatePool.candidates.map((eventItem) => eventItem.key),
      filtered: candidatePool.filtered
    },
    probabilities: {
      topRows: takeRows(probabilities, 8, 'top'),
      lowWeightRows: takeRows(probabilities, 8, 'low')
    }
  };
}

export async function main(rawArgs: string[]) {
  const options = parseArgs(rawArgs);
  if (options.report === 'static') {
    const result = await analyzeStaticEventAllocation({
      sourceFile: options.sourceFile,
      constantsFile: options.constantsFile
    });
    console.log(JSON.stringify(result, null, 2));
    return;
  }

  const result = await analyzeScenarioEventAllocation(options.scenarioFile!, {
    sourceFile: options.sourceFile,
    constantsFile: options.constantsFile
  });
  console.log(JSON.stringify(result, null, 2));
}

