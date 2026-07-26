# Session Maintenance Template

## A) Session 摘要模板

```md
## Session 摘要（Bastion 优先）

### 1. Title Source / Query 工作流
- 关键动作：
- 风险收敛：
- 可复用步骤：

### 2. Performance Loop 风险收敛
- 关键动作：
- 风险收敛：
- 可复用步骤：

### 3. Release / Env Version 自动化
- 关键动作：
- 风险收敛：
- 可复用步骤：

### 4. 跨仓通用经验（附录）
- AGENTS 路由策略：
- 波次验证策略：
- Skill 同步防漂移策略：
```

## B) Skill 变更建议模板

```md
## Skill 变更建议

1. 新增 skill：
- 名称：
- 能力边界：
- 输出格式：

2. 优化现有 skill：
- 统一骨架：触发条件 -> 必改真源 -> 生成/同步 -> 验证 -> 交付说明
- 去重项：
- 命令对齐：
- stop-rule / 失败处理：
```

## C) 验证命令模板

```bash
rg --files skills | rg 'SKILL.md|references|agents/openai.yaml'
rg -n 'sync:title-data|test:title-data-sync|sync:platform-data|build:release' skills AGENTS.md package.json
rg -n '禁止重排|DOMINATOR|COUNT 之前|生成产物|不可手改' skills/*/SKILL.md
```

## D) 命令级演练模板（低风险）

Title 类演练：

```bash
rg -n 'data/title-source.json|sync:title-data|test:title-data-sync|title/init.opy|MAP_TITLE_DATA' skills/add-workshop-title/SKILL.md skills/grant-player-title/SKILL.md
```

Event 类演练：

```bash
rg -n 'COUNT|eventConfigDev|eventType ==|wait\(' skills/add-workshop-event/SKILL.md
rg -n 'enum BuffEventId|enum DebuffEventId|enum MechEventId|COUNT' src/constants/event_ids_*.opy
```
