<script setup>
import { computed, ref, watch } from 'vue';

import AllocatorAlertsSection from './AllocatorAlertsSection.vue';
import AllocatorScenarioSection from './AllocatorScenarioSection.vue';
import AllocatorSessionSimulationSection from './AllocatorSessionSimulationSection.vue';
import AllocatorStaticSummarySection from './AllocatorStaticSummarySection.vue';

const props = defineProps(['loading', 'error', 'report', 'filterText']);

const selectedScenarioId = ref('');
const scenarioFilter = computed(() => String(props.filterText || '').trim().toLocaleLowerCase());

const filteredAlerts = computed(() => {
  const alerts = props.report?.alerts ?? [];
  if (!scenarioFilter.value) {
    return alerts;
  }
  return alerts.filter((alert) =>
    [alert.title, alert.summary, alert.evidence].join('|').toLocaleLowerCase().includes(scenarioFilter.value)
  );
});

const filteredScenarios = computed(() => {
  const scenarios = props.report?.scenarios ?? [];
  if (!scenarioFilter.value) {
    return scenarios;
  }
  return scenarios.filter((scenario) => String(scenario.searchText || '').includes(scenarioFilter.value));
});

const activeScenario = computed(
  () => filteredScenarios.value.find((scenario) => scenario.id === selectedScenarioId.value) || filteredScenarios.value[0] || null
);

const activeSessionSimulation = computed(() => {
  const simulations = props.report?.sessionSimulation?.scenarios ?? [];
  const baselineScenarioId = props.report?.sessionSimulation?.baselineScenarioId ?? '';
  return (
    simulations.find((scenario) => scenario.id === selectedScenarioId.value) ||
    simulations.find((scenario) => scenario.id === baselineScenarioId) ||
    simulations[0] ||
    null
  );
});

const metaPills = computed(() => {
  if (!props.report) {
    return [];
  }
  return [
    {
      label: '去重窗口',
      value: `${props.report.meta.recentDedupCount} 个事件`,
      note: '最近抽取优先避开'
    },
    {
      label: '抽取基准',
      value: String(props.report.meta.eventWeight),
      note: '当前权重阈值'
    },
    {
      label: '预置场景',
      value: `${props.report.meta.scenarioCount} 个`,
      note: '用于对比分配行为'
    },
    {
      label: '延续风险',
      value: props.report.alerts.some((alert) => alert.id === 'category-roll-persists') ? '存在' : '无',
      note: '下一轮类别影响'
    }
  ];
});

watch(
  () => filteredScenarios.value.map((scenario) => scenario.id).join('|'),
  () => {
    if (!filteredScenarios.value.length) {
      selectedScenarioId.value = '';
      return;
    }
    if (!filteredScenarios.value.some((scenario) => scenario.id === selectedScenarioId.value)) {
      selectedScenarioId.value =
        filteredScenarios.value.find((scenario) => scenario.id === 'prod-default')?.id || filteredScenarios.value[0].id;
    }
  },
  { immediate: true }
);
</script>

<template>
  <section class="catalog-panel card ow-card allocator-panel">
    <header class="card-header">
      <h2>事件分配报告</h2>
      <p class="allocator-subtitle">用于观察候选范围收缩、低权重抬升与类别倾向延续。</p>
    </header>

    <div v-if="loading" class="state-block">正在生成事件分配报告…</div>
    <div v-else-if="error" class="state-block state-error">{{ error }}</div>
    <div v-else-if="!report" class="state-block">当前没有可显示的分配报告数据。</div>
    <div v-else class="allocator-layout">
      <AllocatorAlertsSection
        :alerts="filteredAlerts"
        :static-summary="report.staticSummary"
        :meta-pills="metaPills"
      />

      <AllocatorStaticSummarySection :static-summary="report.staticSummary" />

      <AllocatorSessionSimulationSection
        :simulation="activeSessionSimulation"
        :duration-label="report.sessionSimulation.durationLabel"
      />

      <AllocatorScenarioSection
        :scenarios="filteredScenarios"
        :active-scenario="activeScenario"
        :selected-scenario-id="selectedScenarioId"
        @select="selectedScenarioId = $event"
      />
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
  line-height: 1.6;
  max-width: 52rem;
}

.allocator-layout {
  display: grid;
  gap: 1rem;
}
</style>
