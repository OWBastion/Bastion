# Bastion 文档索引

## agents/ — 流程与契约（任务路由入口）

按任务形态路由的操作规范，AGENTS.md 的 canonical rule index 指向这里。

- `architecture-rules.md` — 架构一致性与入口约束
- `build-validation.md` — 构建与验证
- `performance-loop-safety.md` — 性能与循环安全
- `collaboration-commit.md` — 协作、交付与提交
- `doc-sync.md` — 文档同步
- `context-routing.md` — 上下文获取与按需加载
- `ecosystem-platform-boundary.md` — 生态/平台边界

## modules/ — 模块文档（架构与实现）

按 `src/` 目录组织的模块说明，含文件级索引附录，入口见 `modules/README.md`。

## contracts/ — 稳定契约

跨模块/跨系统的稳定接口契约（如结算截图 HUD 契约）。

## references/ — 外部参考文章

OverPy/Workshop 教程与计算参考，与项目导航分离：

- `Loops.md` — Workshop 循环机制教程笔记
- `overpy.md` — OverPy 参考
- `Element-Count-Calculation.md` — 元素计数计算参考

## 根级文档

- `improve-server-stability.md` — 服务器稳定性改进（项目运维指南，被 AGENTS/CONTRIBUTING 活跃引用）
