import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import path from 'node:path';
import test from 'node:test';
import { compile, OverPyCompiler, readyPromise } from 'overpy';

const read = (file: string) => readFile(new URL(`../${file}`, import.meta.url), 'utf8');

type Ast = {
  name: string;
  args: Ast[];
  children: Ast[];
  numValue?: number;
  ruleAttributes?: { subroutineName?: string };
};

type CandidatePoolState = {
  globals: Record<string, unknown>;
  player: Record<string, unknown>;
};

let productionCandidatePoolRule: Promise<Ast> | undefined;

function getProductionCandidatePoolRule() {
  productionCandidatePoolRule ??= (async () => {
    await readyPromise;
    let rules: Ast[] | undefined;
    const compileRules = OverPyCompiler.prototype.compileRules;
    OverPyCompiler.prototype.compileRules = function (astRules: Ast[]) {
      rules = astRules;
      return compileRules.call(this, astRules);
    };

    try {
      await compile('#!mainFile "main.opy"\n', 'en-US', path.resolve('src'), 'main.opy');
    } finally {
      OverPyCompiler.prototype.compileRules = compileRules;
    }

    const rule = rules?.find((item) => item.ruleAttributes?.subroutineName === 'buildCandidatePool');
    if (!rule) {
      throw new Error('buildCandidatePool rule was not compiled');
    }
    return rule;
  })();
  return productionCandidatePoolRule;
}

function evaluate(node: Ast, state: CandidatePoolState, current?: unknown): unknown {
  if (node.args.length === 0 && node.numValue != null) {
    return node.numValue;
  }
  if (['==', '!=', '<', '<=', '>', '>='].includes(node.name)) {
    return node.name;
  }
  if (node.name === 'true') {
    return true;
  }
  if (node.name === 'null') {
    return null;
  }
  if (node.name === 'eventPlayer') {
    return state.player;
  }
  if (node.name === '__currentArrayElement__') {
    return current;
  }
  if (node.name === '__number__') {
    return evaluate(node.args[0], state, current);
  }
  if (node.name === '__globalVar__') {
    return state.globals[node.args[0].name];
  }
  if (node.name === '__playerVar__') {
    return state.player[node.args[1].name];
  }
  if (node.name === '__hero__') {
    return node.args[0].name;
  }
  if (node.name === '.getHero') {
    return state.player.hero;
  }
  if (node.name === '__filteredArray__') {
    return (evaluate(node.args[0], state, current) as unknown[]).filter((item) => evaluate(node.args[1], state, item));
  }

  const args = node.args.map((arg) => evaluate(arg, state, current));
  switch (node.name) {
    case '__valueInArray__':
      if (args[0] == null) {
        throw new Error(`Expected an array in __valueInArray__ (${node.args[0].name}, ${node.args[1].name})`);
      }
      return (args[0] as unknown[])[Number(args[1])];
    case '__compare__':
      {
        const nullablePlayerVariables = new Set(['eventForceRoll', 'eventLastId', 'playerOnceEventState']);
        const left = args[0];
        const right = node.args[2].name === 'null' && !nullablePlayerVariables.has(node.args[0].args[1]?.name)
          ? 0
          : args[2];
        return ({ '==': left === right, '!=': left !== right, '<': (left as number) < (right as number), '<=': (left as number) <= (right as number), '>': (left as number) > (right as number), '>=': (left as number) >= (right as number) } as Record<string, boolean>)[args[1] as string];
      }
    case '__and__':
      return Boolean(args[0]) && Boolean(args[1]);
    case '__or__':
      return Boolean(args[0]) || Boolean(args[1]);
    case '__not__':
      return !args[0];
    case '__array__':
      return args;
    case '__arrayContains__':
      return (args[0] as unknown[]).includes(args[1]);
    case '__any__':
      return (args[0] as unknown[]).some(Boolean);
    case 'len':
      return (args[0] as unknown[]).length;
    default:
      throw new Error(`Unsupported candidate-pool value: ${node.name}`);
  }
}

function runActions(actions: Ast[], state: CandidatePoolState) {
  for (let index = 0; index < actions.length; index += 1) {
    const action = actions[index];
    if (action.name === '__if__') {
      let matched = Boolean(evaluate(action.args[0], state));
      if (matched) {
        runActions(action.children, state);
      }
      while (actions[index + 1]?.name === '__elif__' || actions[index + 1]?.name === '__else__') {
        index += 1;
        const branch = actions[index];
        if (!matched && (branch.name === '__else__' || Boolean(evaluate(branch.args[0], state)))) {
          matched = true;
          runActions(branch.children, state);
        }
      }
      continue;
    }
    if (action.name === '__setPlayerVariable__') {
      state.player[action.args[1].name] = evaluate(action.args[2], state);
      continue;
    }
    if (action.name === '__modifyPlayerVariable__' && action.args[2].name === '__removeFromArrayByValue__') {
      const variable = action.args[1].name;
      const value = evaluate(action.args[3], state);
      state.player[variable] = (state.player[variable] as unknown[]).filter((item) => item !== value);
    }
  }
}

async function buildCandidates(player: Record<string, unknown>, catalog: Array<[number, number]>) {
  const rule = await getProductionCandidatePoolRule();
  const eventCatalogWeight: number[] = [];
  const eventCatalogType: number[] = [];
  for (const [id, type] of catalog) {
    eventCatalogWeight[id] = 1;
    eventCatalogType[id] = type;
  }
  const state = {
    globals: {
      eventCatalogId: catalog.map(([id]) => id),
      eventCatalogWeight,
      eventCatalogType,
      gamblerHeartsteelJackpot: 8,
      phaseHero: [[], [], [], [], []]
    },
    player: {
      hero: 'SOLDIER',
      thiefBuffStolen: false,
      eventForceRoll: null,
      eventLastId: null,
      playerOnceEventState: [0],
      heart_steel: [4],
      mod_dmg_perma: 0,
      mod_speed_perma: 0,
      mod_heal_perma: 0,
      ...player
    }
  };
  runActions(rule.children, state);
  return state.player.eventTempIndex;
}

test('production candidate pool preserves Thief and dedup fallback semantics', async () => {
  assert.deepEqual(
    await buildCandidates({ thiefBuffStolen: true, eventForceRoll: 50, eventLastId: [40, 55] }, [[1, 0], [40, 1], [55, 2]]),
    [40, 55]
  );
});

test('production candidate pool preserves forced-category and Temper Heart semantics', async () => {
  assert.deepEqual(await buildCandidates({ eventForceRoll: 50 }, [[38, 1], [40, 1]]), [40]);
  assert.deepEqual(await buildCandidates({ eventForceRoll: 0, playerOnceEventState: [1] }, [[1, 0], [23, 0]]), [1, 23]);
  assert.deepEqual(await buildCandidates({ eventForceRoll: 0, playerOnceEventState: [2] }, [[1, 0], [23, 0]]), [1]);
});

test('production candidate pool preserves hard eligibility across dedup fallback', async () => {
  assert.deepEqual(
    await buildCandidates(
      { playerOnceEventState: [2], heart_steel: [0], eventLastId: [38, 40] },
      [[16, 0], [17, 0], [23, 0], [38, 1], [40, 1], [50, 2], [59, 2], [60, 2], [65, 2], [66, 2]]
    ),
    [38, 40]
  );
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
