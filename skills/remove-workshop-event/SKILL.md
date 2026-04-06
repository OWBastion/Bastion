---
name: remove-workshop-event
description: 为 Bastion Overwatch Workshop 项目执行随机事件移除/下线（默认 hard-delete 物理删除）。Use when user asks to remove or retire a Buff/Debuff/Mech event, including triggers such as “移除事件”, “下线事件”, “删除 Buff/Debuff/Mech 事件”, or “retire event”. Covers enum/constants/locales/config/effects/event-source synchronization with strict validation gates.
---

# Remove Workshop Event

按最小改动执行；不做无关重排。
默认策略固定为“彻底物理删除（hard-delete）”。

## 1) 触发条件

满足任一条件时使用：

1. 用户要求移除/下线某个 Buff / Debuff / Mech 事件。
2. 用户要求 retire event，且未显式要求保留 retired 条目。
3. 需要清理已废弃事件的枚举、配置、规则和数据引用。

## 2) 默认策略（唯一流程）

按固定顺序删除，禁止跳步：

1. 枚举：从 `src/constants/event_ids_*.opy` 删除目标枚举项（其余顺序保持不变，不重排）。
2. 常量：从 `src/constants/event_constants.opy` 删除目标 `EVT_*` 常量块。
3. 本地化：从 `src/locales/zh-CN.opy` 与 `src/locales/en-US.opy` 删除目标 `STR_EVT_*` 键。
4. 配置：从 `src/config/eventConfig.opy` 与 `src/config/eventConfigDev.opy` 删除目标事件注册、append、dev setting。
5. 效果：从 `src/events/effects/*Effects.opy` 删除目标 include；默认删除对应 effect 文件（若用户明确要求保留文件，再改为清空并标注停用原因）。
6. 数据：从 `data/event-source.json` 删除目标事件条目（不是改 `retired`）。

## 3) 禁止项

1. 不修改与目标事件无关的其他事件。
2. 不做自动重排、重构或额外优化。
3. 不新增占位事件或兼容性垫片。
4. 不跳过验证命令。

## 4) 失败处理规则

当 `pnpm run sync:event-data`、`pnpm run build:*` 或测试失败时：

1. 仅修复与本次目标事件删除直接相关的残留引用。
2. 不引入范围外变更（例如 unrelated 事件重命名、批量格式化、结构重写）。

## 5) 必跑验证

至少执行并通过：

1. `pnpm run build:main`
2. `pnpm run build:dev`
3. `./tools/check_locale_keys.sh`
4. `pnpm run sync:event-data`
5. `pnpm run test:event-data-sync`

## 6) 结果自检

1. `rg` 检索目标 KEY/ID/STR/EVT/include/config append 残留为 0。
2. `event-source.json` 不再包含目标事件条目。
3. 生成产物（event manifest / query data）与源码一致。

详细检查命令模板见 [references/remove-template.md](references/remove-template.md)。
