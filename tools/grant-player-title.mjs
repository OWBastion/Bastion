import fs from 'node:fs/promises';
import path from 'node:path';
import readline from 'node:readline/promises';
import { stdin as input, stdout as output } from 'node:process';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const SOURCE_FILE = path.resolve(__dirname, '../data/title-source.json');

const MAP_ALIAS = {
  '66号公路': 'DATA_ROUTE66',
  '沃斯卡娅工业区': 'DATA_VOLSKAYA',
  '月球基地': 'DATA_HORIZON_LUNAR_COLONY'
};

const TITLE_ALIAS = {
  'what can i say': 'MANBA'
};

function ensureString(value, message) {
  if (typeof value !== 'string' || value.trim() === '') {
    throw new Error(message);
  }
}

function splitCsv(value) {
  if (!value || typeof value !== 'string') {
    return [];
  }
  return value
    .split(',')
    .map((item) => item.trim())
    .filter(Boolean);
}

function parseYesNo(value, defaultValue = false) {
  const raw = String(value ?? '').trim().toLowerCase();
  if (raw === '') {
    return defaultValue;
  }
  return ['y', 'yes', 'true', '1'].includes(raw);
}

function normalizeAutoMasteryMode(value) {
  const raw = String(value ?? '').trim().toLowerCase();
  if (raw === '') {
    return 'check_only';
  }
  if (!['off', 'check_only', 'grant'].includes(raw)) {
    throw new Error('autoMasteryMode must be one of: off, check_only, grant');
  }
  return raw;
}

function normalizeTitleInput(value, titleKeySet, titlesByLabel) {
  ensureString(value, `Invalid title key: ${value}`);
  const raw = value.trim();

  const stripped = raw.replace(/^TITLE\./i, '').trim();
  if (titleKeySet.has(stripped)) {
    return stripped;
  }

  const alias = TITLE_ALIAS[raw.toLowerCase()];
  if (alias && titleKeySet.has(alias)) {
    return alias;
  }

  if (titlesByLabel.has(raw)) {
    return titlesByLabel.get(raw);
  }

  throw new Error(`Unknown title input: ${value}`);
}

function normalizeMapInput(value, mapKeySet, mapByLabel) {
  ensureString(value, `Invalid map key: ${value}`);
  const raw = value.trim();

  if (mapKeySet.has(raw)) {
    return raw;
  }

  const alias = MAP_ALIAS[raw];
  if (alias && mapKeySet.has(alias)) {
    return alias;
  }

  if (mapByLabel.has(raw)) {
    return mapByLabel.get(raw);
  }

  throw new Error(`Unknown map input: ${value}`);
}

function ensureInArray(arr, value) {
  if (!arr.includes(value)) {
    arr.push(value);
    return true;
  }
  return false;
}

function parseRequest(raw) {
  if (!raw || typeof raw !== 'object') {
    throw new Error('Input request must be a JSON object.');
  }

  if (!Array.isArray(raw.players) || raw.players.length === 0) {
    throw new Error('Input request must include a non-empty players array.');
  }

  const options = {
    grantDifficultyFromMaps: raw.options?.grantDifficultyFromMaps === true,
    autoMasteryMode: raw.options?.autoMasteryMode ?? 'check_only'
  };

  if (!['off', 'check_only', 'grant'].includes(options.autoMasteryMode)) {
    throw new Error('options.autoMasteryMode must be one of: off, check_only, grant');
  }

  const players = raw.players.map((item, index) => {
    if (!item || typeof item !== 'object') {
      throw new Error(`players[${index}] must be an object.`);
    }

    ensureString(item.name, `players[${index}].name is required.`);

    const generalTitles = Array.isArray(item.generalTitles)
      ? item.generalTitles.map((x) => {
          ensureString(x, `players[${index}].generalTitles must contain non-empty strings.`);
          return x;
        })
      : [];

    const mapDominators = Array.isArray(item.mapDominators)
      ? item.mapDominators.map((x) => {
          ensureString(x, `players[${index}].mapDominators must contain non-empty strings.`);
          return x;
        })
      : [];

    return {
      name: item.name.trim(),
      generalTitles,
      mapDominators
    };
  });

  return { players, options };
}

export function buildInteractiveRequest({
  targetType,
  playerName,
  generalTitles,
  mapDominators,
  mapKey,
  targetPlayers,
  options
}) {
  const normalizedTargetType = String(targetType ?? '').trim().toLowerCase();

  if (!['player', 'map'].includes(normalizedTargetType)) {
    throw new Error('targetType must be player or map');
  }

  const requestOptions = {
    grantDifficultyFromMaps: options?.grantDifficultyFromMaps === true,
    autoMasteryMode: normalizeAutoMasteryMode(options?.autoMasteryMode)
  };

  if (normalizedTargetType === 'player') {
    ensureString(playerName, 'playerName is required for player mode');

    const req = {
      players: [
        {
          name: playerName.trim(),
          generalTitles: splitCsv(generalTitles),
          mapDominators: splitCsv(mapDominators)
        }
      ],
      options: requestOptions
    };

    if (!req.players[0].generalTitles.length && !req.players[0].mapDominators.length) {
      throw new Error('At least one general title or map dominator is required in player mode');
    }

    return req;
  }

  const normalizedMapKey = String(mapKey ?? '').trim();
  if (!normalizedMapKey) {
    throw new Error('mapKey is required for map mode');
  }

  const players = splitCsv(targetPlayers);
  if (!players.length) {
    throw new Error('targetPlayers is required for map mode');
  }

  return {
    players: players.map((name) => ({
      name,
      generalTitles: [],
      mapDominators: [normalizedMapKey]
    })),
    options: requestOptions
  };
}

export async function loadTitleSource(sourceFile = SOURCE_FILE) {
  const sourceText = await fs.readFile(sourceFile, 'utf8');
  return JSON.parse(sourceText);
}

export function applyGrantRequest(sourceData, requestData) {
  const { players: requestPlayers, options } = parseRequest(requestData);

  const titleKeySet = new Set(sourceData.titles.map((item) => item.key));
  const mapKeySet = new Set(sourceData.mapTitles.map((item) => item.mapKey));
  const titlesByLabel = new Map(sourceData.titles.map((item) => [item.label, item.key]));
  const mapByLabel = new Map(sourceData.mapTitles.map((item) => [item.mapLabel, item.mapKey]));

  const playersByName = new Map(sourceData.players.map((player, index) => [player.name, { player, index }]));
  const mapByKey = new Map(sourceData.mapTitles.map((mapItem) => [mapItem.mapKey, mapItem]));

  const summary = {
    addedPlayers: [],
    generalTitleAdds: {},
    mapAdds: {},
    masteryCheck: {},
    options
  };

  for (const reqPlayer of requestPlayers) {
    let record = playersByName.get(reqPlayer.name);
    if (!record) {
      const player = { name: reqPlayer.name, titleKeys: [] };
      sourceData.players.push(player);
      record = { player, index: sourceData.players.length - 1 };
      playersByName.set(reqPlayer.name, record);
      summary.addedPlayers.push(reqPlayer.name);
    }

    const normalizedTitleKeys = reqPlayer.generalTitles.map((key) => normalizeTitleInput(key, titleKeySet, titlesByLabel));
    const normalizedMapKeys = reqPlayer.mapDominators.map((key) => normalizeMapInput(key, mapKeySet, mapByLabel));

    for (const titleKey of normalizedTitleKeys) {
      const added = ensureInArray(record.player.titleKeys, titleKey);
      if (added) {
        if (!summary.generalTitleAdds[reqPlayer.name]) {
          summary.generalTitleAdds[reqPlayer.name] = [];
        }
        summary.generalTitleAdds[reqPlayer.name].push(titleKey);
      }
    }

    for (const mapKey of normalizedMapKeys) {
      const mapItem = mapByKey.get(mapKey);
      const addedConqueror = ensureInArray(mapItem.holders.CONQUEROR, reqPlayer.name);
      const addedDominator = ensureInArray(mapItem.holders.DOMINATOR, reqPlayer.name);

      if (addedConqueror || addedDominator) {
        if (!summary.mapAdds[mapKey]) {
          summary.mapAdds[mapKey] = { CONQUEROR: [], DOMINATOR: [] };
        }
        if (addedConqueror) {
          summary.mapAdds[mapKey].CONQUEROR.push(reqPlayer.name);
        }
        if (addedDominator) {
          summary.mapAdds[mapKey].DOMINATOR.push(reqPlayer.name);
        }
      }
    }
  }

  for (const reqPlayer of requestPlayers) {
    const playerName = reqPlayer.name;
    const playerRecord = playersByName.get(playerName).player;

    const conqCount = sourceData.mapTitles.reduce(
      (count, mapItem) => count + (mapItem.holders.CONQUEROR.includes(playerName) ? 1 : 0),
      0
    );
    const domCount = sourceData.mapTitles.reduce(
      (count, mapItem) => count + (mapItem.holders.DOMINATOR.includes(playerName) ? 1 : 0),
      0
    );

    if (options.grantDifficultyFromMaps) {
      if (conqCount > 0) {
        const added = ensureInArray(playerRecord.titleKeys, 'CHALLENGER_LEGEND');
        if (added) {
          if (!summary.generalTitleAdds[playerName]) {
            summary.generalTitleAdds[playerName] = [];
          }
          summary.generalTitleAdds[playerName].push('CHALLENGER_LEGEND');
        }
      }
      if (domCount > 0) {
        const added = ensureInArray(playerRecord.titleKeys, 'TRAVELER_HELL');
        if (added) {
          if (!summary.generalTitleAdds[playerName]) {
            summary.generalTitleAdds[playerName] = [];
          }
          summary.generalTitleAdds[playerName].push('TRAVELER_HELL');
        }
      }
    }

    const allConqueror = conqCount === sourceData.mapTitles.length;
    const allDominator = domCount === sourceData.mapTitles.length;

    if (options.autoMasteryMode === 'grant') {
      if (allConqueror) {
        const added = ensureInArray(playerRecord.titleKeys, 'ALL_IN_ONE');
        if (added) {
          if (!summary.generalTitleAdds[playerName]) {
            summary.generalTitleAdds[playerName] = [];
          }
          summary.generalTitleAdds[playerName].push('ALL_IN_ONE');
        }
      }

      if (allDominator) {
        const added = ensureInArray(playerRecord.titleKeys, 'SKY');
        if (added) {
          if (!summary.generalTitleAdds[playerName]) {
            summary.generalTitleAdds[playerName] = [];
          }
          summary.generalTitleAdds[playerName].push('SKY');
        }
      }
    }

    if (options.autoMasteryMode !== 'off') {
      summary.masteryCheck[playerName] = {
        allConqueror,
        allDominator,
        conquerorCount: conqCount,
        dominatorCount: domCount,
        mapCount: sourceData.mapTitles.length
      };
    }
  }

  return { sourceData, summary };
}

export async function grantPlayerTitle({
  sourceFile = SOURCE_FILE,
  inputFile,
  requestData,
  dryRun = false
} = {}) {
  const hasInputFile = Boolean(inputFile);
  const hasRequestData = Boolean(requestData);

  if (!hasInputFile && !hasRequestData) {
    throw new Error('Missing --input <request.json> or requestData');
  }

  const sourceData = await loadTitleSource(sourceFile);

  let parsedInput = requestData;
  if (hasInputFile) {
    const inputRaw = await fs.readFile(path.resolve(inputFile), 'utf8');
    parsedInput = JSON.parse(inputRaw);
  }

  const beforeText = `${JSON.stringify(sourceData, null, 2)}\n`;
  const workingCopy = JSON.parse(beforeText);
  const { sourceData: nextData, summary } = applyGrantRequest(workingCopy, parsedInput);
  const afterText = `${JSON.stringify(nextData, null, 2)}\n`;

  if (!dryRun) {
    await fs.writeFile(sourceFile, afterText, 'utf8');
  }

  return {
    dryRun,
    changed: beforeText !== afterText,
    summary,
    preview: {
      addedPlayers: summary.addedPlayers,
      generalTitleAdds: summary.generalTitleAdds,
      mapAdds: summary.mapAdds
    }
  };
}

export function parseCliArgs(argv) {
  const args = { dryRun: false, interactive: false };

  for (let i = 0; i < argv.length; i += 1) {
    const token = argv[i];

    if (token === '--input') {
      const value = argv[i + 1];
      if (!value) {
        throw new Error('Missing value for --input');
      }
      args.inputFile = value;
      i += 1;
      continue;
    }

    if (token === '--interactive') {
      args.interactive = true;
      continue;
    }

    if (token === '--dry-run') {
      args.dryRun = true;
      continue;
    }

    if (token === '--help' || token === '-h') {
      args.help = true;
      continue;
    }

    throw new Error(`Unknown argument: ${token}`);
  }

  return args;
}

export function validateCliArgs(args) {
  if (args.interactive && args.inputFile) {
    throw new Error('--interactive and --input are mutually exclusive');
  }

  if (!args.help && !args.interactive && !args.inputFile) {
    throw new Error('Either --interactive or --input <request.json> is required');
  }
}

export async function collectInteractiveRequest(sourceData, io = { input, output }) {
  const rl = readline.createInterface(io);
  try {
    const typeAnswer = (await rl.question('发放对象类型 [player/map] (默认 player): ')).trim().toLowerCase();
    const targetType = typeAnswer || 'player';

    if (!['player', 'map'].includes(targetType)) {
      throw new Error('对象类型必须是 player 或 map');
    }

    let requestPayload;

    if (targetType === 'player') {
      let playerName = '';
      while (!playerName) {
        playerName = (await rl.question('玩家名称: ')).trim();
      }

      const generalTitles = await rl.question('通用称号（逗号分隔，可空）: ');
      const mapDominators = await rl.question('地图主宰（逗号分隔，可空）: ');

      requestPayload = {
        targetType,
        playerName,
        generalTitles,
        mapDominators
      };
    } else {
      const mapHints = sourceData.mapTitles
        .slice(0, 8)
        .map((item) => `${item.mapLabel}(${item.mapKey})`)
        .join('、');
      const mapKey = await rl.question(`地图（mapKey/中文名，示例：${mapHints}）: `);
      const targetPlayers = await rl.question('玩家列表（逗号分隔）: ');

      requestPayload = {
        targetType,
        mapKey,
        targetPlayers
      };
    }

    const difficultyAnswer = await rl.question('自动补发难度挑战称号? [y/N]: ');
    const autoMasteryRaw = await rl.question('地图精通模式 [off/check_only/grant] (默认 check_only): ');

    const requestData = buildInteractiveRequest({
      ...requestPayload,
      options: {
        grantDifficultyFromMaps: parseYesNo(difficultyAnswer, false),
        autoMasteryMode: normalizeAutoMasteryMode(autoMasteryRaw)
      }
    });

    return requestData;
  } finally {
    rl.close();
  }
}

const invokedPath = process.argv[1] ? path.resolve(process.argv[1]) : null;

if (invokedPath === __filename) {
  Promise.resolve()
    .then(async () => {
      const args = parseCliArgs(process.argv.slice(2));
      validateCliArgs(args);

      if (args.help) {
        console.log('Usage:');
        console.log('  node tools/grant-player-title.mjs --input <request.json> [--dry-run]');
        console.log('  node tools/grant-player-title.mjs --interactive [--dry-run]');
        process.exit(0);
      }

      let requestData = null;
      if (args.interactive) {
        const sourceData = await loadTitleSource(SOURCE_FILE);
        requestData = await collectInteractiveRequest(sourceData);

        const preview = await grantPlayerTitle({
          sourceFile: SOURCE_FILE,
          requestData,
          dryRun: true
        });

        console.log('\n变更预览:');
        console.log(JSON.stringify(preview.preview, null, 2));

        const rl = readline.createInterface({ input, output });
        try {
          const confirm = await rl.question('确认写入? [y/N]: ');
          if (!parseYesNo(confirm, false)) {
            console.log('已取消，不做写入。');
            process.exit(0);
          }
        } finally {
          rl.close();
        }
      }

      const result = await grantPlayerTitle({
        inputFile: args.inputFile,
        requestData,
        dryRun: args.dryRun
      });
      console.log(JSON.stringify(result, null, 2));
    })
    .catch((error) => {
      console.error(error.message);
      process.exitCode = 1;
    });
}
