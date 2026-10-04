#!mainFile "../../main.opy"

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
    # 附身中的技能锁由附身效果收尾时自行恢复，不在此重置。
    if eventPlayer.possess == null:
        eventPlayer.setAbility1Enabled(heroList[eventPlayer.heroNumber] not in [Hero.TORBJORN, Hero.SYMMETRA])
        eventPlayer.setAbility2Enabled(heroList[eventPlayer.heroNumber] != Hero.LIFEWEAVER or PROFILE_LIFEWEAVER_GRIP_ELIGIBLE(eventPlayer))
    wait(getServerLoad() / 100 * 0.5)
    eventPlayer.setAllowedHeroes(heroList.slice(0, eventPlayer.heroNumber + 1))
    refreshCompatibleEventPool()
    wait(getServerLoad() / 100 * 0.5)
    wait(getServerLoad() / 100 * 0.5)
    wait(3)
    savePlayerData()
    wait(0.1)
