import assert from "node:assert/strict";
import { createHash } from "node:crypto";
import { test } from "node:test";
import { validateCandidate, type Snapshot } from "./build-platform-candidate.ts";

const stable = (value: unknown): unknown => Array.isArray(value) ? value.map(stable) : value && typeof value === "object" ? Object.fromEntries(Object.entries(value).sort(([left], [right]) => left.localeCompare(right)).map(([key, item]) => [key, stable(item)])) : value;
const snapshot = (contentId: string): Snapshot => {
  const withoutHash = {
  schemaVersion: 1,
  candidateId: "candidate-test",
  baseReleaseId: null,
  sourceVersion: "candidate-test",
  generatedAt: 1,
  items: [{ contentType: "title", contentId, operation: "upsert", data: {} }],
  } as const;
  return { ...withoutHash, snapshotHash: createHash("sha256").update(JSON.stringify(stable(withoutHash))).digest("hex") };
};

test("accepts a title ID implemented by Bastion", async () => {
  await assert.doesNotReject(() => validateCandidate(snapshot("title.PIONEER")));
});

test("rejects a candidate with an unknown stable ID", async () => {
  await assert.rejects(() => validateCandidate(snapshot("title.DOES_NOT_EXIST")), /unknown Bastion IDs/);
});
