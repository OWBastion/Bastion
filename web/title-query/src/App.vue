<script setup>
import { computed, onMounted, onUnmounted, ref, watch } from 'vue';

const THEME_STORAGE_KEY = 'title-query-theme-mode';
const ROUTE_FALLBACK = 'titles';
const ROUTE_ORDER = ['titles', 'events'];
const ROUTE_LABELS = {
  titles: '称号',
  events: '事件'
};
const ROUTE_HEADINGS = {
  titles: {
    title: '玩家称号查询',
    copy: '输入玩家名后可直接看到“已获取 / 未获取”的完整称号进度情况。'
  },
  events: {
    title: '事件查询',
    copy: '按随机事件包查看 Buff / Debuff / Mech 清单与基础参数。'
  }
};
const TYPE_LABELS = {
  buff: '增益',
  debuff: '减益',
  mech: '机制'
};
const MAP_TITLE_LABELS = {
  PIONEER: '开拓者',
  CONQUEROR: '征服者',
  DOMINATOR: '主宰'
};

const currentRoute = ref(ROUTE_FALLBACK);
const loading = ref(true);
const error = ref('');
const themeMode = ref('light');

const playerQuery = ref('');
const eventQuery = ref('');

const players = ref([]);
const titles = ref([]);
const mapTitles = ref([]);
const titleMeta = ref(null);
const eventPacks = ref([]);
const eventMeta = ref(null);

const expandedSeriesKeys = ref(new Set());
const collapsedDefaultSeriesKeys = ref(new Set());
const completedMapsExpanded = ref(false);

function normalizeRoute(hashValue) {
  const raw = String(hashValue || '')
    .replace(/^#\/?/, '')
    .split('?')[0]
    .trim()
    .toLowerCase();
  return ROUTE_ORDER.includes(raw) ? raw : ROUTE_FALLBACK;
}

function setRouteFromHash() {
  currentRoute.value = normalizeRoute(typeof window === 'undefined' ? '' : window.location.hash);
}

function routeHref(routeKey) {
  return `#/${routeKey}`;
}

function isRouteActive(routeKey) {
  return currentRoute.value === routeKey;
}

const activeRouteHeading = computed(() => ROUTE_HEADINGS[currentRoute.value] ?? ROUTE_HEADINGS[ROUTE_FALLBACK]);
const hasPlayerQuery = computed(() => playerQuery.value.trim().length > 0);

const filteredPlayers = computed(() => {
  const keyword = playerQuery.value.trim().toLocaleLowerCase();
  const sortedPlayers = [...players.value].sort((left, right) => {
    if (right.titleCount !== left.titleCount) {
      return right.titleCount - left.titleCount;
    }
    return left.name.localeCompare(right.name, 'zh-Hans-CN');
  });

  if (!keyword) {
    return [];
  }

  return sortedPlayers.filter((player) => player.name.toLocaleLowerCase().includes(keyword));
});

const exactPlayerMatch = computed(() => {
  const keyword = playerQuery.value.trim();
  if (!keyword) {
    return null;
  }

  return players.value.find((player) => player.name === keyword) || null;
});

const showcasedPlayer = computed(() => {
  if (!hasPlayerQuery.value) {
    return null;
  }

  return exactPlayerMatch.value || filteredPlayers.value[0] || null;
});

const visibleTitles = computed(() => titles.value.filter((title) => title.id > 10));

function groupTitlesBySeries(titleList) {
  const seriesMap = new Map();

  for (const title of titleList) {
    const series = String(title?.category || '').trim() || '未分类';
    const bucket = seriesMap.get(series);

    if (bucket) {
      bucket.push(title);
    } else {
      seriesMap.set(series, [title]);
    }
  }

  return [...seriesMap.entries()]
    .map(([series, seriesTitles]) => ({
      series,
      titles: [...seriesTitles].sort((left, right) => left.id - right.id)
    }))
    .sort((left, right) => {
      if (right.titles.length !== left.titles.length) {
        return right.titles.length - left.titles.length;
      }

      return left.series.localeCompare(right.series, 'zh-Hans-CN');
    });
}

const groupedTitles = computed(() => {
  const player = showcasedPlayer.value;
  const ownedIds = new Set(player?.titleIds ?? []);
  const owned = [];
  const missing = [];

  for (const title of visibleTitles.value) {
    if (ownedIds.has(title.id)) {
      owned.push(title);
    } else {
      missing.push(title);
    }
  }

  return {
    ownedSeries: groupTitlesBySeries(owned),
    missingSeries: groupTitlesBySeries(missing),
    ownedCount: owned.length,
    missingCount: missing.length
  };
});

const groupedMapTitles = computed(() => {
  const player = showcasedPlayer.value;
  const maps = mapTitles.value ?? [];
  const mainTitleOrder = ['CONQUEROR', 'DOMINATOR'];
  const pioneerKey = 'PIONEER';

  return maps.map((mapItem) => {
    const status = player?.mapTitleStatus?.[mapItem.mapKey] ?? {};
    const mainSlots = mainTitleOrder
      .map((slotKey, index) => ({
        key: slotKey,
        label: MAP_TITLE_LABELS[slotKey],
        owned: Boolean(status[slotKey]),
        order: index
      }))
      .sort((left, right) => {
        if (left.owned !== right.owned) {
          return Number(left.owned) - Number(right.owned);
        }
        return left.order - right.order;
      });

    const pioneerSlot = {
      key: pioneerKey,
      label: MAP_TITLE_LABELS[pioneerKey],
      owned: Boolean(status[pioneerKey]),
      order: 0
    };

    const mainOwnedSlots = mainSlots.filter((slot) => slot.owned).length;
    const mainMissingSlots = mainSlots.length - mainOwnedSlots;

    return {
      ...mapItem,
      mainSlots,
      pioneerSlot,
      mainOwnedSlots,
      mainTotalSlots: mainSlots.length,
      mainMissingSlots,
      isMainComplete: mainMissingSlots === 0,
      isPioneerOwned: pioneerSlot.owned
    };
  });
});

const incompleteMapTitles = computed(() =>
  groupedMapTitles.value
    .filter((mapItem) => !mapItem.isMainComplete)
    .sort((left, right) => {
      if (right.mainMissingSlots !== left.mainMissingSlots) {
        return right.mainMissingSlots - left.mainMissingSlots;
      }
      return left.mapLabel.localeCompare(right.mapLabel, 'zh-Hans-CN');
    })
);

const completeMapTitles = computed(() =>
  groupedMapTitles.value
    .filter((mapItem) => mapItem.isMainComplete)
    .sort((left, right) => left.mapLabel.localeCompare(right.mapLabel, 'zh-Hans-CN'))
);

const mapSummary = computed(() => {
  const totalCount = groupedMapTitles.value.length;
  const pioneerOwnedCount = groupedMapTitles.value.filter((mapItem) => mapItem.isPioneerOwned).length;

  return {
    incompleteCount: incompleteMapTitles.value.length,
    completeCount: completeMapTitles.value.length,
    totalCount,
    pioneerOwnedCount,
    pioneerMissingCount: totalCount - pioneerOwnedCount
  };
});

const filteredEventPacks = computed(() => {
  const keyword = eventQuery.value.trim().toLocaleLowerCase();
  const sortedPacks = [...eventPacks.value].sort((left, right) => left.id - right.id);

  if (!keyword) {
    return sortedPacks;
  }

  return sortedPacks
    .map((pack) => {
      const filteredEvents = (pack.events || []).filter((eventItem) => {
        const searchText = [
          pack.labelZh,
          TYPE_LABELS[eventItem.type] || eventItem.type,
          eventItem.nameZh,
          eventItem.key,
          eventItem.descZh,
          ...(eventItem.tags || [])
        ]
          .join('|')
          .toLocaleLowerCase();
        return searchText.includes(keyword);
      });

      return {
        ...pack,
        events: filteredEvents
      };
    })
    .filter((pack) => pack.events.length > 0);
});

function eventGroups(pack) {
  return ['buff', 'debuff', 'mech']
    .map((type) => ({
      type,
      label: TYPE_LABELS[type],
      events: (pack.events || []).filter((eventItem) => eventItem.type === type)
    }))
    .filter((group) => group.events.length > 0);
}

function eventTypeClass(type) {
  if (type === 'buff') {
    return 'event-item-buff';
  }
  if (type === 'debuff') {
    return 'event-item-debuff';
  }
  return 'event-item-mech';
}

function normalizedDesc(value) {
  return String(value || '').replace(/\\n/g, '\n');
}

const sourceDisplay = computed(() => {
  if (!titleMeta.value) {
    return '躲避堡垒 3';
  }

  const sourceLabel = titleMeta.value.sourceLabel || '躲避堡垒 3';
  return titleMeta.value.sourceVersion ? `${sourceLabel} ${titleMeta.value.sourceVersion}` : sourceLabel;
});

const eventSourceDisplay = computed(() => {
  if (!eventMeta.value) {
    return '随机事件';
  }

  const sourceLabel = eventMeta.value.sourceLabel || '随机事件';
  return eventMeta.value.manifestVersion ? `${sourceLabel} ${eventMeta.value.manifestVersion}` : sourceLabel;
});

function getSeriesKey(groupType, seriesName) {
  return `${groupType}:${seriesName}`;
}

function getSeriesBodyId(groupType, seriesName) {
  const normalized = String(seriesName)
    .toLocaleLowerCase()
    .replace(/[^a-z0-9\u4e00-\u9fff]+/gi, '-')
    .replace(/^-+|-+$/g, '');
  return `series-body-${groupType}-${normalized || 'default'}`;
}

function isSeriesExpanded(groupType, index, seriesName) {
  const seriesKey = getSeriesKey(groupType, seriesName);
  if (collapsedDefaultSeriesKeys.value.has(seriesKey)) {
    return false;
  }
  if (expandedSeriesKeys.value.has(seriesKey)) {
    return true;
  }
  return index < 2;
}

function toggleSeries(groupType, index, seriesName) {
  const seriesKey = getSeriesKey(groupType, seriesName);
  const nextExpanded = !isSeriesExpanded(groupType, index, seriesName);

  if (index < 2) {
    if (nextExpanded) {
      collapsedDefaultSeriesKeys.value.delete(seriesKey);
    } else {
      collapsedDefaultSeriesKeys.value.add(seriesKey);
    }
    return;
  }

  if (nextExpanded) {
    expandedSeriesKeys.value.add(seriesKey);
  } else {
    expandedSeriesKeys.value.delete(seriesKey);
  }
}

function isRetiredTitle(title) {
  if (title?.availability === 'retired') {
    return true;
  }

  const conditionText = String(title?.condition || '');
  return /不再发放|历史称号/.test(conditionText);
}

function detectSystemTheme() {
  if (typeof window === 'undefined' || typeof window.matchMedia !== 'function') {
    return 'light';
  }

  return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
}

function applyTheme(nextMode, persist = true) {
  const normalized = nextMode === 'dark' ? 'dark' : 'light';
  themeMode.value = normalized;

  if (typeof window !== 'undefined') {
    document.documentElement.dataset.theme = normalized;
    if (persist) {
      window.localStorage.setItem(THEME_STORAGE_KEY, normalized);
    }
  }
}

function initTheme() {
  if (typeof window === 'undefined') {
    return;
  }

  const savedTheme = window.localStorage.getItem(THEME_STORAGE_KEY);
  if (savedTheme === 'light' || savedTheme === 'dark') {
    applyTheme(savedTheme, false);
    return;
  }

  applyTheme(detectSystemTheme(), false);
}

function toggleTheme() {
  applyTheme(themeMode.value === 'dark' ? 'light' : 'dark');
}

async function loadData() {
  loading.value = true;
  error.value = '';

  try {
    const [titleResponse, eventResponse] = await Promise.all([
      fetch('./data/titles.json', { cache: 'no-store' }),
      fetch('./data/events.json', { cache: 'no-store' })
    ]);

    if (!titleResponse.ok) {
      throw new Error(`称号数据请求失败（${titleResponse.status}）`);
    }

    if (!eventResponse.ok) {
      throw new Error(`事件数据请求失败（${eventResponse.status}）`);
    }

    const [titlePayload, eventPayload] = await Promise.all([titleResponse.json(), eventResponse.json()]);
    players.value = titlePayload.players ?? [];
    titles.value = titlePayload.titles ?? [];
    mapTitles.value = titlePayload.mapTitles ?? [];
    titleMeta.value = titlePayload.meta ?? null;

    eventPacks.value = eventPayload.packs ?? [];
    eventMeta.value = eventPayload.meta ?? null;
  } catch (loadError) {
    error.value = loadError instanceof Error ? loadError.message : '查询数据加载失败';
  } finally {
    loading.value = false;
  }
}

onMounted(() => {
  initTheme();
  setRouteFromHash();
  if (typeof window !== 'undefined') {
    window.addEventListener('hashchange', setRouteFromHash);
  }
  loadData();
});

onUnmounted(() => {
  if (typeof window !== 'undefined') {
    window.removeEventListener('hashchange', setRouteFromHash);
  }
});

watch(
  () => showcasedPlayer.value?.name ?? '',
  () => {
    expandedSeriesKeys.value = new Set();
    collapsedDefaultSeriesKeys.value = new Set();
    completedMapsExpanded.value = false;
  }
);
</script>

<template>
  <div class="page-shell" :data-theme="themeMode">
    <div class="ambient ambient-left"></div>
    <div class="ambient ambient-right"></div>
    <div class="backdrop-grid"></div>

    <main class="page-frame">
      <section class="hero-panel ow-card">
        <div class="hero-band">
          <p class="eyebrow">躲避堡垒 3</p>
          <p class="hero-band-copy">TITLE / EVENT QUERY</p>
          <button
            type="button"
            class="theme-toggle ow-button ow-button-secondary"
            :aria-pressed="themeMode === 'dark'"
            :aria-label="themeMode === 'dark' ? '切换为亮色主题' : '切换为暗色主题'"
            @click="toggleTheme"
          >
            <span class="theme-toggle-icon" aria-hidden="true">{{ themeMode === 'dark' ? '☀' : '☾' }}</span>
          </button>
        </div>

        <div class="hero-heading">
          <div>
            <h1>{{ activeRouteHeading.title }}</h1>
            <p class="hero-copy">{{ activeRouteHeading.copy }}</p>
          </div>
          <div class="hero-emblem">QUERY PANEL</div>
        </div>

        <nav class="route-nav" aria-label="查询路由">
          <a
            v-for="routeKey in ROUTE_ORDER"
            :key="`route-${routeKey}`"
            class="route-link ow-button"
            :class="isRouteActive(routeKey) ? 'route-link-active' : 'route-link-idle'"
            :href="routeHref(routeKey)"
            :aria-current="isRouteActive(routeKey) ? 'page' : null"
          >
            {{ ROUTE_LABELS[routeKey] }}
          </a>
        </nav>

        <label class="search-panel" v-if="currentRoute === 'titles'">
          <span>搜索玩家</span>
          <input
            v-model="playerQuery"
            name="player-search"
            type="search"
            placeholder="输入完整昵称或关键字，例如 卖核弹 / Cold / 旅店…"
            autocomplete="off"
          />
        </label>

        <label class="search-panel" v-else>
          <span>搜索事件</span>
          <input
            v-model="eventQuery"
            name="event-search"
            type="search"
            placeholder="输入事件名、包编号或类型，例如 随机事件包 4 / 赌徒 / Debuff…"
            autocomplete="off"
          />
        </label>

        <div class="search-candidates" v-if="currentRoute === 'titles' && hasPlayerQuery && !loading && !error && filteredPlayers.length">
          <button
            v-for="player in filteredPlayers"
            :key="`candidate-${player.name}`"
            class="candidate-chip ow-button ow-button-secondary"
            type="button"
            @click="playerQuery = player.name"
          >
            <span class="candidate-name">{{ player.name }}</span>
            <span class="candidate-count">{{ player.titleCount }}</span>
          </button>
        </div>
      </section>

      <section class="content-grid" v-if="currentRoute === 'titles'">
        <article class="card ow-card spotlight-card">
          <header class="card-header">
            <p>查询结果</p>
            <h2>玩家详情</h2>
          </header>

          <div v-if="loading" class="state-block">正在加载称号数据…</div>
          <div v-else-if="error" class="state-block state-error">{{ error }}</div>
          <div v-else-if="!hasPlayerQuery" class="spotlight-body">
            <div class="player-heading">
              <div>
                <p class="player-name">未选择玩家</p>
                <p class="player-meta">请输入玩家昵称后查看个人称号与解锁条件</p>
              </div>
              <div class="player-badge">READY</div>
            </div>
          </div>
          <div v-else-if="!showcasedPlayer" class="state-block">
            没有找到匹配的玩家，试试缩短关键字或直接输入完整昵称。
          </div>
          <div v-else class="spotlight-body">
            <div class="player-heading">
              <div>
                <div class="player-name-row">
                  <p class="player-name">{{ showcasedPlayer.name }}</p>
                  <p class="player-meta">已获取 {{ groupedTitles.ownedCount }} / {{ visibleTitles.length }}</p>
                </div>
              </div>
              <div class="player-badge">LOCKED IN</div>
            </div>
          </div>
        </article>
      </section>

      <section class="catalog-panel card ow-card" v-if="currentRoute === 'titles' && hasPlayerQuery">
        <header class="card-header">
          <p>所有称号列表</p>
          <h2>已获取 / 未获取</h2>
        </header>

        <div v-if="loading" class="state-block">正在生成称号进度…</div>
        <div v-else-if="error" class="state-block state-error">当前无法显示称号进度。</div>
        <div v-else class="title-groups">
          <article class="title-group title-group-owned">
            <header class="title-group-head">
              <h3>已获取</h3>
              <span class="title-group-count">{{ groupedTitles.ownedCount }}</span>
            </header>
            <div class="series-list" v-if="groupedTitles.ownedSeries.length">
              <article
                class="series-card"
                :class="isSeriesExpanded('owned', ownedIndex, seriesGroup.series) ? 'is-expanded' : 'is-collapsed'"
                v-for="(seriesGroup, ownedIndex) in groupedTitles.ownedSeries"
                :key="`owned-series-${seriesGroup.series}`"
              >
                <header class="series-head">
                  <p class="series-name">{{ seriesGroup.series }}</p>
                  <span class="series-count">{{ seriesGroup.titles.length }}</span>
                  <button
                    type="button"
                    class="series-toggle ow-button ow-button-aux"
                    @click="toggleSeries('owned', ownedIndex, seriesGroup.series)"
                    :aria-expanded="isSeriesExpanded('owned', ownedIndex, seriesGroup.series)"
                    :aria-controls="getSeriesBodyId('owned', seriesGroup.series)"
                  >
                    <span>{{ isSeriesExpanded('owned', ownedIndex, seriesGroup.series) ? '收起' : '展开' }}</span>
                    <span
                      class="series-toggle-icon"
                      :class="isSeriesExpanded('owned', ownedIndex, seriesGroup.series) ? 'is-expanded' : ''"
                      aria-hidden="true"
                    >
                      ▾
                    </span>
                  </button>
                </header>
                <div
                  class="series-body"
                  :id="getSeriesBodyId('owned', seriesGroup.series)"
                  :class="isSeriesExpanded('owned', ownedIndex, seriesGroup.series) ? 'is-expanded' : 'is-collapsed'"
                  :aria-hidden="!isSeriesExpanded('owned', ownedIndex, seriesGroup.series)"
                >
                  <ul class="status-title-list series-title-list">
                    <li v-for="title in seriesGroup.titles" :key="`owned-${title.id}`">
                      <span class="title-chip title-chip-owned">
                        <span class="title-head">
                          <span class="title-label">{{ title.label }}</span>
                          <span class="title-tag">{{ title.category }}</span>
                          <span class="title-tag title-tag-challenge" v-for="tag in title.tags || []" :key="`owned-tag-${title.id}-${tag}`">
                            {{ tag }}
                          </span>
                          <span class="title-tag title-tag-retired" v-if="isRetiredTitle(title)">不再发放</span>
                        </span>
                        <span class="title-condition">{{ title.condition }}</span>
                      </span>
                    </li>
                  </ul>
                </div>
              </article>
            </div>
            <p v-else class="group-empty">当前玩家暂无已获取称号。</p>
          </article>

          <article class="title-group title-group-missing">
            <header class="title-group-head">
              <h3>未获取</h3>
              <span class="title-group-count">{{ groupedTitles.missingCount }}</span>
            </header>
            <div class="series-list" v-if="groupedTitles.missingSeries.length">
              <article
                class="series-card"
                :class="isSeriesExpanded('missing', missingIndex, seriesGroup.series) ? 'is-expanded' : 'is-collapsed'"
                v-for="(seriesGroup, missingIndex) in groupedTitles.missingSeries"
                :key="`missing-series-${seriesGroup.series}`"
              >
                <header class="series-head">
                  <p class="series-name">{{ seriesGroup.series }}</p>
                  <span class="series-count">{{ seriesGroup.titles.length }}</span>
                  <button
                    type="button"
                    class="series-toggle ow-button ow-button-aux"
                    @click="toggleSeries('missing', missingIndex, seriesGroup.series)"
                    :aria-expanded="isSeriesExpanded('missing', missingIndex, seriesGroup.series)"
                    :aria-controls="getSeriesBodyId('missing', seriesGroup.series)"
                  >
                    <span>{{ isSeriesExpanded('missing', missingIndex, seriesGroup.series) ? '收起' : '展开' }}</span>
                    <span
                      class="series-toggle-icon"
                      :class="isSeriesExpanded('missing', missingIndex, seriesGroup.series) ? 'is-expanded' : ''"
                      aria-hidden="true"
                    >
                      ▾
                    </span>
                  </button>
                </header>
                <div
                  class="series-body"
                  :id="getSeriesBodyId('missing', seriesGroup.series)"
                  :class="isSeriesExpanded('missing', missingIndex, seriesGroup.series) ? 'is-expanded' : 'is-collapsed'"
                  :aria-hidden="!isSeriesExpanded('missing', missingIndex, seriesGroup.series)"
                >
                  <ul class="status-title-list series-title-list">
                    <li v-for="title in seriesGroup.titles" :key="`missing-${title.id}`">
                      <span class="title-chip title-chip-missing">
                        <span class="title-head">
                          <span class="title-label">{{ title.label }}</span>
                          <span class="title-tag">{{ title.category }}</span>
                          <span class="title-tag title-tag-challenge" v-for="tag in title.tags || []" :key="`missing-tag-${title.id}-${tag}`">
                            {{ tag }}
                          </span>
                          <span class="title-tag title-tag-retired" v-if="isRetiredTitle(title)">不再发放</span>
                        </span>
                        <span class="title-condition">{{ title.condition }}</span>
                      </span>
                    </li>
                  </ul>
                </div>
              </article>
            </div>
            <p v-else class="group-empty">当前玩家已获取全部称号。</p>
          </article>
        </div>
      </section>

      <section class="catalog-panel card ow-card" v-if="currentRoute === 'titles' && hasPlayerQuery">
        <header class="card-header">
          <p>地图专属称号</p>
          <h2>已获取 / 未获取</h2>
        </header>

        <div v-if="loading" class="state-block">正在获取地图称号进度…</div>
        <div v-else-if="error" class="state-block state-error">当前无法显示地图称号进度。</div>
        <div v-else-if="!showcasedPlayer" class="state-block">请选择玩家后查看地图专属称号。</div>
        <div v-else class="map-section-stack">
          <header class="map-summary">
            <span class="map-summary-item map-summary-item-alert">未完成 {{ mapSummary.incompleteCount }}</span>
            <span class="map-summary-item map-summary-item-complete">已完成 {{ mapSummary.completeCount }}</span>
            <span class="map-summary-item">总计 {{ mapSummary.totalCount }}</span>
            <span class="map-summary-item map-summary-item-complete">开拓者 {{ mapSummary.pioneerOwnedCount }}</span>
            <span class="map-summary-item map-summary-item-pioneer">未开拓 {{ mapSummary.pioneerMissingCount }}</span>
          </header>

          <section class="map-block map-block-priority">
            <header class="map-block-head">
              <h3>未获得地图</h3>
              <span class="map-block-count">{{ mapSummary.incompleteCount }}</span>
            </header>
            <p class="map-block-empty" v-if="!incompleteMapTitles.length">全部地图主进度已收集完成。</p>
            <div v-else class="map-title-grid">
              <article class="map-title-card map-title-card-priority" v-for="mapItem in incompleteMapTitles" :key="mapItem.mapKey">
                <header class="map-title-head">
                  <p class="map-title-name">{{ mapItem.mapLabel }}</p>
                  <span class="map-title-progress">{{ mapItem.mainOwnedSlots }} / {{ mapItem.mainTotalSlots }}</span>
                </header>
                <section class="map-slot-group map-slot-group-main">
                  <ul class="status-title-list">
                    <li v-for="slot in mapItem.mainSlots" :key="`${mapItem.mapKey}-${slot.key}`">
                      <span class="title-chip" :class="slot.owned ? 'title-chip-owned' : 'title-chip-missing'">
                        <span class="title-head">
                          <span class="title-label">{{ slot.label }}</span>
                          <span class="title-tag" :class="slot.owned ? 'map-status-owned' : 'map-status-missing'">
                            {{ slot.owned ? '已获得' : '未获得' }}
                          </span>
                        </span>
                      </span>
                    </li>
                  </ul>
                </section>
                <section class="map-slot-group map-slot-group-pioneer">
                  <p class="map-slot-group-title">开拓者</p>
                  <span class="title-chip" :class="mapItem.pioneerSlot.owned ? 'title-chip-owned' : 'title-chip-missing'">
                    <span class="title-head">
                      <span class="title-label">{{ mapItem.pioneerSlot.label }}</span>
                      <span class="title-tag" :class="mapItem.pioneerSlot.owned ? 'map-status-owned' : 'map-status-missing'">
                        {{ mapItem.pioneerSlot.owned ? '已获得' : '未获得' }}
                      </span>
                    </span>
                  </span>
                </section>
              </article>
            </div>
          </section>

          <section class="map-block map-block-complete">
            <header class="map-block-head">
              <h3>已全收集地图</h3>
              <span class="map-block-count">{{ mapSummary.completeCount }}</span>
              <button
                type="button"
                class="series-toggle ow-button ow-button-aux"
                @click="completedMapsExpanded = !completedMapsExpanded"
                :aria-expanded="completedMapsExpanded"
                aria-controls="complete-map-list"
              >
                <span>{{ completedMapsExpanded ? '收起' : '展开' }}</span>
                <span class="series-toggle-icon" :class="completedMapsExpanded ? 'is-expanded' : ''" aria-hidden="true">▾</span>
              </button>
            </header>
            <div class="complete-map-body" id="complete-map-list" :class="completedMapsExpanded ? 'is-expanded' : 'is-collapsed'" :aria-hidden="!completedMapsExpanded">
              <div class="map-title-grid">
                <article class="map-title-card map-title-card-complete" v-for="mapItem in completeMapTitles" :key="mapItem.mapKey">
                  <header class="map-title-head">
                    <p class="map-title-name">{{ mapItem.mapLabel }}</p>
                    <span class="map-title-progress">{{ mapItem.mainOwnedSlots }} / {{ mapItem.mainTotalSlots }}</span>
                  </header>
                  <section class="map-slot-group map-slot-group-main">
                    <ul class="status-title-list">
                      <li v-for="slot in mapItem.mainSlots" :key="`${mapItem.mapKey}-${slot.key}`">
                        <span class="title-chip" :class="slot.owned ? 'title-chip-owned' : 'title-chip-missing'">
                          <span class="title-head">
                            <span class="title-label">{{ slot.label }}</span>
                            <span class="title-tag" :class="slot.owned ? 'map-status-owned' : 'map-status-missing'">
                              {{ slot.owned ? '已获得' : '未获得' }}
                            </span>
                          </span>
                        </span>
                      </li>
                    </ul>
                  </section>
                  <section class="map-slot-group map-slot-group-pioneer">
                    <p class="map-slot-group-title">开拓者</p>
                    <span class="title-chip" :class="mapItem.pioneerSlot.owned ? 'title-chip-owned' : 'title-chip-missing'">
                      <span class="title-head">
                        <span class="title-label">{{ mapItem.pioneerSlot.label }}</span>
                        <span class="title-tag" :class="mapItem.pioneerSlot.owned ? 'map-status-owned' : 'map-status-missing'">
                          {{ mapItem.pioneerSlot.owned ? '已获得' : '未获得' }}
                        </span>
                      </span>
                    </span>
                  </section>
                </article>
              </div>
            </div>
          </section>
        </div>
      </section>

      <section class="catalog-panel card ow-card" v-if="currentRoute === 'events'">
        <header class="card-header">
          <p>随机事件包</p>
          <h2>按版本分组</h2>
        </header>
        <div v-if="loading" class="state-block">正在加载事件数据…</div>
        <div v-else-if="error" class="state-block state-error">{{ error }}</div>
        <div v-else-if="!filteredEventPacks.length" class="state-block">没有匹配的事件，请调整关键字。</div>
        <div v-else class="event-pack-list">
          <article class="map-block" v-for="pack in filteredEventPacks" :key="`pack-${pack.id}`">
            <header class="map-block-head">
              <h3>{{ pack.labelZh }}</h3>
              <span class="map-block-count">{{ pack.eventCount }}</span>
            </header>
            <div class="event-group-list">
              <section class="event-group" v-for="group in eventGroups(pack)" :key="`group-${pack.id}-${group.type}`">
                <p class="event-group-title">{{ group.label }}</p>
                <ul class="event-item-list">
                  <li v-for="eventItem in group.events" :key="`event-${eventItem.type}-${eventItem.id}`">
                    <article class="event-item" :class="eventTypeClass(eventItem.type)">
                      <p class="event-line">
                        <span class="event-name">{{ eventItem.nameZh }}</span>
                        <span class="event-meta">{{ eventItem.durationSec }}s</span>
                        <span class="event-meta">权重 {{ eventItem.weight }}</span>
                      </p>
                      <p class="event-desc">{{ normalizedDesc(eventItem.descZhCompiled || eventItem.descZh) }}</p>
                    </article>
                  </li>
                </ul>
              </section>
            </div>
          </article>
        </div>
      </section>

      <footer class="page-footer" v-if="titleMeta || eventMeta">
        <span>称号源：{{ sourceDisplay }}</span>
        <span>事件源：{{ eventSourceDisplay }}</span>
        <span>生成时间：{{ new Date((eventMeta?.generatedAt || titleMeta?.generatedAt) ?? Date.now()).toLocaleString('zh-CN') }}</span>
      </footer>
    </main>
  </div>
</template>
