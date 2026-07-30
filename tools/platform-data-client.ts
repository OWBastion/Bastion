export const DEFAULT_PLATFORM_DATA_BASE_URL = 'https://api.owbastion.com';
export const PLATFORM_DATA_CONTRACT_VERSION = '1' as const;
export const PLATFORM_DATA_USER_AGENT = 'OWBastion-BastionSync/1.0';
export const PLATFORM_DATA_TOKEN_ENV = 'BASTION_BUILD_TOKEN';

export const PLATFORM_DATA_RESOURCES = ['events', 'maps', 'achievements', 'titles'] as const;
export type PlatformDataResource = (typeof PLATFORM_DATA_RESOURCES)[number];

type PlatformDataItem = Record<string, unknown>;

export type PlatformDataPage<TItem extends PlatformDataItem = PlatformDataItem> = {
  contractVersion: typeof PLATFORM_DATA_CONTRACT_VERSION;
  items: TItem[];
  page: number;
  pageSize: number;
  total: number;
  hasMore: boolean;
};

export type PlatformData = {
  events: PlatformDataItem[];
  maps: PlatformDataItem[];
  achievements: PlatformDataItem[];
  titles: PlatformDataItem[];
  playerTitleGrants: PlatformDataItem[];
  mapTitleHolders: PlatformDataItem[];
};

export type PlatformDataClientOptions = {
  baseUrl?: string;
  pageSize?: number;
  accessToken?: string;
  fetch?: typeof globalThis.fetch;
};

type ResourceIdField = 'eventId' | 'mapId' | 'challengeId' | 'titleKey';

const RESOURCE_ID_FIELDS: Record<PlatformDataResource, ResourceIdField> = {
  events: 'eventId',
  maps: 'mapId',
  achievements: 'challengeId',
  titles: 'titleKey'
};

export class PlatformDataClientError extends Error {
  readonly resource?: PlatformDataResource;
  readonly page?: number;
  readonly status?: number;

  constructor(message: string, details: { resource?: PlatformDataResource; page?: number; status?: number } = {}) {
    super(message);
    this.name = 'PlatformDataClientError';
    this.resource = details.resource;
    this.page = details.page;
    this.status = details.status;
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function ensurePositiveInteger(value: unknown, label: string, details: { resource: PlatformDataResource; page: number }) {
  if (!Number.isInteger(value) || (value as number) < 1) {
    throw new PlatformDataClientError(`${label} must be a positive integer`, details);
  }
}

function ensureNonNegativeInteger(value: unknown, label: string, details: { resource: PlatformDataResource; page: number }) {
  if (!Number.isInteger(value) || (value as number) < 0) {
    throw new PlatformDataClientError(`${label} must be a non-negative integer`, details);
  }
}

function ensurePageResponse(
  value: unknown,
  resource: PlatformDataResource,
  requestedPage: number,
  requestedPageSize: number
): PlatformDataPage {
  const details = { resource, page: requestedPage };
  if (!isRecord(value)) {
    throw new PlatformDataClientError('Response must be a JSON object', details);
  }

  if (value.contractVersion !== PLATFORM_DATA_CONTRACT_VERSION) {
    throw new PlatformDataClientError(
      `Unsupported contractVersion ${JSON.stringify(value.contractVersion)}; expected ${PLATFORM_DATA_CONTRACT_VERSION}`,
      details
    );
  }

  if (!Array.isArray(value.items)) {
    throw new PlatformDataClientError('Response items must be an array', details);
  }

  ensurePositiveInteger(value.page, 'Response page', details);
  ensurePositiveInteger(value.pageSize, 'Response pageSize', details);
  ensureNonNegativeInteger(value.total, 'Response total', details);
  if (typeof value.hasMore !== 'boolean') {
    throw new PlatformDataClientError('Response hasMore must be a boolean', details);
  }

  if (value.page !== requestedPage) {
    throw new PlatformDataClientError(`Response page ${String(value.page)} does not match requested page ${requestedPage}`, details);
  }
  if (value.pageSize !== requestedPageSize) {
    throw new PlatformDataClientError(
      `Response pageSize ${String(value.pageSize)} does not match requested pageSize ${requestedPageSize}`,
      details
    );
  }
  if (value.items.length > value.pageSize) {
    throw new PlatformDataClientError('Response items cannot exceed pageSize', details);
  }
  if (value.total < value.items.length) {
    throw new PlatformDataClientError('Response total cannot be smaller than items.length', details);
  }
  if (value.hasMore !== (value.page * value.pageSize < value.total)) {
    throw new PlatformDataClientError('Response hasMore is inconsistent with page, pageSize, and total', details);
  }

  const idField = RESOURCE_ID_FIELDS[resource];
  for (const [index, item] of value.items.entries()) {
    if (!isRecord(item)) {
      throw new PlatformDataClientError(`items[${index}] must be an object`, details);
    }
    const id = item[idField];
    if (typeof id !== 'string' || id.trim() === '') {
      throw new PlatformDataClientError(`items[${index}].${idField} must be a non-empty string`, details);
    }
  }

  return value as PlatformDataPage;
}

function ensureCustomPageResponse(value: unknown, resource: string, requestedPage: number, requestedPageSize: number): PlatformDataPage {
  const details = { page: requestedPage };
  if (!isRecord(value)) throw new PlatformDataClientError('Response must be a JSON object', details);
  if (value.contractVersion !== PLATFORM_DATA_CONTRACT_VERSION) throw new PlatformDataClientError(`Unsupported contractVersion ${JSON.stringify(value.contractVersion)}; expected ${PLATFORM_DATA_CONTRACT_VERSION}`, details);
  if (!Array.isArray(value.items)) throw new PlatformDataClientError(`Response items must be an array for ${resource}`, details);
  ensurePositiveInteger(value.page, 'Response page', { resource: 'titles', page: requestedPage });
  ensurePositiveInteger(value.pageSize, 'Response pageSize', { resource: 'titles', page: requestedPage });
  ensureNonNegativeInteger(value.total, 'Response total', { resource: 'titles', page: requestedPage });
  if (typeof value.hasMore !== 'boolean' || value.page !== requestedPage || value.pageSize !== requestedPageSize || value.items.length > value.pageSize || value.total < value.items.length || value.hasMore !== (value.page * value.pageSize < value.total)) {
    throw new PlatformDataClientError(`Invalid pagination response for ${resource}`, details);
  }
  for (const item of value.items) if (!isRecord(item)) throw new PlatformDataClientError('Response items must contain objects', details);
  return value as PlatformDataPage;
}

function normalizeBaseUrl(baseUrl: string): string {
  let parsed: URL;
  try {
    parsed = new URL(baseUrl);
  } catch {
    throw new PlatformDataClientError(`Invalid platform data base URL: ${baseUrl}`);
  }

  if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') {
    throw new PlatformDataClientError(`Platform data base URL must use http or https: ${baseUrl}`);
  }

  return baseUrl.replace(/\/+$/, '');
}

function validatePageSize(pageSize: number): void {
  if (!Number.isInteger(pageSize) || pageSize < 1 || pageSize > 100) {
    throw new PlatformDataClientError('pageSize must be an integer between 1 and 100');
  }
}

export class PlatformDataClient {
  private readonly baseUrl: string;
  private readonly pageSize: number;
  private readonly accessToken?: string;
  private readonly fetchImpl: typeof globalThis.fetch;

  private async request(url: URL, details: { resource?: PlatformDataResource; page: number }): Promise<Response> {
    for (let attempt = 0; ; attempt += 1) {
      let response: Response;
      try {
        const headers: Record<string, string> = { 'user-agent': PLATFORM_DATA_USER_AGENT };
        if (this.accessToken) headers.authorization = `Bearer ${this.accessToken}`;
        response = await this.fetchImpl(url, { headers });
      } catch (error) {
        throw new PlatformDataClientError(`Request failed: ${error instanceof Error ? error.message : String(error)}`, details);
      }
      if (response.status !== 429 || attempt >= 3) return response;
      const retryAfter = response.headers.get('retry-after');
      const retryAfterSeconds = retryAfter ? Number(retryAfter) : NaN;
      const delayMs = Number.isFinite(retryAfterSeconds) && retryAfterSeconds >= 0
        ? Math.min(retryAfterSeconds * 1000, 30_000)
        : Math.min(250 * (2 ** attempt), 4_000);
      await new Promise((resolve) => setTimeout(resolve, delayMs));
    }
  }

  constructor(options: PlatformDataClientOptions = {}) {
    this.baseUrl = normalizeBaseUrl(options.baseUrl ?? DEFAULT_PLATFORM_DATA_BASE_URL);
    this.pageSize = options.pageSize ?? 100;
    this.accessToken = options.accessToken?.trim() || undefined;
    validatePageSize(this.pageSize);
    this.fetchImpl = options.fetch ?? globalThis.fetch;
    if (typeof this.fetchImpl !== 'function') {
      throw new PlatformDataClientError('A fetch implementation is required');
    }
  }

  async fetchAll(): Promise<PlatformData> {
    const [events, maps, achievements, titles] = await Promise.all(
      PLATFORM_DATA_RESOURCES.map((resource) => this.fetchResource(resource))
    );

    return { events, maps, achievements, titles, playerTitleGrants: [], mapTitleHolders: [] };
  }

  async fetchPlayerTitleGrants(): Promise<PlatformDataItem[]> {
    return this.fetchCustomResource('player-title-grants', new URLSearchParams(), (item) => String(item.playerName));
  }

  async fetchTitles(mapId?: string): Promise<PlatformDataItem[]> {
    const query = new URLSearchParams();
    if (mapId) query.set('mapId', mapId);
    return this.fetchCustomResource('titles', query, (item) => `${String(item.titleKey)}:${String(item.mapId ?? '')}`);
  }

  async fetchMapTitleHolders(mapId: string): Promise<PlatformDataItem[]> {
    const query = new URLSearchParams({ mapId });
    return this.fetchCustomResource('map-title-holders', query, (item) => `${String(item.mapId)}:${String(item.slot)}:${String(item.playerName)}`);
  }

  async fetchResource(resource: PlatformDataResource): Promise<PlatformDataItem[]> {
    const items: PlatformDataItem[] = [];
    const ids = new Set<string>();
    let requestedPage = 1;
    let expectedTotal: number | undefined;

    while (true) {
      const response = await this.fetchPage(resource, requestedPage);
      if (expectedTotal === undefined) {
        expectedTotal = response.total;
      } else if (response.total !== expectedTotal) {
        throw new PlatformDataClientError(
          `Response total ${response.total} does not match earlier total ${expectedTotal}`,
          { resource, page: requestedPage }
        );
      }

      const idField = RESOURCE_ID_FIELDS[resource];
      for (const item of response.items) {
        const id = item[idField] as string;
        if (ids.has(id)) {
          throw new PlatformDataClientError(`Duplicate ${idField}: ${id}`, { resource, page: requestedPage });
        }
        ids.add(id);
        items.push(item);
      }

      if (!response.hasMore) {
        if (items.length !== response.total) {
          throw new PlatformDataClientError(
            `Fetched ${items.length} items but response total is ${response.total}`,
            { resource, page: requestedPage }
          );
        }
        return items;
      }

      requestedPage += 1;
    }
  }

  private async fetchCustomResource(resource: string, query: URLSearchParams, identity: (item: PlatformDataItem) => string): Promise<PlatformDataItem[]> {
    const items: PlatformDataItem[] = [];
    const ids = new Set<string>();
    let requestedPage = 1;
    let expectedTotal: number | undefined;
    while (true) {
      const pageQuery = new URLSearchParams(query);
      pageQuery.set('page', String(requestedPage));
      pageQuery.set('pageSize', String(this.pageSize));
      const response = await this.fetchCustomPage(resource, pageQuery, requestedPage);
      if (expectedTotal === undefined) expectedTotal = response.total;
      else if (response.total !== expectedTotal) throw new PlatformDataClientError(`Response total ${response.total} does not match earlier total ${expectedTotal}`, { page: requestedPage });
      for (const item of response.items) {
        const id = identity(item);
        if (!id || id === 'undefined' || id === 'null') throw new PlatformDataClientError(`Invalid identity in ${resource}`, { page: requestedPage });
        if (ids.has(id)) throw new PlatformDataClientError(`Duplicate identity in ${resource}: ${id}`, { page: requestedPage });
        ids.add(id); items.push(item);
      }
      if (!response.hasMore) {
        if (items.length !== response.total) throw new PlatformDataClientError(`Fetched ${items.length} items but response total is ${response.total}`, { page: requestedPage });
        return items;
      }
      requestedPage += 1;
    }
  }

  private async fetchCustomPage(resource: string, query: URLSearchParams, page: number): Promise<PlatformDataPage> {
    const url = new URL(`${this.baseUrl}/v1/agents/${resource}`);
    for (const [key, value] of query) url.searchParams.set(key, value);
    const response = await this.request(url, { page });
    if (!response.ok) throw new PlatformDataClientError(`HTTP ${response.status} ${response.statusText} from ${url.pathname}`, { page, status: response.status });
    let payload: unknown;
    try { payload = await response.json(); }
    catch (error) { throw new PlatformDataClientError(`Response is not valid JSON: ${error instanceof Error ? error.message : String(error)}`, { page }); }
    return ensureCustomPageResponse(payload, resource, page, this.pageSize);
  }

  private async fetchPage(resource: PlatformDataResource, page: number): Promise<PlatformDataPage> {
    const url = new URL(`${this.baseUrl}/v1/agents/${resource}`);
    url.searchParams.set('page', String(page));
    url.searchParams.set('pageSize', String(this.pageSize));

    const response = await this.request(url, { resource, page });

    if (!response.ok) {
      let body = '';
      try {
        body = (await response.text()).trim().slice(0, 256);
      } catch {
        // Preserve the HTTP status when the response body cannot be read.
      }
      const suffix = body ? `: ${body}` : '';
      throw new PlatformDataClientError(`HTTP ${response.status} ${response.statusText}${suffix} from ${url.pathname}`, {
        resource,
        page,
        status: response.status
      });
    }

    let payload: unknown;
    try {
      payload = await response.json();
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      throw new PlatformDataClientError(`Response is not valid JSON: ${message}`, { resource, page });
    }

    return ensurePageResponse(payload, resource, page, this.pageSize);
  }
}

export async function fetchPlatformData(options: PlatformDataClientOptions = {}): Promise<PlatformData> {
  return new PlatformDataClient(options).fetchAll();
}
