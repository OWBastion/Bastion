#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine unlockAchievement

macro Player.unlockAchievement(titleId):
    eventPlayer.tempUnlockId = titleId
    unlockAchievement()

def unlockAchievement():
    @Name "Subroutine: UnlockAchievement"

    if hashTag == false or eventPlayer.tempUnlockId == null or eventPlayer.tempUnlockId in eventPlayer.earnedAchievements:
        return

    eventPlayer.earnedAchievements.append(eventPlayer.tempUnlockId)

    playEffect(eventPlayer, DynamicEffect.GOOD_EXPLOSION, Color.AQUA, eventPlayer, 10)

    if eventPlayer.key not in titlePlayer:
        goto lb_1
    eventPlayer.playerTitles.append(eventPlayer.tempUnlockId)

    lb_1:
    smallMessage(eventPlayer, "  {0}  已解锁成就：{1}".format(iconString(Icon.CHECKMARK), allTitle[eventPlayer.tempUnlockId]))
