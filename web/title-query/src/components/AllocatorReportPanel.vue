<script setup>
import { computed, ref, watch } from 'vue';

const props = defineProps(['loading', 'error', 'report', 'filterText']);

const selectedScenarioId = ref('');

const scenarioFilter = computed(() => String(props.filterText || '').trim().toLocaleLowerCase());
const alerts = computed(() => props.report?.alerts ?? []);
const staticSummary = computed(() => props.report?.staticSummary ?? []);

const filteredAlerts = computed(() => {
  if (!scenarioFilter.value) {
    return alerts.value;
  }

  return alerts.value.filter((alert) =>
    [alert.title, alert.detail].join('|').toLocaleLowerCase().includes(scenarioFilter.value)
  );
});

const filteredScenarios = computed(() => {
  const scenarios = props.report?.scenarios ?? [];
  if (!scenarioFilter.value) {
    return scenarios;
  }

  return scenarios.filter((scenario) => {
    const text = [
      scenario.label,
      scenario.description,
      scenario.selectedTypeLabel,
      scenario.candidatePool.candidateKeys.join('|'),
      scenario.candidatePool.filtered
        .map((item) => `${item.key}|${item.reasonLabels.join('|')}|${item.reasons.join('|')}`)
        .join('|')
    ]
      .join('|')
      .toLocaleLowerCase();
    return text.includes(scenarioFilter.value);
  });
});

const activeScenario = computed(
  () => filteredScenarios.value.find((scenario) => scenario.id === selectedScenarioId.value) || filteredScenarios.value[0] || null
);

watch(
  () => filteredScenarios.value.map((scenario) => scenario.id).join('|'),
  () => {
    if (!filteredScenarios.value.length) {
      selectedScenarioId.value = '';
      return;
    }
    if (!filteredScenarios.value.some((scenario) => scenario.id === selectedScenarioId.value)) {
      selectedScenarioId.value = filteredScenarios.value[0].id;
    }
  },
  { immediate: true }
);

function formatPercent(value) {
  return `${(Number(value || 0) * 100).toFixed(2)}%`;
}

function formatRoll(value) {
  return Number(value || 0).toFixed(3).replace(/\.?0+$/, '');
}

function metricWidth(rows, field, value) {
  const values = rows.map((row) => Math.abs(Number(row?.[field] || 0)));
  const max = Math.max(...values, 0);
  if (max <= 0) {
    return '0%';
  }
  return `${Math.max(10, Math.min(100, (Math.abs(Number(value || 0)) / max) * 100)).toFixed(2)}%`;
}

function barClass(field, value) {
  if (field === 'fallbackProbability') {
    return 'probability-bar-fallback';
  }
  return Number(value || 0) >= 0 ? 'probability-bar-positive' : 'probability-bar-negative';
}

function alertClass(severity) {
  return severity === 'warn' ? 'alert-card-warn' : 'alert-card-info';
}
</script>

<template>
  <section class="catalog-panel card ow-card allocator-panel">
    <header class="card-header">
      <h2>事件分配报告</h2>
      <p class="allocator-subtitle">从候选池、去重、category roll 与兜底质量三个层面查看当前 allocator 的真实分布。</p>
    </header>

    <div v-if="loading" class="state-block">正在生成事件分配报告…</div>
    <div v-else-if="error" class="state-block state-error">{{ error }}</div>
    <div v-else-if="!report" class="state-block">当前没有可显示的分配报告数据。</div>
    <div v-else class="allocator-layout">
      <section class="allocator-section">
        <header class="allocator-section-head">
          <div>
            <p class="allocator-eyebrow">Overview</p>
            <h3>核心告警与总览</h3>
          </div>
          <div class="allocator-meta-list">
            <span class="allocator-meta-pill">eventWeight {{ report.meta.eventWeight }}</span>
            <span class="allocator-meta-pill">去重窗口 {{ report.meta.recentDedupCount }}</span>
            <span class="allocator-meta-pill">场景 {{ report.meta.scenarioCount }}</span>
          </div>
        </header>

        <div class="alert-grid" v-if="filteredAlerts.length">
          <article v-for="alert in filteredAlerts" :key="alert.id" class="alert-card" :class="alertClass(alert.severity)">
            <p class="alert-kicker">{{ alert.severity === 'warn' ? '需要关注' : '提示' }}</p>
            <h4>{{ alert.title }}</h4>
            <p>{{ alert.detail }}</p>
          </article>
        </div>
        <p v-else class="group-empty">当前过滤词没有匹配到告警。</p>

        <div class="summary-grid">
          <article v-for="summary in staticSummary" :key="`summary-${summary.type}`" class="summary-card">
            <header class="summary-card-head">
              <div>
                <p class="summary-label">{{ summary.typeLabel }}</p>
                <h4>{{ summary.candidateCount }} 个候选</h4>
              </div>
              <span class="summary-fallback">{{ summary.fallbackStageLabel }}</span>
            </header>
            <dl class="summary-metrics">
              <div>
                <dt>平均接受率</dt>
                <dd>{{ formatPercent(summary.acceptanceAverage) }}</dd>
              </div>
              <div>
                <dt>最大 uplift</dt>
                <dd>{{ summary.strongestUpliftRow ? `${summary.strongestUpliftRow.key} / ${formatPercent(summary.strongestUpliftRow.deltaProbability)}` : '无' }}</dd>
              </div>
              <div>
                <dt>最大 fallback</dt>
                <dd>{{ summary.strongestFallbackRow ? `${summary.strongestFallbackRow.key} / ${formatPercent(summary.strongestFallbackRow.fallbackProbability)}` : '无' }}</dd>
              </div>
            </dl>
          </article>
        </div>
      </section>

      <section class="allocator-section">
        <header class="allocator-section-head">
          <div>
            <p class="allocator-eyebrow">Static Comparison</p>
            <h3>当前算法 vs 标准加权抽样</h3>
          </div>
        </header>

        <article v-for="summary in staticSummary" :key="`static-${summary.type}`" class="static-card">
          <header class="static-card-head">
            <div>
              <h4>{{ summary.typeLabel }}</h4>
              <p>{{ summary.candidateCount }} 个候选，平均接受率 {{ formatPercent(summary.acceptanceAverage) }}</p>
            </div>
            <span class="summary-fallback">{{ summary.fallbackStageLabel }}</span>
          </header>

          <div class="static-row-block">
            <p class="static-row-title">Top Rows</p>
            <div class="probability-table">
              <div class="probability-row probability-row-head">
                <span>事件</span>
                <span>当前</span>
                <span>参考</span>
                <span>Delta</span>
                <span>Fallback</span>
              </div>
              <div class="probability-row" v-for="row in summary.topRows" :key="`top-${summary.type}-${row.key}`">
                <span class="probability-key">{{ row.key }}</span>
                <span>{{ formatPercent(row.currentProbability) }}</span>
                <span>{{ formatPercent(row.referenceProbability) }}</span>
                <span class="probability-bar-cell">
                  <span class="probability-value">{{ formatPercent(row.deltaProbability) }}</span>
                  <span class="probability-bar-track">
                    <span
                      class="probability-bar"
                      :class="barClass('deltaProbability', row.deltaProbability)"
                      :style="{ width: metricWidth(summary.topRows, 'deltaProbability', row.deltaProbability) }"
                    ></span>
                  </span>
                </span>
                <span class="probability-bar-cell">
                  <span class="probability-value">{{ formatPercent(row.fallbackProbability) }}</span>
                  <span class="probability-bar-track">
                    <span
                      class="probability-bar probability-bar-fallback"
                      :style="{ width: metricWidth(summary.topRows, 'fallbackProbability', row.fallbackProbability) }"
                    ></span>
                  </span>
                </span>
              </div>
            </div>
          </div>

          <div class="static-row-block">
            <p class="static-row-title">Low-weight Uplift Rows</p>
            <div class="probability-table">
              <div class="probability-row probability-row-head">
                <span>事件</span>
                <span>权重</span>
                <span>当前</span>
                <span>Delta</span>
                <span>Fallback</span>
              </div>
              <div class="probability-row" v-for="row in summary.lowWeightRows" :key="`low-${summary.type}-${row.key}`">
                <span class="probability-key">{{ row.key }}</span>
                <span>{{ row.weight }}</span>
                <span>{{ formatPercent(row.currentProbability) }}</span>
                <span class="probability-bar-cell">
                  <span class="probability-value">{{ formatPercent(row.deltaProbability) }}</span>
                  <span class="probability-bar-track">
                    <span
                      class="probability-bar"
                      :class="barClass('deltaProbability', row.deltaProbability)"
                      :style="{ width: metricWidth(summary.lowWeightRows, 'deltaProbability', row.deltaProbability) }"
                    ></span>
                  </span>
                </span>
                <span class="probability-bar-cell">
                  <span class="probability-value">{{ formatPercent(row.fallbackProbability) }}</span>
                  <span class="probability-bar-track">
                    <span
                      class="probability-bar probability-bar-fallback"
                      :style="{ width: metricWidth(summary.lowWeightRows, 'fallbackProbability', row.fallbackProbability) }"
                    ></span>
                  </span>
                </span>
              </div>
            </div>
          </div>
        </article>
      </section>

      <section class="allocator-section">
        <header class="allocator-section-head allocator-section-head-scenario">
          <div>
            <p class="allocator-eyebrow">Scenario Explorer</p>
            <h3>预置场景浏览</h3>
          </div>
          <div class="scenario-chip-list">
            <button
              v-for="scenario in filteredScenarios"
              :key="scenario.id"
              type="button"
              class="scenario-chip ow-button ow-button-secondary"
              :class="scenario.id === activeScenario?.id ? 'scenario-chip-active' : ''"
              @click="selectedScenarioId = scenario.id"
            >
              {{ scenario.label }}
            </button>
          </div>
        </header>

        <div v-if="!filteredScenarios.length" class="state-block">当前过滤词没有匹配到场景。</div>
        <template v-else-if="activeScenario">
          <article class="scenario-card">
            <header class="scenario-card-head">
              <div>
                <h4>{{ activeScenario.label }}</h4>
                <p>{{ activeScenario.description }}</p>
              </div>
              <div class="scenario-meta-list">
                <span class="allocator-meta-pill">{{ activeScenario.selectedTypeLabel }}</span>
                <span class="allocator-meta-pill">{{ activeScenario.candidatePool.fallbackStageLabel }}</span>
                <span class="allocator-meta-pill">seed {{ activeScenario.seed }}</span>
              </div>
            </header>

            <div class="scenario-grid">
              <section class="scenario-block">
                <p class="static-row-title">Category Roll Chain</p>
                <div class="transition-list">
                  <article v-for="transition in activeScenario.categoryTransitions" :key="`${activeScenario.id}-${transition.stage}`" class="transition-card">
                    <p class="transition-stage">{{ transition.stage }}</p>
                    <p class="transition-roll">{{ formatRoll(transition.roll) }}</p>
                    <p class="transition-desc">{{ transition.sourceLabel }} → {{ transition.typeLabel }}</p>
                  </article>
                </div>
              </section>

              <section class="scenario-block">
                <p class="static-row-title">Candidate Pool</p>
                <p class="scenario-copy">
                  候选 {{ activeScenario.candidatePool.candidateKeys.length }} 个：
                  <code>{{ activeScenario.candidatePool.candidateKeys.join(', ') || '(empty)' }}</code>
                </p>
                <p class="scenario-copy">过滤 {{ activeScenario.candidatePool.filteredCount }} 个。</p>
                <div class="filtered-list" v-if="activeScenario.candidatePool.filtered.length">
                  <article v-for="item in activeScenario.candidatePool.filtered" :key="`${activeScenario.id}-${item.key}`" class="filtered-card">
                    <p class="filtered-key">{{ item.key }}</p>
                    <p class="filtered-reasons">{{ item.reasonLabels.join(' / ') }}</p>
                  </article>
                </div>
                <p v-else class="group-empty">该场景没有被过滤的事件。</p>
              </section>
            </div>

            <div class="scenario-grid">
              <section class="scenario-block">
                <p class="static-row-title">Top Rows</p>
                <div class="probability-table">
                  <div class="probability-row probability-row-head">
                    <span>事件</span>
                    <span>当前</span>
                    <span>参考</span>
                    <span>Fallback</span>
                  </div>
                  <div class="probability-row" v-for="row in activeScenario.probabilities.topRows" :key="`scenario-top-${activeScenario.id}-${row.key}`">
                    <span class="probability-key">{{ row.key }}</span>
                    <span>{{ formatPercent(row.currentProbability) }}</span>
                    <span>{{ formatPercent(row.referenceProbability) }}</span>
                    <span>{{ formatPercent(row.fallbackProbability) }}</span>
                  </div>
                </div>
              </section>

              <section class="scenario-block">
                <p class="static-row-title">Low-weight Rows</p>
                <div class="probability-table">
                  <div class="probability-row probability-row-head">
                    <span>事件</span>
                    <span>权重</span>
                    <span>Delta</span>
                    <span>Fallback</span>
                  </div>
                  <div class="probability-row" v-for="row in activeScenario.probabilities.lowWeightRows" :key="`scenario-low-${activeScenario.id}-${row.key}`">
                    <span class="probability-key">{{ row.key }}</span>
                    <span>{{ row.weight }}</span>
                    <span>{{ formatPercent(row.deltaProbability) }}</span>
                    <span>{{ formatPercent(row.fallbackProbability) }}</span>
                  </div>
                </div>
              </section>
            </div>
          </article>
        </template>
      </section>
    </div>
  </section>
</template>

<style scoped>
.allocator-panel {
  padding: 1rem 1.05rem 1.2rem;
}

.allocator-subtitle {
  margin: 0.35rem 0 0;
  color: var(--ow-text-soft);
  line-height: 1.55;
}

.allocator-layout {
  display: grid;
  gap: 1rem;
}

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
.static-card-head h4,
.scenario-card-head h4,
.alert-card h4,
.summary-card h4 {
  margin: 0;
  color: var(--ow-text);
}

.allocator-section-head-scenario {
  align-items: center;
}

.allocator-eyebrow,
.alert-kicker,
.summary-label,
.static-row-title,
.transition-stage {
  margin: 0;
  color: var(--ow-text-muted);
  font-size: 0.74rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.allocator-meta-list,
.scenario-meta-list,
.scenario-chip-list {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.allocator-meta-pill,
.summary-fallback {
  border: 1px solid var(--ow-line);
  border-radius: 999px;
  padding: 0.28rem 0.6rem;
  color: var(--ow-text-soft);
  background: rgba(255, 255, 255, 0.04);
  font-size: 0.78rem;
}

.alert-grid,
.summary-grid,
.scenario-grid {
  display: grid;
  gap: 0.8rem;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
}

.alert-card,
.summary-card,
.static-card,
.scenario-card,
.transition-card,
.filtered-card {
  border: 1px solid var(--ow-line);
  border-radius: var(--ow-radius-md);
  background: rgba(255, 255, 255, 0.04);
}

.alert-card,
.summary-card,
.transition-card,
.filtered-card {
  padding: 0.85rem 0.95rem;
}

.alert-card p,
.summary-card p,
.scenario-card p,
.filtered-card p,
.static-card p {
  margin: 0;
}

.alert-card-warn {
  box-shadow: inset 0 0 0 1px rgba(240, 100, 20, 0.18);
}

.alert-card-info {
  box-shadow: inset 0 0 0 1px rgba(0, 154, 243, 0.18);
}

.summary-card-head,
.static-card-head,
.scenario-card-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 1rem;
}

.summary-metrics {
  display: grid;
  gap: 0.6rem;
  margin: 0.9rem 0 0;
}

.summary-metrics div {
  display: grid;
  gap: 0.2rem;
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

.static-card,
.scenario-card {
  padding: 0.95rem 1rem;
  display: grid;
  gap: 0.9rem;
}

.static-row-block,
.scenario-block {
  display: grid;
  gap: 0.55rem;
}

.probability-table {
  display: grid;
  gap: 0.45rem;
}

.probability-row {
  display: grid;
  grid-template-columns: minmax(120px, 1.4fr) repeat(2, minmax(70px, 0.8fr)) minmax(160px, 1.2fr) minmax(160px, 1.2fr);
  gap: 0.65rem;
  align-items: center;
  color: var(--ow-text-soft);
  font-size: 0.84rem;
}

.probability-row-head {
  color: var(--ow-text-muted);
  font-size: 0.76rem;
  text-transform: uppercase;
}

.probability-key {
  color: var(--ow-text);
  font-weight: 700;
  overflow-wrap: anywhere;
}

.probability-bar-cell {
  display: flex;
  align-items: center;
  gap: 0.45rem;
}

.probability-value {
  width: 4.5rem;
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

.probability-bar-positive {
  background: linear-gradient(90deg, rgba(0, 154, 243, 0.35), rgba(0, 154, 243, 0.92));
}

.probability-bar-negative {
  background: linear-gradient(90deg, rgba(240, 100, 20, 0.35), rgba(240, 100, 20, 0.92));
}

.probability-bar-fallback {
  background: linear-gradient(90deg, rgba(163, 133, 255, 0.35), rgba(163, 133, 255, 0.95));
}

.scenario-chip {
  border-color: var(--ow-line);
}

.scenario-chip-active {
  border-color: var(--ow-line-strong);
  color: var(--ow-text);
  box-shadow: inset 0 0 0 1px rgba(240, 100, 20, 0.24);
}

.transition-list,
.filtered-list {
  display: grid;
  gap: 0.55rem;
}

.transition-roll {
  margin: 0.22rem 0 0;
  color: var(--ow-text);
  font-family: var(--font-display);
  font-size: 1.28rem;
  font-style: italic;
}

.transition-desc,
.scenario-copy,
.filtered-reasons,
.static-card-head p,
.scenario-card-head p {
  color: var(--ow-text-soft);
  line-height: 1.5;
}

.filtered-key {
  color: var(--ow-text);
  font-weight: 700;
  margin-bottom: 0.2rem;
}

.group-empty {
  margin: 0;
  color: var(--ow-text-soft);
}

code {
  color: var(--ow-text);
  word-break: break-all;
}

@media (max-width: 900px) {
  .allocator-section-head,
  .summary-card-head,
  .static-card-head,
  .scenario-card-head {
    flex-direction: column;
  }

  .probability-row {
    grid-template-columns: minmax(120px, 1fr) repeat(2, minmax(64px, 0.7fr)) minmax(120px, 1fr) minmax(120px, 1fr);
  }
}

@media (max-width: 640px) {
  .probability-row {
    grid-template-columns: 1fr;
    gap: 0.25rem;
    padding: 0.55rem 0.65rem;
    border: 1px solid var(--ow-line);
    border-radius: var(--ow-radius-sm);
    background: rgba(255, 255, 255, 0.03);
  }

  .probability-row-head {
    display: none;
  }

  .probability-bar-cell {
    flex-wrap: wrap;
  }

  .probability-value {
    width: auto;
  }
}
</style>
