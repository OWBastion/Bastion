#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine progressHero

def progressHero():
    @Name "add 1 to heroNumber, switch player to the newly unlocked hero, and set hero availability to that hero and all preceding"
    
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
    wait(getServerLoad() / 100 * 0.5)
    eventPlayer.setAllowedHeroes(heroList.slice(0, eventPlayer.heroNumber + 1))
    wait(getServerLoad() / 100 * 0.5)
    wait(getServerLoad() / 100 * 0.5)
    wait(3)
    savePlayerData()
    wait(0.1)
