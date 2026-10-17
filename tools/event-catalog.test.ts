import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const read = (file: string) => readFile(new URL(`../${file}`, import.meta.url), 'utf8');

const FIELDS = ['eventName', 'eventDesc', 'eventDuration', 'eventCatalogWeight', 'eventCatalogType'] as const;

function registeredEvents(catalog: string): string[] {
  const ids: string[] = [];
  for (const match of catalog.matchAll(/eventCatalogType\[\s*EventId\.([A-Z0-9_]+)\s*\]\s*=\s*EventType\.(BUFF|DEBUFF|MECH)/g)) {
    ids.push(match[1]);
  }
  return ids;
}

function catalogOrder(source: string, file: string): string[] {
  const match = source.match(/#!define\s+EVENT_CATALOG_ORDER\s+\[([^\]]*)\]/);
  assert.ok(match, `${file} must define EVENT_CATALOG_ORDER`);
  return match[1].split(',').map((item) => item.trim().replace(/^EventId\./, ''));
}

test('every registered event assigns all catalog fields', async () => {
  const catalog = await read('src/events/catalog/eventCatalog.opy');
  const ids = registeredEvents(catalog);
  assert.ok(ids.length > 0, 'event catalog must register at least one event');
  for (const id of ids) {
    for (const field of FIELDS) {
      assert.match(
        catalog,
        new RegExp(`${field}\\[\\s*EventId\\.${id}\\s*\\]\\s*=`),
        `${field}[EventId.${id}] missing in eventCatalog.opy`
      );
    }
  }
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
