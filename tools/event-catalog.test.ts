import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const read = (file: string) => readFile(new URL(`../${file}`, import.meta.url), 'utf8');

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
