<script setup>
defineProps(['alerts', 'staticSummary', 'metaPills']);

function alertClass(severity) {
  return severity === 'warn' ? 'alert-card-warn' : 'alert-card-info';
}

function summaryMetrics(summary) {
  return [
    {
      label: '有效候选',
      value: `${summary.candidateCount} 个`
    },
    {
      label: '平均接受率',
      value: summary.acceptanceAveragePercent
    },
    {
      label: '抬升峰值',
      value: summary.strongestUpliftRow ? summary.strongestUpliftRow.extraChancePercent : '暂无'
    }
  ];
}
</script>

<template>
  <section class="allocator-section">
    <header class="allocator-section-head">
      <div>
        <p class="allocator-eyebrow">总览</p>
        <h3>核心指标</h3>
      </div>
      <div class="allocator-metric-strip">
        <article v-for="pill in metaPills" :key="pill.label" class="allocator-stat-card">
          <p class="stat-label">{{ pill.label }}</p>
          <p class="stat-value">{{ pill.value }}</p>
          <p class="stat-note">{{ pill.note }}</p>
        </article>
      </div>
    </header>

    <div v-if="alerts.length" class="alert-grid">
      <article v-for="alert in alerts" :key="alert.id" class="alert-card" :class="alertClass(alert.severity)">
        <p class="alert-kicker">{{ alert.severity === 'warn' ? '异常提示' : '补充指标' }}</p>
        <h4>{{ alert.title }}</h4>
        <p class="alert-summary">{{ alert.summary }}</p>
        <p class="alert-evidence">依据：{{ alert.evidence }}</p>
      </article>
    </div>
    <p v-else class="group-empty">当前筛选条件没有匹配到异常提示。</p>

    <div class="summary-grid">
      <article v-for="summary in staticSummary" :key="summary.type" class="summary-card">
        <div class="summary-head">
          <div>
            <p class="summary-label">{{ summary.typeLabel }}</p>
            <h4>当前有效候选 {{ summary.candidateCount }} 个</h4>
          </div>
          <p class="summary-peak">{{ summary.acceptanceAveragePercent }}</p>
        </div>
        <dl class="summary-metric-grid">
          <div v-for="item in summaryMetrics(summary)" :key="`${summary.type}-${item.label}`">
            <dt>{{ item.label }}</dt>
            <dd>{{ item.value }}</dd>
          </div>
        </dl>
        <div class="summary-foot">
          <p>低权重抬升：{{ summary.strongestUpliftRow ? `${summary.strongestUpliftRow.eventNameZh} ${summary.strongestUpliftRow.extraChancePercent}` : '暂无' }}</p>
          <p>保底主导：{{ summary.strongestFallbackRow ? `${summary.strongestFallbackRow.eventNameZh} ${summary.strongestFallbackRow.safetyLiftPercent}` : '暂无' }}</p>
        </div>
      </article>
    </div>
  </section>
</template>

<style scoped>
.allocator-section {
  display: grid;
  gap: 0.9rem;
}

.allocator-section-head {
  display: grid;
  gap: 1rem;
}

.allocator-section-head h3,
.alert-card h4,
.summary-card h4 {
  margin: 0;
  color: var(--ow-text);
}

.allocator-eyebrow,
.alert-kicker,
.summary-label {
  margin: 0;
  color: var(--ow-text-muted);
  font-size: 0.74rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.allocator-metric-strip {
  display: grid;
  gap: 0.7rem;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
}

.allocator-stat-card,
.alert-card,
.summary-card {
  border: 1px solid var(--ow-line);
  border-radius: var(--ow-radius-md);
  background: rgba(255, 255, 255, 0.04);
}

.allocator-stat-card {
  padding: 0.8rem 0.9rem;
}

.stat-label {
  margin: 0;
  color: var(--ow-text-muted);
  font-size: 0.73rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.stat-value {
  margin: 0.25rem 0 0;
  color: var(--ow-text);
  font-family: var(--font-display);
  font-size: clamp(1.25rem, 2vw, 1.7rem);
  line-height: 1;
}

.stat-note {
  margin: 0.28rem 0 0;
  color: var(--ow-text-soft);
  font-size: 0.77rem;
}

.alert-grid,
.summary-grid {
  display: grid;
  gap: 0.8rem;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
}

.alert-card p,
.summary-card p {
  margin: 0;
}

.alert-card,
.summary-card {
  padding: 0.9rem 0.95rem;
}

.alert-card-warn {
  box-shadow: inset 0 0 0 1px rgba(240, 100, 20, 0.18);
}

.alert-card-info {
  box-shadow: inset 0 0 0 1px rgba(0, 154, 243, 0.18);
}

.alert-summary,
.alert-evidence {
  line-height: 1.45;
}

.alert-summary {
  margin-top: 0.4rem;
  color: var(--ow-text-soft);
}

.alert-evidence {
  margin-top: 0.45rem;
  color: var(--ow-text);
  font-size: 0.82rem;
}

.summary-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 0.8rem;
}

.summary-card h4 {
  margin-top: 0.22rem;
  font-size: 1rem;
  line-height: 1.25;
}

.summary-peak {
  color: var(--ow-text);
  font-family: var(--font-display);
  font-size: 1.4rem;
  line-height: 1;
}

.summary-metric-grid {
  display: grid;
  gap: 0.6rem;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  margin: 0.9rem 0 0;
}

.summary-metric-grid div {
  display: grid;
  gap: 0.18rem;
}

.summary-metric-grid dt {
  color: var(--ow-text-muted);
  font-size: 0.78rem;
}

.summary-metric-grid dd {
  margin: 0;
  color: var(--ow-text);
  line-height: 1.45;
}

.summary-foot {
  margin-top: 0.9rem;
  padding-top: 0.75rem;
  border-top: 1px solid rgba(255, 255, 255, 0.08);
  display: grid;
  gap: 0.25rem;
  color: var(--ow-text-soft);
  font-size: 0.82rem;
}

.group-empty {
  margin: 0;
  color: var(--ow-text-soft);
}

@media (max-width: 860px) {
  .summary-metric-grid {
    grid-template-columns: 1fr;
  }

  .summary-head {
    display: grid;
  }
}
</style>
