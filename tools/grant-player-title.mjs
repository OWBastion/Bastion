import fs from 'node:fs/promises';
import path from 'node:path';
import readline from 'node:readline/promises';
import { stdin as input, stdout as output } from 'node:process';
import { fileURLToPath } from 'node:url';
import { syncTitleData } from './sync-title-data.mjs';

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

const RESTRICTED_GENERAL_TITLE_KEYS = [
  'PIONEER',
  'TEST_LONG',
  'NOT_MY_MAP',
  'WILD_DEV',
  'ARCHITECT',
  'MAINTAINER',
  'THREE_IN_ONE',
  'BLACK_SHEEP',
  'PURE_HARM',
  'CONQUEROR',
  'DOMINATOR',
  'SURVIVOR_EXPERT',
  'CHALLENGER_LEGEND',
  'TRAVELER_HELL',
  'DODGE_ULTIMATE'
];
const RESTRICTED_GENERAL_TITLE_INDEX_BY_KEY = new Map(RESTRICTED_GENERAL_TITLE_KEYS.map((key, index) => [key, index]));

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

function normalizeStringList(value) {
  if (Array.isArray(value)) {
    return value.map((item) => String(item).trim()).filter(Boolean);
  }
  return splitCsv(value);
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

export function resolvePlayerNameFromPlayerId(sourceData, playerIdRaw) {
  const text = String(playerIdRaw ?? '').trim();
  if (!/^\d+$/.test(text)) {
    throw new Error(`Invalid player id: ${playerIdRaw}`);
  }

  const playerId = Number(text);
  if (playerId < 0 || playerId >= sourceData.players.length) {
    throw new Error(`Player id out of range: ${playerId}`);
  }

  return sourceData.players[playerId].name;
}

export function resolveTitleKeyFromLabel(sourceData, labelRaw) {
  const label = String(labelRaw ?? '').trim();
  if (!label) {
    throw new Error('Invalid title label');
  }

  const matched = sourceData.titles.find((item) => item.label === label);
  if (!matched) {
    throw new Error(`Unknown title label: ${labelRaw}`);
  }

  return matched.key;
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

function assertGrantableGeneralTitle(titleKey, titleByKey) {
  const restrictedIndex = RESTRICTED_GENERAL_TITLE_INDEX_BY_KEY.get(titleKey);
  if (restrictedIndex === undefined) {
    return;
  }

  const label = titleByKey.get(titleKey)?.label ?? '(unknown)';
  if (titleKey === 'PIONEER') {
    throw new Error(
      `Restricted general title cannot be granted: key=${titleKey}, label=${label}, index=${restrictedIndex}. Use --map-pioneer <MAP_KEY_OR_LABEL> instead.`
    );
  }
  throw new Error(
    `Restricted general title cannot be granted: key=${titleKey}, label=${label}, index=${restrictedIndex}`
  );
}

export function parseNumberSelection(raw, { max, allowZero = false, allowEmpty = false, multi = false } = {}) {
  const text = String(raw ?? '').trim();
  if (text === '') {
    if (allowEmpty) {
      return [];
    }
    throw new Error('选择不能为空');
  }

  const tokens = multi ? text.split(',') : [text];
  const selected = [];

  for (const token of tokens) {
    const value = token.trim();
    if (!/^\d+$/.test(value)) {
      throw new Error(`无效编号: ${token}`);
    }

    const num = Number(value);
    if (num === 0 && !allowZero) {
      throw new Error('不允许选择 0');
    }
    if (num !== 0 && (num < 1 || num > max)) {
      throw new Error(`编号超出范围: ${num}`);
    }

    if (!selected.includes(num)) {
      selected.push(num);
    }
  }

  return selected;
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
    autoMasteryMode: raw.options?.autoMasteryMode ?? 'check_only',
    failOnMissingPlayer: raw.options?.failOnMissingPlayer === true
  };

  if (!['off', 'check_only', 'grant'].includes(options.autoMasteryMode)) {
    throw new Error('options.autoMasteryMode must be one of: off, check_only, grant');
  }
  if (raw.options?.failOnMissingPlayer !== undefined && typeof raw.options.failOnMissingPlayer !== 'boolean') {
    throw new Error('options.failOnMissingPlayer must be a boolean');
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
    const mapPioneers = Array.isArray(item.mapPioneers)
      ? item.mapPioneers.map((x) => {
          ensureString(x, `players[${index}].mapPioneers must contain non-empty strings.`);
          return x;
        })
      : [];

    return {
      name: item.name.trim(),
      generalTitles,
      mapDominators,
      mapPioneers
    };
  });

  return { players, options };
}

export function buildInteractiveRequest({
  targetType,
  playerName,
  generalTitles,
  mapDominators,
  mapPioneers,
  mapKey,
  targetPlayers,
  mapPioneersByMapMode = false,
  options
}) {
  const normalizedTargetType = String(targetType ?? '').trim().toLowerCase();

  if (!['player', 'map'].includes(normalizedTargetType)) {
    throw new Error('targetType must be player or map');
  }

  const requestOptions = {
    grantDifficultyFromMaps: options?.grantDifficultyFromMaps === true,
    autoMasteryMode: normalizeAutoMasteryMode(options?.autoMasteryMode),
    failOnMissingPlayer: options?.failOnMissingPlayer === true
  };

  if (normalizedTargetType === 'player') {
    ensureString(playerName, 'playerName is required for player mode');

    const req = {
      players: [
        {
          name: playerName.trim(),
          generalTitles: normalizeStringList(generalTitles),
          mapDominators: normalizeStringList(mapDominators),
          mapPioneers: normalizeStringList(mapPioneers)
        }
      ],
      options: requestOptions
    };

    if (!req.players[0].generalTitles.length && !req.players[0].mapDominators.length && !req.players[0].mapPioneers.length) {
      throw new Error('At least one general title, map dominator or map pioneer is required in player mode');
    }

    return req;
  }

  const normalizedMapKey = String(mapKey ?? '').trim();
  if (!normalizedMapKey) {
    throw new Error('mapKey is required for map mode');
  }

  const players = normalizeStringList(targetPlayers);
  if (!players.length) {
    throw new Error('targetPlayers is required for map mode');
  }

  return {
    players: players.map((name) => ({
      name,
      generalTitles: [],
      mapDominators: mapPioneersByMapMode ? [] : [normalizedMapKey],
      mapPioneers: mapPioneersByMapMode ? [normalizedMapKey] : []
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
  const titleByKey = new Map(sourceData.titles.map((item) => [item.key, item]));
  const mapByLabel = new Map(sourceData.mapTitles.map((item) => [item.mapLabel, item.mapKey]));

  const playersByName = new Map(sourceData.players.map((player, index) => [player.name, { player, index }]));
  const mapByKey = new Map(sourceData.mapTitles.map((mapItem) => [mapItem.mapKey, mapItem]));

  const summary = {
    addedPlayers: [],
    generalTitleAdds: {},
    mapAdds: {},
    masteryTitleRemovals: {},
    masteryCheck: {},
    options
  };

  for (const reqPlayer of requestPlayers) {
    let record = playersByName.get(reqPlayer.name);
    if (!record) {
      if (options.failOnMissingPlayer) {
        throw new Error(`Player not found in title source: ${reqPlayer.name}`);
      }
      const player = { name: reqPlayer.name, titleKeys: [] };
      sourceData.players.push(player);
      record = { player, index: sourceData.players.length - 1 };
      playersByName.set(reqPlayer.name, record);
      summary.addedPlayers.push(reqPlayer.name);
    }

    const normalizedTitleKeys = reqPlayer.generalTitles.map((key) => normalizeTitleInput(key, titleKeySet, titlesByLabel));
    const normalizedMapKeys = reqPlayer.mapDominators.map((key) => normalizeMapInput(key, mapKeySet, mapByLabel));
    const normalizedMapPioneerKeys = reqPlayer.mapPioneers.map((key) => normalizeMapInput(key, mapKeySet, mapByLabel));

    for (const titleKey of normalizedTitleKeys) {
      assertGrantableGeneralTitle(titleKey, titleByKey);
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
          summary.mapAdds[mapKey] = { PIONEER: [], CONQUEROR: [], DOMINATOR: [] };
        }
        if (addedConqueror) {
          summary.mapAdds[mapKey].CONQUEROR.push(reqPlayer.name);
        }
        if (addedDominator) {
          summary.mapAdds[mapKey].DOMINATOR.push(reqPlayer.name);
        }
      }
    }

    for (const mapKey of normalizedMapPioneerKeys) {
      const mapItem = mapByKey.get(mapKey);
      const addedPioneer = ensureInArray(mapItem.holders.PIONEER, reqPlayer.name);
      const addedDominator = ensureInArray(mapItem.holders.DOMINATOR, reqPlayer.name);
      const addedConqueror = ensureInArray(mapItem.holders.CONQUEROR, reqPlayer.name);

      if (addedPioneer || addedDominator || addedConqueror) {
        if (!summary.mapAdds[mapKey]) {
          summary.mapAdds[mapKey] = { PIONEER: [], CONQUEROR: [], DOMINATOR: [] };
        }
        if (addedPioneer) {
          summary.mapAdds[mapKey].PIONEER.push(reqPlayer.name);
        }
        if (addedDominator) {
          summary.mapAdds[mapKey].DOMINATOR.push(reqPlayer.name);
        }
        if (addedConqueror) {
          summary.mapAdds[mapKey].CONQUEROR.push(reqPlayer.name);
        }
      }
    }
  }

  const mapCount = sourceData.mapTitles.length;
  const masteryStatsByPlayer = new Map();

  // Full-scan mastery reconciliation: remove global mastery titles that no longer meet map holders criteria.
  for (const player of sourceData.players) {
    const conqCount = sourceData.mapTitles.reduce(
      (count, mapItem) => count + (mapItem.holders.CONQUEROR.includes(player.name) ? 1 : 0),
      0
    );
    const domCount = sourceData.mapTitles.reduce(
      (count, mapItem) => count + (mapItem.holders.DOMINATOR.includes(player.name) ? 1 : 0),
      0
    );
    const allConqueror = conqCount === mapCount;
    const allDominator = domCount === mapCount;

    masteryStatsByPlayer.set(player.name, {
      allConqueror,
      allDominator,
      conquerorCount: conqCount,
      dominatorCount: domCount,
      mapCount
    });

    if (!allConqueror) {
      const beforeLength = player.titleKeys.length;
      player.titleKeys = player.titleKeys.filter((key) => key !== 'ALL_IN_ONE');
      if (player.titleKeys.length !== beforeLength) {
        if (!summary.masteryTitleRemovals[player.name]) {
          summary.masteryTitleRemovals[player.name] = [];
        }
        summary.masteryTitleRemovals[player.name].push('ALL_IN_ONE');
      }
    }

    if (!allDominator) {
      const beforeLength = player.titleKeys.length;
      player.titleKeys = player.titleKeys.filter((key) => key !== 'SKY');
      if (player.titleKeys.length !== beforeLength) {
        if (!summary.masteryTitleRemovals[player.name]) {
          summary.masteryTitleRemovals[player.name] = [];
        }
        summary.masteryTitleRemovals[player.name].push('SKY');
      }
    }
  }

  for (const reqPlayer of requestPlayers) {
    const playerName = reqPlayer.name;
    const playerRecord = playersByName.get(playerName).player;
    const playerMastery = masteryStatsByPlayer.get(playerName);
    const conqCount = playerMastery.conquerorCount;
    const domCount = playerMastery.dominatorCount;

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

    const allConqueror = playerMastery.allConqueror;
    const allDominator = playerMastery.allDominator;

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
        mapCount
      };
    }
  }

  return { sourceData, summary };
}

export async function grantPlayerTitle({
  sourceFile = SOURCE_FILE,
  inputFile,
  requestData,
  dryRun = false,
  syncFn = syncTitleData
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
  const changed = beforeText !== afterText;
  let autoSync = {
    executed: false,
    reason: dryRun ? 'dry_run' : changed ? 'pending' : 'no_changes'
  };

  if (!dryRun && changed) {
    await fs.writeFile(sourceFile, afterText, 'utf8');

    const syncResult = await syncFn({ sourceFile });
    autoSync = {
      executed: true,
      reason: 'source_changed',
      titleFileChanged: syncResult.titleFileChanged,
      sourceVersion: syncResult.sourceVersion,
      generated: {
        titleCount: syncResult.webPayload.meta.titleCount,
        playerCount: syncResult.webPayload.meta.playerCount,
        mapTitleCount: syncResult.webPayload.meta.mapTitleCount
      }
    };
  }

  return {
    dryRun,
    changed,
    summary,
    autoSync,
    preview: {
      addedPlayers: summary.addedPlayers,
      generalTitleAdds: summary.generalTitleAdds,
      mapAdds: summary.mapAdds,
      masteryTitleRemovals: summary.masteryTitleRemovals
    }
  };
}

export function parseCliArgs(argv) {
  const args = {
    dryRun: false,
    interactive: false,
    generalTitles: [],
    generalTitleLabels: [],
    mapPioneers: [],
    failOnMissingPlayer: false
  };

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

    if (token === '--player-name') {
      const value = argv[i + 1];
      if (!value) {
        throw new Error('Missing value for --player-name');
      }
      args.playerName = value;
      i += 1;
      continue;
    }

    if (token === '--player-id') {
      const value = argv[i + 1];
      if (!value) {
        throw new Error('Missing value for --player-id');
      }
      args.playerId = value;
      i += 1;
      continue;
    }

    if (token === '--general-title') {
      const value = argv[i + 1];
      if (!value) {
        throw new Error('Missing value for --general-title');
      }
      args.generalTitles.push(value);
      i += 1;
      continue;
    }

    if (token === '--general-title-label') {
      const value = argv[i + 1];
      if (!value) {
        throw new Error('Missing value for --general-title-label');
      }
      args.generalTitleLabels.push(value);
      i += 1;
      continue;
    }

    if (token === '--fail-on-missing-player') {
      args.failOnMissingPlayer = true;
      continue;
    }

    if (token === '--map-pioneer') {
      const value = argv[i + 1];
      if (!value) {
        throw new Error('Missing value for --map-pioneer');
      }
      args.mapPioneers.push(value);
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
  const directMode = Boolean(args.playerName) || args.playerId !== undefined;
  const modeCount = Number(Boolean(args.interactive)) + Number(Boolean(args.inputFile)) + Number(directMode);
  if (modeCount > 1) {
    throw new Error('--interactive, --input and direct player mode are mutually exclusive');
  }

  if (args.playerName && args.playerId !== undefined) {
    throw new Error('--player-name and --player-id are mutually exclusive');
  }

  if (!args.help && !args.interactive && !args.inputFile && !directMode) {
    throw new Error('One mode is required: --interactive, --input <request.json>, --player-name <name>, or --player-id <id>');
  }

  const directGrantCount = args.generalTitles.length + args.generalTitleLabels.length + args.mapPioneers.length;
  if (directMode && directGrantCount === 0) {
    throw new Error(
      'Direct player mode requires --general-title <TITLE_KEY> or --general-title-label <中文称号> or --map-pioneer <MAP_KEY_OR_LABEL>'
    );
  }

  if (!directMode && (args.generalTitles.length > 0 || args.generalTitleLabels.length > 0 || args.mapPioneers.length > 0)) {
    throw new Error('--general-title / --general-title-label / --map-pioneer can only be used in direct player mode');
  }

  if (!directMode && args.failOnMissingPlayer) {
    throw new Error('--fail-on-missing-player can only be used in direct player mode');
  }
}

const INTERACTIVE_DEFAULT_OPTIONS = {
  grantDifficultyFromMaps: false,
  autoMasteryMode: 'check_only'
};

const ANSI_RESET_FOREGROUND = '\u001b[39m';

export function createAnsi({ enabled } = {}) {
  const shouldColor =
    enabled ??
    (Boolean(output.isTTY) && process.env.NO_COLOR !== '1' && process.env.TERM !== 'dumb');

  const withCode = (open, close) => (text) =>
    shouldColor ? `\u001b[${open}m${String(text)}\u001b[${close}m` : String(text);
  const withForeground = (code) => (text) =>
    shouldColor ? `\u001b[${code}m${String(text)}${ANSI_RESET_FOREGROUND}` : String(text);

  return {
    enabled: shouldColor,
    accent: withForeground(36),
    success: withForeground(32),
    warning: withForeground(33),
    error: withForeground(31),
    strong: withCode(1, 22),
    contrast: withCode(7, 27)
  };
}

function createUi(outputStream = output) {
  const ansi = createAnsi({
    enabled:
      Boolean(outputStream?.isTTY) &&
      process.env.NO_COLOR !== '1' &&
      process.env.TERM !== 'dumb'
  });

  return {
    ansi,
    info: (text) => console.log(ansi.accent(text)),
    success: (text) => console.log(ansi.success(text)),
    warning: (text) => console.log(ansi.warning(text)),
    error: (text) => console.log(ansi.error(text)),
    strong: (text) => console.log(ansi.strong(text)),
    contrast: (text) => console.log(ansi.contrast(text))
  };
}

function printOptions(list, { includeZeroLabel, ui } = {}) {
  if (includeZeroLabel) {
    if (ui) {
      ui.info(`  0) ${includeZeroLabel}`);
    } else {
      console.log(`  0) ${includeZeroLabel}`);
    }
  }
  list.forEach((item, index) => {
    if (ui) {
      ui.info(`  ${index + 1}) ${item}`);
    } else {
      console.log(`  ${index + 1}) ${item}`);
    }
  });
}

async function askSingleChoice(
  rl,
  prompt,
  list,
  { includeZeroLabel, allowEmpty = false, defaultChoice, defaultLabel, ui } = {}
) {
  while (true) {
    printOptions(list, { includeZeroLabel, ui });
    const raw = await rl.question(`${ui?.ansi.strong(prompt) ?? prompt}: `);

    if (String(raw ?? '').trim() === '' && allowEmpty) {
      if (defaultChoice === undefined) {
        return undefined;
      }
      if (ui) {
        ui.warning(`未输入，已使用默认值：${defaultLabel ?? defaultChoice}`);
      }
      return defaultChoice;
    }

    try {
      const selected = parseNumberSelection(raw, {
        max: list.length,
        allowZero: Boolean(includeZeroLabel),
        multi: false
      });
      return selected[0];
    } catch (error) {
      if (ui) {
        ui.error(`输入无效: ${error.message}`);
      } else {
        console.log(`输入无效: ${error.message}`);
      }
    }
  }
}

async function askMultiChoice(
  rl,
  prompt,
  list,
  { allowZero = false, allowEmpty = false, includeZeroLabel, ui } = {}
) {
  while (true) {
    printOptions(list, { includeZeroLabel, ui });
    const raw = await rl.question(`${ui?.ansi.strong(prompt) ?? prompt}: `);
    try {
      return parseNumberSelection(raw, {
        max: list.length,
        allowZero,
        allowEmpty,
        multi: true
      });
    } catch (error) {
      if (ui) {
        ui.error(`输入无效: ${error.message}`);
      } else {
        console.log(`输入无效: ${error.message}`);
      }
    }
  }
}

async function askNewPlayerName(rl, ui) {
  while (true) {
    const name = (await rl.question(`${ui?.ansi.strong('新玩家名称') ?? '新玩家名称'}: `)).trim();
    if (!name) {
      if (ui) {
        ui.warning('玩家名称不能为空');
      } else {
        console.log('玩家名称不能为空');
      }
      continue;
    }

    const confirm = await rl.question(
      `${ui?.ansi.strong(`确认新增玩家 "${name}"? [y/N]`) ?? `确认新增玩家 "${name}"? [y/N]`}: `
    );
    if (parseYesNo(confirm, false)) {
      return name;
    }
    if (ui) {
      ui.warning('已取消新增，返回选择。');
    } else {
      console.log('已取消新增，返回选择。');
    }
    return null;
  }
}

async function pickPlayersByMenu(rl, playerNames, { allowCreate = false, multi = true, ui } = {}) {
  const selected = [];

  if (!multi) {
    const choice = await askSingleChoice(rl, '选择玩家编号', playerNames, {
      includeZeroLabel: allowCreate ? '新增玩家' : undefined,
      ui
    });
    if (choice === 0) {
      const newName = await askNewPlayerName(rl, ui);
      if (newName) {
        return [newName];
      }
      return pickPlayersByMenu(rl, playerNames, { allowCreate, multi, ui });
    }
    return [playerNames[choice - 1]];
  }

  while (true) {
    const picked = await askMultiChoice(rl, '选择玩家编号（多选逗号，回车结束）', playerNames, {
      allowZero: allowCreate,
      allowEmpty: true,
      includeZeroLabel: allowCreate ? '新增玩家并加入本次选择' : undefined,
      ui
    });

    if (picked.length === 0) {
      if (selected.length > 0) {
        return selected;
      }
      if (ui) {
        ui.warning('至少选择一名玩家');
      } else {
        console.log('至少选择一名玩家');
      }
      continue;
    }

    for (const index of picked) {
      if (index === 0) {
        const newName = await askNewPlayerName(rl, ui);
        if (newName && !selected.includes(newName)) {
          selected.push(newName);
        }
        continue;
      }

      const name = playerNames[index - 1];
      if (!selected.includes(name)) {
        selected.push(name);
      }
    }

    if (ui) {
      ui.success(`当前已选玩家: ${selected.join(', ')}`);
    } else {
      console.log(`当前已选玩家: ${selected.join(', ')}`);
    }
  }
}

export async function collectInteractiveRequest(sourceData, io = { input, output }) {
  const usingInjectedReadline = Boolean(io?.readline);
  const rl = io?.readline ?? readline.createInterface(io);
  const ui = createUi(io.output);
  try {
    ui.strong('选择对象类型:');
    const mode = await askSingleChoice(rl, '输入编号', ['玩家模式', '地图模式'], { ui });

    const titleOptions = sourceData.titles.map((item) => `${item.key} (${item.label})`);
    const mapOptions = sourceData.mapTitles.map((item) => `${item.mapKey} (${item.mapLabel})`);
    const playerNames = sourceData.players.map((item) => item.name);

    let requestPayload;

    if (mode === 1) {
      const selectedPlayer = await pickPlayersByMenu(rl, playerNames, { allowCreate: true, multi: false, ui });

      const titlePicked = await askMultiChoice(rl, '选择通用称号（多选逗号，回车跳过）', titleOptions, {
        allowZero: false,
        allowEmpty: true,
        ui
      });
      const mapPicked = await askMultiChoice(rl, '选择地图主宰（多选逗号，回车跳过）', mapOptions, {
        allowZero: false,
        allowEmpty: true,
        ui
      });
      const mapPioneerPicked = await askMultiChoice(rl, '选择地图开拓者（多选逗号，回车跳过）', mapOptions, {
        allowZero: false,
        allowEmpty: true,
        ui
      });

      requestPayload = {
        targetType: 'player',
        playerName: selectedPlayer[0],
        generalTitles: titlePicked.map((index) => sourceData.titles[index - 1].key),
        mapDominators: mapPicked.map((index) => sourceData.mapTitles[index - 1].mapKey),
        mapPioneers: mapPioneerPicked.map((index) => sourceData.mapTitles[index - 1].mapKey)
      };
    } else {
      const mapPicked = await askSingleChoice(rl, '选择地图编号', mapOptions, { ui });
      const selectedPlayers = await pickPlayersByMenu(rl, playerNames, { allowCreate: true, multi: true, ui });
      const pioneerChoice = await askSingleChoice(
        rl,
        '是否发放开拓者（会自动补发主宰+征服者，回车默认：否）',
        ['否', '是'],
        {
          allowEmpty: true,
          defaultChoice: 1,
          defaultLabel: '否',
          ui
        }
      );

      requestPayload = {
        targetType: 'map',
        mapKey: sourceData.mapTitles[mapPicked - 1].mapKey,
        targetPlayers: selectedPlayers,
        mapPioneersByMapMode: pioneerChoice === 2
      };
    }

    const difficultyChoice = await askSingleChoice(rl, '自动补发难度挑战称号（回车默认：否）', ['否', '是'], {
      allowEmpty: true,
      defaultChoice: 1,
      defaultLabel: '否',
      ui
    });
    const masteryChoice = await askSingleChoice(
      rl,
      '地图精通模式（回车默认：check_only）',
      ['off', 'check_only', 'grant'],
      {
        allowEmpty: true,
        defaultChoice: 2,
        defaultLabel: 'check_only',
        ui
      }
    );

    const options = {
      grantDifficultyFromMaps: difficultyChoice === 2,
      autoMasteryMode: ['off', 'check_only', 'grant'][masteryChoice - 1]
    };

    return buildInteractiveRequest({
      ...requestPayload,
      options
    });
  } finally {
    if (!usingInjectedReadline) {
      rl.close();
    }
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
        console.log(
          '  node tools/grant-player-title.mjs --player-name <name> [--general-title <TITLE_KEY>] [--general-title-label <中文称号>] [--map-pioneer <MAP_KEY_OR_LABEL>] [--fail-on-missing-player] [--dry-run]'
        );
        console.log(
          '  node tools/grant-player-title.mjs --player-id <id> [--general-title <TITLE_KEY>] [--general-title-label <中文称号>] [--map-pioneer <MAP_KEY_OR_LABEL>] [--dry-run]'
        );
        process.exit(0);
      }

      let requestData = null;
      if (args.interactive) {
        const sourceData = await loadTitleSource(SOURCE_FILE);
        requestData = await collectInteractiveRequest(sourceData);
        const ui = createUi(output);

        const preview = await grantPlayerTitle({
          sourceFile: SOURCE_FILE,
          requestData,
          dryRun: true
        });

        ui.contrast('\n变更预览');
        ui.strong(JSON.stringify(preview.preview, null, 2));

        const rl = readline.createInterface({ input, output });
        try {
          const confirm = await rl.question(`${ui.ansi.strong('确认写入? [y/N]')}: `);
          if (!parseYesNo(confirm, false)) {
            ui.warning('已取消，不做写入。');
            process.exit(0);
          }
          ui.success('确认写入，开始执行同步流程。');
        } finally {
          rl.close();
        }
      }

      if (args.playerName || args.playerId !== undefined) {
        const sourceData = await loadTitleSource(SOURCE_FILE);
        const targetName = args.playerName ?? resolvePlayerNameFromPlayerId(sourceData, args.playerId);
        const mappedFromLabels = args.generalTitleLabels.map((label) => resolveTitleKeyFromLabel(sourceData, label));
        const mergedGeneralTitles = [...args.generalTitles, ...mappedFromLabels];

        requestData = buildInteractiveRequest({
          targetType: 'player',
          playerName: targetName,
          generalTitles: [...new Set(mergedGeneralTitles)],
          mapPioneers: [...new Set(args.mapPioneers)],
          mapDominators: [],
          options: {
            grantDifficultyFromMaps: false,
            autoMasteryMode: 'off',
            failOnMissingPlayer: args.failOnMissingPlayer
          }
        });
      }

      const result = await grantPlayerTitle({
        inputFile: args.inputFile,
        requestData,
        dryRun: args.dryRun
      });
      console.log(JSON.stringify(result, null, 2));
    })
    .catch((error) => {
      const ansi = createAnsi();
      console.error(ansi.error(error.message));
      process.exitCode = 1;
    });
}
