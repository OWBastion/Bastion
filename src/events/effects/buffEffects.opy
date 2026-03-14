#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Loop consistency note:
# Preferred sustained-loop template:
# action -> wait(cadence) -> if ruleCondition: loop() -> cleanup.
# Intentional exceptions keep waitUntil or event-split patterns where external
# lifecycle synchronization is required.

# Event effect index (generated): keep include order stable.
# 下线流程：1) 事件文件内 @Disabled + 注释；2) 移除 eventConfig/eventConfigDev 注册；3) 从此处移除 include。

#!include "by-event/buff/gale_blessing.opy"
#!include "by-event/buff/iron_bulwark.opy"
#!include "by-event/buff/adrenaline.opy"
#!include "by-event/buff/life_spring.opy"
#!include "by-event/buff/black_fans_assault.opy"
#!include "by-event/buff/speed_stack.opy"
#!include "by-event/buff/flesh_regen.opy"
#!include "by-event/buff/heart_of_steel.opy"
#!include "by-event/buff/death_delay.opy"
#!include "by-event/buff/symbiosis.opy"
#!include "by-event/buff/konami_code.opy"
#!include "by-event/buff/photon_shield.opy"
#!include "by-event/buff/regroup_call.opy"
#!include "by-event/buff/resolve.opy"
#!include "by-event/buff/will_to_win.opy"
#!include "by-event/buff/pheidippides_trial.opy"
#!include "by-event/buff/heart_of_steel_pro.opy"
#!include "by-event/buff/stat_power.opy"
#!include "by-event/buff/ult_momentum.opy"
#!include "by-event/buff/phase_surge.opy"
#!include "by-event/buff/bodyguard.opy"
#!include "by-event/buff/martyr_trial.opy"
#!include "by-event/buff/hyperactive_heal.opy"
#!include "by-event/buff/morale_boost_promax.opy"
#!include "by-event/buff/f5_refresh.opy"
#!include "by-event/buff/healing_tower_promax.opy"
#!include "by-event/buff/super_transform.opy"
#!include "by-event/buff/draw_fire.opy"
#!include "by-event/buff/tenacity.opy"
