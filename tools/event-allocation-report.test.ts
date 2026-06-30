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
});

test('renders non-tty summary and tui frame headings', async () => {
  const report = await buildEventAllocationReportData({
    sourceFile,
    constantsFile,
    scenarioFiles: [path.resolve(__dirname, './event-allocation-scenarios/prod-default.json')]
  });

  const summary = renderNonTtySummary(report);
  assert.match(summary, /Overview/);
  assert.match(summary, /Scenario Explorer/);

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
  assert.match(frame, /Static Comparison/);
  assert.match(frame, /Low-weight Uplift Rows/);
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
