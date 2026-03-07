---
name: grant-player-title
description: 为 Bastion Overwatch Workshop 项目发放玩家称号的专用流程，支持通用称号与地图专属称号。Use when requests involve granting TITLE.* to players, adding missing players into player_database and TITLE_PLAYER_NAMES, and updating map title datasets (DATA_* with PIONEER/CONQUEROR/DOMINATOR).
---

# Grant Player Title

按顺序执行，保持最小改动，避免无关重排。

## 1) 收集输入

1. 玩家名（一个或多个）
2. 通用称号列表（`TITLE.*`）
3. 地图专属称号列表：地图数据宏（`DATA_*`）+ 键位（`PIONEER`/`CONQUEROR`/`DOMINATOR`）

## 2) 读取并确认现状

1. 读取 `src/title/title-cn.opy`，确认 `TITLE` 枚举、`player_database`、`DATA_*` 宏。
2. 读取 `src/tools/playerNameToIndex.js` 与 `src/tools/playerNameToIndexDelimited.js`，确认 `TITLE_PLAYER_NAMES` 顺序。
3. 读取 `src/utilities/system/setPlayerTitle.opy`，确认地图称号合并逻辑：
   - `MapTITLEKey.PIONEER = 0`
   - `MapTITLEKey.CONQUEROR = 1`
   - `MapTITLEKey.DOMINATOR = 2`

## 3) 处理玩家不存在场景（必做）

1. 如果玩家名不在 `player_database`：
   - 在 `player_database` 末尾新增 `{ name: "...", titles: [...] }`。
   - 在两个 `TITLE_PLAYER_NAMES` 数组末尾新增同名条目，两个文件顺序必须完全一致。
2. 不重排既有玩家，不修改既有索引含义。
3. 新玩家默认 `titles` 放入本次请求中的通用称号；如果没有通用称号，使用空数组 `[]`。

## 4) 发放通用称号

1. 在 `player_database` 目标玩家的 `titles` 中追加请求称号。
2. 保持唯一性，避免重复 `TITLE.*`。
3. 不移除历史称号，除非用户明确要求。

## 5) 发放地图专属称号

1. 在 `src/title/title-cn.opy` 的对应 `DATA_<MAP>` 宏里更新对应索引列表：
   - 索引 `0` -> `PIONEER`
   - 索引 `1` -> `CONQUEROR`
   - 索引 `2` -> `DOMINATOR`
2. 使用 `playerNameToIndexDelimited([...], "-")` 维护玩家名列表。
3. 保持列表唯一；若玩家已存在则不重复添加。
4. 等级约束（必做）：
   - `DOMINATOR` 高于 `CONQUEROR`：当玩家被加入索引 `2`（`DOMINATOR`）时，必须确保同一玩家也在索引 `1`（`CONQUEROR`）。
   - 反向不成立：加入 `CONQUEROR` 时，不应自动加入 `DOMINATOR`，除非用户明确要求。

## 6) 同步 Web 查询页面数据（必做）

在修改 `src/title/title-cn.opy`（包括通用称号、玩家称号、地图称号）后，必须同步更新 web 查询页面数据：

```bash
pnpm run generate:title-query-data
```

并确认生成文件已更新：

```bash
git status --short web/title-query/public/data/titles.json
```

## 7) 校验

运行：

```bash
rg -n "name: \"<PLAYER>\"" src/title/title-cn.opy
rg -n "TITLE_PLAYER_NAMES" src/tools/playerNameToIndex.js src/tools/playerNameToIndexDelimited.js
rg -n "DATA_<MAP>|MapTITLEKey|setPlayerTitle" src/title/title-cn.opy src/utilities/system/setPlayerTitle.opy
rg -n "\"players\"|\"mapTitles\"|\"version\"" web/title-query/public/data/titles.json
```

再做人工校验：

1. 新增玩家是否同时出现在 `player_database` 与两个 `TITLE_PLAYER_NAMES`。
2. 两个 `TITLE_PLAYER_NAMES` 是否完全同序。
3. 地图专属称号是否落在正确的 `DATA_*` 索引位置。
4. 若本次新增了 `DOMINATOR`，对应玩家是否也已出现在同图的 `CONQUEROR` 列表中。
5. `web/title-query/public/data/titles.json` 是否已随本次称号改动同步更新。

## 8) 交付说明

回复时明确：

1. 新增了哪些玩家。
2. 每个玩家新增了哪些通用称号。
3. 每张地图新增了哪些地图专属称号（含 `PIONEER`/`CONQUEROR`/`DOMINATOR`）。
4. Web 查询页面数据是否已同步更新（`web/title-query/public/data/titles.json`）。
