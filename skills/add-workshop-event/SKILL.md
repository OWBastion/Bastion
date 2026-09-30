---
name: add-workshop-event
description: 为 Bastion Overwatch Workshop 项目新增或调整随机事件（Buff/Debuff/Mech）的专用流程。Use when user asks to add a new event, change event type/category, register event constants, wire eventConfig/eventConfigDev, add or update zh-CN/en-US localization keys, and implement event behavior in effects rules while preserving main/devMain structure and server-load safety.
---

# Add Workshop Event

按最小改动执行；不做无关重排。

## 1) 触发条件

满足任一条件时使用：

1. 新增 Buff / Debuff / Mech 事件。
2. 变更事件常量、本地化、配置注册或效果规则。
3. 修复事件 ID 枚举与配置/规则映射不一致。

## 2) 必改真源

按固定顺序修改，禁止跳步：

1. `src/constants/event_ids.opy`：先加枚举，插入对应 `# ---- <Buff|Debuff|Mech> ----` 分节末尾、`COUNT` 之前。
2. `src/constants/event_constants.opy`：新增时长、权重与行为参数常量。
3. `src/locales/zh-CN.opy` 与 `src/locales/en-US.opy`：新增 TITLE/DESC 键。
4. `src/config/eventConfig.opy` 与 `src/config/eventConfigDev.opy`：注册事件并 append 对应 ID。
5. `src/events/effects/*.opy`：实现或更新效果规则。

Stop-rule：任一步校验失败，先修当前层，再进入下一层。

## 3) 生成/同步

事件改动通常无需额外生成脚本；需保证主线/开发配置同时更新并语义一致。

仅检查入口一致性，不重排 include：

1. `src/main.opy`
2. `src/devMain.opy`

## 4) 验证

执行 [references/event-template.md](references/event-template.md) 中的检查命令，至少确认：

1. 枚举项位于 `COUNT` 之前、对应类型分节内，且使用 `EventId.X` 枚举名而非裸数字 ID。
2. 两套 locale 均存在 title/desc 键，`format(...)` 占位符顺序匹配。
3. `eventConfig` 与 `eventConfigDev` 均已注册（含 `eventCatalogType` 类别写入与 `eventCatalogId.append`）。
4. 规则条件可检查项齐全：
- 派发仅含 `eventId == EventId.X` 单条件，不含 `eventType`。
- 默认条件区门控；动作区判断仅用于例外。
- 使用动作区判断时含显式 `wait(...)`。
- 收尾清理状态与效果实体。

失败处理：

1. 若枚举或配置映射断裂，回退到“枚举 -> 配置”层修复后再检规则。
2. 若规则缺少 `wait(...)` 或清理逻辑，禁止提交。

## 5) 交付说明

回复时必须列明：

1. 事件类型与枚举名。
2. 新增常量/本地化键/配置注册点。
3. 规则关键门控与收尾策略。
4. 已执行命令与结果。
