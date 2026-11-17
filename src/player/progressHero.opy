#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine progressHero

def progressHero():
    @Name "add 1 to heroNumber, switch player to the newly unlocked hero, and set hero availability to that hero and all preceding"
    
    eventPlayer.eventCompatibleBasePool = null
    eventPlayer.heroNumber++
    eventPlayer.controlJumpIndex = 0
    eventPlayer.controlPlayerRespawnPosition = null
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer.getPosition(), 200)
    eventPlayer.progressionDeathCount = 0
    wait(0.032)
    eventPlayer.preloadHero(heroList[eventPlayer.heroNumber])
    eventPlayer.startForcingHero(heroList[eventPlayer.heroNumber])
    waitUntil(eventPlayer.getHero() == heroList[eventPlayer.heroNumber], 0.5)
    eventPlayer.stopForcingCurrentHero()

    # Set Ability Enabled 是玩家级覆盖标志，跨英雄切换保留且压过大厅设置；
    # 残留的 enable/disable 标志必须在这里按大厅配置重新断言，
    # 否则大厅禁用的技能（托比昂炮台/秩序之光哨戒炮/生命之梭生命之握）会被泄漏打开。
    eventPlayer.setAbility1Enabled(heroList[eventPlayer.heroNumber] not in [Hero.TORBJORN, Hero.SYMMETRA])
    eventPlayer.setAbility2Enabled(heroList[eventPlayer.heroNumber] != Hero.LIFEWEAVER or PROFILE_LIFEWEAVER_GRIP_ELIGIBLE(eventPlayer))
    eventPlayer.setAllowedHeroes(heroList.slice(0, eventPlayer.heroNumber + 1))
    eventPlayer.progressTailPending = true


# 收尾（事件池刷新、存档）与负载成正比且在事件激活前会阻塞，
# 不能留在调用方规则里，否则终点判定规则会在此期间无法处理下一次到达。
# 多名玩家同时通关时按槽位错开，并按负载放慢，避免事件池刷新同帧堆叠。
rule "Finish hero progression":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.progressTailPending == true

    eventPlayer.progressTailPending = false
    wait(eventPlayer.getSlot() * 0.032 + getServerLoad() * 0.005)
    refreshCompatibleEventPool()
    wait(getServerLoad() * 0.01)
    wait(3)
    savePlayerData()
    wait(0.1)
    if ruleCondition:
        loop()
