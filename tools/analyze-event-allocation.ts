import fs from 'node:fs/promises';
import path from 'node:path';
import readline from 'node:readline';
import { fileURLToPath } from 'node:url';

import { loadEventSource } from './sync-event-data.ts';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const REPO_ROOT = path.resolve(__dirname, '..');
const SOURCE_FILE = path.resolve(__dirname, '../data/event-source.json');
const CONSTANTS_FILE = path.resolve(__dirname, '../src/constants/event_constants.opy');
const SCENARIO_DIR = path.resolve(__dirname, './event-allocation-scenarios');
export const DEFAULT_REPORT_OUTPUT_FILE = path.resolve(
  __dirname,
  '../web/title-query/public/data/event-allocation-report.json'
);
export const REPORT_VERSION = 'v3';

const EVENT_TYPE_INDEX = {
  buff: 0,
  debuff: 1,
  mech: 2
} as const;

const EVENT_TYPE_LABELS = {
  buff: '增益',
  debuff: '减益',
  mech: '机制'
} as const;

const REASON_LABELS: Record<string, string> = {
  'disabled-by-scenario': '场景手动禁用',
  'inactive-source': '事件源未启用',
  'nonpositive-weight': '权重非正值',
  'temper-heart-used': '心之钢已在本局生效过',
  'recent-dedup': '命中最近事件去重窗口',
  'force-roll-selfless-gated': '舍己为人在当前强制抽取条件下被排除',
  'gambler-jackpot-too-small': '奖池未达 8 层',
  'gambler-heartsteel-too-low': '玩家心之钢不足 4 层'
};

const SCENARIO_METADATA: Record<string, { id: string; label: string; description: string }> = {
  'prod-default.json': {
    id: 'prod-default',
    label: '默认生产分配',
    description: '使用默认事件池，观察基础分布，以及哪些低权重事件会被额外抬高。'
  },
  'recent-dedup-window.json': {
    id: 'recent-dedup-window',
    label: '最近事件去重窗口',
    description: '模拟最近抽过的同类事件很多时，这一轮真正可抽到的范围会缩到什么程度。'
  },
  'temper-heart-used.json': {
    id: 'temper-heart-used',
    label: '心之钢已生效',
    description: '验证一次性事件在本局已经触发后，会不会直接退出抽取范围。'
  }
};

const ANSI = {
  reset: '\u001B[0m',
  dim: '\u001B[2m',
  bold: '\u001B[1m',
  orange: '\u001B[38;5;208m',
  blue: '\u001B[38;5;45m',
  green: '\u001B[38;5;84m',
  red: '\u001B[38;5;203m',
  yellow: '\u001B[38;5;221m',
  magenta: '\u001B[38;5;213m',
  gray: '\u001B[38;5;248m'
} as const;

type EventType = keyof typeof EVENT_TYPE_INDEX;

type EventItem = {
  key: string;
  type: EventType;
  id: number;
  weight: number;
  availability: string;
};

type SourcePack = {
  id: number;
  key: string;
  labelZh: string;
};

type SourceEvent = EventItem & {
  pack: number;
  nameZh: string;
  durationSec: number;
};

const SESSION_SIMULATION_DURATION_HOURS = 4;
const SESSION_SIMULATION_DURATION_SECONDS = SESSION_SIMULATION_DURATION_HOURS * 60 * 60;
const SESSION_SIMULATION_RUNS = 1200;
const SESSION_WAIT_MIN_SECONDS = 30;
const SESSION_WAIT_MAX_SECONDS = 35;
const SESSION_SIMULATION_SEED_OFFSET = 0x9e3779b9;

type ScenarioInput = {
  enabledEventKeys?: string[];
  playerState?: {
    heroNumber?: number;
    heartsteelStacks?: number;
    eventLastKeys?: string[];
    temperHeartUsed?: boolean;
    categoryRoll?: number | null;
    categoryRollSnapshot?: number | null;
    eventForceRoll?: number | null;
    eventForceCount?: number | null;
  };
  jackpotStacks?: number;
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

export type ProbabilityRow = {
  key: string;
  id: number;
  weight: number;
  currentProbability: number;
  referenceProbability: number;
  deltaProbability: number;
  fallbackProbability: number;
};

export type EventAllocationDisplayRow = ProbabilityRow & {
  eventNameZh: string;
  eventTypeLabelZh: string;
  packLabelZh: string;
  currentChancePercent: string;
  expectedChancePercent: string;
  extraChancePercent: string;
  safetyLiftPercent: string;
  summaryText: string;
  fallbackSummaryText: string;
  nameWithKeyFallback: string;
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
  enabledEventKeys: string[] | null;
  jackpotStacks: number;
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
  reports: StaticTypeReport[];
};

type AnalyzeOptions = {
  report: 'static' | 'scenario';
  format: 'json' | 'tui' | 'html-data';
  scenarioFile?: string;
  sourceFile?: string;
  constantsFile?: string;
  outputFile?: string;
};

export type EventAllocationAlert = {
  id: string;
  severity: 'info' | 'warn';
  title: string;
  summary: string;
  evidence: string;
};

export type EventAllocationScenarioView = {
  id: string;
  label: string;
  description: string;
  scenarioPath: string | null;
  selectedType: EventType;
  selectedTypeLabel: string;
  iterations: number;
  selectedTypeSummary: string;
  candidatePoolSummary: string;
  transitionSummary: string;
  filteredSummary: string;
  categoryTransitions: Array<CategoryTransition & { typeLabel: string; sourceLabel: string }>;
  candidatePool: {
    type: EventType;
    typeLabel: string;
    eventNames: string[];
    events: Array<{
      key: string;
      eventNameZh: string;
      eventTypeLabelZh: string;
      packLabelZh: string;
      nameWithKeyFallback: string;
    }>;
    filtered: Array<
      FilterReason & {
        eventNameZh: string;
        packLabelZh: string;
        nameWithKeyFallback: string;
        reasonLabels: string[];
        reasonSummary: string;
      }
    >;
    filteredCount: number;
  };
  probabilities: {
    topRows: EventAllocationDisplayRow[];
    lowWeightRows: EventAllocationDisplayRow[];
  };
  searchText: string;
};

export type EventAllocationStaticSummary = {
  type: EventType;
  typeLabel: string;
  candidateCount: number;
  acceptanceAverage: number;
  acceptanceAveragePercent: string;
  poolSummary: string;
  topRows: EventAllocationDisplayRow[];
  lowWeightRows: EventAllocationDisplayRow[];
  strongestUpliftRow: EventAllocationDisplayRow | null;
  strongestFallbackRow: EventAllocationDisplayRow | null;
};

export type EventAllocationHtmlData = {
  meta: {
    reportVersion: string;
    sourceFile: string;
    constantsFile: string;
    generatedAt: string;
    eventWeight: number;
    recentDedupCount: number;
    scenarioCount: number;
  };
  alerts: EventAllocationAlert[];
  staticSummary: EventAllocationStaticSummary[];
  sessionSimulation: EventAllocationSessionSimulation;
  scenarios: EventAllocationScenarioView[];
};

export type EventAllocationSessionEventSummary = {
  key: string;
  eventNameZh: string;
  eventTypeLabelZh: string;
  packLabelZh: string;
  atLeastOnceProbability: number;
  atLeastOnceProbabilityPercent: string;
  expectedCycleCount: number;
  probabilityTierLabel: '极高' | '高' | '中' | '低';
  sortValue: number;
};

export type EventAllocationSessionTypeSummary = {
  type: EventType;
  typeLabel: string;
  averageAtLeastOnceProbability: number;
  averageAtLeastOnceProbabilityPercent: string;
  highestEvent: EventAllocationSessionEventSummary | null;
  lowestEvent: EventAllocationSessionEventSummary | null;
};

export type EventAllocationSessionScenarioSummary = {
  id: string;
  label: string;
  description: string;
  estimatedCycleCount: number;
  estimatedCycleCountLabel: string;
  eventSummaries: EventAllocationSessionEventSummary[];
  typeSummaries: EventAllocationSessionTypeSummary[];
  assumptions: string[];
  searchText: string;
};

export type EventAllocationSessionSimulation = {
  durationHours: number;
  durationLabel: string;
  baselineScenarioId: string;
  scenarios: EventAllocationSessionScenarioSummary[];
};

type TuiState = {
  pageIndex: number;
  selectedScenarioIndex: number;
  selectedStaticIndex: number;
  selectedAlertIndex: number;
  filterText: string;
  filterMode: boolean;
  activeScenarioId: string | null;
};

function parseArgs(rawArgs: string[]): AnalyzeOptions {
  let report: AnalyzeOptions['report'] = 'static';
  let format: AnalyzeOptions['format'] = 'json';
  let scenarioFile: string | undefined;
  let sourceFile: string | undefined;
  let constantsFile: string | undefined;
  let outputFile: string | undefined;

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
    if (arg === '--format') {
      const value = rawArgs[index + 1];
      if (value !== 'json' && value !== 'tui' && value !== 'html-data') {
        throw new Error(`--format expects json, tui or html-data, got: ${String(value ?? '')}`);
      }
      format = value;
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
    if (arg === '--output') {
      outputFile = rawArgs[index + 1];
      if (!outputFile) {
        throw new Error('--output expects a file path');
      }
      index += 1;
      continue;
    }
    throw new Error(`Unknown argument: ${arg}`);
  }

  if (format === 'json' && report === 'scenario' && !scenarioFile) {
    throw new Error('--scenario is required when --report scenario');
  }
  if (format !== 'html-data' && outputFile) {
    throw new Error('--output is only supported with --format html-data');
  }

  return {
    report,
    format,
    scenarioFile,
    sourceFile,
    constantsFile,
    outputFile
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
  jackpotStacks: number,
  enabledEventKeys: Set<string> | null,
  config: {
    dedupMultiplier: number;
    forceRollSelflessGiveaway: number;
    gamblerWinnerTakeAllPoolMin: number;
    gamblerWinnerTakeAllPlayerStacksMin: number;
  }
): CandidatePoolResult {
  const typedEvents = events.filter((eventItem) => eventItem.type === type).sort((left, right) => left.id - right.id);
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
    if (type === 'mech' && eventItem.key === 'GAMBLER_WINNER_TAKE_ALL') {
      if (jackpotStacks < config.gamblerWinnerTakeAllPoolMin) {
        addReason(eventItem.key, 'gambler-jackpot-too-small');
        return false;
      }
      if (playerState.heartsteelStacks < config.gamblerWinnerTakeAllPlayerStacksMin) {
        addReason(eventItem.key, 'gambler-heartsteel-too-low');
        return false;
      }
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
  const geometricFactor = averageAcceptance === 0 ? 0 : (1 - failureRate ** loopCount) / averageAcceptance;
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
    dedupMultiplier: number;
    forceRollSelflessGiveaway: number;
  }
): StaticTypeReport {
  const playerState = {
    heroNumber: 0,
    heartsteelStacks: 0,
    eventLastKeys: [] as string[],
    temperHeartUsed: false,
    categoryRoll: null,
    categoryRollSnapshot: null,
    eventForceRoll: null,
    eventForceCount: null
  };
  const pool = buildCandidatePool(events, type, playerState, 0, null, constants);
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

async function loadSharedAnalysisInputs(options: { sourceFile?: string; constantsFile?: string } = {}) {
  const sourceFile = options.sourceFile ?? SOURCE_FILE;
  const constantsFile = options.constantsFile ?? CONSTANTS_FILE;
  const [sourceData, constantsSource] = await Promise.all([loadEventSource(sourceFile), fs.readFile(constantsFile, 'utf8')]);
  const constants = {
    eventWeight: parseDefineNumber(constantsSource, 'EVT_INIT_EVENT_WEIGHT'),
    recentDedupCount: parseDefineNumber(constantsSource, 'EVT_RECENT_EVENT_DEDUP_COUNT'),
    dedupMultiplier: parseDefineNumber(constantsSource, 'EVT_DEDUP_TYPE_MULTIPLIER'),
    cheatCardCountingForceRoll: parseDefineNumber(constantsSource, 'EVT_MECH_7_FORCE_ROLL'),
    forceRollSelflessGiveaway: parseDefineNumber(constantsSource, 'EVT_MECH_8_FORCE_ROLL'),
    gamblerShortInvestmentForceCount: parseDefineNumber(constantsSource, 'EVT_MECH_8_FORCE_COUNT'),
    gamblerLongInvestmentForceRoll: parseDefineNumber(constantsSource, 'EVT_MECH_12_FORCE_ROLL'),
    gamblerLongInvestmentForceCount: parseDefineNumber(constantsSource, 'EVT_MECH_12_FORCE_COUNT'),
    gamblerWinnerTakeAllPoolMin: parseDefineNumber(constantsSource, 'EVT_MECH_24_POOL_MIN'),
    gamblerWinnerTakeAllPlayerStacksMin: parseDefineNumber(constantsSource, 'EVT_MECH_24_PLAYER_STACKS_MIN')
  };

  return {
    sourceFile,
    constantsFile,
    sourceData,
    events: sourceData.events as SourceEvent[],
    packs: sourceData.packs as SourcePack[],
    constants
  };
}

export async function analyzeStaticEventAllocation(options: { sourceFile?: string; constantsFile?: string } = {}): Promise<StaticReport> {
  const { sourceFile, constantsFile, events, constants } = await loadSharedAnalysisInputs(options);

  return {
    sourceFile: path.relative(REPO_ROOT, sourceFile),
    constantsFile: path.relative(REPO_ROOT, constantsFile),
    eventWeight: constants.eventWeight,
    recentDedupCount: constants.recentDedupCount,
    reports: ['buff', 'debuff', 'mech'].map((type) => buildStaticTypeReport(events, type, constants))
  };
}

export async function analyzeScenarioEventAllocation(
  scenarioFile: string,
  options: { sourceFile?: string; constantsFile?: string } = {}
): Promise<ScenarioReport> {
  const { sourceFile, events, constants } = await loadSharedAnalysisInputs(options);
  const absoluteScenarioFile = toAbsolute(sourceFile, scenarioFile, scenarioFile);
  const scenarioSource = await fs.readFile(absoluteScenarioFile, 'utf8');
  const scenario = JSON.parse(scenarioSource) as ScenarioInput;
  const playerState = {
    heroNumber: scenario.playerState?.heroNumber ?? 0,
    heartsteelStacks: scenario.playerState?.heartsteelStacks ?? 0,
    eventLastKeys: scenario.playerState?.eventLastKeys ?? [],
    temperHeartUsed: scenario.playerState?.temperHeartUsed ?? false,
    categoryRoll: scenario.playerState?.categoryRoll ?? null,
    categoryRollSnapshot: scenario.playerState?.categoryRollSnapshot ?? null,
    eventForceRoll: scenario.playerState?.eventForceRoll ?? null,
    eventForceCount: scenario.playerState?.eventForceCount ?? null
  };
  const jackpotStacks = scenario.jackpotStacks ?? 0;
  const seed = scenario.seed ?? 1;
  const iterations = scenario.iterations ?? 200000;

  const enabledEventKeys = scenario.enabledEventKeys ? new Set(scenario.enabledEventKeys) : null;
  const transitions = buildTransitions(playerState, seed);
  const selectedType = transitions[0].type;
  const candidatePool = buildCandidatePool(events, selectedType, playerState, jackpotStacks, enabledEventKeys, constants);
  const probabilities = computeProbabilityRows(candidatePool.candidates, constants.eventWeight);

  return {
    scenarioPath: path.relative(REPO_ROOT, absoluteScenarioFile),
    iterations,
    seed,
    enabledEventKeys: enabledEventKeys ? Array.from(enabledEventKeys) : null,
    jackpotStacks,
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

function chooseEventWithRejectSampling(candidates: EventItem[], eventWeight: number, rng: () => number) {
  if (candidates.length === 0) {
    throw new Error('Reject sampling requires a non-empty candidate pool.');
  }

  let loopCount = 0;
  let chosen = candidates[0];
  while (loopCount < 8) {
    chosen = candidates[Math.floor(rng() * candidates.length)] ?? candidates[candidates.length - 1];
    if (rng() * eventWeight < chosen.weight) {
      return chosen;
    }
    loopCount += 1;
  }
  return chosen;
}

function getProbabilityTierLabel(probability: number): EventAllocationSessionEventSummary['probabilityTierLabel'] {
  if (probability >= 0.95) {
    return '极高';
  }
  if (probability >= 0.75) {
    return '高';
  }
  if (probability >= 0.4) {
    return '中';
  }
  return '低';
}

function applyLongSessionEventState(
  eventKey: string,
  playerState: Required<NonNullable<ScenarioInput['playerState']>>,
  constants: {
    forceRollSelflessGiveaway: number;
    cheatCardCountingForceRoll: number;
    gamblerShortInvestmentForceCount: number;
    gamblerLongInvestmentForceRoll: number;
    gamblerLongInvestmentForceCount: number;
  }
) {
  if (eventKey === 'TEMPER_HEART') {
    playerState.temperHeartUsed = true;
  }
  if (eventKey === 'CHEAT_CARD_COUNTING') {
    playerState.eventForceRoll = constants.cheatCardCountingForceRoll;
    playerState.eventForceCount = null;
  }
  if (eventKey === 'GAMBLER_SHORT_INVESTMENT') {
    playerState.eventForceRoll = constants.forceRollSelflessGiveaway;
    playerState.eventForceCount = constants.gamblerShortInvestmentForceCount;
  }
  if (eventKey === 'GAMBLER_LONG_INVESTMENT') {
    playerState.eventForceRoll = constants.gamblerLongInvestmentForceRoll;
    playerState.eventForceCount = constants.gamblerLongInvestmentForceCount;
  }
}

function advanceLongSessionPlayerState(
  selectedEvent: SourceEvent,
  playerState: Required<NonNullable<ScenarioInput['playerState']>>,
  constants: {
    recentDedupCount: number;
    dedupMultiplier: number;
    forceRollSelflessGiveaway: number;
    cheatCardCountingForceRoll: number;
    gamblerShortInvestmentForceCount: number;
    gamblerLongInvestmentForceRoll: number;
    gamblerLongInvestmentForceCount: number;
  },
  rng: () => number
) {
  applyLongSessionEventState(selectedEvent.key, playerState, constants);

  if (playerState.eventForceRoll != null) {
    if ((playerState.eventForceCount ?? -1) > 0) {
      playerState.eventForceCount = (playerState.eventForceCount ?? 0) - 1;
    } else {
      playerState.eventForceRoll = null;
    }
  }

  playerState.eventLastKeys = [...playerState.eventLastKeys, `${selectedEvent.type}:${selectedEvent.key}`].slice(
    -constants.recentDedupCount
  );

  const nextCategory = applyClearPlayerEventCategoryUpdate(playerState.categoryRoll, playerState.categoryRollSnapshot, rng);
  playerState.categoryRoll = nextCategory.categoryRoll;
  playerState.categoryRollSnapshot = nextCategory.categoryRollSnapshot;
}

async function resolveScenarioFiles(selectedScenarioFile?: string) {
  if (selectedScenarioFile) {
    return [toAbsolute(path.join(REPO_ROOT, 'dummy'), selectedScenarioFile, selectedScenarioFile)];
  }
  const names = (await fs.readdir(SCENARIO_DIR)).filter((name) => name.endsWith('.json')).sort((left, right) => left.localeCompare(right, 'en'));
  return names.map((name) => path.join(SCENARIO_DIR, name));
}

function prettifyScenarioInfo(scenarioFile: string) {
  const baseName = path.basename(scenarioFile);
  const known = SCENARIO_METADATA[baseName];
  if (known) {
    return known;
  }
  const stem = baseName.replace(/\.json$/, '');
  return {
    id: stem.replace(/[^a-z0-9]+/gi, '-').replace(/^-+|-+$/g, '').toLowerCase(),
    label: stem.replace(/[-_]+/g, ' '),
    description: '自定义场景'
  };
}

function getTypeLabel(type: EventType) {
  return EVENT_TYPE_LABELS[type];
}

function getTransitionSourceLabel(source: CategoryTransition['source']) {
  if (source === 'force-roll') {
    return '强制类别';
  }
  if (source === 'category-roll') {
    return '沿用上一轮倾向';
  }
  return '重新掷出';
}

function mapReasonLabels(reasons: string[]) {
  return reasons.map((reason) => REASON_LABELS[reason] || reason);
}

function getEventDisplayMeta(
  eventKey: string,
  type: EventType,
  sourceEventsByKey: Map<string, SourceEvent>,
  packLabelById: Map<number, string>
) {
  const sourceEvent = sourceEventsByKey.get(eventKey);
  const eventNameZh = sourceEvent?.nameZh ?? eventKey;
  const packLabelZh = sourceEvent ? packLabelById.get(sourceEvent.pack) ?? '未分组' : '未分组';
  return {
    eventNameZh,
    eventTypeLabelZh: getTypeLabel(type),
    packLabelZh,
    nameWithKeyFallback: sourceEvent?.nameZh ? `${sourceEvent.nameZh}` : eventKey
  };
}

function buildDisplayRow(
  row: ProbabilityRow,
  type: EventType,
  sourceEventsByKey: Map<string, SourceEvent>,
  packLabelById: Map<number, string>
): EventAllocationDisplayRow {
  const meta = getEventDisplayMeta(row.key, type, sourceEventsByKey, packLabelById);
  return {
    ...row,
    ...meta,
    currentChancePercent: formatPercent(row.currentProbability),
    expectedChancePercent: formatPercent(row.referenceProbability),
    extraChancePercent: formatPercent(row.deltaProbability),
    safetyLiftPercent: formatPercent(row.fallbackProbability),
    summaryText:
      row.deltaProbability > 0 ? '比按权重更容易抽到' : row.deltaProbability < 0 ? '比按权重更难抽到' : '与按权重抽取接近',
    fallbackSummaryText: row.fallbackProbability > 0 ? '主要来自保底抬升' : '几乎不依赖保底抬升'
  };
}

function buildTransitionSummary(transitions: Array<CategoryTransition & { typeLabel: string; sourceLabel: string }>) {
  const current = transitions[0];
  const next = transitions[1];
  if (!current || !next) {
    return '当前场景没有足够的类别倾向数据。';
  }
  if (next.source === 'category-roll') {
    return `这一轮先偏向${current.typeLabel}，下一轮仍会沿用这次的类别倾向。`;
  }
  return `这一轮先偏向${current.typeLabel}，清除事件后下一轮会重新决定类别。`;
}

function buildCandidatePoolSummary(typeLabel: string, candidateCount: number, fallbackStage: CandidatePoolResult['fallbackStage']) {
  if (candidateCount === 0) {
    return `这一轮原本会先抽${typeLabel}，但当前没有可进入抽取范围的事件。`;
  }
  if (fallbackStage === 'strict') {
    return `这一轮会先抽${typeLabel}，当前有 ${candidateCount} 个事件真正进入抽取范围。`;
  }
  if (fallbackStage === 'dedup-fallback') {
    return `这一轮会先抽${typeLabel}，但最近事件去重压缩了候选范围，最后保留 ${candidateCount} 个可抽事件。`;
  }
  return `这一轮会先抽${typeLabel}，普通范围已不够用，最后放宽限制保留 ${candidateCount} 个可抽事件。`;
}

function buildFilteredSummary(filteredCount: number, recentDedupCount: number) {
  if (filteredCount === 0) {
    return '这一轮没有事件被暂时排除。';
  }
  return `这一轮有 ${filteredCount} 个事件暂时没进入抽取范围，其中最近 ${recentDedupCount} 个刚抽过的事件会优先被避开。`;
}

function formatTransitionStage(stage: CategoryTransition['stage']) {
  if (stage === 'current') {
    return '当前这一轮';
  }
  if (stage === 'next') {
    return '下一轮';
  }
  return '下下轮';
}

function getStrongestRow(rows: ProbabilityRow[], selector: (row: ProbabilityRow) => number) {
  return rows.reduce<ProbabilityRow | null>((best, row) => {
    if (best == null || selector(row) > selector(best)) {
      return row;
    }
    return best;
  }, null);
}

function buildLongSessionSimulation(
  scenarioReports: ScenarioReport[],
  scenarioFiles: string[],
  sourceEventsByKey: Map<string, SourceEvent>,
  packLabelById: Map<number, string>,
  constants: {
    eventWeight: number;
    recentDedupCount: number;
    dedupMultiplier: number;
    forceRollSelflessGiveaway: number;
    cheatCardCountingForceRoll: number;
    gamblerShortInvestmentForceCount: number;
    gamblerLongInvestmentForceRoll: number;
    gamblerLongInvestmentForceCount: number;
    gamblerWinnerTakeAllPoolMin: number;
    gamblerWinnerTakeAllPlayerStacksMin: number;
  }
): EventAllocationSessionSimulation {
  const sourceEvents = Array.from(sourceEventsByKey.values());
  const scenarios = scenarioReports.map((scenarioReport, index) => {
    const scenarioPath = scenarioReport.scenarioPath ? path.resolve(REPO_ROOT, scenarioReport.scenarioPath) : scenarioFiles[index];
    const meta = prettifyScenarioInfo(scenarioPath);
    const enabledEventKeys = scenarioReport.enabledEventKeys ? new Set(scenarioReport.enabledEventKeys) : null;
    const eventStats = new Map(sourceEvents.map((eventItem) => [eventItem.key, { seenCount: 0, cycleCount: 0 }]));
    let totalCycles = 0;

    for (let runIndex = 0; runIndex < SESSION_SIMULATION_RUNS; runIndex += 1) {
      const rng = createRng(scenarioReport.seed + SESSION_SIMULATION_SEED_OFFSET + runIndex * 7919);
      const playerState = {
        ...scenarioReport.playerState,
        eventLastKeys: [...scenarioReport.playerState.eventLastKeys]
      };
      let jackpotStacks = scenarioReport.jackpotStacks;
      const seenEvents = new Set<string>();
      let elapsedSeconds = 0;

      while (elapsedSeconds < SESSION_SIMULATION_DURATION_SECONDS) {
        elapsedSeconds += SESSION_WAIT_MIN_SECONDS + Math.floor(rng() * (SESSION_WAIT_MAX_SECONDS - SESSION_WAIT_MIN_SECONDS + 1));
        const outcome = resolveCategoryOutcome(playerState, rng);
        const candidatePool = buildCandidatePool(sourceEvents, outcome.type, playerState, jackpotStacks, enabledEventKeys, constants);
        if (candidatePool.candidates.length === 0) {
          const nextCategory = applyClearPlayerEventCategoryUpdate(playerState.categoryRoll, playerState.categoryRollSnapshot, rng);
          playerState.categoryRoll = nextCategory.categoryRoll;
          playerState.categoryRollSnapshot = nextCategory.categoryRollSnapshot;
          continue;
        }
        const selectedEvent = chooseEventWithRejectSampling(candidatePool.candidates, constants.eventWeight, rng) as SourceEvent;
        const sourceEvent = sourceEventsByKey.get(selectedEvent.key);
        if (!sourceEvent) {
          throw new Error(`Missing source event for long session simulation: ${selectedEvent.key}`);
        }

        eventStats.get(sourceEvent.key)!.cycleCount += 1;
        seenEvents.add(sourceEvent.key);
        totalCycles += 1;
        elapsedSeconds += sourceEvent.durationSec;
        advanceLongSessionPlayerState(sourceEvent, playerState, constants, rng);
        if (sourceEvent.key === 'GAMBLER_WINNER_TAKE_ALL') {
          jackpotStacks = 0;
        } else if (
          sourceEvent.key === 'GAMBLER' ||
          sourceEvent.key === 'GAMBLER_HEART_OF_STEEL' ||
          sourceEvent.key === 'GAMBLER_ALL_IN_ART_5' ||
          sourceEvent.key === 'GAMBLER_DICE_MANIAC'
        ) {
          jackpotStacks = Math.max(jackpotStacks, constants.gamblerWinnerTakeAllPoolMin);
        }
      }

      seenEvents.forEach((eventKey) => {
        eventStats.get(eventKey)!.seenCount += 1;
      });
    }

    const eventSummaries = sourceEvents
      .map((eventItem) => {
        const stats = eventStats.get(eventItem.key)!;
        const atLeastOnceProbability = stats.seenCount / SESSION_SIMULATION_RUNS;
        const metaRow = getEventDisplayMeta(eventItem.key, eventItem.type, sourceEventsByKey, packLabelById);
        return {
          key: eventItem.key,
          eventNameZh: metaRow.eventNameZh,
          eventTypeLabelZh: metaRow.eventTypeLabelZh,
          packLabelZh: metaRow.packLabelZh,
          atLeastOnceProbability,
          atLeastOnceProbabilityPercent: formatPercent(atLeastOnceProbability),
          expectedCycleCount: stats.cycleCount / SESSION_SIMULATION_RUNS,
          probabilityTierLabel: getProbabilityTierLabel(atLeastOnceProbability),
          sortValue: atLeastOnceProbability
        } satisfies EventAllocationSessionEventSummary;
      })
      .sort((left, right) => right.sortValue - left.sortValue || left.eventNameZh.localeCompare(right.eventNameZh, 'zh-Hans-CN'));

    const typeSummaries = (['buff', 'debuff', 'mech'] as EventType[]).map((type) => {
      const rows = eventSummaries.filter((item) => sourceEventsByKey.get(item.key)?.type === type);
      const averageAtLeastOnceProbability = rows.length
        ? rows.reduce((sum, item) => sum + item.atLeastOnceProbability, 0) / rows.length
        : 0;
      return {
        type,
        typeLabel: getTypeLabel(type),
        averageAtLeastOnceProbability,
        averageAtLeastOnceProbabilityPercent: formatPercent(averageAtLeastOnceProbability),
        highestEvent: rows[0] ?? null,
        lowestEvent: rows[rows.length - 1] ?? null
      } satisfies EventAllocationSessionTypeSummary;
    });

    const estimatedCycleCount = totalCycles / SESSION_SIMULATION_RUNS;
    return {
      id: meta.id,
      label: meta.label,
      description: meta.description,
      estimatedCycleCount,
      estimatedCycleCountLabel: `约 ${Math.round(estimatedCycleCount)} 轮`,
      eventSummaries,
      typeSummaries,
      assumptions: [
        '口径：4 小时单局',
        '节奏：30~35 秒等待 + 当前事件持续时间',
        '玩家：普通进行中状态'
      ],
      searchText: [
        meta.id,
        meta.label,
        meta.description,
        typeSummaries.map((item) => item.typeLabel).join('|'),
        eventSummaries.map((item) => `${item.eventNameZh}|${item.eventTypeLabelZh}|${item.packLabelZh}|${item.probabilityTierLabel}`).join('|')
      ]
        .join('|')
        .toLocaleLowerCase()
    } satisfies EventAllocationSessionScenarioSummary;
  });

  return {
    durationHours: SESSION_SIMULATION_DURATION_HOURS,
    durationLabel: `${SESSION_SIMULATION_DURATION_HOURS} h`,
    baselineScenarioId: scenarios.find((scenario) => scenario.id === 'prod-default')?.id ?? scenarios[0]?.id ?? 'prod-default',
    scenarios
  };
}

function buildAlerts(staticSummary: EventAllocationStaticSummary[], scenarios: EventAllocationScenarioView[]): EventAllocationAlert[] {
  const alerts: EventAllocationAlert[] = [];
  const strongestUplift = staticSummary
    .map((summary) => ({
      typeLabel: summary.typeLabel,
      row: summary.strongestUpliftRow
    }))
    .filter((item) => item.row != null)
    .sort((left, right) => right.row!.deltaProbability - left.row!.deltaProbability)[0];
  if (strongestUplift?.row) {
    alerts.push({
      id: 'strongest-low-weight-uplift',
      severity: 'warn',
      title: '低权重事件更容易被抬高',
      summary: `${strongestUplift.typeLabel}里的低权重事件，在当前算法下会比按权重时更常出现。`,
      evidence: `${strongestUplift.row.eventNameZh} 当前出现率 ${strongestUplift.row.currentChancePercent}，比按权重多出 ${strongestUplift.row.extraChancePercent}。`
    });
  }

  const strongestFallback = staticSummary
    .map((summary) => ({
      typeLabel: summary.typeLabel,
      row: summary.strongestFallbackRow
    }))
    .filter((item) => item.row != null)
    .sort((left, right) => right.row!.fallbackProbability - left.row!.fallbackProbability)[0];
  if (strongestFallback?.row) {
    alerts.push({
      id: 'strongest-fallback-mass',
      severity: 'info',
      title: '保底抬升会明显影响少数事件',
      summary: `${strongestFallback.typeLabel}里有些事件的出现率，主要是被保底机制托上去的。`,
      evidence: `${strongestFallback.row.eventNameZh} 的保底抬升占到 ${strongestFallback.row.safetyLiftPercent}。`
    });
  }

  const persistedScenario = scenarios.find((scenario) => scenario.categoryTransitions[1]?.source === 'category-roll');
  if (persistedScenario) {
    alerts.push({
      id: 'category-roll-persists',
      severity: 'warn',
      title: '类别倾向会连续影响下一轮',
      summary: '同一类事件的倾向，不一定只影响当前这一轮。',
      evidence: persistedScenario.transitionSummary
    });
  }

  const compressedScenario = scenarios.find((scenario) => scenario.candidatePool.filtered.some((item) => item.reasons.includes('recent-dedup')));
  if (compressedScenario) {
    alerts.push({
      id: 'recent-dedup-compression',
      severity: 'info',
      title: '最近抽过的事件会先被排除',
      summary: '去重窗口会明显缩小这一轮真正可抽到的范围。',
      evidence: compressedScenario.filteredSummary
    });
  }

  return alerts;
}

export async function buildEventAllocationReportData(options: {
  sourceFile?: string;
  constantsFile?: string;
  scenarioFiles?: string[];
} = {}): Promise<EventAllocationHtmlData> {
  const { sourceFile, constantsFile, sourceData, packs, constants } = await loadSharedAnalysisInputs(options);
  const staticReport = await analyzeStaticEventAllocation(options);
  const scenarioFiles = options.scenarioFiles ?? (await resolveScenarioFiles());
  const scenarioReports = await Promise.all(scenarioFiles.map((scenarioFile) => analyzeScenarioEventAllocation(scenarioFile, options)));
  const sourceEventsByKey = new Map((sourceData.events as SourceEvent[]).map((eventItem) => [eventItem.key, eventItem]));
  const packLabelById = new Map((packs as SourcePack[]).map((pack) => [pack.id, pack.labelZh]));

  const staticSummary: EventAllocationStaticSummary[] = staticReport.reports.map((report) => {
    const topRows = report.topRows.map((row) => buildDisplayRow(row, report.type, sourceEventsByKey, packLabelById));
    const lowWeightRows = report.lowWeightRows.map((row) => buildDisplayRow(row, report.type, sourceEventsByKey, packLabelById));
    const strongestUplift = getStrongestRow(report.lowWeightRows, (row) => row.deltaProbability);
    const strongestFallback = getStrongestRow(report.lowWeightRows, (row) => row.fallbackProbability);
    return {
      type: report.type,
      typeLabel: getTypeLabel(report.type),
      candidateCount: report.candidateCount,
      acceptanceAverage: report.acceptanceAverage,
      acceptanceAveragePercent: formatPercent(report.acceptanceAverage),
      poolSummary: buildCandidatePoolSummary(getTypeLabel(report.type), report.candidateCount, report.fallbackStage),
      topRows,
      lowWeightRows,
      strongestUpliftRow: strongestUplift ? buildDisplayRow(strongestUplift, report.type, sourceEventsByKey, packLabelById) : null,
      strongestFallbackRow: strongestFallback ? buildDisplayRow(strongestFallback, report.type, sourceEventsByKey, packLabelById) : null
    };
  });

  const scenarios: EventAllocationScenarioView[] = scenarioReports.map((scenarioReport, index) => {
    const scenarioPath = scenarioReport.scenarioPath ? path.resolve(REPO_ROOT, scenarioReport.scenarioPath) : scenarioFiles[index];
    const meta = prettifyScenarioInfo(scenarioPath);
    const categoryTransitions = scenarioReport.categoryTransitions.map((transition) => ({
      ...transition,
      typeLabel: getTypeLabel(transition.type),
      sourceLabel: getTransitionSourceLabel(transition.source)
    }));
    const candidateEvents = scenarioReport.candidatePool.candidateKeys.map((key) => ({
      key,
      ...getEventDisplayMeta(key, scenarioReport.candidatePool.type, sourceEventsByKey, packLabelById)
    }));
    const filtered = scenarioReport.candidatePool.filtered.map((item) => ({
      ...item,
      ...getEventDisplayMeta(item.key, scenarioReport.candidatePool.type, sourceEventsByKey, packLabelById),
      reasonLabels: mapReasonLabels(item.reasons),
      reasonSummary: mapReasonLabels(item.reasons).join('、')
    }));
    const topRows = scenarioReport.probabilities.topRows.map((row) =>
      buildDisplayRow(row, scenarioReport.selectedType, sourceEventsByKey, packLabelById)
    );
    const lowWeightRows = scenarioReport.probabilities.lowWeightRows.map((row) =>
      buildDisplayRow(row, scenarioReport.selectedType, sourceEventsByKey, packLabelById)
    );
    const selectedTypeLabel = getTypeLabel(scenarioReport.selectedType);
    const selectedTypeSummary = `这个场景会先从${selectedTypeLabel}事件里抽取。`;
    const candidatePoolSummary = buildCandidatePoolSummary(
      selectedTypeLabel,
      candidateEvents.length,
      scenarioReport.candidatePool.fallbackStage
    );
    const transitionSummary = buildTransitionSummary(categoryTransitions);
    const filteredSummary = buildFilteredSummary(filtered.length, staticReport.recentDedupCount);
    return {
      id: meta.id,
      label: meta.label,
      description: meta.description,
      scenarioPath: scenarioReport.scenarioPath,
      selectedType: scenarioReport.selectedType,
      selectedTypeLabel,
      iterations: scenarioReport.iterations,
      selectedTypeSummary,
      candidatePoolSummary,
      transitionSummary,
      filteredSummary,
      categoryTransitions,
      candidatePool: {
        type: scenarioReport.candidatePool.type,
        typeLabel: getTypeLabel(scenarioReport.candidatePool.type),
        eventNames: candidateEvents.map((item) => item.eventNameZh),
        events: candidateEvents,
        filtered,
        filteredCount: filtered.length
      },
      probabilities: {
        topRows,
        lowWeightRows
      },
      searchText: [
        meta.label,
        meta.description,
        selectedTypeSummary,
        candidatePoolSummary,
        transitionSummary,
        filteredSummary,
        candidateEvents.map((item) => item.nameWithKeyFallback).join('|'),
        filtered.map((item) => `${item.nameWithKeyFallback}|${item.reasonSummary}`).join('|')
      ]
        .join('|')
        .toLocaleLowerCase()
    };
  });
  const sessionSimulation = buildLongSessionSimulation(scenarioReports, scenarioFiles, sourceEventsByKey, packLabelById, constants);

  const scenariosWithSessionSearch = scenarios.map((scenario) => {
    const sessionScenario = sessionSimulation.scenarios.find((item) => item.id === scenario.id);
    if (!sessionScenario) {
      return scenario;
    }
    return {
      ...scenario,
      searchText: `${scenario.searchText}|${sessionScenario.searchText}`
    };
  });

  return {
    meta: {
      reportVersion: REPORT_VERSION,
      sourceFile: path.relative(REPO_ROOT, sourceFile),
      constantsFile: path.relative(REPO_ROOT, constantsFile),
      generatedAt: new Date().toISOString(),
      eventWeight: staticReport.eventWeight,
      recentDedupCount: staticReport.recentDedupCount,
      scenarioCount: scenarios.length
    },
    alerts: buildAlerts(staticSummary, scenariosWithSessionSearch),
    staticSummary,
    sessionSimulation,
    scenarios: scenariosWithSessionSearch
  };
}

function formatPercent(value: number) {
  return `${(value * 100).toFixed(2)}%`;
}

function colorize(enabled: boolean, color: string, text: string) {
  return enabled ? `${color}${text}${ANSI.reset}` : text;
}

function renderProbabilityRow(row: ProbabilityRow) {
  const name = (row as EventAllocationDisplayRow).eventNameZh ?? row.key;
  return `${name.padEnd(16)} 当前 ${formatPercent(row.currentProbability).padStart(8)} / 按权重 ${formatPercent(row.referenceProbability).padStart(
    8
  )} / 高出 ${formatPercent(row.deltaProbability).padStart(8)} / 保底抬升 ${formatPercent(row.fallbackProbability).padStart(8)}`;
}

function renderOverviewPage(report: EventAllocationHtmlData, useAnsi: boolean, filterText: string) {
  const filteredAlerts = report.alerts.filter((alert) => {
    if (!filterText) {
      return true;
    }
    const haystack = `${alert.title}|${alert.summary}|${alert.evidence}`.toLowerCase();
    return haystack.includes(filterText.toLowerCase());
  });

  const lines = [
    colorize(useAnsi, ANSI.bold, '总览'),
    `当前共准备了 ${report.meta.scenarioCount} 个预置场景，最近会避开 ${report.meta.recentDedupCount} 个刚抽过的事件。`,
    ''
  ];

  if (!filteredAlerts.length) {
    lines.push('没有匹配当前过滤词的告警。');
  } else {
    filteredAlerts.forEach((alert, index) => {
      const prefix = alert.severity === 'warn' ? colorize(useAnsi, ANSI.yellow, 'WARN') : colorize(useAnsi, ANSI.blue, 'INFO');
      lines.push(`${String(index + 1).padStart(2)}. [${prefix}] ${alert.title}`);
      lines.push(`    ${alert.summary}`);
      lines.push(`    ${alert.evidence}`);
    });
  }

  lines.push('', colorize(useAnsi, ANSI.bold, '三类事件概览'));
  report.staticSummary.forEach((summary) => {
    lines.push(`${summary.typeLabel.padEnd(4)} ${summary.poolSummary}`);
  });
  const baselineSession = report.sessionSimulation.scenarios.find((scenario) => scenario.id === report.sessionSimulation.baselineScenarioId);
  if (baselineSession) {
    lines.push('', colorize(useAnsi, ANSI.bold, '4 小时长局模拟'));
    lines.push(`基线场景：${baselineSession.label} · ${baselineSession.estimatedCycleCountLabel}`);
    lines.push(`最高事件：${baselineSession.eventSummaries[0]?.eventNameZh ?? '暂无'} ${baselineSession.eventSummaries[0]?.atLeastOnceProbabilityPercent ?? ''}`.trim());
    lines.push(
      `最低事件：${baselineSession.eventSummaries[baselineSession.eventSummaries.length - 1]?.eventNameZh ?? '暂无'} ${
        baselineSession.eventSummaries[baselineSession.eventSummaries.length - 1]?.atLeastOnceProbabilityPercent ?? ''
      }`.trim()
    );
  }
  return lines.join('\n');
}

function renderStaticPage(report: EventAllocationHtmlData, useAnsi: boolean, selectedIndex: number) {
  const summary = report.staticSummary[selectedIndex] ?? report.staticSummary[0];
  const lines = [
    colorize(useAnsi, ANSI.bold, `静态对比 · ${summary.typeLabel}`),
    `${summary.poolSummary} 平均接受率 ${summary.acceptanceAveragePercent}。`,
    '',
    colorize(useAnsi, ANSI.orange, '最常出现的事件')
  ];
  summary.topRows.forEach((row) => lines.push(renderProbabilityRow(row)));
  lines.push('', colorize(useAnsi, ANSI.blue, '最容易被额外抬高的低权重事件'));
  summary.lowWeightRows.forEach((row) => lines.push(renderProbabilityRow(row)));
  return lines.join('\n');
}

function renderScenarioPage(report: EventAllocationHtmlData, useAnsi: boolean, selectedScenarioId: string | null, filterText: string) {
  const filteredScenarios = report.scenarios.filter((scenario) => {
    if (!filterText) {
      return true;
    }
    return scenario.searchText.includes(filterText.toLowerCase());
  });
  const active = filteredScenarios.find((scenario) => scenario.id === selectedScenarioId) ?? filteredScenarios[0] ?? null;

  const lines = [colorize(useAnsi, ANSI.bold, '场景浏览')];
  if (!active) {
    lines.push('没有匹配当前过滤词的场景。');
    return lines.join('\n');
  }

  lines.push(`${active.label} · ${active.description}`);
  lines.push(active.selectedTypeSummary);
  lines.push('');
  lines.push(colorize(useAnsi, ANSI.orange, '类别倾向如何连续影响后续事件'));
  lines.push(active.transitionSummary);
  active.categoryTransitions.forEach((transition) => {
    lines.push(`${formatTransitionStage(transition.stage).padEnd(8)} ${transition.sourceLabel.padEnd(12)} -> ${transition.typeLabel}`);
  });
  lines.push('');
  lines.push(colorize(useAnsi, ANSI.blue, '本轮可能抽到哪些事件'));
  lines.push(active.candidatePoolSummary);
  lines.push(`可抽事件：${active.candidatePool.events.map((item) => item.eventNameZh).join('、') || '暂无'}`);
  if (active.candidatePool.filtered.length) {
    lines.push('');
    lines.push(colorize(useAnsi, ANSI.magenta, '本轮没进入抽取范围的事件'));
    lines.push(active.filteredSummary);
    active.candidatePool.filtered.slice(0, 8).forEach((item) => {
      lines.push(`- ${item.eventNameZh}: ${item.reasonSummary}`);
    });
  }
  lines.push('', colorize(useAnsi, ANSI.magenta, '最常出现的事件'));
  active.probabilities.topRows.slice(0, 5).forEach((row) => lines.push(renderProbabilityRow(row)));
  lines.push('', colorize(useAnsi, ANSI.green, '最容易被额外抬高的低权重事件'));
  active.probabilities.lowWeightRows.slice(0, 5).forEach((row) => lines.push(renderProbabilityRow(row)));
  return lines.join('\n');
}

export function renderTuiFrame(report: EventAllocationHtmlData, state: TuiState, useAnsi = false) {
  const pageTitles = ['总览', '静态对比', '场景浏览'];
  const header = [
    colorize(useAnsi, ANSI.bold, '事件分配报告'),
    `${pageTitles
      .map((title, index) => (index === state.pageIndex ? colorize(useAnsi, ANSI.orange, `[${title}]`) : title))
      .join('  ')}`,
    `筛选：${state.filterText || '无'} ${state.filterMode ? '(输入中)' : ''}`,
    colorize(useAnsi, ANSI.dim, 'keys: h/l page  j/k move  [/ ] scenario  / filter  q quit'),
    ''
  ];

  let body = '';
  if (state.pageIndex === 0) {
    body = renderOverviewPage(report, useAnsi, state.filterText);
  } else if (state.pageIndex === 1) {
    body = renderStaticPage(report, useAnsi, state.selectedStaticIndex);
  } else {
    body = renderScenarioPage(report, useAnsi, state.activeScenarioId, state.filterText);
  }

  return `${header.join('\n')}${body}`;
}

export function renderNonTtySummary(report: EventAllocationHtmlData) {
  return [renderOverviewPage(report, false, ''), '', renderStaticPage(report, false, 0), '', renderScenarioPage(report, false, report.scenarios[0]?.id ?? null, '')].join(
    '\n'
  );
}

async function runInteractiveTui(report: EventAllocationHtmlData, initialScenarioId: string | null) {
  const stdin = process.stdin;
  const stdout = process.stdout;
  const state: TuiState = {
    pageIndex: 0,
    selectedScenarioIndex: 0,
    selectedStaticIndex: 0,
    selectedAlertIndex: 0,
    filterText: '',
    filterMode: false,
    activeScenarioId: initialScenarioId ?? report.scenarios[0]?.id ?? null
  };

  function redraw() {
    stdout.write('\u001Bc');
    stdout.write(`${renderTuiFrame(report, state, true)}\n`);
  }

  function scenarioIds() {
    return report.scenarios.map((scenario) => scenario.id);
  }

  function moveScenario(step: number) {
    const ids = scenarioIds();
    if (!ids.length) {
      state.activeScenarioId = null;
      return;
    }
    const currentIndex = Math.max(ids.indexOf(state.activeScenarioId ?? ''), 0);
    const nextIndex = (currentIndex + step + ids.length) % ids.length;
    state.activeScenarioId = ids[nextIndex];
  }

  function cleanup() {
    if (typeof stdin.setRawMode === 'function') {
      stdin.setRawMode(false);
    }
    stdin.pause();
    stdout.write(`${ANSI.reset}\n`);
  }

  readline.emitKeypressEvents(stdin);
  if (typeof stdin.setRawMode === 'function') {
    stdin.setRawMode(true);
  }
  stdin.resume();
  redraw();

  await new Promise<void>((resolve) => {
    const handler = (_str: string, key: readline.Key) => {
      if (state.filterMode) {
        if (key.name === 'return' || key.name === 'escape') {
          state.filterMode = false;
          redraw();
          return;
        }
        if (key.name === 'backspace') {
          state.filterText = state.filterText.slice(0, -1);
          redraw();
          return;
        }
        if (key.sequence && key.sequence.length === 1 && !key.ctrl && !key.meta) {
          state.filterText += key.sequence;
          redraw();
        }
        return;
      }

      if (key.name === 'q' || (key.ctrl && key.name === 'c')) {
        stdin.off('keypress', handler);
        cleanup();
        resolve();
        return;
      }
      if (key.name === 'slash') {
        state.filterMode = true;
        redraw();
        return;
      }
      if (key.name === 'h' || key.name === 'left') {
        state.pageIndex = (state.pageIndex + 2) % 3;
        redraw();
        return;
      }
      if (key.name === 'l' || key.name === 'right') {
        state.pageIndex = (state.pageIndex + 1) % 3;
        redraw();
        return;
      }
      if (key.name === 'j' || key.name === 'down') {
        if (state.pageIndex === 1) {
          state.selectedStaticIndex = (state.selectedStaticIndex + 1) % report.staticSummary.length;
        } else if (state.pageIndex === 2) {
          moveScenario(1);
        }
        redraw();
        return;
      }
      if (key.name === 'k' || key.name === 'up') {
        if (state.pageIndex === 1) {
          state.selectedStaticIndex = (state.selectedStaticIndex + report.staticSummary.length - 1) % report.staticSummary.length;
        } else if (state.pageIndex === 2) {
          moveScenario(-1);
        }
        redraw();
        return;
      }
      if (key.sequence === '[') {
        moveScenario(-1);
        redraw();
        return;
      }
      if (key.sequence === ']') {
        moveScenario(1);
        redraw();
      }
    };

    stdin.on('keypress', handler);
  });
}

async function writeHtmlData(outputFile: string, report: EventAllocationHtmlData) {
  await fs.mkdir(path.dirname(outputFile), { recursive: true });
  await fs.writeFile(outputFile, `${JSON.stringify(report, null, 2)}\n`, 'utf8');
}

export async function main(rawArgs: string[]) {
  const options = parseArgs(rawArgs);
  if (options.format === 'json') {
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
    return;
  }

  if (options.format === 'html-data') {
    const report = await buildEventAllocationReportData({
      sourceFile: options.sourceFile,
      constantsFile: options.constantsFile
    });
    const outputFile = toAbsolute(path.join(REPO_ROOT, 'dummy'), options.outputFile, DEFAULT_REPORT_OUTPUT_FILE);
    await writeHtmlData(outputFile, report);
    console.log(`Wrote event allocation report to ${path.relative(REPO_ROOT, outputFile)}`);
    return;
  }

  const scenarioFiles = options.scenarioFile ? [toAbsolute(path.join(REPO_ROOT, 'dummy'), options.scenarioFile, options.scenarioFile)] : undefined;
  const report = await buildEventAllocationReportData({
    sourceFile: options.sourceFile,
    constantsFile: options.constantsFile,
    scenarioFiles
  });

  if (!process.stdout.isTTY || !process.stdin.isTTY) {
    console.log(renderNonTtySummary(report));
    return;
  }

  await runInteractiveTui(report, report.scenarios[0]?.id ?? null);
}
