<script setup>
defineProps(['staticSummary']);

function metricWidth(rows, field, value) {
  const values = rows.map((row) => Math.abs(Number(row?.[field] || 0)));
  const max = Math.max(...values, 0);
  if (max <= 0) {
    return '0%';
  }
  return `${Math.max(10, Math.min(100, (Math.abs(Number(value || 0)) / max) * 100)).toFixed(2)}%`;
}
</script>

<template>
  <section class="allocator-section">
    <header class="allocator-section-head">
      <div>
        <p class="allocator-eyebrow">静态对比</p>
        <h3>当前算法和按权重抽取的差别</h3>
      </div>
    </header>

    <article v-for="summary in staticSummary" :key="summary.type" class="static-card">
      <header class="static-card-head">
        <div>
          <h4>{{ summary.typeLabel }}</h4>
          <p>{{ summary.poolSummary }}</p>
        </div>
        <span class="static-pill">平均接受率 {{ summary.acceptanceAveragePercent }}</span>
      </header>

      <div class="static-row-block">
        <p class="static-row-title">最常出现的事件</p>
        <div class="probability-table">
          <div class="probability-row probability-row-head">
            <span>事件</span>
            <span>当前出现率</span>
            <span>按权重时应有出现率</span>
            <span>高出多少</span>
            <span>保底抬升占比</span>
          </div>
          <div v-for="row in summary.topRows" :key="`${summary.type}-${row.key}-top`" class="probability-row">
            <div class="probability-name">
              <span class="probability-key">{{ row.eventNameZh }}</span>
              <span class="probability-note">{{ row.summaryText }}</span>
            </div>
            <span>{{ row.currentChancePercent }}</span>
            <span>{{ row.expectedChancePercent }}</span>
            <span class="probability-bar-cell">
              <span class="probability-value">{{ row.extraChancePercent }}</span>
              <span class="probability-bar-track">
                <span class="probability-bar probability-bar-extra" :style="{ width: metricWidth(summary.topRows, 'deltaProbability', row.deltaProbability) }"></span>
              </span>
            </span>
            <span class="probability-bar-cell">
              <span class="probability-value">{{ row.safetyLiftPercent }}</span>
              <span class="probability-bar-track">
                <span class="probability-bar probability-bar-safety" :style="{ width: metricWidth(summary.topRows, 'fallbackProbability', row.fallbackProbability) }"></span>
              </span>
            </span>
          </div>
        </div>
      </div>

      <div class="static-row-block">
        <p class="static-row-title">最容易被额外抬高的低权重事件</p>
        <div class="probability-table">
          <div class="probability-row probability-row-head">
            <span>事件</span>
            <span>当前出现率</span>
            <span>按权重时应有出现率</span>
            <span>高出多少</span>
            <span>保底抬升占比</span>
          </div>
          <div v-for="row in summary.lowWeightRows" :key="`${summary.type}-${row.key}-low`" class="probability-row">
            <div class="probability-name">
              <span class="probability-key">{{ row.eventNameZh }}</span>
              <span class="probability-note">{{ row.fallbackSummaryText }}</span>
            </div>
            <span>{{ row.currentChancePercent }}</span>
            <span>{{ row.expectedChancePercent }}</span>
            <span class="probability-bar-cell">
              <span class="probability-value">{{ row.extraChancePercent }}</span>
              <span class="probability-bar-track">
                <span class="probability-bar probability-bar-extra" :style="{ width: metricWidth(summary.lowWeightRows, 'deltaProbability', row.deltaProbability) }"></span>
              </span>
            </span>
            <span class="probability-bar-cell">
              <span class="probability-value">{{ row.safetyLiftPercent }}</span>
              <span class="probability-bar-track">
                <span class="probability-bar probability-bar-safety" :style="{ width: metricWidth(summary.lowWeightRows, 'fallbackProbability', row.fallbackProbability) }"></span>
              </span>
            </span>
          </div>
        </div>
      </div>
    </article>
  </section>
</template>

<style scoped>
.allocator-section {
  display: grid;
  gap: 0.9rem;
}

.allocator-section-head h3,
.static-card-head h4 {
  margin: 0;
  color: var(--ow-text);
}

.allocator-eyebrow,
.static-row-title {
  margin: 0;
  color: var(--ow-text-muted);
  font-size: 0.74rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.static-card {
  border: 1px solid var(--ow-line);
  border-radius: var(--ow-radius-md);
  background: rgba(255, 255, 255, 0.04);
  padding: 0.95rem 1rem;
  display: grid;
  gap: 0.95rem;
}

.static-card-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 1rem;
}

.static-card-head p {
  margin: 0.35rem 0 0;
  color: var(--ow-text-soft);
  line-height: 1.55;
}

.static-pill {
  border: 1px solid var(--ow-line);
  border-radius: 999px;
  padding: 0.28rem 0.6rem;
  color: var(--ow-text-soft);
  background: rgba(255, 255, 255, 0.04);
  font-size: 0.78rem;
}

.static-row-block,
.probability-table {
  display: grid;
  gap: 0.55rem;
}

.probability-row {
  display: grid;
  grid-template-columns: minmax(170px, 1.45fr) repeat(2, minmax(110px, 0.9fr)) minmax(170px, 1.2fr) minmax(170px, 1.2fr);
  gap: 0.65rem;
  align-items: center;
  color: var(--ow-text-soft);
  font-size: 0.84rem;
}

.probability-row-head {
  color: var(--ow-text-muted);
  font-size: 0.76rem;
}

.probability-name {
  display: grid;
  gap: 0.15rem;
}

.probability-key {
  color: var(--ow-text);
  font-weight: 700;
  overflow-wrap: anywhere;
}

.probability-note {
  color: var(--ow-text-muted);
  font-size: 0.75rem;
  line-height: 1.4;
}

.probability-bar-cell {
  display: flex;
  align-items: center;
  gap: 0.45rem;
}

.probability-value {
  width: 4.7rem;
  flex-shrink: 0;
}

.probability-bar-track {
  position: relative;
  flex: 1;
  min-width: 0;
  height: 0.52rem;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.08);
  overflow: hidden;
}

.probability-bar {
  position: absolute;
  inset: 0 auto 0 0;
  border-radius: 999px;
}

.probability-bar-extra {
  background: linear-gradient(90deg, rgba(0, 154, 243, 0.35), rgba(0, 154, 243, 0.92));
}

.probability-bar-safety {
  background: linear-gradient(90deg, rgba(240, 160, 44, 0.35), rgba(240, 160, 44, 0.95));
}

@media (max-width: 860px) {
  .probability-row {
    grid-template-columns: 1fr;
    padding: 0.7rem 0;
    border-top: 1px solid rgba(255, 255, 255, 0.06);
  }

  .probability-row-head {
    display: none;
  }

  .static-card-head {
    grid-template-columns: 1fr;
  }
}
</style>
