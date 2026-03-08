# 02. 环境、常量与本地化

## `env/` 模块

### `env/env.opy`

- `DEBUG = false`
- 版本号示例：`VERSION = "26.0227.3"`

### `env/env_dev.opy`

- `DEBUG = true`
- 版本号示例：`VERSION = "26.dev"`

### `env/game.opy`

负责运行时初始化：

- workshop setting 读取（难度、重开时间、DLC 开关、调试开关等）
- `turnSpeedMultiplier`、`maxDeath` 等核心派生参数
- `heroList` 动态校验（与 `getAllHeroes()` 对齐）
- `phaseHero`（相位/位移技能检测分组）初始化
- 开发者名单、颜色表初始化

## `constants/` 模块

### `constants/player_constants.opy`

- 聚合大厅、模式、英雄比例类配置
- `devMain.opy` 已大量引用该层宏（如 `LOBBY_TEAM1_SLOTS`）

### `constants/event_constants.opy`

- 事件系统参数主表（千行级）
- 统一管理：持续时间、权重、阈值、半径、触发间隔、治疗/伤害系数
- 近期调优示例：`EVT_MECH_20_DMG_REDUCE_DIVISOR` 从 `40` 调整为 `25`，`EVT_MECH_20_SPEED_FACTOR` 从 `2` 调整为 `2.5`
- 命名模式：
  - `EVT_BUFF_x_*`
  - `EVT_DEBUFF_x_*`
  - `EVT_MECH_x_*`

建议：新增/调优事件优先在该文件做参数化，避免硬编码散落在 `events/effects/*.opy`。

### `constants/event_ids_*.opy`

- 使用 `BuffEventId` / `DebuffEventId` / `MechEventId` 枚举定义事件 ID
- 每个枚举末尾包含哨兵项 `COUNT`（仅用于计数，不参与事件注册）
- 同文件提供 `BUFF_EVENT_ID_COUNT` / `DEBUFF_EVENT_ID_COUNT` / `MECH_EVENT_ID_COUNT`（映射到各自 `*.COUNT`），用于按枚举总数动态校验事件池完整性（例如 `utilities/hashtag.opy`）

## `locales/` 模块

- `locales/zh-CN.opy`：中文主文本
- `locales/en-US.opy`：英文文本

覆盖内容：

- 模式描述、设置项、HUD 文案
- 事件标题与描述
- 系统提示（保存进度、重开警告、成就等）

## 称号数据源与生成链路

称号系统现采用“单一真源 + 受管生成”模式：

- 真源文件：`data/title-source.json`
- 同步脚本：`tools/sync-title-data.mjs`
- 生成目标：
  - `src/title/title-cn.opy` 的受管区块（`enum TITLE` / `player_database` / `allTitle`）
  - `web/title-query/public/data/titles.json`

`src/title/title-cn.opy` 中以下区块为自动生成，禁止手工直接维护：

- `# BEGIN/END AUTO-GENERATED TITLE ENUM`
- `# BEGIN/END AUTO-GENERATED TITLE PLAYER DATABASE`
- `# BEGIN/END AUTO-GENERATED ALL_TITLE`

地图称号映射同样由 `data/title-source.json` 的 `mapTitles` 维护，并由同步脚本自动生成到 `title-cn.opy`。

## 维护要点

- 参数改动优先改常量，不直接改效果规则体。
- 本地化 key 与配置/事件逻辑必须同名联动。
- 事件持续时间不写入 `locales` 文案；持续时间统一由 `constants/event_constants.opy` 管理。
- 事件文案中涉及动态数值时，优先使用占位符并由 `EVT_*` 常量通过 `.format()` 注入，避免把数值硬编码在文案里。
- 提交前运行 `tools/check_locale_keys.sh`，确保中英 key 对齐、无重复 key、配置引用 key 有定义。
- `env` 层的默认值变更会影响 main/dev 两入口行为，应同步验证。
- 发布前可执行 `pnpm run bump:env-version` 自动更新 `src/env/env.opy` 的 `VERSION`（`YY.MMDD.N`）。
- 称号相关改动后运行 `pnpm run sync:title-data` 与 `pnpm run test:title-data-sync`。
- `data/title-source.json` 中 `players` 顺序即索引语义；新增玩家只允许追加，禁止重排。
