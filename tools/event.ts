import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

type EventType = 'buff' | 'debuff' | 'mech';

type AddSpec = {
  action: 'add';
  type: EventType;
  key: string;
  id: number;
  titleZh: string;
  descZh: string;
  titleEn: string;
  descEn: string;
  duration: string;
  weight: string;
  configDescExpr?: string;
};

type RemoveSpec = {
  action: 'remove';
  type: EventType;
  key: string;
  id: number;
};

type MaintainSpec = AddSpec | RemoveSpec;

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const ROOT = path.resolve(__dirname, '..');

const PATHS = {
  ids: path.resolve(ROOT, 'src/constants/event_ids.opy'),
  constants: path.resolve(ROOT, 'src/constants/event_constants.opy'),
  localeZh: path.resolve(ROOT, 'src/locales/zh-CN.opy'),
  localeEn: path.resolve(ROOT, 'src/locales/en-US.opy'),
  catalog: path.resolve(ROOT, 'src/config/eventCatalog.opy'),
  catalogMain: path.resolve(ROOT, 'src/config/eventCatalogMain.opy'),
  catalogDev: path.resolve(ROOT, 'src/config/eventCatalogDev.opy')
} as const;

const ENUM_NAME = 'EventId';

const ENUM_SECTION_END: Record<EventType, string> = {
  buff: '    # ---- Debuff ----',
  debuff: '    # ---- Mech ----',
  mech: '    # sentinel only for integrity checks'
};

const CONFIG_CONTAINER: Record<EventType, { prefix: string }> = {
  buff: { prefix: 'BUFF' },
  debuff: { prefix: 'DEBUFF' },
  mech: { prefix: 'MECH' }
};

function ensureString(value: unknown, label: string): string {
  if (typeof value !== 'string' || value.trim() === '') {
    throw new Error(`${label} must be a non-empty string`);
  }
  return value.trim();
}

function ensureInteger(value: unknown, label: string): number {
  if (!Number.isInteger(value)) {
    throw new Error(`${label} must be an integer`);
  }
  return value as number;
}

function normalizeEventType(value: unknown): EventType {
  const normalized = String(value ?? '').trim().toLowerCase();
  if (normalized !== 'buff' && normalized !== 'debuff' && normalized !== 'mech') {
    throw new Error(`type must be one of buff/debuff/mech, got: ${String(value ?? '')}`);
  }
  return normalized;
}

function escapeRegExp(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function addEnumEntry(source: string, type: EventType, key: string, id: number): string {
  const marker = `enum ${ENUM_NAME}:`;
  const start = source.indexOf(marker);
  if (start < 0) {
    throw new Error(`Unable to find ${marker}`);
  }
  if (source.includes(`\n    ${key}\n`) || source.includes(`\n    ${key} =`)) {
    throw new Error(`${ENUM_NAME}.${key} already exists`);
  }
  const sectionEnd = source.indexOf(ENUM_SECTION_END[type], start);
  if (sectionEnd < 0) {
    throw new Error(`Unable to find ${type} section end in ${ENUM_NAME}`);
  }
  const insert = `    # legacy numeric id: ${id}\n    ${key}\n`;
  return `${source.slice(0, sectionEnd)}${insert}${source.slice(sectionEnd)}`;
}

function removeEnumEntry(source: string, key: string): string {
  const regex = new RegExp(`^\\s{4}${escapeRegExp(key)}(?:\\s*=\\s*\\d+)?\\s*$`, 'm');
  const match = source.match(regex);
  if (!match || match.index == null) {
    throw new Error(`${ENUM_NAME}.${key} not found`);
  }

  const lineStart = source.lastIndexOf('\n', match.index) + 1;
  let start = lineStart;
  const commentStart = source.lastIndexOf('\n', lineStart - 2) + 1;
  const prevLine = source.slice(commentStart, lineStart - 1);
  if (prevLine.trim().startsWith('# legacy numeric id:')) {
    start = commentStart;
  }

  const lineEnd = source.indexOf('\n', match.index + match[0].length);
  const end = lineEnd === -1 ? source.length : lineEnd + 1;
  return `${source.slice(0, start)}${source.slice(end)}`;
}

function addConstantsBlock(source: string, type: EventType, id: number, duration: string, weight: string): string {
  const prefix = CONFIG_CONTAINER[type].prefix;
  const durationKey = `EVT_${prefix}_${id}_DURATION`;
  const weightKey = `EVT_${prefix}_${id}_WEIGHT`;

  if (source.includes(`#!define ${durationKey} `) || source.includes(`#!define ${weightKey} `)) {
    throw new Error(`Constants for ${prefix} ${id} already exist`);
  }

  const sectionMarker = `# -----------------------------------------------------------------------------\n# ${prefix} 事件（按ID排序）`;
  const sectionStart = source.indexOf(sectionMarker);
  if (sectionStart < 0) {
    throw new Error(`Unable to find ${prefix} section in event_constants.opy`);
  }

  const nextSection = source.indexOf('# -----------------------------------------------------------------------------', sectionStart + sectionMarker.length);
  const insertPos = nextSection > 0 ? nextSection : source.length;
  const block =
    `\n# --- ID ${id} ---\n` +
    '# Duration（秒）\n' +
    `#!define ${durationKey} ${duration}\n` +
    '# Weight（权重）\n' +
    `#!define ${weightKey} ${weight}\n`;

  return `${source.slice(0, insertPos)}${block}${source.slice(insertPos)}`;
}

function removeConstantsBlock(source: string, type: EventType, id: number): string {
  const prefix = CONFIG_CONTAINER[type].prefix;
  const keyPrefix = `#!define EVT_${prefix}_${id}_`;

  const lines = source.split('\n');
  const filtered = lines.filter((line) => !line.startsWith(keyPrefix));
  if (filtered.length === lines.length) {
    throw new Error(`No EVT_${prefix}_${id}_* constants found`);
  }
  return `${filtered.join('\n')}\n`;
}

function addLocaleEntries(source: string, type: EventType, id: number, title: string, desc: string): string {
  const prefix = CONFIG_CONTAINER[type].prefix;
  const titleKey = `STR_EVT_${prefix}_${id}_TITLE`;
  const descKey = `STR_EVT_${prefix}_${id}_DESC`;
  if (source.includes(`#!define ${titleKey} `) || source.includes(`#!define ${descKey} `)) {
    throw new Error(`Locale keys ${titleKey}/${descKey} already exist`);
  }

  return `${source.trimEnd()}\n#!define ${titleKey} ${JSON.stringify(title)}\n#!define ${descKey} ${JSON.stringify(desc)}\n`;
}

function removeLocaleEntries(source: string, type: EventType, id: number): string {
  const prefix = CONFIG_CONTAINER[type].prefix;
  const titleKey = `STR_EVT_${prefix}_${id}_TITLE`;
  const descKey = `STR_EVT_${prefix}_${id}_DESC`;
  const lines = source.split('\n');
  const filtered = lines.filter((line) => !line.startsWith(`#!define ${titleKey} `) && !line.startsWith(`#!define ${descKey} `));
  if (filtered.length === lines.length) {
    throw new Error(`Locale keys ${titleKey}/${descKey} not found`);
  }
  return `${filtered.join('\n')}\n`;
}

function addConfigRegistration(source: string, spec: AddSpec): string {
  const cfg = CONFIG_CONTAINER[spec.type];
  const titleToken = `STR_EVT_${cfg.prefix}_${spec.id}_TITLE`;
  const descToken = spec.configDescExpr?.trim() || `STR_EVT_${cfg.prefix}_${spec.id}_DESC`;
  const block =
    `    eventName[${ENUM_NAME}.${spec.key}] = ${titleToken}\n` +
    `    eventDesc[${ENUM_NAME}.${spec.key}] = ${descToken}\n` +
    `    eventDuration[${ENUM_NAME}.${spec.key}] = EVT_${cfg.prefix}_${spec.id}_DURATION\n` +
    `    eventCatalogWeight[${ENUM_NAME}.${spec.key}] = EVT_${cfg.prefix}_${spec.id}_WEIGHT\n` +
    `    eventCatalogType[${ENUM_NAME}.${spec.key}] = EventType.${cfg.prefix}`;

  if (source.includes(`${ENUM_NAME}.${spec.key}]`) || source.includes(`${ENUM_NAME}.${spec.key})`)) {
    throw new Error(`${ENUM_NAME}.${spec.key} already registered in config`);
  }

  return `${source.trimEnd()}\n\n${block}\n`;
}

function addCatalogOrderEntry(source: string, key: string): string {
  const pattern = /(#!define\s+EVENT_CATALOG_ORDER\s+\[[^\]]*)\]/;
  if (!pattern.test(source)) {
    throw new Error('EVENT_CATALOG_ORDER define not found');
  }
  if (source.includes(`${ENUM_NAME}.${key}`)) {
    throw new Error(`${ENUM_NAME}.${key} already present in EVENT_CATALOG_ORDER`);
  }
  return source.replace(pattern, `$1, ${ENUM_NAME}.${key}]`);
}

function removeCatalogOrderEntry(source: string, key: string): string {
  const escaped = escapeRegExp(`${ENUM_NAME}.${key}`);
  const pattern = new RegExp(`${escaped},\\s*|,\\s*${escaped}`);
  if (!pattern.test(source)) {
    throw new Error(`${ENUM_NAME}.${key} not found in EVENT_CATALOG_ORDER`);
  }
  return source.replace(pattern, '');
}

function removeConfigRegistration(source: string, spec: RemoveSpec): string {
  const escapedEnum = escapeRegExp(`${ENUM_NAME}.${spec.key}`);
  const lines = source.split('\n');
  let removed = 0;
  const filtered = lines.filter((line) => {
    const matchAssign = new RegExp(`^\\s*\\w+\\[\\s*${escapedEnum}\\s*\\]\\s*=`).test(line);
    if (matchAssign) {
      removed += 1;
      return false;
    }
    return true;
  });

  if (removed === 0) {
    throw new Error(`${ENUM_NAME}.${spec.key} registration not found`);
  }

  return `${filtered.join('\n')}\n`;
}

async function mutateFiles(spec: MaintainSpec, dryRun: boolean) {
  const files = {
    ids: PATHS.ids,
    constants: PATHS.constants,
    localeZh: PATHS.localeZh,
    localeEn: PATHS.localeEn,
    catalog: PATHS.catalog,
    catalogMain: PATHS.catalogMain,
    catalogDev: PATHS.catalogDev
  };

  const [ids, constants, localeZh, localeEn, catalog, catalogMain, catalogDev] = await Promise.all([
    fs.readFile(files.ids, 'utf8'),
    fs.readFile(files.constants, 'utf8'),
    fs.readFile(files.localeZh, 'utf8'),
    fs.readFile(files.localeEn, 'utf8'),
    fs.readFile(files.catalog, 'utf8'),
    fs.readFile(files.catalogMain, 'utf8'),
    fs.readFile(files.catalogDev, 'utf8')
  ]);

  let next = { ids, constants, localeZh, localeEn, catalog, catalogMain, catalogDev };

  if (spec.action === 'add') {
    next = {
      ids: addEnumEntry(next.ids, spec.type, spec.key, spec.id),
      constants: addConstantsBlock(next.constants, spec.type, spec.id, spec.duration, spec.weight),
      localeZh: addLocaleEntries(next.localeZh, spec.type, spec.id, spec.titleZh, spec.descZh),
      localeEn: addLocaleEntries(next.localeEn, spec.type, spec.id, spec.titleEn, spec.descEn),
      catalog: addConfigRegistration(next.catalog, spec),
      catalogMain: addCatalogOrderEntry(next.catalogMain, spec.key),
      catalogDev: addCatalogOrderEntry(next.catalogDev, spec.key)
    };
  } else {
    next = {
      ids: removeEnumEntry(next.ids, spec.key),
      constants: removeConstantsBlock(next.constants, spec.type, spec.id),
      localeZh: removeLocaleEntries(next.localeZh, spec.type, spec.id),
      localeEn: removeLocaleEntries(next.localeEn, spec.type, spec.id),
      catalog: removeConfigRegistration(next.catalog, spec),
      catalogMain: removeCatalogOrderEntry(next.catalogMain, spec.key),
      catalogDev: removeCatalogOrderEntry(next.catalogDev, spec.key)
    };
  }

  const writes = [
    [files.ids, next.ids],
    [files.constants, next.constants],
    [files.localeZh, next.localeZh],
    [files.localeEn, next.localeEn],
    [files.catalog, next.catalog],
    [files.catalogMain, next.catalogMain],
    [files.catalogDev, next.catalogDev]
  ] as const;

  if (!dryRun) {
    await Promise.all(writes.map(([file, content]) => fs.writeFile(file, content, 'utf8')));
  }

  return writes.map(([file]) => path.relative(ROOT, file));
}

function parseSpec(input: unknown): MaintainSpec {
  const raw = input as Record<string, unknown>;
  if (!raw || typeof raw !== 'object') {
    throw new Error('Spec JSON must be an object');
  }

  const action = ensureString(raw.action, 'action').toLowerCase();
  if (action !== 'add' && action !== 'remove') {
    throw new Error(`action must be add/remove, got: ${action}`);
  }

  const type = normalizeEventType(raw.type);
  const key = ensureString(raw.key, 'key').toUpperCase();
  const id = ensureInteger(raw.id, 'id');

  if (action === 'remove') {
    return { action, type, key, id };
  }

  return {
    action,
    type,
    key,
    id,
    titleZh: ensureString(raw.titleZh, 'titleZh'),
    descZh: ensureString(raw.descZh, 'descZh'),
    titleEn: ensureString(raw.titleEn, 'titleEn'),
    descEn: ensureString(raw.descEn, 'descEn'),
    duration: ensureString(raw.duration, 'duration'),
    weight: ensureString(raw.weight, 'weight'),
    configDescExpr: typeof raw.configDescExpr === 'string' ? raw.configDescExpr : undefined
  };
}

function parseArgs(rawArgs: string[]) {
  let specFile = '';
  let dryRun = false;

  for (let i = 0; i < rawArgs.length; i += 1) {
    const arg = rawArgs[i];
    if (arg === '--dry-run') {
      dryRun = true;
      continue;
    }
    if (arg === '--spec') {
      const value = rawArgs[i + 1];
      if (!value) {
        throw new Error('--spec requires a path');
      }
      specFile = value;
      i += 1;
      continue;
    }
  }

  if (!specFile) {
    throw new Error('Usage: pnpm run tools -- event:add --spec <file.json> [--dry-run] | event:remove --spec <file.json> [--dry-run]');
  }

  return { specFile: path.resolve(process.cwd(), specFile), dryRun };
}

export async function main(rawArgs: string[]) {
  const { specFile, dryRun } = parseArgs(rawArgs);
  const rawSpec = JSON.parse(await fs.readFile(specFile, 'utf8'));
  const spec = parseSpec(rawSpec);

  const touched = await mutateFiles(spec, dryRun);
  console.log(`${spec.action} ${spec.type}.${spec.key} (id=${spec.id}) ${dryRun ? '[dry-run]' : '[applied]'}`);
  for (const file of touched) {
    console.log(`- ${file}`);
  }
  console.log('Next: pnpm run sync:platform-data && pnpm run build');
}

const invokedPath = process.argv[1] ? path.resolve(process.argv[1]) : null;
if (invokedPath === __filename) {
  main(process.argv.slice(2)).catch((error) => {
    const message = error instanceof Error ? error.message : String(error);
    console.error(message);
    process.exitCode = 1;
  });
}
