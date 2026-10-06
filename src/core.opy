#!include "map/mapDetection.opy"
#!include "blacklist/init.opy"
#!include "blacklist/removeFromBlacklist.opy"
#!include "events/init/detectFlag.opy"

#!include "heroes/all_hero.opy"

#!include "events/allocation/buildCompatibleEventPool.opy"

#!include "events/allocation/buildCandidatePool.opy"

#!include "events/allocation/rejectSampling.opy"

## Utilities / business services（include 槽位保持原位以维持展开顺序）
#!include "events/effects/healthPool.opy"

#!include "events/effects/dashDetector.opy"

#!include "player/savePlayerData.opy"

#!include "player/progressHero.opy"

#!include "player/playerRegen.opy"

#!include "env/setDifficulty.opy"

#!include "player/thirdPerson.opy"

#!include "bastion/createBastionBot.opy"

#!include "events/integrity/hashtag.opy"

## Player stats / Events: lifecycle（include 槽位保持原位以维持展开顺序）
#!include "player/updatePlayerStats.opy"

#!include "events/lifecycle/setEventDuration.opy"

#!include "events/lifecycle/resetPlayerCD.opy"

#!include "player/setPlayerSize.opy"

#!include "events/lifecycle/clearEventEffect.opy"

#!include "events/lifecycle/setPlayerEvent.opy"

#!include "events/lifecycle/clearPlayerEvent.opy"

#!include "player/setPlayerHP.opy"

#!include "player/startCombatRegen.opy"

#!include "events/allocation/assignPlayerEvent.opy"

#!include "events/effects/buffEffects.opy"

#!include "events/effects/debuffEffects.opy"

#!include "events/effects/mechEffects.opy"

# Maps
#!include "map/setup_all_map.opy"

#!include "bastion/init.opy"

#!include "map/controlJump.opy"
#!include "player/finishSettlement.opy"
#!include "events/integrity/masteryRunCode.opy"

#!include "effects/init.opy"
#!include "map/interactions.opy"
#!include "effects/nano.opy"
#!include "effects/player.opy"

# 事件完整重置入口；保持在 status.opy 前以维持子程序索引与规则顺序
#!include "events/lifecycle/resetPlayerEventState.opy"
#!include "player/status.opy"
#!include "player/init.opy"


#!include "utilities/system/autoReboot.opy"

## 菜单：公共框架 / 玩家 / 房主 / 开发（include 槽位保持规则发射顺序，跨角色交错不可重排）
#!include "menu/frame.opy"
#!include "menu/hero.opy"
#!include "menu/dev/pages.opy"
#!include "menu/player.opy"
#!include "menu/dev/difficulty.opy"
#!include "menu/host/reboot.opy"
#!include "menu/dev/restart.opy"
#!include "menu/host/moderation.opy"
#!include "menu/dev/admin.opy"
#!include "menu/dev/movement.opy"
#!include "menu/dev/actions.opy"
#!include "menu/dev/weights.opy"
