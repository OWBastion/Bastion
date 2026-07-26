# Title Change Templates

## 1) 新增称号（真源 JSON）

仅在 `data/title-source.json -> titles` 末尾追加，保持既有顺序。

```json
{
  "key": "NEW_TITLE_NAME",
  "label": "新称号文案",
  "category": "活动限定",
  "condition": "达成条件描述",
  "availability": "active",
  "displayExpr": "\"新称号文案\"",
  "colorExpr": "heroColor[12]"
}
```

## 2) 玩家授予（真源 JSON）

```json
{
  "name": "玩家名",
  "titleKeys": ["CHALLENGER_LEGEND", "NEW_TITLE_NAME"]
}
```

规则：新增玩家只允许追加到 `players` 末尾。

## 3) 地图奖励（真源 JSON）

```json
{
  "mapKey": "DATA_MAP_NAME",
  "mapLabel": "地图名",
  "holders": {
    "PIONEER": ["A"],
    "CONQUEROR": ["A", "B"],
    "DOMINATOR": ["A"]
  }
}
```

规则：`DOMINATOR` 必须是 `CONQUEROR` 子集。

## 4) 验证命令

```bash
pnpm run sync:title-data
pnpm run test:title-data-sync
rg -n 'AUTO-GENERATED TITLE ENUM|AUTO-GENERATED TITLE PLAYER DATABASE|AUTO-GENERATED MAP_TITLE_DATA|AUTO-GENERATED ALL_TITLE|DATA_' src/title/title-cn.opy
rg -n '"key":|"titleKeys":|"mapTitles":|"holders":' data/title-source.json
```

## 5) 失败排查

1. 生成产物差异：仅修 `data/title-source.json`，再同步。
2. include 校验失败：只恢复缺失 include，不重排入口顺序。
