#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/轨道投射"

# Event: DebuffEventId.ORBITAL_STRIKE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。
#
# 复用堡垒既有炮击链路：堡垒常驻的 startFacing(directionTowards(eye, aimPosition), ...) 持续追踪
# playervar aimPosition；本事件仅将 aimPosition 钉在锁定位置，并用与 "Pulse secondary fire" 相同的
# forceButtonPress(Button.SECONDARY_FIRE) 发射榴弹，伤害/处决判定全部走既有规则。
# bastion.eventMission 在本文件中被借用为“瞄准接管截止时间戳”（> getTotalTimeElapsed() 时，
# bastion/init.opy 的 "Update aim point" / "Pre-aim nearest target" 跳过覆写 aimPosition）；
# 正常释放时置 0，驱动方异常中断时该时间戳自动过期，堡垒 AI 自行恢复，不会永久劫持。

rule "Lock position and strike":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.DEBUFF, eventPlayer.eventId == DebuffEventId.ORBITAL_STRIKE, eventPlayer.isAlive()]) == true

    # 锁定当前位置，落点不再追踪玩家
    eventPlayer.tempAimPosition = eventPlayer.getPosition()
    # 挑选离锁定位置最近且未被其他轨道投射占用的存活堡垒
    eventPlayer.temp = [bot for bot in getPlayers(Team.2) if bot.isDummy() == true and bot.isAlive() == true and bot.getHero() == Hero.BASTION and bot.eventMission <= getTotalTimeElapsed()]
    if len(eventPlayer.temp) == 0:
        goto lbl_0
    eventPlayer.target = sorted(eventPlayer.temp, lambda bot: distance(bot, eventPlayer.tempAimPosition))[0]

    # 接管该堡垒瞄准（挂起自动覆写 aimPosition），并给出地面预警
    eventPlayer.target.eventMission = getTotalTimeElapsed() + EVT_DEBUFF_24_RESERVE_TIME
    eventPlayer.target.aimPosition = eventPlayer.tempAimPosition
    createEffect(getAllPlayers(), Effect.RING, Color.TEAM_2, eventPlayer.tempAimPosition, EVT_DEBUFF_24_WARNING_RADIUS, EffectReeval.NONE)
    eventPlayer.eventEffect[0] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.TEAM_2, eventPlayer.tempAimPosition, EVT_DEBUFF_24_WARNING_RADIUS, EffectReeval.NONE)
    eventPlayer.eventEffect[1] = getLastCreatedEntity()
    wait(EVT_DEBUFF_24_WARNING_TIME)

    destroyEffect(eventPlayer.eventEffect[0])
    eventPlayer.eventEffect[0] = null
    destroyEffect(eventPlayer.eventEffect[1])
    eventPlayer.eventEffect[1] = null
    # 炮击落在锁定位置；堡垒死亡则本轮跳过。榴弹冷却与事件节奏不一致，
    # 预警已给出却落空会误导玩家，故对齐 resetPlayerCD 的做法重置右键冷却再开火。
    # target 在 wait 窗口内可能被其他事件改写（如 PHOTON_SHIELD 会覆写全体 Team.1 的 target），
    # 仅当目标仍是本事件接管中的堡垒（接管时间戳仍未过期）时才开火并解除接管。
    if all([eventPlayer.target != null, eventPlayer.target.isDummy() == true, eventPlayer.target.eventMission > getTotalTimeElapsed()]) == true:
        if eventPlayer.target.isAlive() == true:
            eventPlayer.target.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
            eventPlayer.target.forceButtonPress(Button.SECONDARY_FIRE)
        eventPlayer.target.eventMission = 0
    eventPlayer.target = null

    lbl_0:
    wait(EVT_DEBUFF_24_LOCK_INTERVAL - EVT_DEBUFF_24_WARNING_TIME)
    if ruleCondition:
        loop()
    # 兜底收尾（中途 abort 时由 clearEventEffect 与 eventMission 过期机制接管）
    if all([eventPlayer.target != null, eventPlayer.target.isDummy() == true, eventPlayer.target.eventMission > getTotalTimeElapsed()]) == true:
        eventPlayer.target.eventMission = 0
    eventPlayer.target = null
