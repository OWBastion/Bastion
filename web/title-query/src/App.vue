<script setup>
import { computed, onMounted, onUnmounted, ref, watch } from 'vue';
import EventsPanel from './components/EventsPanel.vue';
import GlossaryPanel from './components/GlossaryPanel.vue';
import TermPopover from './components/TermPopover.vue';
import TitlesPanel from './components/TitlesPanel.vue';
import { useHashRoute } from './composables/useHashRoute';
import { useTermPopover } from './composables/useTermPopover';
import { useThemeMode } from './composables/useThemeMode';

const THEME_STORAGE_KEY = 'title-query-theme-mode';
const ROUTE_FALLBACK = 'titles';
const ROUTE_ORDER = ['titles', 'events', 'glossary'];
const ROUTE_LABELS = {
  titles: '称号',
  events: '事件',
  glossary: '词条'
};
const ROUTE_HEADINGS = {
  titles: {
    title: '玩家称号查询',
    copy: '输入玩家名后可直接看到“已获取 / 未获取”的完整称号进度情况。'
  },
  events: {
    title: '事件查询',
    copy: '按随机事件包查看 Buff / Debuff / Mech 清单与基础参数。'
  },
  glossary: {
    title: '效果词条查询',
    copy: '《躲避堡垒 3》效果词条定义、规则与关联事件。'
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

const { currentRoute, setRouteFromHash, routeHref, isRouteActive } = useHashRoute(ROUTE_ORDER, ROUTE_FALLBACK);
const { themeMode, initTheme, toggleTheme } = useThemeMode(THEME_STORAGE_KEY);
const {
  activeTermKey,
  popoverAnchorStyle,
  isMobilePopover,
  closeTermPopover,
  updateViewportMode,
  toggleTermPopover,
  handleGlobalPointerDown,
  handleGlobalEscape
} = useTermPopover();

const loading = ref(true);
const error = ref('');

const playerQuery = ref('');
const eventQuery = ref('');
const glossaryQuery = ref('');
const glossaryCategory = ref('全部');

const players = ref([]);
const titles = ref([]);
const mapTitles = ref([]);
const titleMeta = ref(null);
const eventPacks = ref([]);
const eventMeta = ref(null);
const glossaryMeta = ref(null);
const glossaryTerms = ref([]);
const eventTermsIndex = ref({});

const expandedSeriesKeys = ref(new Set());
const collapsedDefaultSeriesKeys = ref(new Set());
const expandedEventGroupKeys = ref(new Set());
const collapsedDefaultEventGroupKeys = ref(new Set());
const completedMapsExpanded = ref(false);

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

const glossaryCategories = computed(() => {
  const categories = new Set(glossaryTerms.value.map((term) => term.category));
  return ['全部', ...[...categories].sort((left, right) => left.localeCompare(right, 'zh-Hans-CN'))];
});

const filteredGlossaryTerms = computed(() => {
  const keyword = glossaryQuery.value.trim().toLocaleLowerCase();
  const category = glossaryCategory.value;

  return glossaryTerms.value
    .filter((term) => {
      if (category !== '全部' && term.category !== category) {
        return false;
      }

      if (!keyword) {
        return true;
      }

      const text = [term.nameZh, term.summary, term.definition, ...(term.aliases || [])]
        .join('|')
        .toLocaleLowerCase();
      return text.includes(keyword);
    })
    .sort((left, right) => {
      if ((right.relatedEvents?.length || 0) !== (left.relatedEvents?.length || 0)) {
        return (right.relatedEvents?.length || 0) - (left.relatedEvents?.length || 0);
      }
      return left.nameZh.localeCompare(right.nameZh, 'zh-Hans-CN');
    });
});

const activeTerm = computed(() => glossaryTerms.value.find((term) => term.key === activeTermKey.value) || null);

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
  return String(value || '')
    .replace(/\\n/g, ' ')
    .replace(/\r?\n/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

function isAsciiToken(value) {
  return /^[A-Za-z0-9_ ]+$/.test(value);
}

function eventTermKeys(eventItem) {
  return eventTermsIndex.value[eventItem.key] || [];
}

function termAliasesByEvent(eventItem) {
  const termKeys = eventTermKeys(eventItem);
  const aliases = [];
  for (const termKey of termKeys) {
    const term = glossaryTerms.value.find((item) => item.key === termKey);
    if (!term) {
      continue;
    }

    aliases.push({
      termKey,
      alias: term.nameZh,
      isAscii: isAsciiToken(term.nameZh)
    });

    for (const alias of term.aliases || []) {
      aliases.push({
        termKey,
        alias,
        isAscii: isAsciiToken(alias)
      });
    }
  }

  const unique = new Map();
  for (const item of aliases) {
    const key = `${item.termKey}:${item.alias.toLocaleLowerCase()}`;
    if (!unique.has(key)) {
      unique.set(key, item);
    }
  }

  return [...unique.values()].sort((left, right) => right.alias.length - left.alias.length);
}

function splitTextWithTerms(text, eventItem) {
  const source = String(text || '');
  if (!source) {
    return [];
  }

  const aliases = termAliasesByEvent(eventItem);
  if (!aliases.length) {
    return [{ text: source, termKey: '' }];
  }

  const segments = [];
  let cursor = 0;

  while (cursor < source.length) {
    let matched = null;

    for (const aliasEntry of aliases) {
      const alias = aliasEntry.alias;
      if (!alias) {
        continue;
      }

      const candidate = source.slice(cursor, cursor + alias.length);
      let isMatch = false;

      if (aliasEntry.isAscii) {
        isMatch = candidate.toLocaleLowerCase() === alias.toLocaleLowerCase();
      } else {
        isMatch = candidate === alias;
      }

      if (!isMatch) {
        continue;
      }

      if (aliasEntry.isAscii) {
        const left = cursor === 0 ? '' : source[cursor - 1];
        const right = cursor + alias.length >= source.length ? '' : source[cursor + alias.length];
        if ((left && /[A-Za-z0-9_]/.test(left)) || (right && /[A-Za-z0-9_]/.test(right))) {
          continue;
        }
      }

      matched = aliasEntry;
      break;
    }

    if (!matched) {
      segments.push({ text: source[cursor], termKey: '' });
      cursor += 1;
      continue;
    }

    segments.push({ text: matched.alias, termKey: matched.termKey });
    cursor += matched.alias.length;
  }

  const compactSegments = [];
  for (const segment of segments) {
    const previous = compactSegments[compactSegments.length - 1];
    if (previous && previous.termKey === segment.termKey) {
      previous.text += segment.text;
    } else {
      compactSegments.push({ ...segment });
    }
  }

  return compactSegments;
}

function eventDescSegments(eventItem) {
  const desc = normalizedDesc(eventItem.descZhCompiled || eventItem.descZh);
  return splitTextWithTerms(desc, eventItem);
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

function getEventGroupKey(packId, groupType) {
  return `${packId}:${groupType}`;
}

function getSeriesBodyId(groupType, seriesName) {
  const normalized = String(seriesName)
    .toLocaleLowerCase()
    .replace(/[^a-z0-9\u4e00-\u9fff]+/gi, '-')
    .replace(/^-+|-+$/g, '');
  return `series-body-${groupType}-${normalized || 'default'}`;
}

function getEventGroupBodyId(packId, groupType) {
  const normalizedPackId = String(packId)
    .toLocaleLowerCase()
    .replace(/[^a-z0-9\u4e00-\u9fff]+/gi, '-')
    .replace(/^-+|-+$/g, '');
  const normalizedGroupType = String(groupType)
    .toLocaleLowerCase()
    .replace(/[^a-z0-9\u4e00-\u9fff]+/gi, '-')
    .replace(/^-+|-+$/g, '');
  return `event-group-body-${normalizedPackId || 'default'}-${normalizedGroupType || 'default'}`;
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

function isEventGroupExpanded(packId, index, groupType) {
  const groupKey = getEventGroupKey(packId, groupType);
  if (collapsedDefaultEventGroupKeys.value.has(groupKey)) {
    return false;
  }
  if (expandedEventGroupKeys.value.has(groupKey)) {
    return true;
  }
  return index < 2;
}

function toggleEventGroup(packId, index, groupType) {
  const groupKey = getEventGroupKey(packId, groupType);
  const nextExpanded = !isEventGroupExpanded(packId, index, groupType);

  if (index < 2) {
    if (nextExpanded) {
      collapsedDefaultEventGroupKeys.value.delete(groupKey);
    } else {
      collapsedDefaultEventGroupKeys.value.add(groupKey);
    }
    return;
  }

  if (nextExpanded) {
    expandedEventGroupKeys.value.add(groupKey);
  } else {
    expandedEventGroupKeys.value.delete(groupKey);
  }
}

function isRetiredTitle(title) {
  if (title?.availability === 'retired') {
    return true;
  }

  const conditionText = String(title?.condition || '');
  return /不再发放|历史称号/.test(conditionText);
}

function toggleCompletedMaps() {
  completedMapsExpanded.value = !completedMapsExpanded.value;
}

function openTerm(termKey, targetElement = null) {
  toggleTermPopover(termKey, targetElement);
}

function goToEventWithQuery(queryText) {
  if (typeof window !== 'undefined') {
    window.location.hash = '#/events';
  }
  currentRoute.value = 'events';
  eventQuery.value = String(queryText || '').trim();
}

function resolveTermLabel(termKey) {
  return glossaryTerms.value.find((term) => term.key === termKey)?.nameZh || termKey;
}

async function loadData() {
  loading.value = true;
  error.value = '';

  try {
    const [titleResponse, eventResponse, glossaryResponse] = await Promise.all([
      fetch('./data/titles.json', { cache: 'no-store' }),
      fetch('./data/events.json', { cache: 'no-store' }),
      fetch('./data/glossary.json', { cache: 'no-store' })
    ]);

    if (!titleResponse.ok) {
      throw new Error(`称号数据请求失败（${titleResponse.status}）`);
    }

    if (!eventResponse.ok) {
      throw new Error(`事件数据请求失败（${eventResponse.status}）`);
    }

    if (!glossaryResponse.ok) {
      throw new Error(`词条数据请求失败（${glossaryResponse.status}）`);
    }

    const [titlePayload, eventPayload, glossaryPayload] = await Promise.all([
      titleResponse.json(),
      eventResponse.json(),
      glossaryResponse.json()
    ]);

    players.value = titlePayload.players ?? [];
    titles.value = titlePayload.titles ?? [];
    mapTitles.value = titlePayload.mapTitles ?? [];
    titleMeta.value = titlePayload.meta ?? null;

    eventPacks.value = eventPayload.packs ?? [];
    eventMeta.value = eventPayload.meta ?? null;
    glossaryTerms.value = glossaryPayload.terms ?? [];
    glossaryMeta.value = glossaryPayload.meta ?? null;
    eventTermsIndex.value = glossaryPayload.eventTermsIndex ?? {};
  } catch (loadError) {
    error.value = loadError instanceof Error ? loadError.message : '查询数据加载失败';
  } finally {
    loading.value = false;
  }
}

onMounted(() => {
  initTheme();
  setRouteFromHash();
  updateViewportMode();
  if (typeof window !== 'undefined') {
    window.addEventListener('hashchange', setRouteFromHash);
    window.addEventListener('resize', updateViewportMode);
    document.addEventListener('pointerdown', handleGlobalPointerDown);
    document.addEventListener('keydown', handleGlobalEscape);
  }
  loadData();
});

onUnmounted(() => {
  if (typeof window !== 'undefined') {
    window.removeEventListener('hashchange', setRouteFromHash);
    window.removeEventListener('resize', updateViewportMode);
    document.removeEventListener('pointerdown', handleGlobalPointerDown);
    document.removeEventListener('keydown', handleGlobalEscape);
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

watch(
  () => currentRoute.value,
  () => {
    closeTermPopover();
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

        <label class="search-panel" v-else-if="currentRoute === 'events'">
          <span>搜索事件</span>
          <input
            v-model="eventQuery"
            name="event-search"
            type="search"
            placeholder="输入事件名、包编号或类型，例如 随机事件包 4 / 赌徒 / Debuff…"
            autocomplete="off"
          />
        </label>

        <div class="search-panel search-panel-glossary" v-else>
          <label>
            <span>搜索词条</span>
            <input
              v-model="glossaryQuery"
              name="glossary-search"
              type="search"
              placeholder="输入词条名或别名，例如 无敌 / 相移 / 减疗…"
              autocomplete="off"
            />
          </label>
          <label class="glossary-category-filter">
            <span>词条分类</span>
            <select v-model="glossaryCategory" name="glossary-category">
              <option v-for="category in glossaryCategories" :key="`glossary-category-${category}`" :value="category">
                {{ category }}
              </option>
            </select>
          </label>
        </div>

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

      <TitlesPanel
        v-if="currentRoute === 'titles'"
        :loading="loading"
        :error="error"
        :has-player-query="hasPlayerQuery"
        :showcased-player="showcasedPlayer"
        :grouped-titles="groupedTitles"
        :visible-titles="visibleTitles"
        :is-series-expanded="isSeriesExpanded"
        :toggle-series="toggleSeries"
        :get-series-body-id="getSeriesBodyId"
        :is-retired-title="isRetiredTitle"
        :map-summary="mapSummary"
        :incomplete-map-titles="incompleteMapTitles"
        :complete-map-titles="completeMapTitles"
        :completed-maps-expanded="completedMapsExpanded"
        :toggle-completed-maps="toggleCompletedMaps"
      />

      <EventsPanel
        v-if="currentRoute === 'events'"
        :loading="loading"
        :error="error"
        :filtered-event-packs="filteredEventPacks"
        :event-groups="eventGroups"
        :toggle-event-group="toggleEventGroup"
        :is-event-group-expanded="isEventGroupExpanded"
        :get-event-group-body-id="getEventGroupBodyId"
        :event-type-class="eventTypeClass"
        :event-desc-segments="eventDescSegments"
        :event-term-keys="eventTermKeys"
        :resolve-term-label="resolveTermLabel"
        @open-term="openTerm"
      />

      <GlossaryPanel
        v-if="currentRoute === 'glossary'"
        :loading="loading"
        :error="error"
        :filtered-glossary-terms="filteredGlossaryTerms"
        @open-term="openTerm"
        @jump-to-event="goToEventWithQuery"
      />

      <TermPopover
        v-if="activeTerm"
        :active-term="activeTerm"
        :is-mobile-popover="isMobilePopover"
        :popover-anchor-style="popoverAnchorStyle"
        @close="closeTermPopover"
        @jump-to-event="goToEventWithQuery"
      />

      <footer class="page-footer" v-if="titleMeta || eventMeta || glossaryMeta">
        <span>称号源：{{ sourceDisplay }}</span>
        <span>事件源：{{ eventSourceDisplay }}</span>
        <span>词条源：{{ glossaryMeta?.sourceLabel || '效果词条' }}</span>
        <span>生成时间：{{ new Date((glossaryMeta?.generatedAt || eventMeta?.generatedAt || titleMeta?.generatedAt) ?? Date.now()).toLocaleString('zh-CN') }}</span>
      </footer>
    </main>
  </div>
</template>
