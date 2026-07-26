import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import {
  buildEventAllocationReportData,
  renderNonTtySummary,
  renderTuiFrame
} from './analyze-event-allocation.ts';
import { syncEventAllocationReport } from './sync-event-allocation-report.ts';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const sourceFile = path.resolve(__dirname, '../data/event-source.json');
const constantsFile = path.resolve(__dirname, '../src/constants/event_constants.opy');

test('builds shared html report data with alerts and preset scenarios', async () => {
  const report = await buildEventAllocationReportData({ sourceFile, constantsFile });

  assert.equal(report.meta.reportVersion, 'v3');
  assert.equal(report.staticSummary.length, 3);
  assert.ok(report.scenarios.length >= 3);
  assert.ok(report.alerts.length > 0);
  assert.equal(report.sessionSimulation.durationHours, 4);
  assert.equal(report.sessionSimulation.baselineScenarioId, 'prod-default');
  assert.ok(report.sessionSimulation.scenarios.length >= 3);
  assert.ok(report.sessionSimulation.scenarios[0]?.eventSummaries[0]?.eventNameZh);
  assert.ok(report.staticSummary[0]?.topRows[0]?.eventNameZh);
  assert.ok(report.scenarios[0]?.selectedTypeSummary);
  assert.ok(report.scenarios[0]?.candidatePoolSummary);
  assert.ok(report.scenarios[0]?.filteredSummary);
  const baselineScenario = report.sessionSimulation.scenarios.find((scenario) => scenario.id === 'prod-default');
  assert.ok(baselineScenario);
  assert.ok(baselineScenario!.estimatedCycleCount > 150);
  assert.ok(baselineScenario!.estimatedCycleCount < 300);
  assert.ok(
    baselineScenario!.eventSummaries.every(
      (item, index, rows) => index === 0 || rows[index - 1].atLeastOnceProbability >= item.atLeastOnceProbability
    )
  );
  assert.ok(report.alerts.every((alert) => !/[Dd]elta|fallback|candidateKeys|selectedType/.test(`${alert.title}${alert.summary}${alert.evidence}`)));
});

test('session simulation respects once-state scenario exclusions', async () => {
  const report = await buildEventAllocationReportData({ sourceFile, constantsFile });

  const temperHeartScenario = report.sessionSimulation.scenarios.find((scenario) => scenario.id === 'temper-heart-used');

  assert.ok(temperHeartScenario);
  assert.equal(temperHeartScenario!.eventSummaries.find((item) => item.key === 'TEMPER_HEART')?.atLeastOnceProbability, 0);
});

test('renders non-tty summary and tui frame headings', async () => {
  const report = await buildEventAllocationReportData({
    sourceFile,
    constantsFile,
    scenarioFiles: [path.resolve(__dirname, './event-allocation-scenarios/prod-default.json')]
  });

  const summary = renderNonTtySummary(report);
  assert.match(summary, /总览/);
  assert.match(summary, /场景浏览/);
  assert.match(summary, /4 小时长局模拟/);
  assert.doesNotMatch(summary, /Δ=|fb=|selectedType=|fallbackProbability|deltaProbability/);
  assert.match(summary, /会比按权重时更常出现|保底机制托上去/);

  const frame = renderTuiFrame(
    report,
    {
      pageIndex: 1,
      selectedScenarioIndex: 0,
      selectedStaticIndex: 1,
      selectedAlertIndex: 0,
      filterText: '',
      filterMode: false,
      activeScenarioId: report.scenarios[0]?.id ?? null
    },
    false
  );
  assert.match(frame, /静态对比/);
  assert.match(frame, /最容易被额外抬高的低权重事件/);
});

test('syncs html-data report payload to disk', async () => {
  const outputFile = path.join(os.tmpdir(), `event-allocation-report-${Date.now()}.json`);
  const result = await syncEventAllocationReport({
    outputFile,
    sourceFile,
    constantsFile
  });

  assert.ok(result.outputFile.endsWith('.json'));
  const written = JSON.parse(await fs.readFile(outputFile, 'utf8'));
  assert.equal(written.meta.reportVersion, 'v3');
  assert.ok(Array.isArray(written.staticSummary));
  assert.ok(Array.isArray(written.scenarios));
  assert.ok(Array.isArray(written.sessionSimulation?.scenarios));
});
