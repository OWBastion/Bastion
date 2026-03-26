---
name: grant-player-title
description: 为 Bastion Overwatch Workshop 项目发放玩家称号的专用流程，支持通用称号与地图专属称号。Use when requests involve granting TITLE.* to players and map title rewards through data/title-source.json.
---

# Grant Player Title

目标：将发放流程固定为 `标准输入 -> 预检 -> 自动写入 -> 同步校验 -> 标准回执`，降低手工改 JSON 的重复成本。

## 1) 触发条件

满足任一条件时使用：

1. 给玩家发放通用称号。
2. 给玩家发放地图专属称号（`PIONEER/CONQUEROR/DOMINATOR`）。
3. 玩家不存在，需要补入称号数据库。

## 2) 固定 6 步流程

1. 解析请求：优先整理为 [references/grant-template.md](references/grant-template.md) 的四段结构。
2. 口径确认：只确认派生规则开关（默认值见下）。
3. 写入 source：仅改 `data/title-source.json`（批处理或交互二选一）。
4. 执行 `pnpm run grant:title`；该命令在非 `--dry-run` 且有变更时会自动同步 title 数据。
5. 测试：`pnpm run test:title-data-sync`，必要时再跑 `pnpm run test:title-grant`。
6. 回执：按“交付说明”输出新增玩家、称号和执行命令结果。

## 3) 真源与硬约束

唯一真源：`data/title-source.json`。

1. 玩家不存在时，只允许在 `players` 末尾追加。
2. 通用称号写入 `players[*].titleKeys`（去重、默认不移除历史）。
3. 地图称号写入 `mapTitles[*].holders` 对应槽位（去重）。
4. 禁止手改生成产物：`src/title/title-cn.opy`、`web/title-query/public/data/titles.json`。
5. `DOMINATOR` 高于 `CONQUEROR`：加入 `DOMINATOR` 时，必须确保同图同玩家已在 `CONQUEROR`。

## 4) 中文别名映射（高频）

地图：

1. `66号公路 -> DATA_ROUTE66`
2. `沃斯卡娅工业区 -> DATA_VOLSKAYA`
3. `月球基地 -> DATA_HORIZON_LUNAR_COLONY`

称号：

1. `what can i say -> MANBA`

## 5) 派生规则开关（默认）

1. `DOMINATOR => 同图补 CONQUEROR`：强制开启。
2. 难度挑战称号自动补发（`CHALLENGER_LEGEND/TRAVELER_HELL`）：默认 `OFF`，仅当用户显式提及时执行。
3. 地图精通自动补发（`ALL_IN_ONE/SKY`）：默认 `CHECK_ONLY`（只报告条件结果，不自动写入）。

## 6) 半自动工具接口

命令：

```bash
pnpm run grant:title -- --input <request.json> [--dry-run]
pnpm run grant:title -- --interactive [--dry-run]
```

输入结构：

```json
{
  "players": [
    {
      "name": "玩家名",
      "generalTitles": ["TITLE.HACKING", "what can i say"],
      "mapDominators": ["66号公路", "DATA_VOLSKAYA"]
    }
  ],
  "options": {
    "grantDifficultyFromMaps": false,
    "autoMasteryMode": "check_only"
  }
}
```

交互模式（纯选项菜单）：

1. 对象类型必须通过编号选择：`1) 玩家模式`、`2) 地图模式`。
2. `player` 模式：玩家通过编号选择；通用称号通过 `TITLE` 索引（0-based）多选，地图通过编号多选（可跳过）。
3. `map` 模式：地图通过编号单选；玩家通过编号多选。
4. 仅“新增玩家”分支允许输入玩家名称，并需二次确认。
5. 最后确认派生策略并预览摘要，确认后才写入。

说明：

1. `generalTitles` 支持 `TITLE.` 前缀、裸 key、中文 label、别名。
2. `mapDominators` 支持 mapKey、中文地图名、别名。
3. `--dry-run` 仅输出变更摘要，不落盘。

## 7) 验证

至少确认：

1. `pnpm run grant:title` 的 auto-sync 成功，或手动执行 `pnpm run sync:title-data` 成功。
2. `pnpm run test:title-data-sync` 通过。
3. 目标玩家、称号、地图槽位已同步到生成产物。
4. 自动生成区块标记完整。

## 8) 交付说明

回复时必须列明：

1. 新增玩家（如有）。
2. 每个玩家新增通用称号。
3. 每张地图新增专属称号（含槽位）。
4. 派生规则结果（是否补发难度挑战/地图精通，及依据）。
5. 已执行命令与结果。
