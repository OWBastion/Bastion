<script setup>
defineProps(['scenarios', 'activeScenario', 'selectedScenarioId']);
defineEmits(['select']);
</script>

<template>
  <section class="allocator-section">
    <header class="allocator-section-head allocator-section-head-scenario">
      <div>
        <p class="allocator-eyebrow">场景浏览</p>
        <h3>把具体场景讲清楚</h3>
      </div>
      <div class="scenario-chip-list">
        <button
          v-for="scenario in scenarios"
          :key="scenario.id"
          type="button"
          class="scenario-chip ow-button ow-button-secondary"
          :class="scenario.id === selectedScenarioId ? 'scenario-chip-active' : ''"
          @click="$emit('select', scenario.id)"
        >
          {{ scenario.label }}
        </button>
      </div>
    </header>

    <div v-if="!scenarios.length" class="state-block">当前过滤词没有匹配到场景。</div>
    <article v-else-if="activeScenario" class="scenario-card">
      <header class="scenario-card-head">
        <div>
          <h4>{{ activeScenario.label }}</h4>
          <p>{{ activeScenario.description }}</p>
        </div>
        <span class="scenario-pill">{{ activeScenario.selectedTypeSummary }}</span>
      </header>

      <div class="scenario-grid">
        <section class="scenario-block">
          <p class="static-row-title">这一轮会先抽哪一类事件</p>
          <p class="scenario-copy">{{ activeScenario.transitionSummary }}</p>
          <div class="transition-list">
            <article v-for="transition in activeScenario.categoryTransitions" :key="`${activeScenario.id}-${transition.stage}`" class="transition-card">
              <p class="transition-stage">{{ transition.stage === 'current' ? '当前这一轮' : transition.stage === 'next' ? '下一轮' : '下下轮' }}</p>
              <p class="transition-type">{{ transition.typeLabel }}</p>
              <p class="transition-desc">{{ transition.sourceLabel }}</p>
            </article>
          </div>
        </section>

        <section class="scenario-block">
          <p class="static-row-title">本轮可能抽到哪些事件</p>
          <p class="scenario-copy">{{ activeScenario.candidatePoolSummary }}</p>
          <div class="candidate-list">
            <article v-for="item in activeScenario.candidatePool.events.slice(0, 6)" :key="`${activeScenario.id}-${item.key}`" class="candidate-card">
              <p class="candidate-name">{{ item.eventNameZh }}</p>
              <p class="candidate-pack">{{ item.packLabelZh }}</p>
            </article>
          </div>
          <p v-if="!activeScenario.candidatePool.events.length" class="group-empty">这一轮没有可抽事件。</p>
        </section>
      </div>

      <section class="scenario-block">
        <p class="static-row-title">哪些事件被暂时排除，以及为什么</p>
        <p class="scenario-copy">{{ activeScenario.filteredSummary }}</p>
        <div v-if="activeScenario.candidatePool.filtered.length" class="filtered-list">
          <article v-for="item in activeScenario.candidatePool.filtered.slice(0, 6)" :key="`${activeScenario.id}-${item.key}-filtered`" class="filtered-card">
            <p class="filtered-key">{{ item.eventNameZh }}</p>
            <p class="filtered-reasons">{{ item.reasonSummary }}</p>
          </article>
        </div>
        <p v-else class="group-empty">这个场景里没有事件被额外排除。</p>
      </section>

      <div class="scenario-grid">
        <section class="scenario-block">
          <p class="static-row-title">最常出现的事件</p>
          <div class="compact-table">
            <div class="compact-row compact-row-head">
              <span>事件</span>
              <span>当前出现率</span>
              <span>按权重时应有出现率</span>
              <span>一句话说明</span>
            </div>
            <div v-for="row in activeScenario.probabilities.topRows.slice(0, 5)" :key="`${activeScenario.id}-${row.key}-top`" class="compact-row">
              <span class="compact-key">{{ row.eventNameZh }}</span>
              <span>{{ row.currentChancePercent }}</span>
              <span>{{ row.expectedChancePercent }}</span>
              <span>{{ row.summaryText }}</span>
            </div>
          </div>
        </section>

        <section class="scenario-block">
          <p class="static-row-title">最容易被额外抬高的低权重事件</p>
          <div class="compact-table">
            <div class="compact-row compact-row-head">
              <span>事件</span>
              <span>高出多少</span>
              <span>保底抬升占比</span>
              <span>一句话说明</span>
            </div>
            <div v-for="row in activeScenario.probabilities.lowWeightRows.slice(0, 5)" :key="`${activeScenario.id}-${row.key}-low`" class="compact-row">
              <span class="compact-key">{{ row.eventNameZh }}</span>
              <span>{{ row.extraChancePercent }}</span>
              <span>{{ row.safetyLiftPercent }}</span>
              <span>{{ row.fallbackSummaryText }}</span>
            </div>
          </div>
        </section>
      </div>
    </article>
  </section>
</template>

<style scoped>
.allocator-section {
  display: grid;
  gap: 0.9rem;
}

.allocator-section-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 1rem;
}

.allocator-section-head-scenario {
  align-items: center;
}

.allocator-section-head h3,
.scenario-card-head h4 {
  margin: 0;
  color: var(--ow-text);
}

.allocator-eyebrow,
.static-row-title,
.transition-stage {
  margin: 0;
  color: var(--ow-text-muted);
  font-size: 0.74rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.scenario-chip-list {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.scenario-chip {
  border-color: var(--ow-line);
}

.scenario-chip-active {
  border-color: var(--ow-line-strong);
  color: var(--ow-text);
  box-shadow: inset 0 0 0 1px rgba(240, 100, 20, 0.24);
}

.scenario-card,
.transition-card,
.candidate-card,
.filtered-card {
  border: 1px solid var(--ow-line);
  border-radius: var(--ow-radius-md);
  background: rgba(255, 255, 255, 0.04);
}

.scenario-card {
  padding: 0.95rem 1rem;
  display: grid;
  gap: 0.95rem;
}

.scenario-card-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 1rem;
}

.scenario-card-head p,
.scenario-copy,
.filtered-reasons,
.candidate-pack,
.transition-desc {
  margin: 0;
  color: var(--ow-text-soft);
  line-height: 1.55;
}

.scenario-pill {
  border: 1px solid var(--ow-line);
  border-radius: 999px;
  padding: 0.28rem 0.6rem;
  color: var(--ow-text-soft);
  background: rgba(255, 255, 255, 0.04);
  font-size: 0.78rem;
}

.scenario-grid {
  display: grid;
  gap: 0.8rem;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
}

.scenario-block,
.compact-table {
  display: grid;
  gap: 0.55rem;
}

.transition-list,
.candidate-list,
.filtered-list {
  display: grid;
  gap: 0.55rem;
}

.transition-list {
  grid-template-columns: repeat(auto-fit, minmax(130px, 1fr));
}

.transition-card,
.candidate-card,
.filtered-card {
  padding: 0.85rem 0.95rem;
}

.transition-type,
.candidate-name,
.filtered-key {
  margin: 0.18rem 0 0;
  color: var(--ow-text);
  font-weight: 700;
}

.compact-row {
  display: grid;
  grid-template-columns: minmax(130px, 1.1fr) repeat(2, minmax(90px, 0.8fr)) minmax(130px, 1fr);
  gap: 0.65rem;
  color: var(--ow-text-soft);
  font-size: 0.84rem;
}

.compact-row-head {
  color: var(--ow-text-muted);
  font-size: 0.76rem;
}

.compact-key {
  color: var(--ow-text);
  font-weight: 700;
}

.group-empty {
  margin: 0;
  color: var(--ow-text-soft);
}

@media (max-width: 860px) {
  .compact-row {
    grid-template-columns: 1fr;
    padding: 0.7rem 0;
    border-top: 1px solid rgba(255, 255, 255, 0.06);
  }

  .compact-row-head {
    display: none;
  }
}
</style>
