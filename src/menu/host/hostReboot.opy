#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[DevTool] ..." 前缀不变
#!rulePrefix "DevTool"

rule "Extend reboot timer":
    @Event eachPlayer
    @Condition eventPlayer.menu == 1
    @Condition (eventPlayer.isDev or hostPlayer == eventPlayer) == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true


    if rebootTime + 300 <= 15900 and __currentMap___ != Map.AYUTTHAYA:
        rebootTime += 300
        if eventPlayer.isDev:
            smallMessage(getPlayers(Team.1).filter(lambda player: player.isDev), "  {0}  开发者模式： 已将自动重开时间延长 {1} 分钟".format(iconString(Icon.BOLT), 300 / 60))
        else:
            smallMessage(getAllPlayers(), "  {0}  模式调整： 房主已将自动重开时间延长 {1} 分钟".format(iconString(Icon.BOLT), 300 / 60))
    else:
        smallMessage(eventPlayer, "  {0}  已达到最大上限".format(iconString(Icon.WARNING)))


rule "Reduce reboot timer":
    @Event eachPlayer
    @Condition eventPlayer.menu == 1
    @Condition (eventPlayer.isDev or hostPlayer == eventPlayer) == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true

    #wait(0.16, Wait.ABORT_WHEN_FALSE)
    if rebootTime - 300 >= 300 and __currentMap___ != Map.AYUTTHAYA:
        rebootTime -= 300
        if eventPlayer.isDev:
            smallMessage(getPlayers(Team.1).filter(lambda player: player.isDev), "  {0}  开发者模式： 已将自动重开时间缩短 {1} 分钟".format(iconString(Icon.BOLT), 300 / 60))
        else:
            smallMessage(getAllPlayers(), "  {0}  模式调整： 房主已将自动重开时间缩短 {1} 分钟".format(iconString(Icon.BOLT), 300 / 60))
