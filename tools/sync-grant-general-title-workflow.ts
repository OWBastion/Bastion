import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { loadTitleSource, RESTRICTED_GENERAL_TITLE_KEYS } from './grant-player-title.ts';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const WORKFLOW_FILE = path.resolve(__dirname, '../.github/workflows/grant-general-title.yml');

const PLAYER_OPTIONS_BEGIN = '# BEGIN AUTO-GENERATED PLAYER OPTIONS';
const PLAYER_OPTIONS_END = '# END AUTO-GENERATED PLAYER OPTIONS';
const TITLE_OPTIONS_BEGIN = '# BEGIN AUTO-GENERATED GENERAL TITLE OPTIONS';
const TITLE_OPTIONS_END = '# END AUTO-GENERATED GENERAL TITLE OPTIONS';

function yamlSingleQuote(value: string) {
  return `'${String(value).replace(/'/g, "''")}'`;
}

function unquoteYaml(value: string) {
  const raw = String(value).trim();
  if (raw.startsWith("'") && raw.endsWith("'")) {
    return raw.slice(1, -1).replace(/''/g, "'");
  }
  return raw;
}

function replaceManagedOptions(text: string, beginMarker: string, endMarker: string, options: string[]) {
  const lines = text.split('\n');
  const beginIndex = lines.findIndex((line) => line.includes(beginMarker));
  const endIndex = lines.findIndex((line, index) => index > beginIndex && line.includes(endMarker));

  if (beginIndex < 0 || endIndex < 0 || endIndex <= beginIndex) {
    throw new Error(`Managed option block not found: ${beginMarker} ... ${endMarker}`);
  }

  const indent = lines[beginIndex].match(/^(\s*)/)?.[1] ?? '';
  const generated = options.map((option) => `${indent}- ${yamlSingleQuote(option)}`);

  return [...lines.slice(0, beginIndex + 1), ...generated, ...lines.slice(endIndex)].join('\n');
}

function extractManagedOptions(text: string, beginMarker: string, endMarker: string) {
  const lines = text.split('\n');
  const beginIndex = lines.findIndex((line) => line.includes(beginMarker));
  const endIndex = lines.findIndex((line, index) => index > beginIndex && line.includes(endMarker));

  if (beginIndex < 0 || endIndex < 0 || endIndex <= beginIndex) {
    throw new Error(`Managed option block not found: ${beginMarker} ... ${endMarker}`);
  }

  return lines
    .slice(beginIndex + 1, endIndex)
    .map((line) => line.trim())
    .filter((line) => line.startsWith('- '))
    .map((line) => unquoteYaml(line.slice(2)));
}

export function getGrantGeneralTitleWorkflowOptions(sourceData: Awaited<ReturnType<typeof loadTitleSource>>) {
  const restrictedKeySet = new Set(RESTRICTED_GENERAL_TITLE_KEYS);

  const playerOptions = sourceData.players.map((player) => player.name);
  const generalTitleOptions = sourceData.titles
    .filter((title) => title.availability === 'active' && !restrictedKeySet.has(title.key))
    .map((title) => title.label);

  return { playerOptions, generalTitleOptions };
}

export async function syncGrantGeneralTitleWorkflow({ workflowFile = WORKFLOW_FILE } = {}) {
  const sourceData = await loadTitleSource();
  const { playerOptions, generalTitleOptions } = getGrantGeneralTitleWorkflowOptions(sourceData);

  const beforeText = await fs.readFile(workflowFile, 'utf8');
  const withPlayerOptions = replaceManagedOptions(beforeText, PLAYER_OPTIONS_BEGIN, PLAYER_OPTIONS_END, playerOptions);
  const afterText = replaceManagedOptions(withPlayerOptions, TITLE_OPTIONS_BEGIN, TITLE_OPTIONS_END, generalTitleOptions);

  const changed = beforeText !== afterText;
  if (changed) {
    await fs.writeFile(workflowFile, afterText, 'utf8');
  }

  return {
    changed,
    workflowFile,
    counts: {
      players: playerOptions.length,
      generalTitles: generalTitleOptions.length
    }
  };
}

export async function readGrantGeneralTitleWorkflowOptions({ workflowFile = WORKFLOW_FILE } = {}) {
  const text = await fs.readFile(workflowFile, 'utf8');

  return {
    playerOptions: extractManagedOptions(text, PLAYER_OPTIONS_BEGIN, PLAYER_OPTIONS_END),
    generalTitleOptions: extractManagedOptions(text, TITLE_OPTIONS_BEGIN, TITLE_OPTIONS_END)
  };
}

const invokedPath = process.argv[1] ? path.resolve(process.argv[1]) : null;

export async function main() {
  const result = await syncGrantGeneralTitleWorkflow();
  console.log(
    `Synced grant-general-title workflow options: ${result.counts.players} players, ${result.counts.generalTitles} general titles`
  );
}

if (invokedPath === __filename) {
  main().catch((error) => {
    const message = error instanceof Error ? error.message : String(error);
    console.error(message);
    process.exitCode = 1;
  });
}
