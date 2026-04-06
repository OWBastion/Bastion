import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawn } from 'node:child_process';
import { syncEventData } from './sync-event-data.ts';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const repoRoot = path.resolve(__dirname, '..');

function runNodeTest() {
  return new Promise((resolve, reject) => {
    const child = spawn(process.execPath, ['--import', 'tsx', '--test', 'tools/sync-event-data.test.ts'], {
      cwd: repoRoot,
      stdio: 'inherit'
    });

    child.on('error', reject);
    child.on('exit', (code) => {
      if (code === 0) {
        resolve();
        return;
      }
      reject(new Error(`node --import tsx --test tools/sync-event-data.test.ts failed with exit code ${code}`));
    });
  });
}

export async function finalizeEventData() {
  try {
    const { webPayload } = await syncEventData();
    await runNodeTest();
    console.log(
      `event:finalize ok | total=${webPayload.meta.totalCount} active=${webPayload.meta.activeCount} source=${webPayload.meta.sourceVersion}`
    );
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    process.exitCode = 1;
  }
}

finalizeEventData().catch((error) => {
  console.error(error instanceof Error ? error.message : String(error));
  process.exitCode = 1;
});
