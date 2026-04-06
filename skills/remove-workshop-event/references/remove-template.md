# Event Removal Template

按类型替换占位：`<TYPE_ENUM>`、`<KEY>`、`<ID>`、`<STR_PREFIX>`、`<EVT_PREFIX>`、`<EFFECT_FILE>`。

## 1) 删除清单模板（Hard-Delete）

1. 枚举
- 从 `src/constants/event_ids_*.opy` 删除 `<TYPE_ENUM>.<KEY>`。

2. 常量
- 从 `src/constants/event_constants.opy` 删除 `<EVT_PREFIX>_<ID>*` 相关常量。

3. 本地化
- 从 `src/locales/zh-CN.opy` 删除 `<STR_PREFIX>_<ID>_TITLE` / `<STR_PREFIX>_<ID>_DESC`。
- 从 `src/locales/en-US.opy` 删除 `<STR_PREFIX>_<ID>_TITLE` / `<STR_PREFIX>_<ID>_DESC`。

4. 配置
- 从 `src/config/eventConfig.opy` 删除注册与 `append(...)`。
- 从 `src/config/eventConfigDev.opy` 删除 setting 注册、事件注册与 `append(...)`。

5. 效果
- 从 `src/events/effects/*Effects.opy` 删除 `#!include "<EFFECT_FILE>"`。
- 默认删除 `src/events/effects/<type>/<EFFECT_FILE>` 文件本体。

6. 数据
- 从 `data/event-source.json` 删除 `"key": "<KEY>"` 对应条目。

## 2) 固定检索命令模板

```bash
rg -n '<KEY>|<TYPE_ENUM>\.|<STR_PREFIX>_<ID>|<EVT_PREFIX>_<ID>' src data web tools
rg -n '<EFFECT_FILE>|append\(|createWorkshopSettingBool' src/config src/events/effects
rg -n 'enum BuffEventId|enum DebuffEventId|enum MechEventId|COUNT' src/constants/event_ids_*.opy
```

## 3) 完成定义（DoD）

1. 目标事件残留引用为 0（按上面 `rg` 检查）。
2. `pnpm run build:main` 通过。
3. `pnpm run build:dev` 通过。
4. `./tools/check_locale_keys.sh` 通过。
5. `pnpm run sync:event-data` 通过。
6. `pnpm run test:event-data-sync` 通过。
7. `data/event-source.json` 不再含目标事件。
