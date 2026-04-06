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

#!include "buff/gale_blessing.opy"
#!include "buff/iron_bulwark.opy"
#!include "buff/adrenaline.opy"
#!include "buff/life_spring.opy"
#!include "buff/black_fans_assault.opy"
#!include "buff/speed_stack.opy"
#!include "buff/flesh_regen.opy"
#!include "buff/heart_of_steel.opy"
#!include "buff/death_delay.opy"
#!include "buff/symbiosis.opy"
#!include "buff/konami_code.opy"
#!include "buff/photon_shield.opy"
#!include "buff/regroup_call.opy"
#!include "buff/will_to_win.opy"
#!include "buff/pheidippides_trial.opy"
#!include "buff/heart_of_steel_pro.opy"
#!include "buff/stat_power.opy"
#!include "buff/ult_momentum.opy"
#!include "buff/phase_surge.opy"
#!include "buff/bodyguard.opy"
#!include "buff/martyr_trial.opy"
#!include "buff/hyperactive_heal.opy"
#!include "buff/morale_boost_promax.opy"
#!include "buff/f5_refresh.opy"
#!include "buff/healing_tower_promax.opy"
#!include "buff/super_transform.opy"
#!include "buff/draw_fire.opy"
#!include "buff/magic_master.opy"
#!include "buff/gambler_heart_of_steel.opy"
