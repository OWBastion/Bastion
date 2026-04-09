<script setup>
const props = defineProps([
  'loading',
  'error',
  'filteredEventPacks',
  'eventGroups',
  'toggleEventGroup',
  'isEventGroupExpanded',
  'getEventGroupBodyId',
  'eventTypeClass',
  'eventDescSegments',
  'eventTermKeys',
  'resolveTermLabel'
]);

const emit = defineEmits(['open-term']);

function openTerm(event, termKey) {
  const targetElement = event.currentTarget instanceof HTMLElement ? event.currentTarget : null;
  emit('open-term', termKey, targetElement);
}
</script>

<template>
  <section class="catalog-panel card ow-card">
    <header class="card-header">
      <h2>随机事件</h2>
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
          <section class="event-group" v-for="(group, groupIndex) in eventGroups(pack)" :key="`group-${pack.id}-${group.type}`">
            <header class="event-group-head">
              <p class="event-group-title">{{ group.label }}</p>
              <span class="series-count">{{ group.events.length }}</span>
              <button
                type="button"
                class="series-toggle ow-button ow-button-aux"
                @click="toggleEventGroup(pack.id, groupIndex, group.type)"
                :aria-expanded="isEventGroupExpanded(pack.id, groupIndex, group.type)"
                :aria-controls="getEventGroupBodyId(pack.id, group.type)"
              >
                <span>{{ isEventGroupExpanded(pack.id, groupIndex, group.type) ? '收起' : '展开' }}</span>
                <span
                  class="series-toggle-icon"
                  :class="isEventGroupExpanded(pack.id, groupIndex, group.type) ? 'is-expanded' : ''"
                  aria-hidden="true"
                >
                  ▾
                </span>
              </button>
            </header>
            <div
              class="event-group-body"
              :id="getEventGroupBodyId(pack.id, group.type)"
              :class="isEventGroupExpanded(pack.id, groupIndex, group.type) ? 'is-expanded' : 'is-collapsed'"
              :aria-hidden="!isEventGroupExpanded(pack.id, groupIndex, group.type)"
            >
              <ul class="event-item-list">
                <li v-for="eventItem in group.events" :key="`event-${eventItem.type}-${eventItem.id}`">
                  <article class="event-item" :class="eventTypeClass(eventItem.type)">
                    <p class="event-line">
                      <span class="event-name">{{ eventItem.nameZh }}</span>
                      <span class="event-desc">
                        <template
                          v-for="(segment, segmentIndex) in eventDescSegments(eventItem)"
                          :key="`event-segment-${eventItem.key}-${segmentIndex}`"
                        >
                          <button v-if="segment.termKey" type="button" class="term-trigger" @click="openTerm($event, segment.termKey)">
                            {{ segment.text }}
                          </button>
                          <span v-else>{{ segment.text }}</span>
                        </template>
                      </span>
                    </p>
                    <p class="event-term-list" v-if="eventTermKeys(eventItem).length">
                      <button
                        type="button"
                        class="term-trigger term-trigger-soft"
                        v-for="termKey in eventTermKeys(eventItem)"
                        :key="`event-term-${eventItem.key}-${termKey}`"
                        @click="openTerm($event, termKey)"
                      >
                        {{ resolveTermLabel(termKey) }}
                      </button>
                    </p>
                    <p class="event-tag-list">
                      <span class="event-tag event-tag-duration">{{ eventItem.durationSec }}秒</span>
                      <span class="event-tag event-tag-weight">权重 {{ eventItem.weight }}</span>
                    </p>
                  </article>
                </li>
              </ul>
            </div>
          </section>
        </div>
      </article>
    </div>
  </section>
</template>
