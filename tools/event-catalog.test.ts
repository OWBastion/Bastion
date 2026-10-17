import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const read = (file: string) => readFile(new URL(`../${file}`, import.meta.url), 'utf8');

// Pinned per-profile catalog order. The two profiles intentionally register the
// same event set in different orders; either list changing order or membership
// is a catalog-order regression and must be acknowledged here.
const MAIN_ORDER = [
  'OLIVIA_GIFT', 'GALE_BLESSING', 'IRON_BULWARK', 'LIFE_SPRING', 'BLACK_FANS_ASSAULT', 'SPEED_STACK',
  'FLESH_REGEN', 'HEART_OF_STEEL', 'GRAVITY_ANOMALY', 'EMP', 'SACRIFICE', 'VULNERABLE',
  'SPEED_LIMIT_40', 'GAMBLER', 'MINI_FORM', 'STEALTH_CROUCH', 'DEATH_DELAY', 'KONAMI_CODE',
  'PHOTON_SHIELD', 'GRAVITY_PULL', 'OSTEOPOROSIS', 'EMP_PROMAX', 'ENERGY_LEAK', 'SHARE_THE_PAIN',
  'FEAST_FRENZY', 'POWERLESS_SPOUSE', 'BRAKE_FAILURE', 'REGROUP_CALL', 'WILL_TO_WIN',
  'PHEIDIPPIDES_TRIAL', 'HEART_OF_STEEL_PRO', 'ULT_MOMENTUM', 'HALVED', 'SELFLESS_GIVEAWAY',
  'EXTREME_CHALLENGE', 'JUMP_THRUST', 'GAMBLER_SPEED_CHALLENGE', 'PHASE_SURGE', 'BODYGUARD',
  'MARTYR_TRIAL', 'F5_REFRESH', 'HEALING_TOWER_PROMAX', 'KEEP_DISTANCE_AURA', 'MOON_ROCKET',
  'CHEAT_CARD_COUNTING', 'GAMBLER_SHORT_INVESTMENT', 'CHEAT_SKIP_HERO', 'NESTING_DOLL',
  'GAMBLER_LONG_INVESTMENT', 'VALKYRIE_DESCENT', 'TRINITY_SSR', 'VAMPIRE', 'THIEF',
  'GAMBLER_HELPFUL_SOUL', 'CHEAT_BACKROOM_DEAL', 'MIRROR_INVERSION', 'GAMBLER_WINNER_TAKE_ALL',
  'MAGIC_MASTER', 'DIVINE_REINFORCEMENT', 'TEMPER_HEART', 'BATTLEFIELD_MEDIC', 'WAYWARD_NAVIGATION',
  'OVERWEIGHT_PACK', 'ADLERSBRUNN_WRAITH', 'GAMBLER_DICE_MANIAC', 'GAMBLER_HEART_OF_STEEL',
  'GAMBLER_ALL_IN_ART_5', 'SHARED_BLESSING', 'STATIC_FIELD', 'PROPHET', 'SOLO_RUN', 'SOLO_LEVEL_UP', 'SOLO_DECIDE'
];

const DEV_ORDER = [
  'OLIVIA_GIFT', 'GALE_BLESSING', 'IRON_BULWARK', 'LIFE_SPRING', 'BLACK_FANS_ASSAULT', 'SPEED_STACK',
  'FLESH_REGEN', 'HEART_OF_STEEL', 'DEATH_DELAY', 'KONAMI_CODE', 'PHOTON_SHIELD', 'REGROUP_CALL',
  'WILL_TO_WIN', 'PHEIDIPPIDES_TRIAL', 'HEART_OF_STEEL_PRO', 'ULT_MOMENTUM', 'PHASE_SURGE', 'BODYGUARD',
  'MARTYR_TRIAL', 'F5_REFRESH', 'HEALING_TOWER_PROMAX', 'MAGIC_MASTER', 'DIVINE_REINFORCEMENT', 'TEMPER_HEART',
  'BATTLEFIELD_MEDIC', 'GRAVITY_ANOMALY', 'EMP', 'SACRIFICE', 'VULNERABLE', 'SPEED_LIMIT_40',
  'GRAVITY_PULL', 'OSTEOPOROSIS', 'EMP_PROMAX', 'ENERGY_LEAK', 'SHARE_THE_PAIN', 'FEAST_FRENZY',
  'POWERLESS_SPOUSE', 'HALVED', 'SELFLESS_GIVEAWAY', 'KEEP_DISTANCE_AURA', 'MOON_ROCKET', 'WAYWARD_NAVIGATION',
  'OVERWEIGHT_PACK', 'ADLERSBRUNN_WRAITH', 'EXTREME_CHALLENGE', 'GAMBLER', 'MINI_FORM', 'STEALTH_CROUCH',
  'BRAKE_FAILURE', 'JUMP_THRUST', 'GAMBLER_SPEED_CHALLENGE', 'CHEAT_CARD_COUNTING', 'GAMBLER_SHORT_INVESTMENT', 'CHEAT_SKIP_HERO',
  'NESTING_DOLL', 'GAMBLER_LONG_INVESTMENT', 'VALKYRIE_DESCENT', 'TRINITY_SSR', 'VAMPIRE', 'THIEF',
  'GAMBLER_HELPFUL_SOUL', 'GAMBLER_DICE_MANIAC', 'GAMBLER_HEART_OF_STEEL', 'GAMBLER_ALL_IN_ART_5', 'GAMBLER_WINNER_TAKE_ALL', 'CHEAT_BACKROOM_DEAL',
  'MIRROR_INVERSION', 'SHARED_BLESSING', 'STATIC_FIELD', 'PROPHET', 'SOLO_RUN', 'SOLO_LEVEL_UP', 'SOLO_DECIDE'
];

function catalogRows(catalog: string): { index: number; key: string; row: string }[] {
  const rows: { index: number; key: string; row: string }[] = [];
  for (const match of catalog.matchAll(/# (\d+): EventId\.([A-Z0-9_]+)\n    (\[.*\]),?\s*$/gm)) {
    rows.push({ index: Number(match[1]), key: match[2], row: match[3] });
  }
  return rows;
}

function registeredEvents(catalog: string): string[] {
  return catalogRows(catalog).map((row) => row.key);
}

function topLevelFieldCount(row: string): number {
  let depth = 0;
  let count = 0;
  for (const ch of row) {
    if (ch === '[' || ch === '(') depth += 1;
    else if (ch === ']' || ch === ')') depth -= 1;
    else if (ch === ',' && depth === 1) count += 1;
  }
  return count;
}

function catalogOrder(source: string, file: string): string[] {
  const match = source.match(/#!define\s+EVENT_CATALOG_ORDER\s+\[([^\]]*)\]/);
  assert.ok(match, `${file} must define EVENT_CATALOG_ORDER`);
  return match[1].split(',').map((item) => item.trim().replace(/^EventId\./, ''));
}

test('every registered event assigns all catalog fields', async () => {
  const catalog = await read('src/events/catalog/eventCatalog.opy');
  const rows = catalogRows(catalog);
  assert.ok(rows.length > 0, 'event catalog must register at least one event');
  rows.forEach((row, position) => {
    assert.equal(row.index, position, `row ${row.key} comment index ${row.index} != literal position ${position}`);
    assert.equal(topLevelFieldCount(row.row), 4, `EventId.${row.key} row must contain 5 fields`);
  });
});

test('catalog row order matches EventId enum order', async () => {
  const [catalog, idsSource] = await Promise.all([
    read('src/events/catalog/eventCatalog.opy'),
    read('src/events/event_ids.opy')
  ]);
  const enumKeys = idsSource
    .split('\n')
    .map((line) => line.trim())
    .filter((line) => /^[A-Z0-9_]+(\s*=\s*\d+)?$/.test(line) && line !== 'COUNT')
    .map((line) => line.split(/\s*=\s*/)[0]);
  const rows = catalogRows(catalog);
  assert.deepEqual(
    rows.map((row) => row.key),
    enumKeys,
    'eventCatalogRows order must match EventId enum order'
  );
});

test('each profile catalog order covers the registered set exactly', async () => {
  const [catalog, mainOrderFile, devOrderFile] = await Promise.all([
    read('src/events/catalog/eventCatalog.opy'),
    read('src/events/catalog/eventCatalogMain.opy'),
    read('src/events/catalog/eventCatalogDev.opy')
  ]);
  const registered = new Set(registeredEvents(catalog));
  for (const [label, source] of [['MAIN', mainOrderFile], ['DEV', devOrderFile]] as const) {
    const order = catalogOrder(source, `eventCatalog${label}.opy`);
    assert.equal(new Set(order).size, order.length, `${label} order contains duplicate ids`);
    for (const id of order) {
      assert.ok(registered.has(id), `${label} order lists ${id} which is not registered in eventCatalog.opy`);
    }
    for (const id of registered) {
      assert.ok(order.includes(id), `${label} order is missing registered event ${id}`);
    }
  }
});

test('profile catalog orders preserve the contracted sequences', async () => {
  const [mainOrderFile, devOrderFile] = await Promise.all([
    read('src/events/catalog/eventCatalogMain.opy'),
    read('src/events/catalog/eventCatalogDev.opy')
  ]);
  assert.deepEqual(catalogOrder(mainOrderFile, 'eventCatalogMain.opy'), MAIN_ORDER);
  assert.deepEqual(catalogOrder(devOrderFile, 'eventCatalogDev.opy'), DEV_ORDER);
});
