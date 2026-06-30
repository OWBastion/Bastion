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

function tableNote(row, mode) {
  if (mode === 'top') {
    return Number(row.deltaProbability || 0) >= 0 ? '高于权重' : '低于权重';
  }
  return Number(row.fallbackProbability || 0) > 0 ? '保底主导' : '抬升有限';
}
</script>

<template>
  <section class="allocator-section">
    <header class="allocator-section-head">
      <div>
        <p class="allocator-eyebrow">静态对比</p>
        <h3>静态分配对比</h3>
      </div>
    </header>

    <article v-for="summary in staticSummary" :key="summary.type" class="static-card">
      <header class="static-card-head">
        <h4>{{ summary.typeLabel }}</h4>
        <dl class="static-meta-grid">
          <div>
            <dt>有效候选</dt>
            <dd>{{ summary.candidateCount }}</dd>
          </div>
          <div>
            <dt>平均接受率</dt>
            <dd>{{ summary.acceptanceAveragePercent }}</dd>
          </div>
          <div>
            <dt>抬升峰值</dt>
            <dd>{{ summary.strongestUpliftRow ? summary.strongestUpliftRow.extraChancePercent : '暂无' }}</dd>
          </div>
        </dl>
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
              <span class="probability-note">{{ tableNote(row, 'top') }}</span>
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
              <span class="probability-note">{{ tableNote(row, 'low') }}</span>
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
  border-top: 1px solid var(--ow-line);
  padding: 0.95rem 1rem;
  display: grid;
  gap: 0.95rem;
}

.static-card-head {
  display: grid;
  gap: 0.75rem;
}

.static-meta-grid {
  margin: 0;
  display: grid;
  gap: 0.75rem;
  grid-template-columns: repeat(3, minmax(0, 1fr));
}

.static-meta-grid div {
  display: grid;
  gap: 0.18rem;
}

.static-meta-grid dt {
  color: var(--ow-text-muted);
  font-size: 0.74rem;
  text-transform: uppercase;
  letter-spacing: 0.06em;
}

.static-meta-grid dd {
  margin: 0;
  color: var(--ow-text);
  font-family: var(--font-display);
  font-size: 1.2rem;
  line-height: 1;
}

.static-row-block,
.probability-table {
  display: grid;
  gap: 0.55rem;
}

.static-row-block + .static-row-block {
  padding-top: 0.9rem;
  border-top: 1px solid rgba(255, 255, 255, 0.08);
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
  text-transform: uppercase;
  letter-spacing: 0.04em;
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
  text-transform: uppercase;
  letter-spacing: 0.06em;
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
  .static-meta-grid {
    grid-template-columns: 1fr;
  }

  .probability-row {
    grid-template-columns: 1fr;
    padding: 0.7rem 0;
    border-top: 1px solid rgba(255, 255, 255, 0.06);
  }

  .probability-row-head {
    display: none;
  }
}
</style>
