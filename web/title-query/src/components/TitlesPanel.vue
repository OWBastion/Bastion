<script setup>
defineProps([
  'loading',
  'error',
  'hasPlayerQuery',
  'showcasedPlayer',
  'groupedTitles',
  'visibleTitles',
  'isSeriesExpanded',
  'toggleSeries',
  'getSeriesBodyId',
  'isRetiredTitle',
  'mapSummary',
  'incompleteMapTitles',
  'completeMapTitles',
  'completedMapsExpanded',
  'toggleCompletedMaps'
]);
</script>

<template>
  <section class="content-grid">
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
      <div v-else-if="!showcasedPlayer" class="state-block">没有找到匹配的玩家，试试缩短关键字或直接输入完整昵称。</div>
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

  <section class="catalog-panel card ow-card" v-if="hasPlayerQuery">
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

  <section class="catalog-panel card ow-card" v-if="hasPlayerQuery">
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
            @click="toggleCompletedMaps()"
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
</template>
