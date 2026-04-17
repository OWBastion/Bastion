import { Command } from 'commander';
import { spawn } from 'node:child_process';

function runNode(args: string[]) {
  return new Promise<void>((resolve, reject) => {
    const child = spawn(process.execPath, args, { stdio: 'inherit' });

    child.on('error', reject);
    child.on('exit', (code) => {
      if (code === 0) {
        resolve();
        return;
      }
      reject(new Error(`Command failed: node ${args.join(' ')} (exit ${code ?? 'null'})`));
    });
  });
}

async function runSyncTitleData() {
  const { syncTitleData } = await import('./sync-title-data.ts');
  const { webPayload } = await syncTitleData();
  console.log(
    `Synced ${webPayload.meta.playerCount} players, ${webPayload.meta.titleCount} titles and ${webPayload.meta.mapTitleCount} map title sets from data/title-source.json`
  );
}

async function runSyncEventData() {
  const { syncEventData } = await import('./sync-event-data.ts');
  const { webPayload } = await syncEventData();
  console.log(`Synced ${webPayload.meta.totalCount} events from data/event-source.json`);
}

async function runSyncEffectGlossaryData() {
  const { syncEffectGlossaryData } = await import('./sync-effect-glossary.ts');
  const payload = await syncEffectGlossaryData();
  console.log(`Synced ${payload.meta.totalTermCount} glossary terms from data/effect-glossary-source.json`);
}

async function runEventFinalize() {
  const { finalizeEventData } = await import('./finalize-event-data.ts');
  await finalizeEventData();
}

async function runGrantTitle(rawArgs: string[]) {
  const { main } = await import('./grant-player-title.ts');
  await main(rawArgs);
}

async function runPerfScan(rawArgs: string[]) {
  const { main } = await import('./perf-loop-scan.ts');
  await main(rawArgs);
}

async function runBumpEnvVersion() {
  await runNode(['--import', 'tsx', 'tools/bump-env-version.ts']);
}

async function runNodeTest(testFile: string) {
  await runNode(['--import', 'tsx', '--test', testFile]);
}

function wrapAction(action: () => Promise<void>) {
  return async () => {
    try {
      await action();
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      console.error(message);
      process.exitCode = 1;
    }
  };
}

const program = new Command();

program
  .name('bastion-tools')
  .description('Bastion toolchain unified CLI')
  .showHelpAfterError('(Use --help for usage)');

program.command('sync:title-data').description('Sync title source data').action(wrapAction(runSyncTitleData));
program.command('sync:event-data').description('Sync event source data').action(wrapAction(runSyncEventData));
program.command('sync:effect-glossary').description('Sync effect glossary data').action(wrapAction(runSyncEffectGlossaryData));
program.command('event:finalize').description('Sync event data then run event sync tests').action(wrapAction(runEventFinalize));
program
  .command('grant:title [args...]')
  .description('Grant title via existing grant-player-title CLI arguments')
  .allowUnknownOption(true);
program
  .command('perf:scan [args...]')
  .description('Run performance loop scan with passthrough options/targets')
  .allowUnknownOption(true);
program.command('bump:env-version').description('Bump env version in src/env/env.opy').action(wrapAction(runBumpEnvVersion));
program
  .command('test:title-data-sync')
  .description('Run title data sync tests')
  .action(wrapAction(() => runNodeTest('tools/generate-title-query-data.test.ts')));
program
  .command('test:event-data-sync')
  .description('Run event data sync tests')
  .action(wrapAction(() => runNodeTest('tools/sync-event-data.test.ts')));
program
  .command('test:effect-glossary-sync')
  .description('Run effect glossary sync tests')
  .action(wrapAction(() => runNodeTest('tools/sync-effect-glossary.test.ts')));
program
  .command('test:title-grant')
  .description('Run title grant tests')
  .action(wrapAction(() => runNodeTest('tools/grant-player-title.test.ts')));

const normalizedArgv =
  process.argv[2] === '--'
    ? [process.argv[0], process.argv[1], ...process.argv.slice(3)]
    : process.argv;

async function runPassthroughIfRequested(argv: string[]) {
  const commandName = argv[2];
  if (commandName === 'grant:title') {
    await runGrantTitle(argv.slice(3));
    return true;
  }
  if (commandName === 'perf:scan') {
    await runPerfScan(argv.slice(3));
    return true;
  }
  return false;
}

Promise.resolve()
  .then(async () => {
    if (await runPassthroughIfRequested(normalizedArgv)) {
      return;
    }
    await program.parseAsync(normalizedArgv);
  })
  .catch((error) => {
    const message = error instanceof Error ? error.message : String(error);
    console.error(message);
    process.exitCode = 1;
  });
