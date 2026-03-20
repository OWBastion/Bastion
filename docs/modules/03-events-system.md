# 03. 事件系统（Vishkar Event）

## 模块组成

- 初始化：`src/events/init/detectFlag.opy`
- 配置：`src/config/eventConfig.opy`, `src/config/eventConfigDev.opy`
- 分配：`src/events/allocation/assignPlayerEvent.opy`
- 抽样：`src/events/allocation/rejectSampling.opy`
- 效果：`src/events/effects/buffEffects.opy`, `debuffEffects.opy`, `mechEffects.opy`
- 玩家态子程序：`utilities/event_core/setPlayerEvent.opy`, `clearPlayerEvent.opy`, `setEventDuration.opy`

## 生命周期

1. `detectFlag` 在开局一段时间后激活事件系统（debug 与正式阈值不同）
2. `initialize event array` 构建事件池数组与可抽取 ID 列表
3. `assignPlayerEvent` 对符合条件玩家按周期触发抽取
4. `setPlayerEvent` 决定类别并填充当前玩家事件数据
5. `rejectSampling` 在类别池内按权重抽样（最多 8 轮）
6. 事件效果规则在 `events/effects/*` 中执行
7. 到期后 `clearPlayerEvent` 清理状态与特效

## 事件数据结构

事件条目统一形态：

- `[title, desc, duration, weight]`

全局池：

- `buffEvent`, `debuffEvent`, `mechEvent`
- `buffEventId`, `debuffEventId`, `mechEventId`

玩家态：

- `eventId`, `eventLastId`（最近 N 次去重组合键数组，格式：`eventType * EVT_DEDUP_TYPE_MULTIPLIER + eventId`）, `eventType`, `eventDuration`, `eventDurationHud`
- `eventCount[3]`（各类别计数）
- `eventLucky`（幸运倾向累计）
- `eventForceRoll/eventForceCount`（强制类别调试与作弊链）

## 机制事件 ID（Enum 管理）

- 机制事件使用 `src/constants/event_ids_mech.opy` 的 `MechEventId` enum 管理。
- `config/eventConfig*.opy` 与 `events/effects/mechEffects.opy` 只引用 `MechEventId.<MEMBER>`，不直接写裸数字 ID。
- 当前策略为“源码版本内自洽”：删除中间 enum 成员时，后续成员自动前移，相关规则引用会随编译同步。
- 若新增机制事件，优先在 enum 末尾追加成员，再补配置与效果规则。
- 代码注释需独立成行，避免 `代码 # 注释` 的行尾注释写法，以免触发 OverPy 语法兼容问题。

## 增益与减益事件 ID（Enum 管理）

- 增益事件使用 `src/constants/event_ids_buff.opy` 的 `BuffEventId` enum 管理。
- 减益事件使用 `src/constants/event_ids_debuff.opy` 的 `DebuffEventId` enum 管理。
- `config/eventConfig*.opy`、`events/effects/buffEffects.opy`、`events/effects/debuffEffects.opy` 只引用 enum 成员，不直接写裸数字 ID。
- 与机制组一致，当前策略为“源码版本内自洽”：删除中间 enum 成员时，后续成员自动前移。

## 配置文件差异

### `eventConfig.opy`（生产）

- 偏向按「事件包」做开关
- 配置块结构清晰，批量启用/禁用更方便

### `eventConfigDev.opy`（开发）

- 对单个事件做更细粒度开关
- 调试/验证某个事件更高效
- Buff Pack 4 中 `SUPER_TRANSFORM` / `TENACITY` 已接入独立 workshop setting 开关，便于快速 A/B 与回归

## 类别概率与抽样

在 `setPlayerEvent` 中：

- `0~45`：Buff
- `46~80`：Debuff
- `81~100`：Mech

`rejectSampling` 通过 `random.uniform(0, eventWeight) < 当前事件权重` 决策是否命中，高权重更易命中。

去重策略：

- `eventLastId` 现为最近事件历史组合键数组（长度由 `EVT_RECENT_EVENT_DEDUP_COUNT` 控制，默认 5），按 `eventType * EVT_DEDUP_TYPE_MULTIPLIER + eventId` 存储，避免不同类别同数值 ID 相互误排除。
- 每次抽到新事件后，将其 append 到 `eventLastId`；当长度超过窗口时移除最旧记录（保留最近 N 条）。
- 当可用事件总量过少导致候选池为空时，会降级到仅按启用状态过滤，避免抽样中断。

版本假设：

- 本项目发布模型不支持将新脚本热更新到已运行房间；新脚本仅对使用新 code 新建的房间生效。
- `eventLastId` 的结构兼容按“当前房间所运行脚本版本”定义，不承诺同房间跨版本在线迁移兼容。
- 若需验证脚本更新后的事件链路，请使用新 code 重建房间后再测试。

## 事件效果层设计

- `buffEffects.opy`：增益、任务、共生、回血/护甲/位移增强等（含“超级变换形态”：指定英雄进入非初始形态时获得短时临时生命值；“向我开炮”：50%减伤 + 500可恢复护甲 + 提高堡垒索敌优先级）
- `debuffEffects.opy`：减速、易伤、禁疗、技能连锁、共享伤害等
- 新增事件示例（Debuff 22「登月火箭 / Moon Rocket」）：强制 throttle 归零、重力降至 5 并施加向上冲量，实现“被射向天空且难以控向”
- `mechEffects.opy`：机制类变体（体型、反向移动、赌徒、作弊链等；Mech 20「三位一体」当前换算为 `100HP -> 4%减伤`、`1%减伤 -> 2.5%移速`）
- 新增事件示例（Buff 34「坚韧 / Tenacity」）：常驻获得 60% 击退抵抗；血量低于 40% 自动触发，使用 HOT 在 1.25 秒内恢复 45% 最大生命值，随后进入 6 秒内置冷却；旧 Buff 18「坚定 / Unwavering」已移出公开与运行时判定，仅保留枚举占位以避免 ID 顺序风险。低血量触发采用动作区 `if + wait(0.5)` 的稀疏评估试点；事件身份门控仍保留在 `conditions` block
- 对“玩家附着型持续提示”视觉，优先采用“事件激活时创建一次 effect entity，随后用 `EffectReeval.VISIBILITY_*` 按按钮/姿态/技能状态切换可见性，事件结束时统一清理”的模式；不要在同一事件持续期内因状态反复进出而持续 create/destroy 同一类特效。
- `docs/plans/event-visual-effect-audit.md` 记录了本轮视觉审计与首批落地项；云雾残留、轨迹链、一次性爆发类特效继续保留原有多实例触发模型。

## 性能与稳定性点

- Canonical 规则来源：`docs/agents/performance-loop-safety.md`（此处仅保留路由指针，不复制规则正文）。
- 大量 `eachPlayer` 规则中采用 `wait(...)`、`waitUntil(...)`、短路条件。
- 「死亡延迟（Buff 11）」在致命伤害帧立即施加 `UNKILLABLE`，并增加“未处于 UNKILLABLE”前置条件，避免多段伤害（如堡垒榴弹）导致效果在死亡后才误触发。
- 「胜利意志（Buff 19）」新增 `eventPlayer.isAlive() == true` 前置条件，避免死亡后落入无敌触发流程。
- 「有我有你（Buff 12）」在解除附身时会同步附身者与被附身者的 `controlJumpIndex`（仅在目标索引更高时同步），避免三合一地图跨图传送后出现索引回退导致的传送点失效。
- AOE 触发链（`Player Dealt Damage` 及同类触发如治疗/击退）默认不要依赖 `wait` 之后的事件目标上下文来继续做多目标动作；多目标一致性动作前置到 `wait` 前，或改为每受击者路径/显式缓存目标集合。
- 清理逻辑统一走 `clearPlayerEvent()`，减少状态泄漏。
- 数值更新统一走 `updatePlayerStats()`，避免重复写 setXxx。

## 扩展步骤（推荐）

1. 在 `event_constants.opy` 新增参数
2. 在 `locales/*.opy` 增加标题/描述（不写持续时间，持续时间只放在 `event_constants.opy`）
3. 在 `config/eventConfig*.opy` 注入条目与开关
4. 在 `events/effects/*` 增加规则实现
5. 在 `clearPlayerEvent` 核对是否有新状态需回收
6. 在 `devMain.opy` 用单事件开关做回归验证
