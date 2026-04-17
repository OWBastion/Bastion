import fs from 'node:fs/promises';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';

const DEFAULT_TARGETS = ['src'];
const SOURCE_EXTENSIONS = new Set(['.opy']);
const LOOP_WAIT_WINDOW = 10;
const __filename = fileURLToPath(import.meta.url);

function isFlag(value) {
  return value.startsWith('--');
}

function parseArgs(argv) {
  let strict = false;
  const targets = [];

  for (const arg of argv) {
    if (arg === '--strict') {
      strict = true;
      continue;
    }
    if (isFlag(arg)) {
      throw new Error(`Unknown option: ${arg}`);
    }
    targets.push(arg);
  }

  return {
    strict,
    targets: targets.length > 0 ? targets : DEFAULT_TARGETS
  };
}

async function pathExists(targetPath) {
  try {
    await fs.access(targetPath);
    return true;
  } catch {
    return false;
  }
}

async function collectFiles(targetPath, files, warnings) {
  const resolved = path.resolve(process.cwd(), targetPath);
  const exists = await pathExists(resolved);
  if (!exists) {
    warnings.push(`Missing scan target: ${targetPath}`);
    return;
  }

  const stat = await fs.stat(resolved);
  if (stat.isDirectory()) {
    const entries = await fs.readdir(resolved, { withFileTypes: true });
    for (const entry of entries) {
      const nested = path.join(resolved, entry.name);
      if (entry.isDirectory()) {
        await collectFiles(nested, files, warnings);
        continue;
      }
      if (SOURCE_EXTENSIONS.has(path.extname(entry.name))) {
        files.push(nested);
      }
    }
    return;
  }

  files.push(resolved);
}

function toRel(filePath) {
  return path.relative(process.cwd(), filePath) || '.';
}

function makeFinding(filePath, line, type, detail, severity = 'MEDIUM') {
  return {
    file: toRel(filePath),
    line,
    type,
    detail,
    severity
  };
}

function isComment(line) {
  return line.trimStart().startsWith('#');
}

function hasNearbyWait(lines, index) {
  const start = Math.max(0, index - LOOP_WAIT_WINDOW);
  const end = Math.min(lines.length - 1, index + LOOP_WAIT_WINDOW);
  for (let i = start; i <= end; i += 1) {
    if (isComment(lines[i])) {
      continue;
    }
    if (/\bwait\s*\(/.test(lines[i])) {
      return true;
    }
  }
  return false;
}

function getRuleBlocks(lines) {
  const blocks = [];
  let active = null;

  for (let i = 0; i < lines.length; i += 1) {
    if (/^\s*rule\s+["'`]/.test(lines[i])) {
      if (active) {
        active.end = i - 1;
        blocks.push(active);
      }
      active = {
        start: i,
        end: lines.length - 1,
        lines: []
      };
    }
    if (active) {
      active.lines.push({ lineNo: i + 1, text: lines[i] });
    }
  }

  if (active) {
    blocks.push(active);
  }

  return blocks;
}

function scanRuleBlock(filePath, block) {
  const findings = [];
  const eventLine = block.lines.find((item) => /@Event\s+(eachPlayer|global)\b/.test(item.text));
  if (!eventLine) {
    return findings;
  }
  const eventMatch = eventLine.text.match(/@Event\s+(eachPlayer|global)\b/);
  const eventType = eventMatch ? eventMatch[1] : 'unknown';

  const conditionLines = block.lines.filter((item) => /@Condition\b/.test(item.text) && !isComment(item.text));
  if (conditionLines.length < 2) {
    return findings;
  }

  const cheapPattern =
    /(isAlive\(|hasSpawned\(|isMoving\(|isInSpawnRoom\(|eventPlayer\s*!=\s*null|eventPlayer\s*==\s*null|entityExists\()/;
  const heavyPattern =
    /(distance\(|sorted\(|getLivingPlayers\(|getPlayersInRadius\(|getPlayersWithinRadius\(|\.filter\(|\.sorted\()/;

  let firstCheap = null;
  let firstHeavy = null;

  for (const condition of conditionLines) {
    if (firstCheap === null && cheapPattern.test(condition.text)) {
      firstCheap = condition;
    }
    if (firstHeavy === null && heavyPattern.test(condition.text)) {
      firstHeavy = condition;
    }
  }

  if (firstHeavy && firstCheap && firstHeavy.lineNo < firstCheap.lineNo) {
    findings.push(
      makeFinding(
        filePath,
        firstHeavy.lineNo,
        'ONGOING_GATING_ORDER',
        `Heavy condition appears before cheaper gate in @Event ${eventType}.`,
        'MEDIUM'
      )
    );
  }

  return findings;
}

function scanSource(filePath, content) {
  if (path.extname(filePath) !== '.opy') {
    return [];
  }

  const findings = [];
  const lines = content.split(/\r?\n/);

  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i];
    if (isComment(line)) {
      continue;
    }

    if (/\bloop\s*\(/.test(line) && !hasNearbyWait(lines, i)) {
      findings.push(
        makeFinding(filePath, i + 1, 'WAITLESS_LOOP_RISK', 'Found loop(...) without nearby wait(...) throttle.', 'HIGH')
      );
    }

    if (/\bwhile\s+.+:/.test(line) && !hasNearbyWait(lines, i)) {
      findings.push(
        makeFinding(filePath, i + 1, 'WAITLESS_WHILE_RISK', 'Found while-loop without nearby wait(...) throttle.', 'HIGH')
      );
    }

    if (/\bdistance\s*\(/.test(line)) {
      findings.push(makeFinding(filePath, i + 1, 'HOTSPOT_DISTANCE', 'distance(...) call in rule flow.', 'LOW'));
    }
    if (/\bsorted\s*\(/.test(line)) {
      findings.push(makeFinding(filePath, i + 1, 'HOTSPOT_SORTED', 'sorted(...) call in rule flow.', 'LOW'));
    }
    if (/\bgetLivingPlayers\s*\(/.test(line)) {
      findings.push(
        makeFinding(filePath, i + 1, 'HOTSPOT_PLAYER_SCAN', 'getLivingPlayers(...) array scan in rule flow.', 'LOW')
      );
    }
    if (/\.(filter|sorted|map)\s*\(/.test(line) && /\.(filter|sorted)\s*\(/.test(line)) {
      findings.push(
        makeFinding(
          filePath,
          i + 1,
          'HOTSPOT_CHAINED_ARRAY_OPS',
          'Chained array operations detected; verify selectivity gating.',
          'LOW'
        )
      );
    }
  }

  const ruleBlocks = getRuleBlocks(lines);
  for (const block of ruleBlocks) {
    findings.push(...scanRuleBlock(filePath, block));
  }

  return findings;
}

function groupFindings(findings) {
  const risk = findings.filter((f) => f.severity === 'HIGH');
  const hotspots = findings.filter((f) => f.type.startsWith('HOTSPOT_'));
  const suggestions = findings.filter((f) => f.type === 'ONGOING_GATING_ORDER');
  return { risk, hotspots, suggestions };
}

function formatEntry(entry) {
  return `- [${entry.severity}] ${entry.type} ${entry.file}:${entry.line} -> ${entry.detail}`;
}

function printSection(title, entries) {
  console.log(`${title}:`);
  if (entries.length === 0) {
    console.log('- none');
    return;
  }
  for (const entry of entries) {
    console.log(formatEntry(entry));
  }
}

function printSummary(totalFiles, findings, strict) {
  const high = findings.filter((f) => f.severity === 'HIGH').length;
  const medium = findings.filter((f) => f.severity === 'MEDIUM').length;
  const low = findings.filter((f) => f.severity === 'LOW').length;
  console.log('Summary:');
  console.log(`- files scanned: ${totalFiles}`);
  console.log(`- findings: ${findings.length} (HIGH=${high}, MEDIUM=${medium}, LOW=${low})`);
  console.log(`- strict mode: ${strict ? 'on' : 'off'}`);
}

export async function main(argv = process.argv.slice(2)) {
  const { strict, targets } = parseArgs(argv);
  const files = [];
  const warnings = [];

  for (const target of targets) {
    await collectFiles(target, files, warnings);
  }

  const uniqueFiles = [...new Set(files)].sort();
  const findings = [];
  for (const filePath of uniqueFiles) {
    const content = await fs.readFile(filePath, 'utf8');
    findings.push(...scanSource(filePath, content));
  }

  const grouped = groupFindings(findings);

  console.log('Performance Loop Scan Report');
  console.log(`Targets: ${targets.join(', ')}`);
  if (warnings.length > 0) {
    console.log('Warnings:');
    for (const warning of warnings) {
      console.log(`- ${warning}`);
    }
  }
  printSection('Risk', grouped.risk);
  printSection('Hotspots', grouped.hotspots);
  printSection('Suggestions', grouped.suggestions);
  printSummary(uniqueFiles.length, findings, strict);

  if (strict && grouped.risk.length > 0) {
    process.exitCode = 1;
  }
}

const invokedPath = process.argv[1] ? path.resolve(process.argv[1]) : null;

if (invokedPath === __filename) {
  main().catch((error) => {
    console.error(error.message);
    process.exitCode = 1;
  });
}
