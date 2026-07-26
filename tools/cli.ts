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

async function runSyncTitleData(options = {}) {
  const { syncTitleData } = await import('./sync-title-data.ts');
  const result = await syncTitleData(options);
  const { webPayload } = result;
  console.log(
    `Synced ${webPayload.meta.playerCount} players, ${webPayload.meta.titleCount} titles and ${webPayload.meta.mapTitleCount} map title sets from data/title-source.json`
  );
  return result;
}

async function runSyncPlatformData(options = {}) {
  const { syncPlatformData } = await import('./sync-platform-data.ts');
  await syncPlatformData({ baseUrl: options.url });
}

async function runSyncGrantGeneralTitleWorkflow(options = {}) {
  const { syncGrantGeneralTitleWorkflow } = await import('./sync-grant-general-title-workflow.ts');
  const result = await syncGrantGeneralTitleWorkflow(options);
  console.log(
    `Synced grant-general-title workflow options: ${result.counts.players} players and ${result.counts.generalTitles} general titles`
  );
}

async function runSyncAll() {
  const [titleResult] = await Promise.all([runSyncTitleData()]);
  await runSyncGrantGeneralTitleWorkflow({ sourceData: titleResult.sourceData });
}

async function runGrantTitle(rawArgs: string[]) {
  const { main } = await import('./grant-player-title.ts');
  await main(rawArgs);
}

async function runPerfScan(rawArgs: string[]) {
  const { main } = await import('./perf-loop-scan.ts');
  await main(rawArgs);
}

async function runEvent(rawArgs: string[]) {
  const { main } = await import('./event.ts');
  await main(rawArgs);
}

async function runBumpEnvVersion() {
  await runNode(['--import', 'tsx', 'tools/bump-env-version.ts']);
}

async function runExportPlatformTitleCatalog(rawArgs: string[]) {
  await runNode(['--import', 'tsx', 'tools/export-platform-title-catalog.ts', ...rawArgs]);
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

program.command('sync').description('Sync all source data and workflow options').action(wrapAction(runSyncAll));
program.command('sync:title-data').description('Sync title source data').action(wrapAction(runSyncTitleData));
program
  .command('sync:platform-data')
  .description('Pull current platform metadata, sync generated data, and compile OverPy entries')
  .option('--url <url>', 'Platform Agents API base URL')
  .action(wrapAction(runSyncPlatformData));
program
  .command('sync:grant-general-title-workflow')
  .description('Sync grant-general-title workflow options from data/title-source.json (legacy compat command)')
  .action(wrapAction(runSyncGrantGeneralTitleWorkflow));
program
  .command('grant:title [args...]')
  .description('Grant title via existing grant-player-title CLI arguments')
  .allowUnknownOption(true);
program
  .command('perf:scan [args...]')
  .description('Run performance loop scan with passthrough options/targets')
  .allowUnknownOption(true);
program
  .command('event:add [args...]')
  .description('Add event scaffold via spec JSON (single implementation entry)')
  .allowUnknownOption(true);
program
  .command('event:remove [args...]')
  .description('Remove event scaffold via spec JSON (single implementation entry)')
  .allowUnknownOption(true);
program.command('bump:env-version').description('Bump env version in src/env/env.opy').action(wrapAction(runBumpEnvVersion));
program
  .command('export:platform-title-catalog [args...]')
  .description('Export the Bastion title and map catalog for the platform')
  .allowUnknownOption(true);
program
  .command('test:title-data-sync')
  .description('Run title data sync tests')
  .action(wrapAction(() => runNodeTest('tools/sync-title-data.test.ts')));
program
  .command('test:platform-data-sync')
  .description('Run platform data sync and merge tests')
  .action(wrapAction(async () => {
    await runNodeTest('tools/platform-data-client.test.ts');
    await runNodeTest('tools/sync-platform-data.test.ts');
  }));
program
  .command('test:title-grant')
  .description('Run title grant tests')
  .action(wrapAction(() => runNodeTest('tools/grant-player-title.test.ts')));
program
  .command('test:grant-general-title-workflow')
  .description('Run grant-general-title workflow sync tests')
  .action(wrapAction(() => runNodeTest('tools/sync-grant-general-title-workflow.test.ts')));

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
  if (commandName === 'event:add' || commandName === 'event:remove') {
    await runEvent(argv.slice(3));
    return true;
  }
  if (commandName === 'export:platform-title-catalog') {
    await runExportPlatformTitleCatalog(argv.slice(3));
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
