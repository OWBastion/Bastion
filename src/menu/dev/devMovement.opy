#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[DevTool] ..." 前缀不变
#!rulePrefix "DevTool"

#!define MENU_DEV_MOVEMENT_TITLE(viewer) (STR_MENU_TITLE_DEV_PANEL)
#!define MENU_DEV_MOVEMENT_BODY(viewer) (STR_MENU_OPT_AIR_WALK.format(inputBindingString(Button.PRIMARY_FIRE), STR_MENU_STATE_ON if viewer.isAirWalkEnabled else STR_MENU_STATE_OFF, STR_MENU_OPT_NOCLIP.format(inputBindingString(Button.SECONDARY_FIRE), STR_MENU_STATE_ON if viewer.isPortalEnabled else STR_MENU_STATE_OFF, STR_MENU_OPT_SELECT_INDEX.format(inputBindingString(Button.ABILITY_1), viewer.controlCenterIndex, STR_MENU_OPT_TP_TO_INDEX.format(inputBindingString(Button.ABILITY_2), STR_MENU_OPT_NEXT_PAGE.format(inputBindingString(Button.CROUCH)))))))

rule "Toggle air walk":
    @Event eachPlayer
    @Condition eventPlayer.isDev
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition eventPlayer.menu == MENU_PAGE_DEV_MOVEMENT

    if eventPlayer.isAirWalkEnabled:
        goto lbl_0
    eventPlayer.setGravity(0)
    eventPlayer.isAirWalkEnabled = true
    smallMessage(eventPlayer, "  {0}  开发者模式： 已开启浮空".format(iconString(Icon.BOLT)))
    return
    lbl_0:
    eventPlayer.setGravity(eventPlayer.eventTempIndex if (eventPlayer.eventId == EventId.GRAVITY_ANOMALY and eventPlayer.eventMission != 0) else 100)
    eventPlayer.isAirWalkEnabled = false
    smallMessage(eventPlayer, "  {0}  开发者模式： 已关闭浮空".format(iconString(Icon.BOLT)))


rule "Hold air position":
    @Event eachPlayer
    @Condition eventPlayer.isDev
    @Condition eventPlayer.isAirWalkEnabled
    @Condition eventPlayer.getThrottle() == vect(0, 0, 0)
    @Condition not eventPlayer.isHoldingButton(Button.JUMP)
    @Condition not eventPlayer.isHoldingButton(Button.CROUCH)

    eventPlayer.applyImpulse(Vector.UP, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    eventPlayer.applyImpulse(negToPos(eventPlayer.getVelocity()), 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)


rule "Toggle noclip":
    @Event eachPlayer
    @Condition eventPlayer.isDev
    @Condition eventPlayer.menu == MENU_PAGE_DEV_MOVEMENT
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    if eventPlayer.isPortalEnabled:
        goto lbl_0
    eventPlayer.isPortalEnabled = true
    smallMessage(eventPlayer, "  {0}  开发者模式： 已开启穿墙".format(iconString(Icon.BOLT)))
    return
    lbl_0:
    eventPlayer.isPortalEnabled = false
    smallMessage(eventPlayer, "  {0}  开发者模式： 已关闭穿墙".format(iconString(Icon.BOLT)))


rule "Step noclip":
    @Event eachPlayer
    @Condition eventPlayer.isDev
    @Condition eventPlayer.menu == 0
    @Condition eventPlayer.isPortalEnabled
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition not eventPlayer.isCommunicatingEmote()
    @Condition (getCurrentMap() == Map.HORIZON_LUNAR_COLONY and distance(eventPlayer, vect(-9.38, 8.74, 2.05)) < 1) == false

    eventPlayer.setGravity(abs(0))
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        goto lbl_0
    eventPlayer.teleport(eventPlayer.getPosition() + eventPlayer.getFacingDirection() * 4)
    goto lbl_1
    lbl_0:
    eventPlayer.teleport(eventPlayer.getPosition() + eventPlayer.getFacingDirection() * 20)
    lbl_1:
    wait(0.16)
    if ruleCondition:
        loop()
    if eventPlayer.isAirWalkEnabled:
        return
    eventPlayer.setGravity(abs(eventPlayer.eventTempIndex if (eventPlayer.eventId == EventId.GRAVITY_ANOMALY and eventPlayer.eventMission != 0) else 100))


rule "Cycle control point":
    @Event eachPlayer
    @Condition eventPlayer.isDev
    @Condition eventPlayer.menu == MENU_PAGE_DEV_MOVEMENT
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)

    if not controlCenterPosition:
        smallMessage(eventPlayer, "  {0}  开发者模式： 目标点坐标为空".format(iconString(Icon.BOLT)))
        return
    else:
        if eventPlayer.controlCenterIndex >= 2:
            goto lbl_0
        eventPlayer.controlCenterIndex++
        smallMessage(eventPlayer, "  {0}  开发者模式： 已选择目标点坐标：{1}".format(iconString(Icon.BOLT), controlCenterPosition[eventPlayer.controlCenterIndex]))
        return
        lbl_0:
        eventPlayer.controlCenterIndex = 0
        smallMessage(eventPlayer, "  {0}  开发者模式： 已选择目标点坐标：{1}".format(iconString(Icon.BOLT), controlCenterPosition[eventPlayer.controlCenterIndex]))


rule "Teleport to control point":
    @Event eachPlayer
    @Condition eventPlayer.isDev
    @Condition eventPlayer.menu == MENU_PAGE_DEV_MOVEMENT
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition controlCenterPosition

    eventPlayer.teleport(nearestWalkablePosition(controlCenterPosition[eventPlayer.controlCenterIndex]))
