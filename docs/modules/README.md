# Bastion 项目模块手册（`src/`）

本文档组用于帮助开发者快速理解 `src/` 下核心代码结构、主流程与扩展方式。建议按以下顺序阅读。

## 推荐阅读顺序

1. [01-entry-architecture.md](./01-entry-architecture.md)
2. [02-env-constants-locales.md](./02-env-constants-locales.md)
3. [03-events-system.md](./03-events-system.md)
4. [04-bastion-ai.md](./04-bastion-ai.md)
5. [05-map-system.md](./05-map-system.md)
6. [06-utilities.md](./06-utilities.md)
7. [07-heroes.md](./07-heroes.md)
8. [08-player-effects-title.md](./08-player-effects-title.md)
9. [09-special-seasonal.md](./09-special-seasonal.md)
10. [10-references-workshop-codes.md](./10-references-workshop-codes.md)
11. [appendix-src-file-index.md](./appendix-src-file-index.md)

## `src` 顶层模块速览

- `bastion/`：敌方堡垒 AI 与战斗行为
- `blacklist/`：黑名单初始化
- `composition/`：入口共享组装件（bootstrap、profile 差异宏、CN 专属功能尾部）
- `effects/`：HUD、世界特效、摄像机触发点
- `env/`：环境开关、版本号、全局初始化
- `events/`：事件身份/参数常量、注册目录（`catalog/`）、抽取、生命周期与事件效果实现
- `heroes/`：英雄定制规则
- `locales/`：中英文本地化宏
- `map/`：地图点位、多图切换流程与点位交互
- `menu/`：玩家/房主/开发者菜单（按职责拆分子目录）
- `player/`：玩家初始化、进度/存档、属性计算与成就
- `special/`：春节/活动分支（Lunar）
- `title/`：称号系统（真源为平台 Agents API，由脚本同步到运行文件）
- `tools/`：构建期名称映射脚本
- `utilities/`：无业务属主的系统机制与开发宏

## 文件规模（便于定位核心）

按行数统计的高优先文件：

- `src/events/event_constants.opy`（事件参数总表）
- `src/events/effects/buffEffects.opy`
- `src/events/effects/debuffEffects.opy`
- `src/events/effects/mechEffects.opy`
- `src/main.opy` / `src/devMain.opy` / `src/externalMain.opy`
- `src/events/catalog/eventCatalog.opy` / `src/events/catalog/eventCatalogMain.opy` / `src/events/catalog/eventCatalogDev.opy`
- `src/bastion/init.opy`
- `src/title/title-cn.opy`

## 维护约定

- 新功能优先补充对应模块文档，避免只改代码不改说明。
- 事件类改动需同时核对：`config` + `events/effects` + `locales`。
- 地图类改动需同时核对：对应地图文件 + `map/setup_all_map.opy` +（必要时）`map/mapDetection.opy`。
- 若仅改部分入口（`main.opy` / `devMain.opy` / `externalMain.opy`），必须在变更说明中写明原因。
