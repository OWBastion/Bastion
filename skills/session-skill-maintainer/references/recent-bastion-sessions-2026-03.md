# Recent Bastion Sessions (2026-03)

## Session 摘要

### 1) Title Source / Query 工作流
- 建立并固定 `data/title-source.json` 为称号真源，`src/title/title-cn.opy` 通过同步脚本生成，避免手改生成产物。
- 标题查询页改造集中在候选提示、分组展示、折叠区和主题持久化，流程强调“先同步数据，再改 UI”。
- 关键防漂移动作：统一命令为 `pnpm run sync:title-data` 与 `pnpm run test:title-data-sync`，并在 skill 中显式声明玩家顺序语义与 map 奖励约束。

### 2) Performance Loop 风险收敛
- 采用 TODO 驱动的波次推进（先文档列风险，再按波次修复），优先便宜高筛选率门控，避免先做昂贵 LoS/排序。
- 明确条件区门控优先；动作区判断仅在循环判频等例外场景使用，并要求显式 `wait`。
- 对 AOE + wait 的上下文丢失风险形成文档化约束：跨 wait 链路要前置计算或缓存后迭代。

### 3) Release / Env Version 自动化
- 补齐 `bump:env-version` 与 release workflow 联动，主线 push 自动触发版本推进、构建、打 tag、发布。
- 风险点集中在 guard 一致性：skip-token 与 bump commit message 令牌需同一套约定，避免误跳过或重复触发。

## Skill 变更建议

1. 新增 `session-skill-maintainer` 作为总控 skill，统一输出结构（摘要/建议/验证/风险）。
2. 现有 Bastion skills 统一骨架并抽取 references，降低重复文本与命令漂移风险。
3. 对 title/event skill 强化 stop-rule 与失败处理，提升可审计性。

## 验证命令

```bash
rg --files skills | rg 'SKILL.md|references|agents/openai.yaml'
rg -n 'sync:title-data|test:title-data-sync|sync:platform-data|build:release' skills AGENTS.md package.json
rg -n '禁止重排|DOMINATOR|COUNT 之前|生成产物|不可手改' skills/*/SKILL.md
```

## 未决风险

1. release skip-token 与 bump commit token 仍需长期一致性回归检查。
2. 若未来变更 `title-source` schema，需同步更新 title skills 的验证命令与模板。
3. 事件系统若引入新类型，需先扩展枚举/配置模板再开放 skill 入口。
