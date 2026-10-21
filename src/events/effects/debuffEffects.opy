#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event effect index (generated): keep include order stable.
# 下线流程：1) 事件文件内 @Disabled + 注释；2) 移除 eventCatalog 注册与 EVENT_CATALOG_ORDER 顺序项；3) 从此处移除 include。

#!include "debuff/gravityAnomaly.opy"
#!include "debuff/emp.opy"
#!include "debuff/sacrifice.opy"
#!include "debuff/vulnerable.opy"
#!include "debuff/speedLimit40.opy"
#!include "debuff/gravityPull.opy"
#!include "debuff/osteoporosis.opy"
#!include "debuff/empPromax.opy"
#!include "debuff/energyLeak.opy"
#!include "debuff/shareThePain.opy"
#!include "debuff/feastFrenzy.opy"
#!include "debuff/powerlessSpouse.opy"
#!include "debuff/halved.opy"
#!include "debuff/selflessGiveaway.opy"
#!include "debuff/keepDistanceAura.opy"
#!include "debuff/moonRocket.opy"
#!include "debuff/waywardNavigation.opy"
#!include "debuff/overweightPack.opy"
#!include "debuff/adlersbrunnWraith.opy"
#!include "debuff/staticField.opy"
