# 10. Workshop.Codes 参考映射

本项目大量实践与 Workshop.Codes Wiki 的教程/参考一致。以下为推荐阅读与本项目对应点。

## 1) Loops 教程

- 分类页：[Tutorials](https://workshop.codes/wiki/categories/tutorials)
- 文章：[How to use loops](https://workshop.codes/wiki/articles/how-to-use-loops)

对应到项目：

- `events/effects/healthPool.opy` 的 while 清理循环
- `events/allocation/rejectSampling.opy` 的有限轮采样循环
- `bastion/init.opy`、`effects/init.opy` 中大量循环心跳规则

实践原则：每个循环都带 `wait`，且超时时间可控。

## 2) 地图与 API 参考

- 分类页：[References](https://workshop.codes/wiki/categories/references)
- 文章：[What maps are available in workshop?](https://workshop.codes/wiki/articles/what-maps-are-available-in-workshop)
- 文章：[Workshop Extensions in Overwatch 2](https://workshop.codes/wiki/articles/workshop-extensions-in-overwatch-2)

对应到项目：

- `map/setup_all_map.opy` 与 `map/mapDetection.opy`
- 入口文件启用的 `#!extension`（状态效果、音效、dummy 等）

## 3) C-Style / OverPy 风格参考

- 文章：[C-Style Syntax in Workshop](https://workshop.codes/wiki/articles/c-style-syntax-in-workshop)

对应到项目：

- 本仓库使用 OverPy 宏、subroutine、数组推导与表达式风格
- `constants/event_constants.opy` 与 `title/title-cn.opy` 体现配置化 DSL 的写法

## 4) OW2 Workshop 差异

- 文章：[All Workshop changes from Overwatch 1 to Overwatch 2](https://workshop.codes/wiki/articles/all-workshop-changes-from-overwatch-1-to-overwatch-2)

对应到项目：

- 事件、扩展、地图与英雄 API 在 OW2 环境下的兼容策略

## 5) 实务建议（结合本仓库）

- Canonical 规则来源：`docs/agents/performance-loop-safety.md`（此处仅保留路由指针，不复制规则正文）。
- 新规则优先检查元素数/循环节奏，再检查效果正确性。
- `eachPlayer` 规则优先短路廉价条件，昂贵运算后置。
- 复杂系统优先拆成“配置 + 抽取 + 执行 + 清理”四层，本项目事件系统即该结构。
