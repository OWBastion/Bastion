import fs from 'node:fs/promises';
import path from 'node:path';

import { buildEventAllocationReportData, DEFAULT_REPORT_OUTPUT_FILE } from './analyze-event-allocation.ts';

type SyncEventAllocationReportOptions = {
  outputFile?: string;
  sourceFile?: string;
  constantsFile?: string;
};

export async function syncEventAllocationReport(options: SyncEventAllocationReportOptions = {}) {
  const outputFile = options.outputFile ?? DEFAULT_REPORT_OUTPUT_FILE;
  const payload = await buildEventAllocationReportData({
    sourceFile: options.sourceFile,
    constantsFile: options.constantsFile
  });

  await fs.mkdir(path.dirname(outputFile), { recursive: true });
  await fs.writeFile(outputFile, `${JSON.stringify(payload, null, 2)}\n`, 'utf8');

  return {
    outputFile,
    payload
  };
}
