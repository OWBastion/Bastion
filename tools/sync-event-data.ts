import {
  PLATFORM_DATA_CONTRACT_VERSION,
  assertUnique,
  requireNumber,
  requireString,
  type JsonObject,
  type PlatformData,
  EVENT_CATEGORIES,
  PLATFORM_EVENT_CATEGORIES,
  EVENT_STATUSES
} from './platform-data-client.ts';

export type EventType = 'buff' | 'debuff' | 'mech';

export type EventMacros = { id: string | number; duration: string; weight: string };

export type EventEntry = { key: string; type: EventType; platformId: string; macros: EventMacros };

export function collectEventEntries(catalogSource: string): Array<{ key: string; type: EventType }> {
  const entries = new Map<string, { key: string; type: EventType }>();
  const pattern = /eventCatalogType\[\s*EventId\.([A-Z0-9_]+)\s*\]\s*=\s*EventType\.(BUFF|DEBUFF|MECH)/g;
  for (const match of catalogSource.matchAll(pattern)) {
    entries.set(match[1], { key: match[1], type: match[2].toLowerCase() as EventType });
  }
  return [...entries.values()];
}

export function validateAndMergeEvents(
  platformData: PlatformData,
  platformIds: Record<string, string>,
  challengeIds: Set<string>,
  eventEntries: Array<{ key: string; type: EventType }>
) {
  const remoteById = new Map<string, JsonObject>();
  const mappedPlatformIds = new Set(Object.values(platformIds));
  for (const [index, item] of platformData.events.entries()) {
    const prefix = `events[${index}]`;
    const id = requireString(item.eventId, `${prefix}.eventId`);
    if (remoteById.has(id)) throw new Error(`Duplicate platform event ID: ${id}`);
    remoteById.set(id, item);
    requireString(item.name, `${prefix}.name`);
    requireString(item.description, `${prefix}.description`);
    if (!PLATFORM_EVENT_CATEGORIES.has(item.category)) throw new Error(`${prefix}.category has an unsupported value`);
    if (!EVENT_STATUSES.has(item.releaseStatus)) throw new Error(`${prefix}.releaseStatus has an unsupported value`);
    if (typeof item.archived !== 'boolean') throw new Error(`${prefix}.archived must be a boolean`);
    if (item.durationSeconds !== null && (requireNumber(item.durationSeconds, `${prefix}.durationSeconds`) < 0)) throw new Error(`${prefix}.durationSeconds must be non-negative`);
    if (item.weight !== null && (requireNumber(item.weight, `${prefix}.weight`) < 0)) throw new Error(`${prefix}.weight must be non-negative`);
    if (!Array.isArray(item.challenges)) throw new Error(`${prefix}.challenges must be an array`);
    for (const challenge of item.challenges) {
      const challengeId = requireString(challenge.challengeId, `${prefix}.challengeId`);
      if (!challengeIds.has(challengeId)) throw new Error(`${prefix} references unknown challenge ${challengeId}`);
    }
    if (mappedPlatformIds.has(id) && !EVENT_CATEGORIES.has(item.category)) {
      throw new Error(`${prefix}.category cannot be mapped to a Bastion event`);
    }
  }

  const mappedIds = Object.entries(platformIds);
  assertUnique(mappedIds.map(([, id]) => requireString(id, 'platform event ID')), 'platform event ID mapping');
  for (const [key, platformId] of mappedIds) {
    const local = eventEntries.find((item) => item.key === key);
    if (!local) throw new Error(`Platform event mapping references unknown Bastion event ${key}`);
    const remote = remoteById.get(platformId);
    if (!remote) throw new Error(`Bastion event ${key} is missing from platform event data: ${platformId}`);
    const expectedType = EVENT_CATEGORIES.get(remote.category);
    if (expectedType !== local.type) throw new Error(`Event ${key} category does not match Bastion type ${local.type}`);
  }
  for (const entry of eventEntries) {
    const platformId = platformIds[entry.key];
    if (!platformId) throw new Error(`Bastion event ${entry.key} is missing a platform event mapping`);
  }
  return eventEntries.map((entry) => ({
    ...entry,
    platformId: platformIds[entry.key]
  }));
}

export function replaceOverPyDefine(source: string, name: string, value: string | number): string {
  const pattern = new RegExp(`^#!define\\s+${name.replace(/[.*+?^${}()|[\\]\\]/g, '\\$&')}\\s+.*$`, 'm');
  if (!pattern.test(source)) throw new Error(`Unable to find OverPy define ${name}`);
  return source.replace(pattern, `#!define ${name} ${typeof value === 'number' ? value : JSON.stringify(value)}`);
}

export function resolveEventMacros(eventKey: string, eventType: string, catalogSource: string) {
  const type = eventType.toUpperCase();
  const escapedKey = eventKey.replace(/[.*+?^${}()|[\\]\\]/g, '\\$&');
  const titlePattern = new RegExp(
    `eventName\\[\\s*EventId\\.${escapedKey}\\s*\\]\\s*=\\s*STR_EVT_${type}_(\\d+)_TITLE`
  );
  const durationPattern = new RegExp(
    `eventDuration\\[\\s*EventId\\.${escapedKey}\\s*\\]\\s*=\\s*(EVT_[A-Z0-9_]+)`
  );
  const weightPattern = new RegExp(
    `eventCatalogWeight\\[\\s*EventId\\.${escapedKey}\\s*\\]\\s*=\\s*(EVT_[A-Z0-9_]+)`
  );
  const id = catalogSource.match(titlePattern)?.[1];
  const duration = catalogSource.match(durationPattern)?.[1];
  const weight = catalogSource.match(weightPattern)?.[1];
  if (!id || !duration || !weight) throw new Error(`Unable to resolve OverPy macros for ${eventType}:${eventKey}`);
  return { id, duration, weight };
}

export function mergePlatformEventOverPyData({
  platformData,
  eventEntries,
  constantsSource,
  localeSource
}: {
  platformData: PlatformData;
  eventEntries: EventEntry[];
  constantsSource: string;
  localeSource: string;
}) {
  const remoteById = new Map(platformData.events.map((item) => [requireString(item.eventId, 'eventId'), item]));
  let nextConstantsSource = constantsSource;
  let nextLocaleSource = localeSource;
  for (const eventItem of eventEntries) {
    const remote = remoteById.get(eventItem.platformId);
    if (!remote) throw new Error(`Bastion event ${eventItem.key} is missing from platform event data: ${eventItem.platformId}`);
    const type = eventItem.type.toUpperCase();
    const titleName = `STR_EVT_${type}_${eventItem.macros.id}_TITLE`;
    if (remote.durationSeconds !== null) {
      nextConstantsSource = replaceOverPyDefine(nextConstantsSource, eventItem.macros.duration, requireNumber(remote.durationSeconds, `${eventItem.key}.durationSeconds`));
    }
    if (remote.weight !== null) {
      nextConstantsSource = replaceOverPyDefine(nextConstantsSource, eventItem.macros.weight, requireNumber(remote.weight, `${eventItem.key}.weight`));
    }
    nextLocaleSource = replaceOverPyDefine(nextLocaleSource, titleName, requireString(remote.name, `${eventItem.key}.name`));
  }
  return { constantsSource: nextConstantsSource, localeSource: nextLocaleSource };
}

export function parseDefineNumber(source: string, name: string): number {
  const match = source.match(new RegExp(`^#!define\\s+${name.replace(/[.*+?^${}()|[\\]\\]/g, '\\\\$&')}\\s+(-?(?:\\d+\\.?\\d*|\\.\\d+))\\s*$`, 'm'));
  if (!match) throw new Error(`Unable to find numeric OverPy define ${name}`);
  return Number(match[1]);
}

export function renderEventManifest(eventEntries: EventEntry[], constantsSource: string, mainVersion: string): string {
  const counts = {
    buff: eventEntries.filter((item) => item.type === 'buff').length,
    debuff: eventEntries.filter((item) => item.type === 'debuff').length,
    mech: eventEntries.filter((item) => item.type === 'mech').length
  };
  const activeWeightSum = Number(
    eventEntries.reduce((sum, item) => sum + parseDefineNumber(constantsSource, item.macros.weight), 0).toFixed(3)
  );
  return [
    '#!mainFile "../main.opy"',
    '',
    '# Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.',
    '#!optimizeStrict',
    '',
    '# BEGIN AUTO-GENERATED EVENT MANIFEST',
    '# Source: OWBastion Agents API',
    '#!define EVENT_MANIFEST_SOURCE_LABEL "OWBastion Agents API"',
    `#!define EVENT_MANIFEST_SOURCE_VERSION "contract-${PLATFORM_DATA_CONTRACT_VERSION}"`,
    `#!define EVENT_MANIFEST_MAIN_VERSION "${mainVersion}"`,
    `#!define EVENT_MANIFEST_TOTAL_EVENTS ${eventEntries.length}`,
    `#!define EVENT_MANIFEST_ACTIVE_EVENTS ${eventEntries.length}`,
    `#!define EVENT_MANIFEST_TOTAL_BUFF_COUNT ${counts.buff}`,
    `#!define EVENT_MANIFEST_TOTAL_DEBUFF_COUNT ${counts.debuff}`,
    `#!define EVENT_MANIFEST_TOTAL_MECH_COUNT ${counts.mech}`,
    `#!define EVENT_MANIFEST_ACTIVE_BUFF_COUNT ${counts.buff}`,
    `#!define EVENT_MANIFEST_ACTIVE_DEBUFF_COUNT ${counts.debuff}`,
    `#!define EVENT_MANIFEST_ACTIVE_MECH_COUNT ${counts.mech}`,
    `#!define EVENT_MANIFEST_ACTIVE_WEIGHT_SUM ${activeWeightSum}`,
    '# END AUTO-GENERATED EVENT MANIFEST',
    ''
  ].join('\n');
}
