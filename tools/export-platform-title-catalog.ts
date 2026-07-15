import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

type TitleSource = {
  meta: { sourceLabel: string };
  titles: Array<{ key: string; label: string; category: string; condition: string; availability: string }>;
  players: Array<{ name: string; allTitles?: boolean; titleKeys?: string[] }>;
  mapTitles: Array<{ mapKey: string; mapLabel: string; holders: Record<string, string[]> }>;
};

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, "..");
export async function exportPlatformTitleCatalog(output: string, requestedGameVersion?: string) {
  const source = JSON.parse(await fs.readFile(path.join(root, "data/title-source.json"), "utf8")) as TitleSource;
  const env = await fs.readFile(path.join(root, "src/env/env.opy"), "utf8");
  const version = env.match(/^#!define\s+VERSION\s+"([^"]+)"/m)?.[1];
  if (!version) throw new Error("Unable to parse Bastion VERSION");
  const gameVersion = requestedGameVersion ?? version;
  const mapSourceFiles = await Promise.all((await fs.readdir(path.join(root, "src/map")))
    .filter((file) => file.endsWith(".opy"))
    .map(async (file) => [file, await fs.readFile(path.join(root, "src/map", file), "utf8")] as const));

const titleKeys = new Set(source.titles.map((title) => title.key));
const mapSlots = new Set(["PIONEER", "CONQUEROR", "DOMINATOR"]);
const titleScope = (key: string) => mapSlots.has(key) ? "map" : "global";
const displayKind = (key: string) => key === "PIONEER" ? "map_pioneer" : key === "CONQUEROR" || key === "DOMINATOR" ? "map_name_suffix" : "fixed";
const mapId = (mapKey: string) => `map.${mapKey.replace(/^DATA_/, "").toLocaleLowerCase()}`;

const maps = source.mapTitles.map((entry) => {
  const matching = mapSourceFiles.find(([, content]) => content.includes(`DATA_${entry.mapKey.replace(/^DATA_/, "")}`));
  if (!matching) throw new Error(`Unable to find map source for ${entry.mapKey}`);
  const prefixes = [...matching[1].matchAll(/__currentMapPioneerText___\s*=\s*"([^"]+)"/g)].map((match) => match[1]);
  const pioneerPrefixes = [...new Set(prefixes.length ? prefixes : [entry.mapLabel])];
  const rewards = Object.entries(entry.holders).map(([slot, holderNames]) => {
    if (!mapSlots.has(slot)) throw new Error(`Unsupported map title slot ${slot}`);
    const titleKey = slot;
    if (!titleKeys.has(titleKey)) throw new Error(`Unknown map title key ${titleKey}`);
    return { slot: slot.toLocaleLowerCase(), titleKey, holderNames };
  });
  const conquerors = new Set(entry.holders.CONQUEROR ?? []);
  for (const holder of entry.holders.DOMINATOR ?? []) {
    if (!conquerors.has(holder)) throw new Error(`${entry.mapKey}: DOMINATOR holder is not a CONQUEROR holder: ${holder}`);
  }
  return { mapId: mapId(entry.mapKey), mapKey: entry.mapKey, mapName: entry.mapLabel, gameVersion, status: "active", pioneerPrefixes, rewards };
});

const globalGrants = source.players.flatMap((player) => {
  const titleKeysForPlayer = player.allTitles ? [...titleKeys] : player.titleKeys ?? [];
  return titleKeysForPlayer.filter((titleKey) => !mapSlots.has(titleKey)).map((titleKey) => ({ holderName: player.name, titleKey, scope: "global" as const }));
});

const snapshot = {
  schemaVersion: 1,
  sourceLabel: source.meta.sourceLabel,
  sourceVersion: version,
  gameVersion,
  titles: source.titles.map((title) => ({ ...title, scope: titleScope(title.key), displayKind: displayKind(title.key) })),
  maps,
  globalGrants,
};

  await fs.mkdir(path.dirname(path.resolve(output)), { recursive: true });
  await fs.writeFile(path.resolve(output), `${JSON.stringify(snapshot, null, 2)}\n`);
  console.log(`Exported ${snapshot.titles.length} titles and ${snapshot.maps.length} maps to ${output}`);
}

if (process.argv[1]?.endsWith("export-platform-title-catalog.ts")) {
  const output = process.argv[2];
  if (!output) throw new Error("Usage: pnpm run tools -- export:platform-title-catalog <output> [gameVersion]");
  exportPlatformTitleCatalog(output, process.argv[3]).catch((error) => {
    console.error(error instanceof Error ? error.message : String(error));
    process.exitCode = 1;
  });
}
