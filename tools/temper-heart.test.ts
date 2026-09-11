import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const read = (file: string) => readFile(new URL(`../${file}`, import.meta.url), 'utf8');

test('Temper Heart retries after DRAWN and only completion consumes it', async () => {
  const pool = await read('src/events/allocation/buildCandidatePool.opy');
  assert.match(pool, /if eventPlayer\.playerOnceEventState != null and len\(eventPlayer\.playerOnceEventState\) > PlayerOnceEventSlot\.TEMPER_HEART and eventPlayer\.playerOnceEventState\[PlayerOnceEventSlot\.TEMPER_HEART\] == TemperHeartState\.COMPLETED:\n        eventPlayer\.eventTempIndex\.remove\(BuffEventId\.TEMPER_HEART\)/);
  assert.doesNotMatch(pool, /TEMPER_HEART\].*!= TemperHeartState\.NONE/);
});

test('Temper Heart completion upgrades future Heartsteel gains without multiplying existing stacks', async () => {
  const [effect, mainConfig, devConfig, en, zh] = await Promise.all([
    read('src/events/effects/buff/temper_heart.opy'),
    read('src/config/eventConfig.opy'),
    read('src/config/eventConfigDev.opy'),
    read('src/locales/en-US.opy'),
    read('src/locales/zh-CN.opy')
  ]);

  assert.doesNotMatch(effect, /HeartSteelData\.STACKS\]\s*\*=/);
  assert.match(effect, /HeartSteelData\.GAIN_MULTIPLIER\] = EVT_31_STACK_MULTIPLIER/);
  assert.match(effect, /HeartSteelData\.PERCENT_PER_STACK\] = EVT_8_HP_PERCENT_PER_STACK \+ EVT_31_PERCENT_PER_STACK_BONUS/);
  assert.match(mainConfig, /STR_EVT_BUFF_31_DESC\.format\([^\n]*EVT_31_STACK_MULTIPLIER[^\n]*EVT_8_HP_PERCENT_PER_STACK[^\n]*\)/);
  assert.match(devConfig, /STR_EVT_BUFF_31_DESC\.format\([^\n]*EVT_31_STACK_MULTIPLIER[^\n]*EVT_8_HP_PERCENT_PER_STACK[^\n]*\)/);
  const enDescription = en.match(/^#!define STR_EVT_BUFF_31_DESC .*$/m)?.[0] ?? '';
  const zhDescription = zh.match(/^#!define STR_EVT_BUFF_31_DESC .*$/m)?.[0] ?? '';
  assert.doesNotMatch(enDescription, /Heartsteel stacks x/);
  assert.doesNotMatch(zhDescription, /心之钢层数×/);
});
