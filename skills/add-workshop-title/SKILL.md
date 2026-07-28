---
name: add-workshop-title
description: 为 Bastion Overwatch Workshop 项目复核平台称号同步生成结果（TITLE 枚举、allTitle 文本与颜色、玩家称号数据库、地图称号映射）的专用流程。Use when user asks to add a new title, assign a title to players, wire map title rewards, or update title-related docs while preserving platform sortOrder and stable player IDs.
---

# Add Workshop Title

按最小改动执行；禁止重排已有称号与玩家顺序。

## 1) 触发条件

满足任一条件时使用：

1. 新增通用称号。
2. 调整称号显示文案或颜色。
3. 将称号授予特定玩家。
4. 将称号接入地图奖励（`PIONEER/CONQUEROR/DOMINATOR`）。

## 2) 平台数据真源

唯一数据源是平台称号定义、玩家 active 授予和地图持有者 Agents API。

1. 称号顺序由平台 `sortOrder` 管理。
2. 玩家和地图持有者按稳定 `playerId` 关联，禁止按名称匹配。
3. 禁止手改生成产物：`src/title/title-cn.opy`。

关键约束：

1. `titleKey`、`sortOrder`、地图槽位和颜色语义必须唯一且合法。
2. `DOMINATOR` 必须是同图 `CONQUEROR` 的子集。
3. `color = null` 表示由 `title/init.opy` 彩虹逻辑接管。

## 3) 生成/同步

必跑：

```bash
pnpm run sync:platform-data
```

仅检查双入口 include，不重排顺序：

1. `src/main.opy`
2. `src/devMain.opy`

两者均需保留 `title/title-cn.opy` 与 `title/init.opy`。

## 4) 验证

执行 [references/title-template.md](references/title-template.md) 中的检查命令，至少确认：

1. 自动生成标记区块完整。
2. 平台数据按稳定 ID 校验，未发生名称匹配。
3. `sync:platform-data` 与 `test:platform-data-sync` 通过。

失败处理：

1. 若检测到生成产物与平台数据不一致，回到平台管理端修正后重新同步。
2. 若发现 `DOMINATOR` 不是 `CONQUEROR` 子集，先修 map holders 再重新同步。

## 5) 交付说明

回复时必须列明：

1. 新增/变更的称号 key。
2. 受影响玩家与地图奖励槽位。
3. 已执行的同步/验证命令及结果。
4. 若有未执行命令，给出原因与风险。
