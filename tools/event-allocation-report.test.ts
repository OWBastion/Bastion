import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import {
  buildEventAllocationReportData,
  DEFAULT_REPORT_OUTPUT_FILE,
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

  assert.equal(report.meta.reportVersion, 'v2');
  assert.equal(report.staticSummary.length, 3);
  assert.ok(report.scenarios.length >= 4);
  assert.ok(report.alerts.length > 0);
  assert.ok(report.scenarios.some((scenario) => scenario.id === 'brave-act-locked'));
  assert.ok(report.staticSummary[0]?.topRows[0]?.eventNameZh);
  assert.ok(report.scenarios[0]?.selectedTypeSummary);
  assert.ok(report.scenarios[0]?.candidatePoolSummary);
  assert.ok(report.scenarios[0]?.filteredSummary);
  assert.ok(report.alerts.every((alert) => !/[Dd]elta|fallback|candidateKeys|selectedType/.test(`${alert.title}${alert.summary}${alert.evidence}`)));
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
  assert.equal(written.meta.reportVersion, 'v2');
  assert.ok(Array.isArray(written.staticSummary));
  assert.ok(Array.isArray(written.scenarios));
});

test('default report output stays under title-query public data', () => {
  assert.match(DEFAULT_REPORT_OUTPUT_FILE, /web\/title-query\/public\/data\/event-allocation-report\.json$/);
});
