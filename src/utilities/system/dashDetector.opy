#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "System"

rule "Enable phase trigger":
    @Event eachPlayer
    @Team 1
    @Condition vishkarEventActivated == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.eventType == EventType.BUFF
    @Condition eventPlayer.eventId == BuffEventId.PHASE_SURGE or eventPlayer.eventId == BuffEventId.BODYGUARD
    # 只有当它是 False 时才触发，避免重复触发
    @Condition eventPlayer.phaseState == false
    @Condition eventPlayer.usesPhaseTrigger() == true
    
    eventPlayer.phaseState = true
    # 强制维持至少 0.1 秒，确保事件规则能检测到
    wait(0.096)


rule "Disable phase trigger":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.phaseState == true
    # 当所有条件都不满足时
    @Condition eventPlayer.usesPhaseTrigger() == false
    
    wait()
    eventPlayer.phaseState = false
