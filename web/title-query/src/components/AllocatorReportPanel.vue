<script setup>
import { computed, ref, watch } from 'vue';

import AllocatorAlertsSection from './AllocatorAlertsSection.vue';
import AllocatorScenarioSection from './AllocatorScenarioSection.vue';
import AllocatorSessionSimulationSection from './AllocatorSessionSimulationSection.vue';
import AllocatorStaticSummarySection from './AllocatorStaticSummarySection.vue';

const props = defineProps(['loading', 'error', 'report', 'filterText']);

const selectedScenarioId = ref('');
const scenarioFilter = computed(() => String(props.filterText || '').trim().toLocaleLowerCase());

const SCENARIO_LABEL_MAP = {
  'prod-default': '默认分配',
  'recent-dedup-window': '最近事件去重',
  'temper-heart-used': '心之钢已生效',
  'brave-act-locked': '勇敢举动受限'
};

function sanitizeAllocatorText(value) {
  return String(value || '')
    .replaceAll('默认生产分配', '默认分配')
    .replaceAll('基线场景', '当前场景')
    .replaceAll('最近事件去重窗口', '最近事件去重')
    .replaceAll('去重窗口', '最近避让')
    .replaceAll('命中最近事件去重窗口', '命中最近避让')
    .replaceAll('生产', '')
    .replace(/\s{2,}/g, ' ')
    .trim();
}

function getScenarioDisplayLabel(scenario) {
  return SCENARIO_LABEL_MAP[scenario?.id] || sanitizeAllocatorText(scenario?.label);
}

function decorateScenario(scenario) {
  if (!scenario) {
    return null;
  }
  return {
    ...scenario,
    displayLabel: getScenarioDisplayLabel(scenario),
    displayDescription: sanitizeAllocatorText(scenario.description),
    selectedTypeSummary: sanitizeAllocatorText(scenario.selectedTypeSummary),
    candidatePoolSummary: sanitizeAllocatorText(scenario.candidatePoolSummary),
    transitionSummary: sanitizeAllocatorText(scenario.transitionSummary),
    filteredSummary: sanitizeAllocatorText(scenario.filteredSummary),
    categoryTransitions: scenario.categoryTransitions.map((transition) => ({
      ...transition,
      sourceLabel: sanitizeAllocatorText(transition.sourceLabel)
    })),
    candidatePool: {
      ...scenario.candidatePool,
      filtered: scenario.candidatePool.filtered.map((item) => ({
        ...item,
        reasonLabels: item.reasonLabels.map((label) => sanitizeAllocatorText(label)),
        reasonSummary: sanitizeAllocatorText(item.reasonSummary)
      }))
    }
  };
}

const filteredAlerts = computed(() => {
  const alerts = props.report?.alerts ?? [];
  const decoratedAlerts = alerts.map((alert) => ({
    ...alert,
    title: sanitizeAllocatorText(alert.title),
    summary: sanitizeAllocatorText(alert.summary),
    evidence: sanitizeAllocatorText(alert.evidence)
  }));
  if (!scenarioFilter.value) {
    return decoratedAlerts;
  }
  return decoratedAlerts.filter((alert) =>
    [alert.title, alert.summary, alert.evidence].join('|').toLocaleLowerCase().includes(scenarioFilter.value)
  );
});

const filteredScenarios = computed(() => {
  const scenarios = props.report?.scenarios ?? [];
  const decoratedScenarios = scenarios.map((scenario) => decorateScenario(scenario));
  if (!scenarioFilter.value) {
    return decoratedScenarios;
  }
  return decoratedScenarios.filter((scenario) =>
    [scenario.searchText, scenario.displayLabel, scenario.displayDescription].join('|').toLocaleLowerCase().includes(scenarioFilter.value)
  );
});

const activeScenario = computed(
  () => filteredScenarios.value.find((scenario) => scenario.id === selectedScenarioId.value) || filteredScenarios.value[0] || null
);

const activeSessionSimulation = computed(() => {
  const simulations = props.report?.sessionSimulation?.scenarios ?? [];
  const baselineScenarioId = props.report?.sessionSimulation?.baselineScenarioId ?? '';
  const active =
    simulations.find((scenario) => scenario.id === selectedScenarioId.value) ||
    simulations.find((scenario) => scenario.id === baselineScenarioId) ||
    simulations[0] ||
    null;
  if (!active) {
    return null;
  }
  return {
    ...active,
    displayLabel: getScenarioDisplayLabel(active)
  };
});

const metaPills = computed(() => {
  if (!props.report) {
    return [];
  }
  return [
    {
      label: '最近避让',
      value: `${props.report.meta.recentDedupCount} 个事件`,
      note: '最近抽取不会重复'
    },
    {
      label: '权重上限',
      value: String(props.report.meta.eventWeight),
      note: '单轮接受上限'
    },
    {
      label: '预置场景',
      value: `${props.report.meta.scenarioCount} 个`,
      note: '用于对比差异'
    },
    {
      label: '延续风险',
      value: props.report.alerts.some((alert) => alert.id === 'category-roll-persists') ? '存在' : '无',
      note: '下一轮仍可能受影响'
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
      <p class="allocator-subtitle">事件分布与候选概览。</p>
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
