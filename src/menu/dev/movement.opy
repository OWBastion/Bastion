#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[DevTool] ..." 前缀不变
#!rulePrefix "DevTool"

rule "Toggle air walk":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.menu == 3

    if eventPlayer.isAirWalkEnabled == true:
        goto lbl_0
    eventPlayer.setGravity(0)
    eventPlayer.isAirWalkEnabled = true
    smallMessage(eventPlayer, "  {0}  开发者模式： 已开启浮空".format(iconString(Icon.BOLT)))
    return
    lbl_0:
    eventPlayer.setGravity(100)
    eventPlayer.isAirWalkEnabled = false
    smallMessage(eventPlayer, "  {0}  开发者模式： 已关闭浮空".format(iconString(Icon.BOLT)))


rule "Hold air position":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.isAirWalkEnabled == true
    @Condition eventPlayer.getThrottle() == vect(0, 0, 0)
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false

    eventPlayer.applyImpulse(Vector.UP, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    eventPlayer.applyImpulse(negToPos(eventPlayer.getVelocity()), 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)


rule "Toggle noclip":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 3
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true

    if eventPlayer.isPortalEnabled == true:
        goto lbl_0
    eventPlayer.isPortalEnabled = true
    smallMessage(eventPlayer, "  {0}  开发者模式： 已开启穿墙".format(iconString(Icon.BOLT)))
    return
    lbl_0:
    eventPlayer.isPortalEnabled = false
    smallMessage(eventPlayer, "  {0}  开发者模式： 已关闭穿墙".format(iconString(Icon.BOLT)))


rule "Step noclip":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 0
    @Condition eventPlayer.isPortalEnabled == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isCommunicatingEmote() == false
    @Condition (getCurrentMap() == Map.HORIZON_LUNAR_COLONY and distance(eventPlayer, vect(-9.38, 8.74, 2.05)) < 1) == false

    eventPlayer.setGravity(abs(0))
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true:
        goto lbl_0
    eventPlayer.teleport(eventPlayer.getPosition() + eventPlayer.getFacingDirection() * 4)
    goto lbl_1
    lbl_0:
    eventPlayer.teleport(eventPlayer.getPosition() + eventPlayer.getFacingDirection() * 20)
    lbl_1:
    wait(0.16)
    if ruleCondition:
        loop()
    if eventPlayer.isAirWalkEnabled == true:
        return
    eventPlayer.setGravity(abs(100))


rule "Cycle control point":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 3
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true

    if controlCenterPosition == null:
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
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 3
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition controlCenterPosition != null

    eventPlayer.teleport(nearestWalkablePosition(controlCenterPosition[eventPlayer.controlCenterIndex]))
