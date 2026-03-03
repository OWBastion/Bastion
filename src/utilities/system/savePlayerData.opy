#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine savePlayerData

def savePlayerData():
    @Name "save player data if the player has pa\ufeffssed round 2"
    
    wait(getAverageServerLoad() / 100 * 0.5)
    if eventPlayer.heroNumber > 2:
        #We're saving data as a string, because although we can't hold entity id's, we can hold entity names as string.
        if not "{0}".format(eventPlayer) in savedIndex:
            savedIndex.append("{0}".format(eventPlayer))
        wait(eventPlayer.getSlot() * 0.032 + random.uniform(1, 2) * 0.5)
        savedHero[savedIndex.index("{0}".format(eventPlayer))] = eventPlayer.heroNumber
        wait(getAverageServerLoad() / 100 * 0.5)
        savedDeaths[savedIndex.index("{0}".format(eventPlayer))] = eventPlayer.runDeathCount
        wait(getAverageServerLoad() / 100 * 0.5)
        savedIsWinner[savedIndex.index("{0}".format(eventPlayer))] = eventPlayer.isWinner
        wait(getAverageServerLoad() / 100 * 0.5)
        savedSkipCount[savedIndex.index("{0}".format(eventPlayer))] = eventPlayer.skipCount
        wait(getAverageServerLoad() / 100 * 0.5)
        if eventPlayer.winnerTime == null:
            goto lbl_0
        savedWinnerTime[savedIndex.index("{0}".format(eventPlayer))] = eventPlayer.winnerTime
        lbl_0:
        wait(getAverageServerLoad() / 100 * 0.5)
        savedA36TGrenadeAlive[savedIndex.index("{0}".format(eventPlayer))] = eventPlayer.A36TGrenadeAlive
        savedJoinTime[savedIndex.index("{0}".format(eventPlayer))] = eventPlayer.joinTime
        smallMessage(eventPlayer, STR_MSG_PROGRESS_SAVED)

        wait(2)

        # 如果是主机玩家，提示重开清空
        if eventPlayer == hostPlayer:
            smallMessage(hostPlayer, STR_MSG_HOST_WARNING_RESET)

        wait(2)

        # 随机提示赞赏等级
        if random.randint(0, 2) == 0:
            smallMessage(eventPlayer, STR_MSG_HOST_ENDORSEMENT_HINT)

rule "player deaths are counted manually rather than relying on in-game statistics":
    @Event playerDied
    @Team 1
    @Condition eventPlayer.isWinner == false
    
    wait(0.5 * getServerLoad() / 100)
    eventPlayer.runDeathCount++
    if eventPlayer in savedIndex:
        wait(0.032)
        savedDeaths[savedIndex.index("{0}".format(eventPlayer))] = eventPlayer.runDeathCount
    eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), endPosition.getPosition() if controlRespawnPosition == null else controlJumpPosition[0].getPosition()), Relativity.TO_WORLD)
