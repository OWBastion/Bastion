import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const SOURCE_FILE = path.resolve(__dirname, '../src/title/title-cn.opy');
const ENV_FILE = path.resolve(__dirname, '../src/env/env.opy');
const OUTPUT_FILE = path.resolve(__dirname, '../web/title-query/public/data/titles.json');

const TITLE_GUIDE_METADATA = {
  PIONEER: { category: '社区贡献系列', condition: '在新地图内测/公测中完成对应地图地狱通关（群内审核发放）。' },
  TEST_LONG: { category: '开发保留', condition: '测试占位称号，不对外发放。' },
  NOT_MY_MAP: { category: '开发保留', condition: '开发/管理用途，文档未提供公开挑战条件。' },
  WILD_DEV: { category: '开发保留', condition: '开发/管理用途，文档未提供公开挑战条件。' },
  ARCHITECT: { category: '开发保留', condition: '开发/管理用途，文档未提供公开挑战条件。' },
  MAINTAINER: { category: '开发保留', condition: '开发/管理用途，文档未提供公开挑战条件。' },
  THREE_IN_ONE: { category: '开发保留', condition: '开发/管理用途，文档未提供公开挑战条件。' },
  BLACK_SHEEP: { category: '开发保留', condition: '历史/内部称号，文档未提供公开挑战条件。' },
  PURE_HARM: { category: '开发保留', condition: '历史/内部称号，文档未提供公开挑战条件。' },
  CONQUEROR: { category: '地图精通系列', condition: '通关对应地图传奇难度。' },
  DOMINATOR: { category: '地图精通系列', condition: '通关对应地图地狱难度。' },
  SURVIVOR_EXPERT: { category: '难度挑战系列', condition: '历史称号（当前不再发放）。' },
  CHALLENGER_LEGEND: { category: '难度挑战系列', condition: '成功通关任意地图传奇难度。' },
  TRAVELER_HELL: { category: '难度挑战系列', condition: '成功通关任意地图地狱难度。' },
  DODGE_ULTIMATE: { category: '极限操作系列', condition: '单局阵亡次数 ≤ 15 且成功通关。' },
  LIGHT_PACK: { category: '待补充', condition: '文档未提供该称号的公开挑战条件。' },
  FLAWLESS: { category: '极限操作系列', condition: '单局跳过英雄次数为 0 且通关。' },
  NEVER_GIVE_UP: { category: '极限操作系列', condition: '单局跳过英雄次数为 43 且通关（当前暂停/历史发放）。' },
  PERSEVERANCE: { category: '待补充', condition: '文档未提供该称号的公开挑战条件。' },
  SPEEDRUN: { category: '极限操作系列', condition: '传奇及以上难度，通关时间 < 1 小时 30 分钟。' },
  DODGE_GOD: { category: '生存与闪避系列', condition: '地狱难度单局未被任何榴弹命中并通关（历史称号）。' },
  ZENYATTA: { category: '待补充', condition: '文档未提供该称号的公开挑战条件。' },
  HARD_TO_KILL: { category: '生存与闪避系列', condition: '受到榴弹伤害后剩余 1-5 点生命并存活。' },
  WIN_HEAVEN: { category: '活动限定', condition: '随机事件 2.0 限时挑战达成指定组合条件。' },
  IDOL: { category: '倒霉蛋系列', condition: '历史称号（当前不再发放）。' },
  EGG_FIRST: { category: '倒霉蛋系列', condition: '历史称号（当前不再发放）。' },
  EAT_MORE: { category: '倒霉蛋系列', condition: '历史称号（当前不再发放）。' },
  ALL_IN_ONE: { category: '地图精通系列', condition: '获得所有地图“征服者”头衔。' },
  TRAVELER: { category: '地图精通系列', condition: '获得所有可用地图的难度挑战头衔。' },
  SKY: { category: '地图精通系列', condition: '获得所有地图“主宰”头衔。' },
  FLAME: { category: '活动限定', condition: '狂暴之心限定挑战：低伤害+低阵亡并 25 分钟内通关。' },
  PASS_EGGS: { category: '活动限定', condition: '狂暴之心限定挑战：单局阵亡数 ≤ 5 并通关。' },
  CHOSEN: { category: '随机事件系列', condition: '单局增益事件数量达到减益事件的 1.5 倍及以上。' },
  LUCKY_STAR: { category: '随机事件系列', condition: '连续 10 次抽到增益事件并通关。' },
  GAMBLE_KING: { category: '活动限定', condition: '随机事件 3.0 限时挑战：赌徒类事件连续 5 次增益。' },
  LUCKY_SHINE: { category: '随机事件系列', condition: '单局抽到减益事件次数低于 10。' },
  UNLUCKY: { category: '随机事件系列', condition: '单局减益事件数量达到增益事件的 1.5 倍及以上并通关。' },
  MANBA: { category: '随机事件系列', condition: '连续 10 次抽到减益事件并通关。' },
  MY_FATE: { category: '活动限定', condition: '随机事件 1.0 限时挑战达成指定组合条件。' },
  GOD_GAMBLER: { category: '活动限定', condition: '随机事件 4.0 限时挑战：达成幸运星+钢门并满足赌徒连胜条件。' },
  LAO_DA: { category: '活动限定', condition: '随机事件 4.0 限时挑战：达成 What Can I Say + 倒霉蛋并满足赌徒连败条件。' },
  V_50: { category: '随机事件系列', condition: '使用“吸血鬼 ProMax”从队友吸取 5000+ 生命并通关。' },
  STEEL: { category: '随机事件系列', condition: '心之钢层数达到 1200 层并通关。' },
  HACKING: { category: '随机事件系列', condition: '地狱难度单局触发所有作弊事件并通关。' },
  RED_PACKET: { category: '活动限定', condition: '鸿运当头挑战：单局拾取 88 个红包。' },
  GOOD_LUCK: { category: '活动限定', condition: '鸿运当头挑战：累计触发 50 次增益事件。' },
  LONE_WALKER: { category: '活动限定', condition: '鸿运当头挑战：累计触发 20 次“一马当先”并在该对局通关。' },
  GREEN_MOUNTAIN: { category: '活动限定', condition: '鸿运当头挑战：通关漓江塔夜市/庭院/控制中心。' },
  SUAN_BU_LA: { category: '活动限定', condition: '鸿运当头挑战：累计拾取 18 个“红包刺客”。' }
};

const DEFAULT_TITLE_GUIDE = {
  category: '待补充',
  condition: '文档未提供该称号的公开挑战条件。'
};

function extractIndentedBlock(source, header) {
  const start = source.indexOf(header);
  if (start === -1) {
    throw new Error(`Unable to find block header: ${header}`);
  }

  const blockStart = start + header.length;
  const remainder = source.slice(blockStart);
  const lines = remainder.split('\n');
  const collected = [];

  for (const line of lines) {
    if (line.startsWith('    ') || line.trim() === '') {
      collected.push(line);
      continue;
    }

    break;
  }

  return collected.join('\n');
}

function extractBracketSection(source, header) {
  const start = source.indexOf(header);
  if (start === -1) {
    throw new Error(`Unable to find section header: ${header}`);
  }

  const openIndex = source.indexOf('[', start);
  if (openIndex === -1) {
    throw new Error(`Unable to find opening [ for section: ${header}`);
  }

  let depth = 0;
  let inString = false;
  let escaped = false;

  for (let index = openIndex; index < source.length; index += 1) {
    const char = source[index];

    if (inString) {
      if (escaped) {
        escaped = false;
      } else if (char === '\\') {
        escaped = true;
      } else if (char === '"') {
        inString = false;
      }
      continue;
    }

    if (char === '"') {
      inString = true;
      continue;
    }

    if (char === '[') {
      depth += 1;
      continue;
    }

    if (char === ']') {
      depth -= 1;
      if (depth === 0) {
        return source.slice(openIndex, index + 1);
      }
    }
  }

  throw new Error(`Unable to find closing ] for section: ${header}`);
}

function splitTopLevelObjects(source) {
  const items = [];
  let current = '';
  let depth = 0;
  let inString = false;
  let escaped = false;

  for (const char of source) {
    current += char;

    if (inString) {
      if (escaped) {
        escaped = false;
      } else if (char === '\\') {
        escaped = true;
      } else if (char === '"') {
        inString = false;
      }
      continue;
    }

    if (char === '"') {
      inString = true;
      continue;
    }

    if (char === '{') {
      depth += 1;
      continue;
    }

    if (char === '}') {
      depth -= 1;
      if (depth === 0) {
        items.push(current.trim());
        current = '';
      }
    }
  }

  return items.filter(Boolean);
}

function parseTitleEnum(source) {
  const block = extractIndentedBlock(source, 'enum TITLE:\n');
  const titles = [];

  for (const line of block.split('\n')) {
    const trimmed = line.trim();
    if (!trimmed) {
      continue;
    }

    const match = trimmed.match(/^([A-Z0-9_]+)\s*,?(?:\s*#\s*\d+\s*(.*))?$/);
    if (!match) {
      throw new Error(`Unable to parse TITLE enum line: ${trimmed}`);
    }

    titles.push({
      id: titles.length,
      key: match[1],
      fallbackLabel: (match[2] || '').trim()
    });
  }

  if (titles.length === 0) {
    throw new Error('Parsed TITLE enum is empty.');
  }

  return titles;
}

function parseStaticTitleLabels(source, titleEnum) {
  const block = extractBracketSection(source, 'allTitle = [');
  const lines = block
    .split('\n')
    .map((line) => line.trim())
    .filter((line) => line.startsWith('[') && line !== '[');

  if (lines.length !== titleEnum.length) {
    throw new Error(
      `allTitle entry count (${lines.length}) does not match TITLE enum count (${titleEnum.length}).`
    );
  }

  return titleEnum.map((item, index) => {
    const line = lines[index];
    const match = line.match(/\[\s*"((?:[^"\\]|\\.)*)"/);

    if (!match) {
      throw new Error(`Unable to parse allTitle label line: ${line}`);
    }

    const rawLabel = match[1].replace(/\\"/g, '"');
    const cleaned = rawLabel.replace(/\{\d+\}/g, '').trim();
    const label = cleaned || item.fallbackLabel;

    if (!label) {
      throw new Error(`Unable to resolve label for TITLE.${item.key}`);
    }

    const guide = TITLE_GUIDE_METADATA[item.key] ?? DEFAULT_TITLE_GUIDE;

    return {
      id: item.id,
      key: item.key,
      label,
      category: guide.category,
      condition: guide.condition
    };
  });
}

function parseSimpleArrayMacros(source) {
  const result = new Map();
  const regex = /^#!define\s+([A-Z0-9_]+)\s+\[(.*)\]$/gm;

  for (const match of source.matchAll(regex)) {
    result.set(match[1], match[2].trim());
  }

  return result;
}

function parseTitleListExpression(expression, titleIdByKey, arrayMacros, playerName) {
  const trimmed = expression.trim();
  let resolved = trimmed;

  if (arrayMacros.has(trimmed)) {
    resolved = `[${arrayMacros.get(trimmed)}]`;
  }

  if (!resolved.startsWith('[') || !resolved.endsWith(']')) {
    throw new Error(`Unsupported title expression for ${playerName}: ${expression}`);
  }

  const tokens = resolved
    .slice(1, -1)
    .split(',')
    .map((token) => token.trim())
    .filter(Boolean);

  const seen = new Set();
  const titleIds = [];

  for (const token of tokens) {
    const match = token.match(/^TITLE\.([A-Z0-9_]+)$/);
    if (!match) {
      throw new Error(`Unsupported title token for ${playerName}: ${token}`);
    }

    const titleKey = match[1];
    const titleId = titleIdByKey.get(titleKey);

    if (titleId === undefined) {
      throw new Error(`Unknown title token for ${playerName}: ${token}`);
    }

    if (seen.has(titleId)) {
      console.warn(`Deduplicated duplicate title ${titleKey} for player ${playerName}`);
      continue;
    }

    seen.add(titleId);
    titleIds.push(titleId);
  }

  return titleIds;
}

function parsePlayerDatabase(source, titleEnum) {
  const macros = parseSimpleArrayMacros(source);
  const titleIdByKey = new Map(titleEnum.map((title) => [title.key, title.id]));
  const block = extractBracketSection(source, '#!define player_database');
  const compact = block
    .replace(/\\\s*\n/g, ' ')
    .replace(/\\/g, ' ')
    .replace(/\s+/g, ' ');

  const objectMatches = splitTopLevelObjects(compact.slice(1, -1));
  const players = objectMatches.map((entry) => {
    const nameMatch = entry.match(/name:\s*"([^"]+)"/);
    const titlesMatch = entry.match(/titles:\s*(\[[^\]]*\]|[A-Z0-9_]+)/);

    if (!nameMatch || !titlesMatch) {
      throw new Error(`Unable to parse player entry: ${entry}`);
    }

    const name = nameMatch[1];
    const titleIds = parseTitleListExpression(titlesMatch[1], titleIdByKey, macros, name);

    return {
      name,
      titleIds,
      titleCount: titleIds.length
    };
  });

  if (players.length === 0) {
    throw new Error('Parsed player database is empty.');
  }

  return players;
}

function parseMainVersion(source) {
  const match = source.match(/^#!define\s+VERSION\s+"([^"]+)"/m);
  if (!match) {
    throw new Error('Unable to parse VERSION from src/env/env.opy');
  }

  return match[1];
}

export function parseTitleSource(source) {
  const titleEnum = parseTitleEnum(source);
  const titles = parseStaticTitleLabels(source, titleEnum);
  const players = parsePlayerDatabase(source, titleEnum).sort((left, right) =>
    left.name.localeCompare(right.name, 'zh-Hans-CN')
  );

  return {
    titles,
    players,
    meta: {
      sourceFile: 'src/title/title-cn.opy',
      generatedAt: new Date().toISOString(),
      titleCount: titles.length,
      playerCount: players.length
    }
  };
}

export async function generateTitleQueryData({
  sourceFile = SOURCE_FILE,
  envFile = ENV_FILE,
  outputFile = OUTPUT_FILE
} = {}) {
  const [source, envSource] = await Promise.all([fs.readFile(sourceFile, 'utf8'), fs.readFile(envFile, 'utf8')]);
  const data = parseTitleSource(source);
  const mainVersion = parseMainVersion(envSource);
  data.meta.sourceLabel = '躲避堡垒3';
  data.meta.sourceVersion = mainVersion;

  await fs.mkdir(path.dirname(outputFile), { recursive: true });
  await fs.writeFile(outputFile, `${JSON.stringify(data, null, 2)}\n`, 'utf8');

  return data;
}

const invokedPath = process.argv[1] ? path.resolve(process.argv[1]) : null;

if (invokedPath === __filename) {
  generateTitleQueryData()
    .then((data) => {
      console.log(
        `Generated ${data.meta.playerCount} players and ${data.meta.titleCount} titles at ${path.relative(process.cwd(), OUTPUT_FILE)}`
      );
    })
    .catch((error) => {
      console.error(error.message);
      process.exitCode = 1;
    });
}
