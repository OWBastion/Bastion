import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const DEFAULT_ENV_FILE = path.resolve(__dirname, '../src/env/env.opy');
const ENV_FILE = process.env.BASTION_ENV_FILE
  ? path.resolve(process.cwd(), process.env.BASTION_ENV_FILE)
  : DEFAULT_ENV_FILE;

const VERSION_DEFINE_PATTERN = /^#!define\s+VERSION\s+"([^"]+)"\s*$/gm;
const VERSION_VALUE_PATTERN = /^(\d{2})\.(\d{4})\.(\d+)$/;

function getNow() {
  if (!process.env.BASTION_NOW) {
    return new Date();
  }

  const parsed = new Date(process.env.BASTION_NOW);
  if (Number.isNaN(parsed.getTime())) {
    throw new Error(`Invalid BASTION_NOW value: ${process.env.BASTION_NOW}`);
  }

  return parsed;
}

function pad2(value) {
  return String(value).padStart(2, '0');
}

function parseVersion(value) {
  const match = value.match(VERSION_VALUE_PATTERN);
  if (!match) {
    throw new Error(
      `Invalid VERSION format "${value}". Expected YY.MMDD.N in src/env/env.opy`
    );
  }

  return {
    yy: match[1],
    mmdd: match[2],
    count: Number.parseInt(match[3], 10)
  };
}

async function main() {
  const source = await fs.readFile(ENV_FILE, 'utf8');
  const matches = [...source.matchAll(VERSION_DEFINE_PATTERN)];

  if (matches.length !== 1) {
    throw new Error(
      `Expected exactly one VERSION definition in ${ENV_FILE}, found ${matches.length}`
    );
  }

  const currentVersion = matches[0][1];
  const current = parseVersion(currentVersion);
  const now = getNow();
  const today = {
    yy: pad2(now.getFullYear() % 100),
    mmdd: `${pad2(now.getMonth() + 1)}${pad2(now.getDate())}`
  };
  const sameDay = current.yy === today.yy && current.mmdd === today.mmdd;
  const nextCount = sameDay ? current.count + 1 : 1;
  const nextVersion = `${today.yy}.${today.mmdd}.${nextCount}`;

  const nextSource = source.replace(
    VERSION_DEFINE_PATTERN,
    `#!define VERSION "${nextVersion}"`
  );

  await fs.writeFile(ENV_FILE, nextSource, 'utf8');

  console.log(`Bumped VERSION: ${currentVersion} -> ${nextVersion}`);
}

main().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});
