#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Loop consistency note:
# Preferred sustained-loop template:
# action -> wait(cadence) -> if ruleCondition: loop() -> cleanup.
# Intentional exceptions keep waitUntil or event-split patterns where external
# lifecycle synchronization is required.

# Event effect index (generated): keep include order stable.
# 下线流程：1) 事件文件内 @Disabled + 注释；2) 移除 eventCatalog 注册与 EVENT_CATALOG_ORDER 顺序项；3) 从此处移除 include。

#!include "buff/galeBlessing.opy"
#!include "buff/ironBulwark.opy"
#!include "buff/lifeSpring.opy"
#!include "buff/blackFansAssault.opy"
#!include "buff/speedStack.opy"
#!include "buff/fleshRegen.opy"
#!include "buff/heartOfSteel.opy"
#!include "buff/deathDelay.opy"
#!include "buff/konamiCode.opy"
#!include "buff/photonShield.opy"
#!include "buff/regroupCall.opy"
#!include "buff/willToWin.opy"
#!include "buff/pheidippidesTrial.opy"
#!include "buff/heartOfSteelPro.opy"
#!include "buff/ultMomentum.opy"
#!include "buff/phaseSurge.opy"
#!include "buff/bodyguard.opy"
#!include "buff/martyrTrial.opy"
#!include "buff/f5Refresh.opy"
#!include "buff/healingTowerPromax.opy"
#!include "buff/magicMaster.opy"
#!include "buff/divineReinforcement.opy"
#!include "buff/temperHeart.opy"
#!include "buff/battlefieldMedic.opy"
#!include "buff/sharedBlessing.opy"
#!include "buff/soloRun.opy"
#!include "buff/soloLevelUp.opy"
