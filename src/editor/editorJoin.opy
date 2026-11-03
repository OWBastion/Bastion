#!mainFile "../editorMain.opy"

#!optimizeStrict
#!rulePrefix "Editor"

rule "Initialize editor player":
    @Event playerJoined
    @Team 1

    eventPlayer.invincibleEffect = DEFAULT_INVINCIBLE_EFFECTS.slice(0, InvincibleEffectSlot.COUNT)
    initPlayerEventState()
    if eventPlayer.joinTime == null or eventPlayer.joinTime == 0:
        eventPlayer.joinTime = evalOnce(getTotalTimeElapsed())
    eventPlayer.dmgReduc = false
    eventPlayer.invincible = false
    eventPlayer.editorMode = 0
    eventPlayer.editorTool = 0
    eventPlayer.editorSelectedIndex = -1
    eventPlayer.editorAutoEvent = true
    eventPlayer.editorEventId = -1
    eventPlayer.hudText = ""
    hudText(eventPlayer, null, "{0}".format(HUD_PAD_BOTTOM), eventPlayer.hudText, HudPosition.TOP, 20, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.hudTextId = getLastCreatedText()


# 英雄来自房间设置；换英雄后刷新事件池，并按大厅配置重新断言技能可用性（与 progressHero 一致，清除粘性覆盖标志）。
rule "Refresh event pool when hero changes":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.getHero() != eventPlayer.editorHero

    eventPlayer.editorHero = eventPlayer.getHero()
    eventPlayer.setAbility1Enabled(eventPlayer.getHero() not in [Hero.TORBJORN, Hero.SYMMETRA])
    eventPlayer.setAbility2Enabled(eventPlayer.getHero() != Hero.LIFEWEAVER or PROFILE_LIFEWEAVER_GRIP_ELIGIBLE(eventPlayer))
    refreshCompatibleEventPool()
