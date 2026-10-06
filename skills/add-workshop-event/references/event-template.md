# Event Template

按类型替换 `<TYPE>`（`BUFF|DEBUFF|MECH`）、`<ENUM_NAME>`、`<ID>`、`<PACK>`、`<PARAMS...>`。

## 1) 顺序模板（必须按序）

1. 枚举：`src/constants/event_ids.opy`（新增项插入对应 `# ---- <Buff|Debuff|Mech> ----` 分节末尾，必须在 `COUNT` 之前）
2. 常量：`src/constants/event_constants.opy`
3. 本地化：`src/locales/zh-CN.opy` + `src/locales/en-US.opy`
4. 配置：`src/config/eventCatalog.opy`（字段注册）+ `src/config/eventCatalogMain.opy` / `src/config/eventCatalogDev.opy`（入口顺序追加）
5. 规则：`src/events/effects/*.opy`

## 2) 核心片段

枚举：

```opy
enum EventId:
    ...
    # ---- <Buff|Debuff|Mech> ----
    # legacy numeric id: <ID>
    <ENUM_NAME>
    # sentinel only for integrity checks (do not register as an event)
    COUNT
```

配置：

```opy
    eventName[EventId.<ENUM_NAME>] = STR_EVT_<TYPE>_<ID>_TITLE
    eventDesc[EventId.<ENUM_NAME>] = STR_EVT_<TYPE>_<ID>_DESC.format(<PARAMS...>)
    eventDuration[EventId.<ENUM_NAME>] = EVT_<TYPE>_<ID>_DURATION
    eventCatalogWeight[EventId.<ENUM_NAME>] = EVT_<TYPE>_<ID>_WEIGHT
    eventCatalogType[EventId.<ENUM_NAME>] = EventType.<TYPE>
    eventCatalogId.append(EventId.<ENUM_NAME>)
```

规则条件（单 ID 派发，不带 eventType）：

```opy
@Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.<ENUM_NAME>]) == true
```

## 3) 验证命令

```bash
rg -n 'EventId\.<ENUM_NAME>|STR_EVT_(BUFF|DEBUFF|MECH)_<ID>|EVT_(BUFF|DEBUFF|MECH)_<ID>|eventType ==' src/config src/events src/locales src/constants
rg -n 'enum EventId|COUNT' src/constants/event_ids.opy
rg -n 'EventId\.<KEY>' src/config/eventCatalog*.opy
```

## 4) 可检查收尾清单

1. 规则派发仅含 `eventId == EventId.<ENUM_NAME>` 单条件，不出现 `eventType`。
2. 使用动作区判断时有显式 `wait(...)`。
3. 收尾重置玩家状态并清理事件效果。
