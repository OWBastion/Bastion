import assert from 'node:assert/strict';
import { createServer, type Server } from 'node:http';
import { once } from 'node:events';
import { afterEach, test } from 'node:test';

import {
  fetchPlatformData,
  PlatformDataClient,
  PlatformDataClientError,
  PLATFORM_DATA_USER_AGENT,
  type PlatformDataResource
} from './platform-data-client.ts';

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
    const match = requestUrl.pathname.match(/^\/v1\/agents\/(events|maps|achievements|titles)$/);
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

test('fetches all Agents resources through paginated GET requests using a custom base URL', async () => {
  const datasets: Record<PlatformDataResource, Array<Record<string, unknown>>> = {
    events: [{ eventId: 'event-1' }, { eventId: 'event-2' }, { eventId: 'event-3' }],
    maps: [{ mapId: 'map-1' }],
    achievements: [{ challengeId: 'achievement-1' }, { challengeId: 'achievement-2' }],
    titles: [{ titleKey: 'title-1' }, { titleKey: 'title-2' }, { titleKey: 'title-3' }]
  };
  const { baseUrl, requests } = await startFakeServer((resource, page, pageSize) => {
    const items = datasets[resource].slice((page - 1) * pageSize, page * pageSize);
    return pageResponse(items, page, pageSize, datasets[resource].length);
  });

  const result = await fetchPlatformData({ baseUrl, pageSize: 2 });

  assert.deepEqual(result, { ...datasets, playerTitleGrants: [], mapTitleHolders: [] });
  assert.deepEqual(
    requests.map((request) => `${request.pathname}?${request.searchParams}`),
    [
      '/v1/agents/events?page=1&pageSize=2',
      '/v1/agents/maps?page=1&pageSize=2',
      '/v1/agents/achievements?page=1&pageSize=2',
      '/v1/agents/titles?page=1&pageSize=2',
      '/v1/agents/events?page=2&pageSize=2',
      '/v1/agents/titles?page=2&pageSize=2'
    ]
  );
});

test('identifies Bastion in the Agents request User-Agent', async () => {
  let userAgent: string | null = null;
  const client = new PlatformDataClient({
    baseUrl: 'https://platform.example',
    fetch: async (_input, init) => {
      userAgent = new Headers(init?.headers).get('user-agent');
      return new Response(JSON.stringify(pageResponse([{ mapId: 'map-1' }], 1, 100)), { status: 200 });
    }
  });

  await client.fetchResource('maps');
  assert.equal(userAgent, PLATFORM_DATA_USER_AGENT);
});

test('fetches player grants and map holders through their independent paginated entrances', async () => {
  const requests: string[] = [];
  const fetchImpl = async (input: URL | RequestInfo) => {
    const url = new URL(String(input));
    requests.push(`${url.pathname}?${url.searchParams}`);
    const page = Number(url.searchParams.get('page'));
    const pageSize = Number(url.searchParams.get('pageSize'));
    const items = url.pathname.endsWith('player-title-grants')
      ? [{ playerId: '1', playerName: '玩家', titleKeys: ['TITLE'], allTitles: false }]
      : [{ mapId: 'map.test', slot: 'pioneer', playerId: '1', playerName: '玩家' }];
    return new Response(JSON.stringify(pageResponse(items, page, pageSize, 1)), { status: 200, headers: { 'content-type': 'application/json' } });
  };
  const client = new PlatformDataClient({ baseUrl: 'https://example.test', pageSize: 10, fetch: fetchImpl });
  assert.deepEqual(await client.fetchPlayerTitleGrants(), [{ playerId: '1', playerName: '玩家', titleKeys: ['TITLE'], allTitles: false }]);
  assert.deepEqual(await client.fetchMapTitleHolders('map.test'), [{ mapId: 'map.test', slot: 'pioneer', playerId: '1', playerName: '玩家' }]);
  assert.deepEqual(requests, [
    '/v1/agents/player-title-grants?page=1&pageSize=10',
    '/v1/agents/map-title-holders?mapId=map.test&page=1&pageSize=10'
  ]);
});

test('rejects non-success HTTP responses with resource and status context', async () => {
  const { baseUrl } = await startFakeServer((resource) => {
    if (resource === 'events') return new Response('upstream unavailable', { status: 503, statusText: 'Unavailable' });
    return validPage(resource, 1, 100);
  });

  await assert.rejects(
    () => new PlatformDataClient({ baseUrl }).fetchResource('events'),
    (error: unknown) => {
      assert.ok(error instanceof PlatformDataClientError);
      assert.equal(error.status, 503);
      assert.equal(error.resource, 'events');
      assert.match(error.message, /HTTP 503 Service Unavailable/);
      return true;
    }
  );
});

test('retries rate-limited responses and honors Retry-After', async () => {
  let attempts = 0;
  const { baseUrl } = await startFakeServer((resource, page, pageSize) => {
    attempts += 1;
    if (attempts === 1) return new Response('', { status: 429, headers: { 'retry-after': '0' } });
    return validPage(resource, page, pageSize);
  });

  await new PlatformDataClient({ baseUrl }).fetchResource('maps');
  assert.equal(attempts, 2);
});

test('rejects an unsupported contract version', async () => {
  const { baseUrl } = await startFakeServer((resource, page, pageSize) => ({
    ...validPage(resource, page, pageSize),
    contractVersion: '2'
  }));

  await assert.rejects(
    () => new PlatformDataClient({ baseUrl }).fetchResource('maps'),
    /Unsupported contractVersion "2"; expected 1/
  );
});

test('rejects malformed pagination and item structure', async (t) => {
  await t.test('page does not match request', async () => {
    const { baseUrl } = await startFakeServer((resource, _page, pageSize) => validPage(resource, 2, pageSize));
    await assert.rejects(() => new PlatformDataClient({ baseUrl }).fetchResource('events'), /does not match requested page/);
  });

  await t.test('hasMore is inconsistent with total', async () => {
    const { baseUrl } = await startFakeServer((resource, page, pageSize) => ({
      ...validPage(resource, page, pageSize),
      total: 2,
      hasMore: true
    }));
    await assert.rejects(() => new PlatformDataClient({ baseUrl }).fetchResource('maps'), /hasMore is inconsistent/);
  });

  await t.test('items must contain resource objects and stable IDs', async () => {
    const { baseUrl } = await startFakeServer((resource, page, pageSize) => pageResponse([null as unknown as Record<string, unknown>], page, pageSize));
    await assert.rejects(() => new PlatformDataClient({ baseUrl }).fetchResource('titles'), /items\[0\] must be an object/);
  });
});

test('rejects duplicate IDs within a paginated resource', async () => {
  const { baseUrl } = await startFakeServer((resource, page, pageSize) => {
    if (resource === 'events' && page === 1) {
      return pageResponse([{ eventId: 'duplicate' }, { eventId: 'duplicate' }], page, pageSize, 2);
    }
    return validPage(resource, page, pageSize);
  });

  await assert.rejects(() => new PlatformDataClient({ baseUrl, pageSize: 2 }).fetchResource('events'), /Duplicate eventId: duplicate/);
});

test('rejects duplicate IDs across pages and changing totals', async (t) => {
  await t.test('duplicate across pages', async () => {
    const { baseUrl } = await startFakeServer((resource, page, pageSize) => {
      if (resource !== 'events') return validPage(resource, page, pageSize);
      return page === 1
        ? pageResponse([{ eventId: 'same-event' }], page, pageSize, 2)
        : pageResponse([{ eventId: 'same-event' }], page, pageSize, 2);
    });
    await assert.rejects(() => new PlatformDataClient({ baseUrl, pageSize: 1 }).fetchResource('events'), /Duplicate eventId: same-event/);
  });

  await t.test('total must remain stable during one resource fetch', async () => {
    const { baseUrl } = await startFakeServer((resource, page, pageSize) => {
      if (resource !== 'maps') return validPage(resource, page, pageSize);
      return page === 1
        ? pageResponse([{ mapId: 'map-1' }], page, pageSize, 2)
        : pageResponse([{ mapId: 'map-2' }], page, pageSize, 3);
    });
    await assert.rejects(() => new PlatformDataClient({ baseUrl, pageSize: 1 }).fetchResource('maps'), /does not match earlier total/);
  });
});
