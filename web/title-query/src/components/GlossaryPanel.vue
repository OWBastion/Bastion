<script setup>
defineProps(['loading', 'error', 'filteredGlossaryTerms']);

const emit = defineEmits(['open-term', 'jump-to-event']);

function openTerm(event, termKey) {
  const targetElement = event.currentTarget instanceof HTMLElement ? event.currentTarget : null;
  emit('open-term', termKey, targetElement);
}

function jumpToEvent(termName, fallbackEventName) {
  emit('jump-to-event', termName || fallbackEventName || '');
}
</script>

<template>
  <section class="catalog-panel card ow-card">
    <header class="card-header">
      <p>效果词条</p>
      <h2>定义 / 规则 / 关联事件</h2>
    </header>
    <div v-if="loading" class="state-block">正在加载词条数据…</div>
    <div v-else-if="error" class="state-block state-error">{{ error }}</div>
    <div v-else-if="!filteredGlossaryTerms.length" class="state-block">没有匹配词条，请调整关键字或分类。</div>
    <div v-else class="glossary-grid">
      <article class="glossary-card" v-for="term in filteredGlossaryTerms" :key="`glossary-${term.key}`">
        <header class="glossary-head">
          <div class="glossary-name-line">
            <button type="button" class="glossary-trigger glossary-trigger-main" @click="openTerm($event, term.key)">
              {{ term.nameZh }}
            </button>
            <button
              type="button"
              class="glossary-trigger glossary-trigger-alias"
              v-for="alias in term.aliases || []"
              :key="`inline-alias-${term.key}-${alias}`"
              @click="openTerm($event, term.key)"
            >
              {{ alias }}
            </button>
          </div>
          <span class="title-tag title-tag-category">{{ term.category }}</span>
        </header>
        <p class="glossary-summary">{{ term.summary }}</p>
        <div class="glossary-related" v-if="term.relatedEvents?.length">
          <button
            type="button"
            class="event-related-link ow-button ow-button-secondary"
            v-for="relatedEvent in term.relatedEvents"
            :key="`related-${term.key}-${relatedEvent.key}`"
            @click="jumpToEvent(term.nameZh, relatedEvent.nameZh)"
          >
            <span>{{ relatedEvent.nameZh }}</span>
            <span>{{ relatedEvent.packLabelZh }}</span>
          </button>
        </div>
      </article>
    </div>
  </section>
</template>
