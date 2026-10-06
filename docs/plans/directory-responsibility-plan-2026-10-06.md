# 目录职责统一规划（#356）

审计基线：`origin/main@6b930ab`（#343–#348 已合入后的实际主线）。本文件是规划与迁移清单，不在本 Issue 执行搬迁；所有"建议位置"须经评审确认后才允许动文件。

## 0. 不可逾越的编译约束

任何目录调整都受以下约束，重排不等于行为保持：

1. **include 展开顺序**：规则发射顺序 = 文件在 `core.opy`/`composition/*` 中的 include 槽位顺序；跨域交错槽位（menu host/dev、player/lifecycle 交错）是真实顺序约束，不能按目录边界重排。
2. **变量槽位**：`env/vars.opy`（槽位 0–42）、`env/title-vars.opy`（43–45+）、`env/vars_dev_extra.opy`（dev 增量）构成全局 `globalvar`/`playervar` 索引表，带显式编号的槽位（如 `savedIndex 17`、`savedData 18`、`mapTitlePlayersByKey 43`）是持久化/跨文件契约，文件搬家不改变槽位语义，但拆分 vars 文件会拆散这张注册表。
3. **子程序索引**：子程序按声明顺序登记（`resetPlayerEventState` = 固定索引），include 槽位决定索引值。
4. **`#!mainFile`/`#!rulePrefix`/`#!define` 作用域**：`#!define` 按展开位置生效（必须早于使用点）；`#!mainFile` 是相对 IDE 提示路径，文件移动必须同步改写，否则漂移（现状已有 2 处指向不存在的 `dev_main.opy`）；`#!rulePrefix` 文件作用域。
5. **目录级 `#!include "constants/"`**：`bootstrap.opy` 隐式引入整个目录——向 `constants/` 增删文件即改变编译输入，比文件级 include 更不透明。

## 1. 最终目录职责表

| 目录 | 存放 | 不存放 | 合法消费者 | 处置 |
|---|---|---|---|---|
| `src/`（根） | 3 个 entry（`main`/`devMain`/`externalMain`）+ `core.opy` 有序组装表 | 业务规则、宏库 | entry：wright 编译入口、CI `wright check`；core：仅 entry include | **保留（成本结论，非契约）**。`--kind opy` 不强制 entry 在 src 根，package scripts/CI 路径可迁移更新；但约 190 个 `#!mainFile` 相对路径提示 + 全部构建/发布脚本的 entry 引用使迁出成本高于收益，故按真实迁移成本保留 |
| `src/composition/` | `bootstrap.opy`（settings/vars/extension/license 共享头部）、`profile-cn`/`profile-external`（`PROFILE_*` 差异宏）、`profile-cn-features`（CN 功能尾部 include 表） | 业务规则实现 | entry 文件 | **保留**。职责=编译前序组装；与 core 的分工：composition 管"入口与 profile 差异的静态输入"，core 管"运行时规则的展开顺序" |
| `src/config/` → `src/events/catalog/` | `eventCatalog.opy`（字段注册）、`eventCatalogMain/Dev.opy`（`EVENT_CATALOG_ORDER`） | 非事件内容 | `tools/event.ts`、`tools/sync-event-data.ts`、3 个 entry | **合并**：config/ 的全部内容都是事件域，`tools/event.ts` 与 sync 是唯一写入方；并入 events/ 消除"配置横向分离"，事件变更不再跨无关目录 |
| `src/constants/` → 删除 | `event_ids.opy`/`event_constants.opy`/`event_manifest.opy` → `src/events/`；`player_constants.opy` 的活定义 → `src/composition/mode_constants.opy` | — | bootstrap（目录级 include，当前一次引入全部四文件）；活定义由 bootstrap settings 块与 entry `ENTRY_*` 引用消费 | **删除**：事件常量三文件随事件域；`player_constants` 实测为混合体——活定义（`FULL_DESCRIPTION`/`LOBBY_*`/`PERK_*`/`RESPAWN_*`/`HEALTHPACK_*`/`SETTING_*`/`CLASSIC_MAP_VARIANT_*`）随组装输入定位到 composition，死定义（`ALL_*` 英雄参数、`CTF_*`——`all_teams.opy` 与 bootstrap settings 均用字面量，零引用）剔除作为独立评审单元。目录删除前先处理死配置 |
| `src/env/` | `env.opy`/`env_dev.opy`（VERSION/DEBUG/编译开关，release.yml 读 VERSION） | 运行时规则、变量声明 | bootstrap/entries；`sync-platform-data.ts`（VERSION 解析）、`release.yml`、`bump-env-version.ts` | **收缩为 build profile**：只保留构建配置两文件；运行时内容移交 `session/` |
| `src/session/`（新） | `vars.opy`/`title-vars.opy`/`vars_dev_extra.opy`（全局槽位注册表）、`game.opy`（会话初始化 + player-left 清理 + 颜色/英雄数组运行规则）、`setDifficulty.opy`（运行时 subroutine） | 业务域实现 | bootstrap（vars）、profile（title-vars）、devMain（vars_dev_extra）、entry（game）、core（setDifficulty） | **新建**：回答 build config vs runtime state 边界——槽位注册表（显式编号需同目录集中防碰撞）与对局会话运行时归同一 owner；整文件移动保持原 include 槽位 |
| `src/events/` | allocation（候选池/兼容池/分配/拒绝采样）、effects/{buff,debuff,mech}+索引文件、integrity（hashtag/masteryRunCode）、lifecycle（6 文件）、`init/detectFlag.opy` | 非事件内容 | `core.opy`、`tools/event.ts`、测试 | **调整**：`init/` 仅一个 13 行文件 → 并入 `lifecycle/`（事件会话初态）并删除该子目录；`catalog/` 与常量移入（见上）。其余子目录是真实职责划分，保留 |
| `src/heroes/` | 英雄规则 + `settings/`（`HERO_SETTINGS_*` 宏，被 bootstrap settings 块消费） | — | `core.opy`、`bootstrap.opy` | **保留** |
| `src/locales/` | zh-CN/en-US 文案宏 | 事件定义 | `check_locale_keys.sh`、`tools/event.ts`、`tools/sync-event-data.ts` | **保留**。文案按语言轴切分是平台契约，事件文案在此不算漂移 |
| `src/map/` | 34 个地图文件（生成 revision 区块 + 地图规则）+ `mapDetection`/`setup_all_map`/`controlJump`/`interactions` | 非地图内容 | `sync-map-data.ts`（`src/map/*.opy` 扫描）、`core.opy`、`release.yml` | **保留**。地图文件本身是"生成区块+运行规则"同体，不再分 routes 子目录：扫描/生成/校验都按 `map/*.opy` 平坦模型工作，分层无净收益 |
| `src/menu/` | frame/hero/player/title + `dev/`、`host/` | — | `core.opy`（交错槽位）、`profile-cn-features`（title.opy） | **保留** |
| `src/player/` | 状态/存档/属性/进度/成就/结算/第三人称 | — | `core.opy`、menu | **保留** |
| `src/title/` | 称号实现 + `title-cn.opy`（含生成区块）+ 编译期脚本输入（自 src/tools 迁入） | — | `profile-cn*`、`sync-title-data.ts`、`release.yml` | **保留+扩责**：`src/tools/` 的两个 JS 是 title-cn.opy 的 `__script__` 编译输入、sync-title-data 的生成输出、release 提交清单项——随称号域定位 |
| `src/tools/` → 待定（保留） | 两个 JS 编译输入 → `src/title/`（U2）；`player.json` 去向未定 | — | — | **待定**：目录删除批准推迟到 U7 核实完成——`player.json` 若确认无消费者则删除目录，若确认外部消费者则保留并记录其 owner |
| `src/effects/` | HUD/特效（`init`/`nano`/`player`） | — | `core.opy` | **保留**。与 `events/effects/`（事件行为实现）不同域，文档已注明 |
| `src/bastion/`、`src/blacklist/` | 现状内容 | — | `core.opy` | **保留**。blacklist 两文件各 7 行但职责独立（房间治理），允许合并为单文件——列为可选单元而非必须 |
| `src/utilities/` → 调整 | `dev_support/macros.opy`（实为 production 宏：`Player.key`/`savedIndex`/`percent`/`heroID`/`anchorPos`）、`system/anticrash.opy`（孤儿）、`system/autoReboot.opy` | — | bootstrap（macros 经目录间接）、`core.opy`（autoReboot） | **调整**：`dev_support` 标签错误——该文件是全局运行宏库 → 移为 `src/utilities/macros.opy`（删除 `dev_support/` 层）；`system/` 保留为"无业务属主的系统机制"（anticrash/autoReboot），不再新增业务实现 |
| `data/` | `platform-event-ids.json` | 运行时数据 | `sync-platform-data.ts`（读） | **保留**。Bastion 集成映射，平台仍是业务数据真源 |
| `tools/` | CLI、sync 域模块、event.ts、测试、perf/版本辅助 | 生成产物 | package scripts、CI | **保留**；`event-allocation-scenarios/` 见 §4 调查候选 |
| `build/` | 编译输出 | — | — | **保留忽略**。最终构建输出永不提交 |
| `docs/` | `modules/`（导航）、`agents/`（规则）、`contracts/`（契约）、`plans/`（计划/分析）+ 根目录混合参考文章 | — | AGENTS/README/CONTRIBUTING | **调整**：新增 `docs/references/` 收 OverPy/Workshop 参考文章（`Loops.md`、`overpy.md`、`Element-Count-Calculation.md`），项目文档（`improve-server-stability.md`）留根或入 modules；补 `docs/README.md` 索引。引用方：AGENTS.md 风险路由表 |
| `skills/` | 4 个 Bastion 流程技能 | — | 会话路由 | **保留**（已是 owner，见 AGENTS.md 声明） |

## 2. 文件/目录组迁移映射（当前位置 → owner → 建议位置 → 理由 → 受影响消费者）

| 当前位置 | owner | 建议位置 | 理由 | 受影响消费者 |
|---|---|---|---|---|
| `src/config/eventCatalog.opy` | events | `src/events/catalog/eventCatalog.opy` | 唯一消费者是 event.ts/sync 协调器/entries；消除 config 横向层 | tools/event.ts files 表、sync-platform-data `EVENT_CATALOG_FILE`、3 个 entry include、event-catalog.test、temper-heart.test、skills/{add,remove}-workshop-event、docs |
| `src/config/eventCatalog{Main,Dev}.opy` | events | `src/events/catalog/` | 同上 | 同上 + 3 个 entry include |
| `src/constants/event_ids.opy` | events | `src/events/event_ids.opy` | 定义与写入方均事件域 | event.ts、bootstrap 目录 include → 改 bootstrap 内显式 include，保持原展开次序（须仍在 `game.opy` 消费前） |
| `src/constants/event_constants.opy` | events | `src/events/event_constants.opy` | 主体事件域；但含跨域槽位定义（`InvincibleEffectSlot`/`DEFAULT_INVINCIBLE_EFFECTS`/`DEFAULT_GLOBAL_ONCE_EVENT_STATE`/`GLOBAL_ONCE_EVENT_SLOT_COUNT`） | 非事件消费者：`env/game.opy`（bootstrap 之后、core 之前展开）、`menu/dev/admin.opy`、`player/init.opy`、`events/lifecycle/*`——迁移后 include 槽位必须保持在 `game.opy` 之前；event.ts、`EVENT_CONSTANTS_FILE`、release.yml git add、目录 include |
| `src/constants/event_manifest.opy` | events（生成） | `src/events/event_manifest.opy` | 事件域生成产物 | sync-platform-data `EVENT_MANIFEST_FILE`、sync-event-data 渲染器、release.yml git add + skip-release 排除规则、目录 include |
| `src/constants/player_constants.opy` | 组装输入 | `src/composition/mode_constants.opy`（改名同步） | 活定义是 bootstrap settings 块与 entry `ENTRY_*` 的编译期输入；死定义（`ALL_*`/`CTF_*`）剔除见 §5 | bootstrap 目录 include → 显式 include；消费方：bootstrap settings、entries、game.opy（`CLASSIC_MAP_VARIANT_*`） |
| `src/env/game.opy`、`setDifficulty.opy`、`vars*.opy` | session | `src/session/` | build profile（env）vs runtime state（session）边界 | bootstrap（vars）、profile（title-vars）、devMain（vars_dev_extra）、entry（game）、core（setDifficulty）——仅 include 路径更新，槽位不变 |
| `src/events/init/detectFlag.opy` | events/lifecycle | `src/events/lifecycle/detectFlag.opy` | 事件会话初态标记，init/ 单层目录无独立职责 | `core.opy` 1 行 include |
| `src/tools/playerNameToIndex{,Delimited}.js` | title（生成） | `src/title/playerNameToIndex{,Delimited}.js` | title-cn.opy 的 `__script__` 编译输入 + sync 生成输出 + release 提交项 | title-cn.opy `__script__` 相对路径、sync-title-data `PLAYER_NAME_TO_INDEX*_FILE`、release.yml git add、appendix 索引、add-workshop-title skill |
| `src/tools/player.json` | 未定 | 调查候选 | 全仓零消费者（tools/src/CI/docs 均无引用） | **不批准删除**，先完成外部消费者核实（历史脚本/手动工具） |
| `src/utilities/dev_support/macros.opy` | utilities | `src/utilities/macros.opy` | `dev_support` 误标：内含生产存档/定位/数值宏 | bootstrap 文件级 include `../utilities/dev_support/macros.opy` 单点更新 |
| `docs/{Loops,overpy,Element-Count-Calculation}.md` | references | `docs/references/` | 参考文章与项目导航分离 | AGENTS.md 路由表、docs/agents README、模块文档内链 |
| `docs/improve-server-stability.md` | 项目文档 | 留根或 `docs/modules/` | 被 AGENTS/CONTRIBUTING 活跃引用 | 同上 |
| `docs/`（新增） | — | `docs/README.md` | 顶层索引 | 新文件，无消费者迁移 |
| `tools/event-allocation-scenarios/` | 未定 | 调查候选 | 目录内 3 个 JSON 无任何代码消费者 | **不批准删除**，先核实是否手动测试夹具 |

## 3. 变更场景定位路径（验证跨目录跳转是否减少）

### 新增/下线一个事件
- 现状：`constants/event_ids` + `constants/event_constants` + `config/eventCatalog` + `config/eventCatalog{Main,Dev}` + `locales/*` + `events/effects/<type>/` + `events/effects/*Effects.opy` + `data/platform-event-ids.json`
- 规划后：`events/`（ids、constants、catalog/、effects/）+ `locales/` + `data/`。跨域只剩 locales（语言轴契约）与 data（平台稳定 ID 契约），6 个技术目录收敛为 1 个业务域 + 2 个跨域契约

### 英雄设置变更
- 现状事实：`heroes/settings/{team_rules,all_teams}.opy` 用字面量表达数值，`bootstrap` settings 块只消费 `HERO_SETTINGS_*` 宏；`player_constants.opy` 的 `ALL_*` 参数是死定义，不参与英雄设置链路
- 规划后：`heroes/settings/`（宏结构）+ bootstrap（settings 块）——定位不变；`ALL_*` 死定义剔除是独立清理单元，不属于本路径

### 地图 revision 同步
- `sync-map-data.ts` → `src/map/*.opy` 生成区块 + `src/title/map-title-data.opy` 投影（CN）。不变

### 称号同步
- 现状：`sync-title-data.ts` → `src/title/title-cn.opy` + `src/tools/*.js` + release 提交
- 规划后：`sync-title-data.ts` → `src/title/` 单目录（title-cn.opy + 两个编译输入 JS），写入面从两目录收敛为一

## 4. 生成输入契约

| 生成物 | 生成器 | 提交规则 | 编译消费者 | release 消费者 |
|---|---|---|---|---|
| `title-cn.opy` 生成区块 | sync-title-data | 提交 | bootstrap→profile-cn | `git add` 清单 |
| `src/title/playerNameToIndex*.js`（迁入后） | sync-title-data | **提交**（是编译输入，不是 build 输出） | title-cn.opy `__script__` | `git add` 清单 |
| `event_manifest.opy` | sync-event-data | 提交 | bootstrap 目录 include（迁移后：core/entry include） | `git add` 清单 + skip-release diff 排除 |
| `event_constants.opy`/`zh-CN.opy`（部分区块） | sync-event-data | 提交 | 事件域 include | `git add` 清单 |
| `map/*.opy` revision 区块 | sync-map-data | 提交 | 地图文件本体 | `git add` 清单 |
| `env/env.opy` VERSION | release.yml bump | 提交 | 全 entry | release 自举 |
| `build/*.ow` | wright | **不提交**（build/.gitignore） | — | release 产物 |

`data/platform-event-ids.json`：Bastion↔平台稳定 ID 集成映射，手写维护（event:add/remove 同步），平台仍为业务数据真源。

## 5. 未定项（交评审裁决，不由实现者自选）

1. `player_constants.opy` 死定义（`ALL_*` 英雄参数、`CTF_*` 系列，零外部引用）的剔除方式——改文件属内容变更而非纯搬迁，需独立评审单元确认后随 U6 执行。
2. `env/game.opy` 是否拆分为"存档 schema/大厅设置/英雄列表/调色板"到各自 owner——拆分后各段回到 core/entry include 槽位，但单一初始化规则被切开；倾向整文件移 `session/` 不拆，待评审。
3. `core.opy` 是否迁入 `composition/`——职责同质（都是组装），但 55 行 include 全部要加 `../` 前缀，纯路径 churn；倾向留在 src 根作为"组装脊"，待评审。
4. `src/tools/player.json`、`tools/event-allocation-scenarios/`、`utilities/system/anticrash.opy`（无 include 消费者）三个调查候选的外部消费者核实未完成前不删。
5. `blacklist/init.opy`+`removeFromBlacklist.opy` 是否合单文件——允许但非必须，待评审。
6. `session/` 命名——与 `state/`、`runtime/` 同为候选，以"对局会话状态"语义采用 session，待评审。

## 6. 最小迁移单元（可独立验证，标注串行关系）

| 单元 | 内容 | 验证 | 串行约束 |
|---|---|---|---|
| U1 | config/ → events/catalog/；constants 事件三文件 → events/；bootstrap `constants/` 目录 include → 显式文件 include（须复现原目录 include 的实际展开次序，以编译对照为准；跨域定义须保持在 `game.opy` 消费前的槽位） | 5 入口编译产物与基线逐字节一致；event-catalog.test、temper-heart.test、sync 测试、event.ts dry-run | 触及 entry include 行 + bootstrap + tools 路径常量；与 U2/U3 无依赖，但与 U4/U6 同改 bootstrap → 串行 |
| U2 | src/tools/*.js → src/title/ | title-cn.opy `__script__` 路径同步；编译产物逐字节一致；sync-title-data dryRun 生成比对 | 触及 sync-title-data 与 release.yml git add；与 U1 无共享文件，可并行 |
| U3 | events/init/ → lifecycle/ | 编译产物逐字节一致 | 仅 core.opy 一行；可与任何单元并行 |
| U4 | utilities/dev_support 层消除（macros → utilities/macros.opy） | 编译产物逐字节一致 | 触及 bootstrap include 行；与 U1 串行 |
| U5 | docs 分类 + docs/README.md | 死链扫描零新增；AGENTS/CONTRIBUTING 引用可解析 | 纯文档，可并行 |
| U6 | env/ 收缩 + session/ 新建（game/vars*/setDifficulty 迁移）+ player_constants → composition/mode_constants（死定义剔除经 §5-1 批准后并入） | 编译产物逐字节一致；死定义剔除前后分别验证 | 与 U1 串行（同改 bootstrap/entry include 行）；死定义剔除为独立内容变更评审点 |
| U7 | 调查候选核实（player.json、scenarios、anticrash）→ 另行处置 Issue；src/tools/ 目录删除在 player.json 去向明确后执行 | — | 独立；U2 可先完成 |

每个代码迁移单元的验证合同：固定 wright 版本下 5 个 entry 编译产物与迁移前基线逐字节对照（覆盖规则、条件、动作、变量/子程序映射、发射顺序）；`tools:test`、locale 检查、旧路径零活消费者。文档迁移单元只验证活引用。

## 7. 明确不做的事

- 不引入 domains/、modules/ 这类一层空聚合目录。
- 不为"每个业务单一 include 入口"造假装配线——core.opy 交错槽位是真实约束。
- 不把 locales/data 的跨域契约文件塞进事件实现目录。
- 不删除无消费者证据的调查候选文件。
- 不改玩法、ID、抽取语义、profile 内容、平台契约。
