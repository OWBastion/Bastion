# LESSONS.md — PR Review 复盘沉淀

来源：OWBastion/Bastion 2026-09 ~ 2026-10 约 25 个 PR（#228–#415）的 review 评论。
性质：复盘候选教训，按复发频率/严重度排序。每条标注建议承载位置——能被机械检查的落成检查，判断类进 skill 或文档，不写进本文件后无人维护。

## L1. 检查存在但不运行，等于没有检查（环境，最高优先）

`tools/perf-loop-scan.ts` 自 2026-03 起就能检出 waitless `while`/`loop`，但 CI（`ci-build.yml`）只跑 `pnpm run build` + `wright check`，也无 pre-commit hook。#403 的 `while` 循环一路进到人工 review 才被拦下。

同样未接线的检查：`check_locale_keys.sh`、`tools:test`。

附带缺陷：`perf:scan --strict` 当前在 main 上即失败——`solo_level_up.opy:40` 的 `loop()` 被误报（±10 行词法窗口漏掉了规则体开头的 `waitUntil`/`wait`）。strict 门禁接 CI 前必须先修扫描器的路径分析（或支持豁免注释）。

文档漂移：`docs/agents/build-validation.md` 的 Required Checks 未列 `perf:scan`，`performance-loop-safety.md` 列了。

→ 落地：修扫描器误报；CI 增加 `perf:scan --strict`、`check_locale_keys.sh`、`tools:test`；同步两份文档的 required-checks 清单。

## L2. 不为单一事件新增专属变量；复用暂存槽（复发 4 次）

Workshop 只有 128 个 player 变量槽。reviewer 反复拦截：

- #412：新增专属变量被拒 → 改成数组包标量再被拒（"只有一个数字为什么还声明数组"）→ 最终复用 `eventTempIndex`
- #335：新增 `taskSuccessEvents` 被拒 → 复用 `dlcTimeChallenge` 槽位
- #254：为独立所有权新增 3 个 playervar 被拒 → 改用既有变量内固定槽位数组
- #390：用事件 ID 做数组索引被拒——Workshop 会扫描 0 到最大索引，稀疏结构有真实成本

规则：事件态优先复用已登记的 scratch 槽（`eventTempIndex`、`eventMission`、`eventMissionGoal`、`temp` 等，见 `docs/modules/03-events-system.md`）；确实需要持久变量时显式说明理由。禁止以事件 ID 作数组索引。

→ 落地：diff 检查——新增 `^globalvar |^playervar ` 声明即拦截要求说明（CI step 或 tools 命令）；scratch 复用模式与稀疏数组成本补进 `performance-loop-safety.md`。

## L3. 不扩张 Issue 之外的接口面（复发 3 次）

- #228：为兼容 producer 全量 schema 新增 per-respawn 轴数组、`next_in_order`、Busan no-op hook——四条评论逐条驳回，"not justified by #227's contract"
- #330：Issue 要"新加一个"，实现却替换了既有赌徒事件
- #327：无关的 BLACK_HOLE 权重恢复混入 #318 的修复（agent 自 review 抓到）

规则：每个新增公开面（变量、枚举、schema 字段、配置项、生成产物）必须能对应 Issue 中的一行明确要求；"为将来兼容"不构成理由。这条组织层 `engineering-quality.md` 已有原则，缺的是实施侧的逐条核对。

→ 落地：交付契约补一条——改动公开面的 PR，PR 描述或自检需列出"新增面 → Issue 依据"的映射（`docs/agents/collaboration-commit.md` 或 `.github/docs/pr-delivery.md`）。

## L4. 断言必须能失败：不验存在性，验行为（复发 2 次）

- #233：`includes()` 断言被注释掉的 `# platformMapRevision_...()` 满足，"does not actually prove the setup route is called"
- #235：断言只证明谓词存在——生成器全分支都调 `ROUTE_0()` 也能通过；fixture 的 `selectionCount: 3` 与 Busan 真实契约（三 stage 出两 stage 路线）不符

规则：`tools/` 测试断言生成产物的行为与输出，不断言源码子串或谓词存在；fixture 必须取能区分对错的真实契约值。

→ 落地：`owbastion-test-design-review` skill 补这两个具体反模式（substring 断言、谓词存在性断言）；`tools:test` 接线进 CI（见 L1）。

## L5. 计划/迁移文档的现状声明必须对 live source 核实（#357，6 条纠正）

`docs/plans/directory-responsibility-plan-2026-10-06.md` 一份计划被纠正六处：槽位范围与实际交错分布不符、漏列 `TEAM1_*`/`TEAM2_*`/`BOSS_BASTION_*` 等 live 定义、"唯一消费者"声明不实、迁移表与 U1 合同矛盾。

规则：文档中关于现状的事实声明（槽位分配、消费者清单、"only consumer"、范围划分）写作时必须用 grep/读源码验证，不接受记忆。

→ 落地：`issue-readiness.md` 或 documentation 政策加一条计划文档事实核实要求。

## L6. 事件效果规则的惯例细节（skill 覆盖不全）

`workshop-event` 已含"派发仅 `eventId` 单条件""动作区判断需显式 `wait`"，review 又补出：

- 效果规则内部不重复判断自身 `eventId`/`eventType`——规则已被 ID 门控（#403、#257）
- 清理归属：`clearPlayerEvent` 只做通用清扫、不按事件 ID 分支；事件专属状态在事件文件内回收（#257 的纠正 + #390 的统一 `UNKILLABLE` 清扫合起来才是完整规则）
- 不主动加特效（#267、#269）；少用 `#!define` 收缩实现（#263）；locale 文案注意 `\n` 与占位符（#257、#330）

→ 落地：补进 `skills/workshop-event/` 的规则条件清单；属判断项，不进 lint。

## 附注

- 正面信号：e54-bot 自 review 抓到过真 P1（#327 权重、#329 平台映射、#331 重复结算），二遍自检有效，配合 L3 的映射清单强化即可。
