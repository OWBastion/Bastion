import { createHash } from "node:crypto";
import { execFile } from "node:child_process";
import { promisify } from "node:util";
import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const execFileAsync = promisify(execFile);
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const args = process.argv.slice(2);
const valueAfter = (flag: string) => { const index = args.indexOf(flag); return index === -1 ? undefined : args[index + 1]; };

export type Item = { contentType: "event" | "map" | "title" | "challenge"; contentId: string; operation: "upsert" | "retire" | "delete"; data: Record<string, unknown> };
export type Snapshot = { schemaVersion: 1; candidateId: string; baseReleaseId: string | null; sourceVersion: string; generatedAt: number; items: Item[]; snapshotHash: string };

const readJson = async <T>(file: string) => JSON.parse(await fs.readFile(file, "utf8")) as T;
const stable = (value: unknown): unknown => Array.isArray(value) ? value.map(stable) : value && typeof value === "object" ? Object.fromEntries(Object.entries(value).sort(([left], [right]) => left.localeCompare(right)).map(([key, item]) => [key, stable(item)])) : value;
const snapshotHash = (snapshot: Omit<Snapshot, "snapshotHash">) => createHash("sha256").update(JSON.stringify(stable(snapshot))).digest("hex");
const loadCandidate = async () => {
  const candidatePath = valueAfter("--candidate");
  if (candidatePath) {
    const value = await readJson<any>(path.resolve(candidatePath));
    return (value.snapshot ?? value) as Snapshot;
  }
  const url = valueAfter("--url");
  const token = valueAfter("--token") ?? process.env.BASTION_BUILD_TOKEN;
  if (!url || !token) throw new Error("Usage: pnpm run build:platform-candidate -- --candidate <file> or --url <url> --token <token>");
  const response = await fetch(url, { headers: { authorization: `Bearer ${token}`, accept: "application/json" } });
  if (!response.ok) throw new Error(`Candidate fetch failed: ${response.status}`);
  const value = await response.json() as { snapshot?: Snapshot };
  if (!value.snapshot) throw new Error("Candidate response does not contain snapshot");
  return value.snapshot;
};

export const validateCandidate = async (snapshot: Snapshot) => {
  if (snapshot.schemaVersion !== 1 || !snapshot.candidateId || !/^[a-f0-9]{64}$/.test(snapshot.snapshotHash)) throw new Error("Unsupported or invalid candidate snapshot");
  const computedHash = snapshotHash({ ...snapshot, snapshotHash: undefined });
  if (computedHash !== snapshot.snapshotHash) throw new Error(`Candidate snapshot hash mismatch: expected ${snapshot.snapshotHash}, computed ${computedHash}`);
  const [titleSource, eventSource] = await Promise.all([
    readJson<{ titles: Array<{ key: string }> }>(path.join(root, "data/title-source.json")),
    readJson<{ events: Array<{ key: string }> }>(path.join(root, "data/event-source.json")),
  ]);
  const titles = new Set(titleSource.titles.map((item) => item.key));
  const events = new Set(eventSource.events.map((item) => item.key));
  const maps = new Set((await fs.readdir(path.join(root, "src/map"))).filter((file) => file.endsWith(".opy")).map((file) => `map.${file.slice(0, -4)}`));
  const unknown: string[] = [];
  for (const item of snapshot.items) {
    const known = item.contentType === "event" ? events.has(item.contentId.replace(/^event\./, ""))
      : item.contentType === "title" ? titles.has(item.contentId.replace(/^title\./, ""))
        : item.contentType === "map" ? maps.has(item.contentId)
          : item.contentId.startsWith("title.") ? titles.has(item.contentId.slice("title.".length))
            : item.contentId.startsWith("map.") ? maps.has(item.contentId)
              : false;
    if (!known) unknown.push(`${item.contentType}:${item.contentId}`);
  }
  if (unknown.length) throw new Error(`Candidate references unknown Bastion IDs: ${unknown.join(", ")}`);
  return snapshot;
};

const main = async () => {
  const snapshot = await loadCandidate();
  await validateCandidate(snapshot);
  const output = path.resolve(valueAfter("--output") ?? "build/platform-candidate");
  await fs.mkdir(output, { recursive: true });
  await fs.writeFile(path.join(output, "candidate.json"), `${JSON.stringify(snapshot, null, 2)}\n`);
  if (!args.includes("--skip-build")) {
    for (const command of ["build:main", "build:dev", "build:release"]) await execFileAsync("pnpm", ["run", command], { cwd: root, maxBuffer: 20 * 1024 * 1024 });
  }
  const manifest = { schemaVersion: 1, candidateId: snapshot.candidateId, sourceVersion: snapshot.sourceVersion, snapshotHash: snapshot.snapshotHash, checkedAt: new Date().toISOString(), bastionCommitSha: process.env.SOURCE_COMMIT_SHA ?? process.env.GITHUB_SHA ?? "local", artifacts: ["build/main.ow", "build/devMain.ow", "build/en-US.ow", "build/zh-CN.ow"] };
  await fs.writeFile(path.join(output, "manifest.json"), `${JSON.stringify(manifest, null, 2)}\n`);
  console.log(JSON.stringify(manifest, null, 2));
};

if (process.argv[1]?.endsWith("build-platform-candidate.ts")) main().catch((error) => {
  console.error(error instanceof Error ? error.message : String(error));
  process.exitCode = 1;
});
