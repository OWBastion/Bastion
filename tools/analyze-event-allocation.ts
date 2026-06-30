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
export const REPORT_VERSION = 'v2';

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

const FALLBACK_STAGE_LABELS = {
  strict: '严格候选池',
  'dedup-fallback': '去重回退',
  'force-roll-fallback': '强制抽取回退'
} as const;

const REASON_LABELS: Record<string, string> = {
  'disabled-by-scenario': '场景手动禁用',
  'inactive-source': '事件源未启用',
  'nonpositive-weight': '权重非正值',
  'temper-heart-used': 'TEMPER_HEART 已消费',
  'brave-act-hero-gated': 'BRAVE_ACT 被英雄顺序限制',
  'brave-act-once-state-gated': 'BRAVE_ACT 被一次性状态限制',
  'recent-dedup': '命中最近事件去重窗口',
  'force-roll-selfless-gated': 'SELFLESS_GIVEAWAY 被 force-roll 特判排除'
};

const BRAVE_ACT_STATE = {
  NEW: 0,
  DRAWN: 1,
  ACCEPTED: 2
} as const;

const SCENARIO_METADATA: Record<string, { id: string; label: string; description: string }> = {
  'prod-default.json': {
    id: 'prod-default',
    label: '默认生产候选池',
    description: '使用默认生产事件池和一个固定 Buff 类别 roll，观察基础分布与低权重 uplift。'
  },
  'recent-dedup-window.json': {
    id: 'recent-dedup-window',
    label: '最近事件去重窗口',
    description: '模拟最近 10 次 Buff 已填满的情况，确认 strict 候选池如何压缩。'
  },
  'temper-heart-used.json': {
    id: 'temper-heart-used',
    label: 'Temper Heart 已消费',
    description: '验证 once-state 会在候选池层直接排除 TEMPER_HEART。'
  },
  'brave-act-locked.json': {
    id: 'brave-act-locked',
    label: 'Brave Act 锁定',
    description: '验证 BRAVE_ACT 会因英雄顺序限制被过滤，并观察 categoryRoll 跨轮延续。'
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

export type ProbabilityRow = {
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
  detail: string;
};

export type EventAllocationScenarioView = {
  id: string;
  label: string;
  description: string;
  scenarioPath: string | null;
  selectedType: EventType;
  selectedTypeLabel: string;
  iterations: number;
  seed: number;
  playerState: Required<NonNullable<ScenarioInput['playerState']>>;
  categoryTransitions: Array<CategoryTransition & { typeLabel: string; sourceLabel: string }>;
  candidatePool: {
    type: EventType;
    typeLabel: string;
    fallbackStage: CandidatePoolResult['fallbackStage'];
    fallbackStageLabel: string;
    candidateKeys: string[];
    filtered: Array<FilterReason & { reasonLabels: string[] }>;
    filteredCount: number;
  };
  probabilities: {
    topRows: ProbabilityRow[];
    lowWeightRows: ProbabilityRow[];
  };
};

export type EventAllocationStaticSummary = {
  type: EventType;
  typeLabel: string;
  candidateCount: number;
  acceptanceAverage: number;
  fallbackStage: CandidatePoolResult['fallbackStage'];
  fallbackStageLabel: string;
  topRows: ProbabilityRow[];
  lowWeightRows: ProbabilityRow[];
  strongestUpliftRow: ProbabilityRow | null;
  strongestFallbackRow: ProbabilityRow | null;
};

export type EventAllocationHtmlData = {
  meta: {
    reportVersion: string;
    sourceFile: string;
    constantsFile: string;
    generatedAt: string;
    eventWeight: number;
    recentDedupCount: number;
    braveActMaxHeroOrderExclusive: number;
    scenarioCount: number;
  };
  alerts: EventAllocationAlert[];
  staticSummary: EventAllocationStaticSummary[];
  scenarios: EventAllocationScenarioView[];
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
  enabledEventKeys: Set<string> | null,
  config: {
    dedupMultiplier: number;
    braveActMaxHeroOrderExclusive: number;
    forceRollSelflessGiveaway: number;
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

async function loadSharedAnalysisInputs(options: { sourceFile?: string; constantsFile?: string } = {}) {
  const sourceFile = options.sourceFile ?? SOURCE_FILE;
  const constantsFile = options.constantsFile ?? CONSTANTS_FILE;
  const [sourceData, constantsSource] = await Promise.all([loadEventSource(sourceFile), fs.readFile(constantsFile, 'utf8')]);
  const constants = {
    eventWeight: parseDefineNumber(constantsSource, 'EVT_INIT_EVENT_WEIGHT'),
    recentDedupCount: parseDefineNumber(constantsSource, 'EVT_RECENT_EVENT_DEDUP_COUNT'),
    braveActMaxHeroOrderExclusive: parseDefineNumber(constantsSource, 'EVT_MECH_21_MAX_HERO_ORDER_EXCLUSIVE'),
    dedupMultiplier: parseDefineNumber(constantsSource, 'EVT_DEDUP_TYPE_MULTIPLIER'),
    forceRollSelflessGiveaway: parseDefineNumber(constantsSource, 'EVT_MECH_8_FORCE_ROLL')
  };

  return {
    sourceFile,
    constantsFile,
    events: sourceData.events as EventItem[],
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
    braveActMaxHeroOrderExclusive: constants.braveActMaxHeroOrderExclusive,
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

  const enabledEventKeys = scenario.enabledEventKeys ? new Set(scenario.enabledEventKeys) : null;
  const transitions = buildTransitions(playerState, seed);
  const selectedType = transitions[0].type;
  const candidatePool = buildCandidatePool(events, selectedType, playerState, enabledEventKeys, constants);
  const probabilities = computeProbabilityRows(candidatePool.candidates, constants.eventWeight);

  return {
    scenarioPath: path.relative(REPO_ROOT, absoluteScenarioFile),
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

function getFallbackStageLabel(stage: CandidatePoolResult['fallbackStage']) {
  return FALLBACK_STAGE_LABELS[stage];
}

function getTransitionSourceLabel(source: CategoryTransition['source']) {
  if (source === 'force-roll') {
    return '强制类别';
  }
  if (source === 'category-roll') {
    return '沿用 categoryRoll';
  }
  return 'clearPlayerEvent 重掷';
}

function mapReasonLabels(reasons: string[]) {
  return reasons.map((reason) => REASON_LABELS[reason] || reason);
}

function getStrongestRow(rows: ProbabilityRow[], selector: (row: ProbabilityRow) => number) {
  return rows.reduce<ProbabilityRow | null>((best, row) => {
    if (best == null || selector(row) > selector(best)) {
      return row;
    }
    return best;
  }, null);
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
      title: '低权重事件被兜底抬高',
      detail: `${strongestUplift.typeLabel} ${strongestUplift.row.key} 的 delta 为 ${formatPercent(strongestUplift.row.deltaProbability)}。`
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
      title: '拒绝采样兜底质量可见',
      detail: `${strongestFallback.typeLabel} ${strongestFallback.row.key} 的 fallback 贡献为 ${formatPercent(strongestFallback.row.fallbackProbability)}。`
    });
  }

  const persistedScenario = scenarios.find(
    (scenario) => scenario.categoryTransitions[1]?.source === 'category-roll' && scenario.categoryTransitions[0]?.roll !== scenario.categoryTransitions[1]?.roll
  );
  if (persistedScenario) {
    alerts.push({
      id: 'category-roll-persists',
      severity: 'warn',
      title: 'categoryRoll 会跨 1 轮延续',
      detail: `${persistedScenario.label} 中当前 roll ${formatShortNumber(
        persistedScenario.categoryTransitions[0].roll
      )} 会在下一轮继续影响类别。`
    });
  }

  const compressedScenario = scenarios.find((scenario) => scenario.candidatePool.filtered.some((item) => item.reasons.includes('recent-dedup')));
  if (compressedScenario) {
    alerts.push({
      id: 'recent-dedup-compression',
      severity: 'info',
      title: '去重窗口会显著压缩候选池',
      detail: `${compressedScenario.label} 中共有 ${compressedScenario.candidatePool.filteredCount} 个事件被过滤，其中包含 recent dedup。`
    });
  }

  return alerts;
}

export async function buildEventAllocationReportData(options: {
  sourceFile?: string;
  constantsFile?: string;
  scenarioFiles?: string[];
} = {}): Promise<EventAllocationHtmlData> {
  const { sourceFile, constantsFile } = await loadSharedAnalysisInputs(options);
  const staticReport = await analyzeStaticEventAllocation(options);
  const scenarioFiles = options.scenarioFiles ?? (await resolveScenarioFiles());
  const scenarioReports = await Promise.all(scenarioFiles.map((scenarioFile) => analyzeScenarioEventAllocation(scenarioFile, options)));

  const staticSummary: EventAllocationStaticSummary[] = staticReport.reports.map((report) => {
    const strongestUpliftRow = getStrongestRow(report.lowWeightRows, (row) => row.deltaProbability);
    const strongestFallbackRow = getStrongestRow(report.lowWeightRows, (row) => row.fallbackProbability);
    return {
      type: report.type,
      typeLabel: getTypeLabel(report.type),
      candidateCount: report.candidateCount,
      acceptanceAverage: report.acceptanceAverage,
      fallbackStage: report.fallbackStage,
      fallbackStageLabel: getFallbackStageLabel(report.fallbackStage),
      topRows: report.topRows,
      lowWeightRows: report.lowWeightRows,
      strongestUpliftRow,
      strongestFallbackRow
    };
  });

  const scenarios: EventAllocationScenarioView[] = scenarioReports.map((scenarioReport, index) => {
    const scenarioPath = scenarioReport.scenarioPath ? path.resolve(REPO_ROOT, scenarioReport.scenarioPath) : scenarioFiles[index];
    const meta = prettifyScenarioInfo(scenarioPath);
    return {
      id: meta.id,
      label: meta.label,
      description: meta.description,
      scenarioPath: scenarioReport.scenarioPath,
      selectedType: scenarioReport.selectedType,
      selectedTypeLabel: getTypeLabel(scenarioReport.selectedType),
      iterations: scenarioReport.iterations,
      seed: scenarioReport.seed,
      playerState: scenarioReport.playerState,
      categoryTransitions: scenarioReport.categoryTransitions.map((transition) => ({
        ...transition,
        typeLabel: getTypeLabel(transition.type),
        sourceLabel: getTransitionSourceLabel(transition.source)
      })),
      candidatePool: {
        type: scenarioReport.candidatePool.type,
        typeLabel: getTypeLabel(scenarioReport.candidatePool.type),
        fallbackStage: scenarioReport.candidatePool.fallbackStage,
        fallbackStageLabel: getFallbackStageLabel(scenarioReport.candidatePool.fallbackStage),
        candidateKeys: scenarioReport.candidatePool.candidateKeys,
        filtered: scenarioReport.candidatePool.filtered.map((item) => ({
          ...item,
          reasonLabels: mapReasonLabels(item.reasons)
        })),
        filteredCount: scenarioReport.candidatePool.filtered.length
      },
      probabilities: scenarioReport.probabilities
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
      braveActMaxHeroOrderExclusive: staticReport.braveActMaxHeroOrderExclusive,
      scenarioCount: scenarios.length
    },
    alerts: buildAlerts(staticSummary, scenarios),
    staticSummary,
    scenarios
  };
}

function formatPercent(value: number) {
  return `${(value * 100).toFixed(2)}%`;
}

function formatShortNumber(value: number) {
  return Number(value.toFixed(3)).toString();
}

function colorize(enabled: boolean, color: string, text: string) {
  return enabled ? `${color}${text}${ANSI.reset}` : text;
}

function renderProbabilityRow(row: ProbabilityRow) {
  return `${row.key.padEnd(24)} w=${row.weight.toFixed(2).padStart(4)} cur=${formatPercent(row.currentProbability).padStart(8)} ref=${formatPercent(
    row.referenceProbability
  ).padStart(8)} Δ=${formatPercent(row.deltaProbability).padStart(8)} fb=${formatPercent(row.fallbackProbability).padStart(8)}`;
}

function renderOverviewPage(report: EventAllocationHtmlData, useAnsi: boolean, filterText: string) {
  const filteredAlerts = report.alerts.filter((alert) => {
    if (!filterText) {
      return true;
    }
    const haystack = `${alert.title}|${alert.detail}`.toLowerCase();
    return haystack.includes(filterText.toLowerCase());
  });

  const lines = [
    colorize(useAnsi, ANSI.bold, 'Overview'),
    `eventWeight=${report.meta.eventWeight} recentDedup=${report.meta.recentDedupCount} scenarios=${report.meta.scenarioCount}`,
    ''
  ];

  if (!filteredAlerts.length) {
    lines.push('没有匹配当前过滤词的告警。');
  } else {
    filteredAlerts.forEach((alert, index) => {
      const prefix = alert.severity === 'warn' ? colorize(useAnsi, ANSI.yellow, 'WARN') : colorize(useAnsi, ANSI.blue, 'INFO');
      lines.push(`${String(index + 1).padStart(2)}. [${prefix}] ${alert.title}`);
      lines.push(`    ${alert.detail}`);
    });
  }

  lines.push('', colorize(useAnsi, ANSI.bold, 'Static Summary'));
  report.staticSummary.forEach((summary) => {
    lines.push(
      `${summary.typeLabel.padEnd(4)} candidates=${String(summary.candidateCount).padStart(2)} accept=${formatPercent(
        summary.acceptanceAverage
      ).padStart(8)} fallback=${summary.fallbackStageLabel}`
    );
  });
  return lines.join('\n');
}

function renderStaticPage(report: EventAllocationHtmlData, useAnsi: boolean, selectedIndex: number) {
  const summary = report.staticSummary[selectedIndex] ?? report.staticSummary[0];
  const lines = [
    colorize(useAnsi, ANSI.bold, `Static Comparison · ${summary.typeLabel}`),
    `candidates=${summary.candidateCount} accept=${formatPercent(summary.acceptanceAverage)} fallback=${summary.fallbackStageLabel}`,
    '',
    colorize(useAnsi, ANSI.orange, 'Top Rows')
  ];
  summary.topRows.forEach((row) => lines.push(renderProbabilityRow(row)));
  lines.push('', colorize(useAnsi, ANSI.blue, 'Low-weight Uplift Rows'));
  summary.lowWeightRows.forEach((row) => lines.push(renderProbabilityRow(row)));
  return lines.join('\n');
}

function renderScenarioPage(report: EventAllocationHtmlData, useAnsi: boolean, selectedScenarioId: string | null, filterText: string) {
  const filteredScenarios = report.scenarios.filter((scenario) => {
    if (!filterText) {
      return true;
    }
    const haystack = [
      scenario.label,
      scenario.description,
      scenario.selectedTypeLabel,
      scenario.candidatePool.candidateKeys.join('|'),
      scenario.candidatePool.filtered.map((item) => `${item.key}|${item.reasons.join('|')}`).join('|')
    ]
      .join('|')
      .toLowerCase();
    return haystack.includes(filterText.toLowerCase());
  });
  const active = filteredScenarios.find((scenario) => scenario.id === selectedScenarioId) ?? filteredScenarios[0] ?? null;

  const lines = [colorize(useAnsi, ANSI.bold, 'Scenario Explorer')];
  if (!active) {
    lines.push('没有匹配当前过滤词的场景。');
    return lines.join('\n');
  }

  lines.push(`${active.label} · ${active.description}`);
  lines.push(`selectedType=${active.selectedTypeLabel} fallback=${active.candidatePool.fallbackStageLabel}`);
  lines.push('');
  lines.push(colorize(useAnsi, ANSI.orange, 'Category Transitions'));
  active.categoryTransitions.forEach((transition) => {
    lines.push(
      `${transition.stage.padEnd(8)} ${transition.sourceLabel.padEnd(18)} roll=${formatShortNumber(transition.roll).padStart(8)} => ${transition.typeLabel}`
    );
  });
  lines.push('');
  lines.push(colorize(useAnsi, ANSI.blue, 'Candidate Pool'));
  lines.push(`candidates=${active.candidatePool.candidateKeys.join(', ') || '(empty)'}`);
  if (active.candidatePool.filtered.length) {
    lines.push('filtered:');
    active.candidatePool.filtered.slice(0, 8).forEach((item) => {
      lines.push(`- ${item.key}: ${item.reasonLabels.join(' / ')}`);
    });
  } else {
    lines.push('filtered: none');
  }
  lines.push('', colorize(useAnsi, ANSI.magenta, 'Top Rows'));
  active.probabilities.topRows.slice(0, 5).forEach((row) => lines.push(renderProbabilityRow(row)));
  lines.push('', colorize(useAnsi, ANSI.green, 'Low-weight Rows'));
  active.probabilities.lowWeightRows.slice(0, 5).forEach((row) => lines.push(renderProbabilityRow(row)));
  return lines.join('\n');
}

export function renderTuiFrame(report: EventAllocationHtmlData, state: TuiState, useAnsi = false) {
  const pageTitles = ['Overview', 'Static', 'Scenario'];
  const header = [
    colorize(useAnsi, ANSI.bold, 'Event Allocation Analyzer'),
    `${pageTitles
      .map((title, index) => (index === state.pageIndex ? colorize(useAnsi, ANSI.orange, `[${title}]`) : title))
      .join('  ')}`,
    `filter=${state.filterText || '(none)'} ${state.filterMode ? '(input mode)' : ''}`,
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
