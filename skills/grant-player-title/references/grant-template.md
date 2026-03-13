# Grant Template

## 1) 批量输入模板（四段）

```md
玩家:
- <PLAYER_A>
- <PLAYER_B>

通用称号:
- <PLAYER_A>: [TITLE.<TITLE_KEY_1>, <title alias or label>]
- <PLAYER_B>: [<TITLE_KEY_2>]

地图主宰:
- <PLAYER_A>: [<DATA_MAP_KEY_OR_MAP_LABEL>]
- <PLAYER_B>: [<DATA_MAP_KEY_OR_MAP_LABEL>]

派生策略:
- grantDifficultyFromMaps: <true|false>
- autoMasteryMode: <off|check_only|grant>
```

默认值：

1. `grantDifficultyFromMaps: false`
2. `autoMasteryMode: check_only`

## 2) JSON 请求模板（给 `grant:title`）

```json
{
  "players": [
    {
      "name": "<PLAYER_A>",
      "generalTitles": ["TITLE.<TITLE_KEY_1>", "what can i say"],
      "mapDominators": ["66号公路", "DATA_VOLSKAYA"]
    }
  ],
  "options": {
    "grantDifficultyFromMaps": false,
    "autoMasteryMode": "check_only"
  }
}
```

规则：

1. `DOMINATOR` 发放会自动补同图 `CONQUEROR`。
2. 玩家不存在会自动追加到 `players` 末尾。
3. 生成产物只通过同步脚本更新，禁止手改。

## 3) 标准命令

```bash
pnpm run grant:title -- --input <request.json> --dry-run
pnpm run grant:title -- --input <request.json>
pnpm run grant:title -- --interactive --dry-run
pnpm run grant:title -- --interactive
pnpm run sync:title-data
pnpm run test:title-grant
pnpm run test:title-data-sync
```

交互模式输入示例：

1. 对象类型：`player` / `map`
2. `player`：`玩家名称` + `通用称号(逗号分隔)` + `地图主宰(逗号分隔)`
3. `map`：`地图(mapKey/中文名)` + `玩家列表(逗号分隔)`
4. 派生策略：`grantDifficultyFromMaps` 与 `autoMasteryMode`
5. 预览后确认写入

## 4) 结果校验

```bash
rg -n 'AUTO-GENERATED TITLE ENUM|AUTO-GENERATED TITLE PLAYER DATABASE|AUTO-GENERATED MAP_TITLE_DATA|AUTO-GENERATED ALL_TITLE' src/title/title-cn.opy
rg -n '"players"|"titleKeys"|"mapTitles"|"holders"|"sourceFile"' data/title-source.json web/title-query/public/data/titles.json
```

## 5) 失败排查

1. 玩家未生效：检查 `players[*].name` 是否精确匹配。
2. 地图槽位异常：检查 `mapKey` 与槽位名 `PIONEER/CONQUEROR/DOMINATOR`。
3. 子集约束失败：先补 `CONQUEROR` 再重跑。
4. 同步后不一致：回到 `data/title-source.json` 修复后重跑，不手改生成产物。
