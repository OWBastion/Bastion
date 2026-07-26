---
name: add-workshop-title
description: 为 Bastion Overwatch Workshop 项目新增或调整称号（TITLE 枚举、allTitle 文本与颜色、玩家称号数据库、地图称号映射）的专用流程。Use when user asks to add a new title, assign a title to players, wire map title rewards, or update title-related docs while preserving enum/index stability via data/title-source.json.
---

# Add Workshop Title

按最小改动执行；禁止重排已有称号与玩家顺序。

## 1) 触发条件

满足任一条件时使用：

1. 新增通用称号。
2. 调整称号显示文案或颜色。
3. 将称号授予特定玩家。
4. 将称号接入地图奖励（`PIONEER/CONQUEROR/DOMINATOR`）。

## 2) 必改真源

唯一真源：`data/title-source.json`。

1. 新称号只允许追加到 `titles` 末尾。
2. 玩家不存在时只允许追加到 `players` 末尾。
3. 地图奖励只改对应 `mapTitles[*].holders`。
4. 禁止手改生成产物：`src/title/title-cn.opy`。

关键约束：

1. `key` 必须唯一。
2. `DOMINATOR` 必须是同图 `CONQUEROR` 的子集。
3. `colorExpr = null` 表示由 `title/init.opy` 彩虹逻辑接管。

## 3) 生成/同步

必跑：

```bash
pnpm run sync:title-data
```

仅检查双入口 include，不重排顺序：

1. `src/main.opy`
2. `src/devMain.opy`

两者均需保留 `title/title-cn.opy` 与 `title/init.opy`。

## 4) 验证

执行 [references/title-template.md](references/title-template.md) 中的检查命令，至少确认：

1. 自动生成标记区块完整。
2. `data/title-source.json` 未发生无关重排。
3. `sync:title-data` 与 `test:title-data-sync` 通过。

失败处理：

1. 若检测到生成产物与真源不一致，回到 `data/title-source.json` 修正后重新同步。
2. 若发现 `DOMINATOR` 不是 `CONQUEROR` 子集，先修 map holders 再重新同步。

## 5) 交付说明

回复时必须列明：

1. 新增/变更的称号 key。
2. 受影响玩家与地图奖励槽位。
3. 已执行的同步/验证命令及结果。
4. 若有未执行命令，给出原因与风险。
