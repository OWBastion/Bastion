import assert from 'node:assert/strict';
import { createServer, type Server } from 'node:http';
import { once } from 'node:events';
import { afterEach, test } from 'node:test';

import {
  PlatformDataClient,
  PlatformDataClientError,
  type PlatformDataResource
} from './client.ts';

const servers: Server[] = [];

afterEach(async () => {
  await Promise.all(
    servers.splice(0).map(async (server) => {
      if (server.listening) {
        server.close();
        await once(server, 'close');
      }
    })
  );
});

async function startFakeServer(
  handler: (resource: PlatformDataResource, page: number, pageSize: number, requestUrl: URL) => unknown
): Promise<{ baseUrl: string; requests: URL[] }> {
  const requests: URL[] = [];
  const server = createServer((request, response) => {
    const requestUrl = new URL(request.url ?? '/', 'http://127.0.0.1');
    const match = requestUrl.pathname.match(/^\/v1\/agents\/(events|maps|achievements|titles|player-title-grants|map-title-holders)$/);
    if (request.method !== 'GET' || !match) {
      response.writeHead(404, { 'content-type': 'application/json' });
      response.end(JSON.stringify({ error: 'not found' }));
      return;
    }

    const resource = match[1] as PlatformDataResource;
    const page = Number(requestUrl.searchParams.get('page'));
    const pageSize = Number(requestUrl.searchParams.get('pageSize'));
    requests.push(requestUrl);

    try {
      const result = handler(resource, page, pageSize, requestUrl);
      if (result instanceof Response) {
        response.writeHead(result.status, { 'content-type': result.headers.get('content-type') ?? 'text/plain' });
        result.text().then((body) => response.end(body));
        return;
      }
      response.writeHead(200, { 'content-type': 'application/json' });
      response.end(JSON.stringify(result));
    } catch (error) {
      response.writeHead(500, { 'content-type': 'text/plain' });
      response.end(error instanceof Error ? error.message : String(error));
    }
  });
  servers.push(server);
  server.listen(0, '127.0.0.1');
  await once(server, 'listening');
  const address = server.address();
  assert.ok(address && typeof address === 'object');
  return { baseUrl: `http://127.0.0.1:${address.port}`, requests };
}

function pageResponse(items: Array<Record<string, unknown>>, page: number, pageSize: number, total = items.length) {
  return {
    contractVersion: '1',
    items,
    page,
    pageSize,
    total,
    hasMore: page * pageSize < total
  };
}

function validPage(resource: PlatformDataResource, page: number, pageSize: number) {
  const idField = { events: 'eventId', maps: 'mapId', achievements: 'challengeId', titles: 'titleKey' }[resource];
  const id = `${resource}-${page}`;
  return pageResponse([{ [idField]: id }], page, pageSize, 1);
}

test('fetchAll also reads in-development events', async () => {
  const { baseUrl } = await startFakeServer((resource, page, pageSize, requestUrl) => {
    if (resource !== 'events') return validPage(resource, page, pageSize);
    const id = requestUrl.searchParams.get('status') === 'development' ? 'event-dev' : 'event-live';
    return pageResponse([{ eventId: id }], page, pageSize, 1);
  });

  const data = await new PlatformDataClient({ baseUrl }).fetchAll();
  assert.deepEqual(data.events.map((item) => item.eventId), ['event-live', 'event-dev']);
});

test('distinguishes map achievements with a reused challenge ID by map ID', async () => {
  const { baseUrl } = await startFakeServer((resource, page, pageSize) => {
    if (resource !== 'achievements') return validPage(resource, page, pageSize);
    return pageResponse([
      { challengeId: 'title.CLASSIC', family: 'map', mapId: `map-${page}` }
    ], page, pageSize, 2);
  });

  const result = await new PlatformDataClient({ baseUrl, pageSize: 1 }).fetchResource('achievements');
  assert.deepEqual(result.map((item) => item.mapId), ['map-1', 'map-2']);
});

test('rejects unavailable map-holder projections before an empty collection can be consumed', async () => {
  const { baseUrl } = await startFakeServer((resource) => {
    if ((resource as string) === 'map-title-holders') return new Response(JSON.stringify({ error: { code: 'AGENT_MAP_TITLE_PROJECTION_UNAVAILABLE' } }), { status: 503, statusText: 'Unavailable' });
    return validPage(resource as PlatformDataResource, 1, 100);
  });

  await assert.rejects(
    () => new PlatformDataClient({ baseUrl }).fetchMapTitleHolders('map.test'),
    (error: unknown) => {
      assert.ok(error instanceof PlatformDataClientError);
      assert.equal(error.status, 503);
      assert.match(error.message, /HTTP 503 Service Unavailable/);
      assert.match(error.message, /AGENT_MAP_TITLE_PROJECTION_UNAVAILABLE/);
      return true;
    }
  );
});
