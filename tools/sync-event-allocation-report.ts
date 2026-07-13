import fs from 'node:fs/promises';
import path from 'node:path';

import {
  buildEventAllocationReportData,
  DEFAULT_REPORT_OUTPUT_FILE,
  loadSharedAnalysisInputs
} from './analyze-event-allocation.ts';

type SyncEventAllocationReportOptions = {
  outputFile?: string;
  sourceFile?: string;
  constantsFile?: string;
  sharedInputs?: Awaited<ReturnType<typeof loadSharedAnalysisInputs>>;
};

export async function syncEventAllocationReport(options: SyncEventAllocationReportOptions = {}) {
  const outputFile = options.outputFile ?? DEFAULT_REPORT_OUTPUT_FILE;
  const payload = await buildEventAllocationReportData({
    sourceFile: options.sourceFile,
    constantsFile: options.constantsFile,
    sharedInputs: options.sharedInputs
  });

  await fs.mkdir(path.dirname(outputFile), { recursive: true });
  await fs.writeFile(outputFile, `${JSON.stringify(payload, null, 2)}\n`, 'utf8');

  return {
    outputFile,
    payload
  };
}
