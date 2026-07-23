import { createHash } from "node:crypto";
import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const sha256 = (value: string) => createHash("sha256").update(value).digest("hex");
const readJson = async <T>(file: string) => JSON.parse(await fs.readFile(path.join(root, file), "utf8")) as T;

type TitleSource = { meta: Record<string, unknown>; titles: unknown[]; players: unknown[]; mapTitles: unknown[] };
type EventSource = { meta: Record<string, unknown>; packs: unknown[]; events: unknown[] };

const main = async () => {
  const output = path.resolve(process.argv[2] ?? "build/platform-snapshot");
  const [titles, events, glossary, env] = await Promise.all([
    readJson<TitleSource>("data/title-source.json"),
    readJson<EventSource>("data/event-source.json"),
    readJson<Record<string, unknown>>("data/effect-glossary-source.json"),
    fs.readFile(path.join(root, "src/env/env.opy"), "utf8"),
  ]);
  const gameVersion = env.match(/^#!define\s+VERSION\s+"([^"]+)"/m)?.[1];
  if (!gameVersion) throw new Error("Unable to parse Bastion VERSION");
  const sourceCommitSha = process.env.SOURCE_COMMIT_SHA ?? process.env.GITHUB_SHA ?? "local";
  const files: Record<string, string> = {};
  const payloads: Record<string, unknown> = {
    "titles.json": { schemaVersion: 1, gameVersion, source: titles },
    "events.json": { schemaVersion: 1, gameVersion, source: events },
    "maps.json": { schemaVersion: 1, gameVersion, maps: titles.mapTitles },
    "challenges.json": { schemaVersion: 1, gameVersion, challenges: titles.titles.filter((item: any) => item && item.availability === "active") },
    "glossary.json": { schemaVersion: 1, gameVersion, source: glossary },
    "allocator.json": { schemaVersion: 1, gameVersion, source: "Bastion allocator" },
  };
  await fs.mkdir(output, { recursive: true });
  for (const [file, value] of Object.entries(payloads)) {
    const content = `${JSON.stringify(value, null, 2)}\n`;
    await fs.writeFile(path.join(output, file), content);
    files[file] = sha256(content);
  }
  const manifest = { schemaVersion: 1, gameVersion, sourceCommitSha, generatedAt: new Date().toISOString(), files };
  await fs.writeFile(path.join(output, "manifest.json"), `${JSON.stringify(manifest, null, 2)}\n`);
  console.log(JSON.stringify({ output, ...manifest }, null, 2));
};

main().catch((error) => {
  console.error(error instanceof Error ? error.message : String(error));
  process.exitCode = 1;
});
