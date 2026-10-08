# 02. 环境、常量与本地化

## `env/` 模块（构建 profile）

### `env/env.opy`

- `DEBUG = false`
- 版本号示例：`VERSION = "26.0227.3"`

### `env/env_dev.opy`

- `DEBUG = true`
- 版本号示例：`VERSION = "26.dev"`

## `session/` 模块（对局会话运行时 + 槽位注册表）

### `session/game.opy`

负责运行时初始化：

- workshop setting 读取（难度、重开时间、DLC 开关、调试开关等）
- `turnSpeedMultiplier`、`maxDeath` 等核心派生参数
- `heroList` 动态校验（与 `getAllHeroes()` 对齐）
- `phaseHero`（相位/位移技能检测分组）初始化
- 开发者名单、颜色表初始化
### `session/vars.opy` + `session/title-vars.opy`

跨文件交错的显式 `globalvar`/`playervar` 槽位注册表：vars 显式 global 至 108 / player 至 111，title-vars 插占 global 43–48 与 106–107、player 37–45，另有无编号自动分配声明。槽位编号是持久化/跨文件契约。

- 房间级 `masteryRunCode`：新局初始化为空；事件目录初始化完成时生成 `NNNN-NNNN-NNNN` 数字代码，其中 `round(事件目录总权重 * 100)` 的 4 位数字按固定位序分散在三段（第 1 段第 2-3 位、第 2 段第 3 位、第 3 段第 4 位），其余位随机、每段首位非零；玩家重生、换英雄和进度重置不会改写它；目录权重被开发菜单权重页修改时会置空并重新生成，生成同时维护未取整总账 `eventCatalogWeightTotal` 供 hashTag 超限校验

## `composition/mode_constants.opy`

- 组装期模式/大厅参数：`FULL_DESCRIPTION`、`LOBBY_*`、`PERK_*`、`RESPAWN_*`、`HEALTHPACK_*`、`SETTING_*`
- `devMain.opy` 已大量引用该层宏（如 `LOBBY_TEAM1_SLOTS`）
- `CLASSIC_MAP_VARIANT_*` 枚举属地图域，见 `map/classic_variants.opy`；`TEAM_*`/`BOSS_*` 参数随 `heroes/settings/team_rules.opy`

事件域常量（`events/event_constants.opy`、`events/event_ids.opy`、`events/event_manifest.opy`）见 [03-events-system.md](./03-events-system.md)。

## `locales/` 模块

- `locales/zh-CN.opy`：中文主文本
- `locales/en-US.opy`：英文文本

覆盖内容：

- 模式描述、设置项、HUD 文案
- 事件标题与描述
- 系统提示（保存进度、重开警告、成就等）

## 称号数据源与生成链路

称号系统现采用“平台 API 单一真源 + 受管生成”模式：

- 真源：平台称号定义、玩家 active 授予和地图持有者 Agents API
- 同步脚本：`tools/sync-platform-data.ts`
- 生成目标：
  - `src/title/title-cn.opy` 的受管区块（`enum TITLE` / `player_database` / `allTitle`）
  - `src/map/*.opy` 中每张地图的地图修订、空间配置和修订称号持有者受管区块

`src/title/title-cn.opy` 中以下区块为自动生成，禁止手工直接维护：

- `# BEGIN/END AUTO-GENERATED TITLE ENUM`
- `# BEGIN/END AUTO-GENERATED TITLE PLAYER DATABASE`
- `# BEGIN/END AUTO-GENERATED ALL_TITLE`

地图称号映射由平台地图称号持有者 API 返回，并由同步脚本按 `gameplayRevisionId` 校验；旧的默认地图称号区块继续生成到 `title-cn.opy`，revision 作用域的持有者表达式注入对应地图宏。

地图修订数据必须先通过默认/可选生命周期、空间坐标、控制点数组形状、挑战引用和持有者引用校验，之后才允许注入地图宏或进入 main/dev 编译。OverPy 在编译期展开地图宏；历史和准备中修订不会进入地图产物。

## 维护要点

- 参数改动优先改常量，不直接改效果规则体。
- 本地化 key 与配置/事件逻辑必须同名联动。
- 事件持续时间不写入 `locales` 文案；持续时间统一由 `events/event_constants.opy` 管理。
- 事件文案中涉及动态数值时，优先使用占位符并由 `EVT_*` 常量通过 `.format()` 注入，避免把数值硬编码在文案里。
- 提交前运行 `tools/check_locale_keys.sh`，确保中英 key 对齐、无重复 key、配置引用 key 有定义。
- `env` 层的默认值变更会影响 main/dev 两入口行为，应同步验证。
- 发布前可执行 `pnpm run tools -- bump:env-version` 自动更新 `src/env/env.opy` 的 `VERSION`（`YY.MMDD.N`）。
- 称号相关改动后运行 `pnpm run sync:platform-data` 与 `pnpm run tools -- test:platform-data-sync`。
- `TITLE` 数字 ID 按平台返回的稳定定义顺序生成；玩家和地图持有者按公开 `playerName` 关联（`playerId` 可缺省），OverPy 输出玩家显示名称。
