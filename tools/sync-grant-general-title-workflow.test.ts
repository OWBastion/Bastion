import test from 'node:test';
import assert from 'node:assert/strict';

import { loadTitleSource, RESTRICTED_GENERAL_TITLE_KEYS } from './grant-player-title.ts';
import {
  getGrantGeneralTitleWorkflowOptions,
  readGrantGeneralTitleWorkflowOptions,
  syncGrantGeneralTitleWorkflow
} from './sync-grant-general-title-workflow.ts';

test('grant-general-title workflow options match title-source derived options', async () => {
  await syncGrantGeneralTitleWorkflow();

  const sourceData = await loadTitleSource();
  const expected = getGrantGeneralTitleWorkflowOptions(sourceData);
  const actual = await readGrantGeneralTitleWorkflowOptions();

  assert.deepEqual(actual.playerOptions, expected.playerOptions);
  assert.deepEqual(actual.generalTitleOptions, expected.generalTitleOptions);
});

test('grant-general-title workflow only includes active and non-restricted general titles', async () => {
  const sourceData = await loadTitleSource();
  const restrictedKeySet = new Set(RESTRICTED_GENERAL_TITLE_KEYS);
  const titleByLabel = new Map(sourceData.titles.map((title) => [title.label, title]));
  const { generalTitleOptions } = await readGrantGeneralTitleWorkflowOptions();

  for (const label of generalTitleOptions) {
    const title = titleByLabel.get(label);
    assert.ok(title, `Unknown title label in workflow options: ${label}`);
    assert.equal(title.availability, 'active', `Non-active title leaked into workflow options: ${label}`);
    assert.equal(restrictedKeySet.has(title.key), false, `Restricted title leaked into workflow options: ${title.key}`);
  }
});

test('grant-general-title workflow only includes known players from title-source', async () => {
  const sourceData = await loadTitleSource();
  const knownPlayers = new Set(sourceData.players.map((player) => player.name));
  const { playerOptions } = await readGrantGeneralTitleWorkflowOptions();

  for (const playerName of playerOptions) {
    assert.equal(knownPlayers.has(playerName), true, `Unknown player in workflow options: ${playerName}`);
  }
});
