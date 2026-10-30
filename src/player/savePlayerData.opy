#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine savePlayerData

def savePlayerData():
    @Name "save player data if the player has pa\ufeffssed round 2"
    
    waitLoadShort()
    if eventPlayer.heroNumber > 2:
        #We're saving data as a string, because although we can't hold entity id's, we can hold entity names as string.
        if not eventPlayer.inSaved(savedIndex):
            savedIndex.append(eventPlayer.key)
        eventPlayer.savedDataIndex = eventPlayer.savedIndex(savedIndex)
        wait(eventPlayer.getSlot() * 0.032 + random.uniform(1, 2) * 0.5)
        savedData.savedHero[eventPlayer.savedDataIndex] = eventPlayer.heroNumber
        waitLoadShort()
        savedData.savedDeaths[eventPlayer.savedDataIndex] = eventPlayer.runDeathCount
        waitLoadShort()
        savedData.savedWinner[eventPlayer.savedDataIndex] = eventPlayer.isWinner
        waitLoadShort()
        savedData.savedSkipCount[eventPlayer.savedDataIndex] = eventPlayer.skipCount
        waitLoadShort()
        if not eventPlayer.winnerTime:
            goto lbl_0
        savedData.savedWinnerTime[eventPlayer.savedDataIndex] = eventPlayer.winnerTime
        lbl_0:
        waitLoadShort()
        savedData.savedPlayerOnceEventState[eventPlayer.savedDataIndex] = eventPlayer.playerOnceEventState.slice(0, PLAYER_ONCE_EVENT_SLOT_COUNT) if eventPlayer.playerOnceEventState != null else DEFAULT_PLAYER_ONCE_EVENT_STATE.slice(0, PLAYER_ONCE_EVENT_SLOT_COUNT)
        savedData.savedJoinTime[eventPlayer.savedDataIndex] = eventPlayer.joinTime
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
    @Condition not eventPlayer.isWinner
    
    wait(0.5 * getServerLoad() / 100)
    eventPlayer.runDeathCount++
    if eventPlayer in savedIndex:
        waitTick2()
        savedData.savedDeaths[eventPlayer.savedIndex(savedIndex)] = eventPlayer.runDeathCount
    eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), endPosition.getPosition() if not controlRespawnPosition else controlJumpPosition[0].getPosition()), Relativity.TO_WORLD)
