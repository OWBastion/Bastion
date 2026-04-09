<script setup>
const props = defineProps(['activeTerm', 'isMobilePopover', 'popoverAnchorStyle']);

const emit = defineEmits(['close', 'jump-to-event']);

function jumpToEvent(relatedEvent) {
  const queryText = props.activeTerm?.nameZh || relatedEvent?.nameZh || '';
  emit('jump-to-event', queryText);
}
</script>

<template>
  <aside
    class="term-popover ow-card"
    :class="isMobilePopover ? 'term-popover-mobile' : 'term-popover-desktop'"
    :style="isMobilePopover ? null : popoverAnchorStyle"
    role="dialog"
    :aria-label="`词条详情：${activeTerm.nameZh}`"
  >
    <header class="term-popover-head">
      <div>
        <h3>{{ activeTerm.nameZh }}</h3>
        <div class="term-popover-tags">
          <span class="title-tag title-tag-category">{{ activeTerm.category }}</span>
          <span class="title-tag title-tag-alias" v-for="alias in activeTerm.aliases || []" :key="`popover-alias-${activeTerm.key}-${alias}`">
            {{ alias }}
          </span>
        </div>
      </div>
      <button type="button" class="term-popover-close" aria-label="关闭词条详情" @click="emit('close')">
        ×
      </button>
    </header>
    <p class="term-popover-summary">{{ activeTerm.summary }}</p>
    <p class="term-popover-definition">{{ activeTerm.definition }}</p>
    <div class="term-popover-rules" v-if="activeTerm.rules?.length">
      <p>规则</p>
      <ul>
        <li v-for="rule in activeTerm.rules" :key="`term-rule-${activeTerm.key}-${rule}`">{{ rule }}</li>
      </ul>
    </div>
    <div class="term-popover-related" v-if="activeTerm.relatedEvents?.length">
      <p>关联事件</p>
      <div class="term-popover-related-list">
        <button
          type="button"
          class="event-related-link ow-button ow-button-secondary"
          v-for="relatedEvent in activeTerm.relatedEvents"
          :key="`term-pop-related-${activeTerm.key}-${relatedEvent.key}`"
          @click="jumpToEvent(relatedEvent)"
        >
          <span>{{ relatedEvent.nameZh }}</span>
          <span>{{ relatedEvent.packLabelZh }}</span>
        </button>
      </div>
    </div>
  </aside>
</template>
