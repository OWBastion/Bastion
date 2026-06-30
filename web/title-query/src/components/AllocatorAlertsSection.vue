<script setup>
defineProps(['alerts', 'staticSummary', 'metaPills']);

function alertClass(severity) {
  return severity === 'warn' ? 'alert-card-warn' : 'alert-card-info';
}
</script>

<template>
  <section class="allocator-section">
    <header class="allocator-section-head">
      <div>
        <p class="allocator-eyebrow">总览</p>
        <h3>先看结论</h3>
      </div>
      <div class="allocator-meta-list">
        <span v-for="pill in metaPills" :key="pill" class="allocator-meta-pill">{{ pill }}</span>
      </div>
    </header>

    <div v-if="alerts.length" class="alert-grid">
      <article v-for="alert in alerts" :key="alert.id" class="alert-card" :class="alertClass(alert.severity)">
        <p class="alert-kicker">{{ alert.severity === 'warn' ? '需要关注' : '补充说明' }}</p>
        <h4>{{ alert.title }}</h4>
        <p class="alert-summary">{{ alert.summary }}</p>
        <p class="alert-evidence">{{ alert.evidence }}</p>
      </article>
    </div>
    <p v-else class="group-empty">当前过滤词没有匹配到结论卡。</p>

    <div class="summary-grid">
      <article v-for="summary in staticSummary" :key="summary.type" class="summary-card">
        <p class="summary-label">{{ summary.typeLabel }}</p>
        <h4>{{ summary.poolSummary }}</h4>
        <dl class="summary-metrics">
          <div>
            <dt>平均接受率</dt>
            <dd>{{ summary.acceptanceAveragePercent }}</dd>
          </div>
          <div>
            <dt>最容易被抬高</dt>
            <dd>{{ summary.strongestUpliftRow ? `${summary.strongestUpliftRow.eventNameZh} · ${summary.strongestUpliftRow.extraChancePercent}` : '暂无' }}</dd>
          </div>
          <div>
            <dt>最依赖保底抬升</dt>
            <dd>{{ summary.strongestFallbackRow ? `${summary.strongestFallbackRow.eventNameZh} · ${summary.strongestFallbackRow.safetyLiftPercent}` : '暂无' }}</dd>
          </div>
        </dl>
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
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
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

.allocator-meta-list {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.allocator-meta-pill {
  border: 1px solid var(--ow-line);
  border-radius: 999px;
  padding: 0.28rem 0.6rem;
  color: var(--ow-text-soft);
  background: rgba(255, 255, 255, 0.04);
  font-size: 0.78rem;
}

.alert-grid,
.summary-grid {
  display: grid;
  gap: 0.8rem;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
}

.alert-card,
.summary-card {
  border: 1px solid var(--ow-line);
  border-radius: var(--ow-radius-md);
  background: rgba(255, 255, 255, 0.04);
  padding: 0.9rem 0.95rem;
}

.alert-card p,
.summary-card p {
  margin: 0;
}

.alert-card-warn {
  box-shadow: inset 0 0 0 1px rgba(240, 100, 20, 0.18);
}

.alert-card-info {
  box-shadow: inset 0 0 0 1px rgba(0, 154, 243, 0.18);
}

.alert-summary,
.alert-evidence {
  color: var(--ow-text-soft);
  line-height: 1.55;
}

.alert-summary {
  margin-top: 0.4rem;
}

.alert-evidence {
  margin-top: 0.45rem;
  color: var(--ow-text);
}

.summary-card h4 {
  margin-top: 0.35rem;
  font-size: 1rem;
  line-height: 1.55;
}

.summary-metrics {
  display: grid;
  gap: 0.6rem;
  margin: 0.9rem 0 0;
}

.summary-metrics div {
  display: grid;
  gap: 0.18rem;
}

.summary-metrics dt {
  color: var(--ow-text-muted);
  font-size: 0.78rem;
}

.summary-metrics dd {
  margin: 0;
  color: var(--ow-text);
  line-height: 1.45;
}

.group-empty {
  margin: 0;
  color: var(--ow-text-soft);
}
</style>
