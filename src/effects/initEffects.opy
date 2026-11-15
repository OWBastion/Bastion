#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "initialize effects":
    hashTag = not not hashTag
    wait(random.uniform(1, 2))
    setDifficulty()
    
    # --------------------------------------------------------------------------------------------------------------------------------
    # Player HUD (Left)
    # --------------------------------------------------------------------------------------------------------------------------------
    # 增益 · 减益 · 总计
    hudSubheader(localPlayer if localPlayer.settlementCardEnd == null else null, STR_HUD_STATS_EVENT.format(localPlayer.eventCount[EventType.BUFF], localPlayer.eventCount[EventType.DEBUFF], localPlayer.eventCount[EventType.BUFF] + localPlayer.eventCount[EventType.DEBUFF] + localPlayer.eventCount[EventType.MECH]), HudPosition.LEFT, 4, rgb(160, 169, 186), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)

    # 属性行
    hudSubheader(localPlayer if localPlayer.settlementCardEnd == null else null, STR_HUD_ATTR_PANEL.format(
        round(localPlayer.heart_steel[HeartSteelData.STACKS]),
        localPlayer.mod_speed_perma,
        negToPos(localPlayer.mod_dmg_perma),
        localPlayer.mod_heal_perma + localPlayer.mod_heal_event
    ), HudPosition.LEFT, 5, rgb(160, 169, 186), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)

    # --------------------------------------------------------------------------------------------------------------------------------
    # 个人事件详情 (顶部中央底部): 排在 assignPlayerEvent 的 HUD_PAD_BOTTOM 状态行 (TOP 20) 之后
    # --------------------------------------------------------------------------------------------------------------------------------
    hudText(
        null if localPlayer.eventId == -1 or localPlayer.settlementCardEnd != null else localPlayer,
        null,
        null,
        STR_HUD_EVENT_TITLE.format(
            abilityIconString(Hero.SOMBRA, Button.ULTIMATE) if localPlayer.eventType == EventType.DEBUFF else abilityIconString(Hero.ZENYATTA, Button.ABILITY_1),
            eventName[localPlayer.eventId],
            STR_TIME_UNIT_SEC.format(localPlayer.eventDurationHud) if eventDuration[localPlayer.eventId] > 0 else STR_MSG_DURATION_INSTANT
        ),
        HudPosition.TOP, 3, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    hudText(
        null if localPlayer.eventId == -1 or localPlayer.settlementCardEnd != null else localPlayer,
        null,
        null,
        eventDesc[localPlayer.eventId],
        HudPosition.TOP, 4, Color.WHITE, Color.WHITE, rgb(255, 255, 255, 255), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    # --------------------------------------------------------------------------------------------------------------------------------
    # 自选事件三选一 (顶部中央)：与事件详情互斥（仅 eventId == -1 时有候选），沿用同一排序区间
    # --------------------------------------------------------------------------------------------------------------------------------
    hudText(
        null if len(localPlayer.eventOffer) == 0 or localPlayer.settlementCardEnd != null else localPlayer,
        STR_HUD_EVENT_OFFER_TITLE.format(localPlayer.eventPickPending),
        null,
        STR_HUD_EVENT_OFFER_HINT.format(inputBindingString(Button.INTERACT), inputBindingString(Button.PRIMARY_FIRE), inputBindingString(Button.SECONDARY_FIRE), inputBindingString(Button.RELOAD)),
        HudPosition.TOP, 3, rgb(36, 205, 244), Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    hudText(
        null if len(localPlayer.eventOffer) < 1 or localPlayer.settlementCardEnd != null else localPlayer,
        STR_HUD_EVENT_OFFER_ENTRY.format(inputBindingString(Button.PRIMARY_FIRE), eventName[localPlayer.eventOffer[0]]),
        null,
        eventDesc[localPlayer.eventOffer[0]],
        HudPosition.TOP, 4, Color.WHITE, Color.WHITE, rgb(255, 255, 255, 255), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    hudText(
        null if len(localPlayer.eventOffer) < 2 or localPlayer.settlementCardEnd != null else localPlayer,
        STR_HUD_EVENT_OFFER_ENTRY.format(inputBindingString(Button.SECONDARY_FIRE), eventName[localPlayer.eventOffer[1]]),
        null,
        eventDesc[localPlayer.eventOffer[1]],
        HudPosition.TOP, 5, Color.WHITE, Color.WHITE, rgb(255, 255, 255, 255), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    hudText(
        null if len(localPlayer.eventOffer) < 3 or localPlayer.settlementCardEnd != null else localPlayer,
        STR_HUD_EVENT_OFFER_ENTRY.format(inputBindingString(Button.RELOAD), eventName[localPlayer.eventOffer[2]]),
        null,
        eventDesc[localPlayer.eventOffer[2]],
        HudPosition.TOP, 6, Color.WHITE, Color.WHITE, rgb(255, 255, 255, 255), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )

    # --------------------------------------------------------------------------------------------------------------------------------
    # Goal Effects
    # --------------------------------------------------------------------------------------------------------------------------------
    wait(0.5)
    goalPointEffects()
        
    # --------------------------------------------------------------------------------------------------------------------------------
    # Mode Info (Top/Right HUD)
    # --------------------------------------------------------------------------------------------------------------------------------
    wait(0.5)
    # 欢迎信息
    hudSubheader(getAllPlayers(), "{0} | {1}".format(STR_MODE_CODE, STR_HUD_FOOTER_INFO), HudPosition.TOP, 1, rgb(255, 255, 255, 125), HudReeval.VISIBILITY_AND_STRING)

    # 地图 · 难度
    hudSubtext([player for player in getAllPlayers() if player.settlementCardEnd == null], "{0} · {1}".format(getCurrentMap() if __currentMapText___ == null else __currentMapText___, difficultyText[0]), HudPosition.RIGHT, -6, difficultyText[1], HudReeval.VISIBILITY_STRING_AND_COLOR)

    # 模式版本
    hudSubheader([player for player in getAllPlayers() if player.settlementCardEnd == null], "{0} {1}".format(STR_HUD_VERSION, VERSION), HudPosition.RIGHT, -5, Color.GRAY, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)

    # 运行时信息
    hudSubheader([player for player in getAllPlayers() if player.settlementCardEnd == null], "{0}\n{1}".format(
        STR_HUD_AUTO_RESTART.format(hhmmss(max(0, rebootTime - getTotalTimeElapsed()))),
        STR_HUD_SERVER_UPTIME.format(hhmmss(getTotalTimeElapsed()))
    ), HudPosition.RIGHT, -4, Color.YELLOW if rebootTime - getTotalTimeElapsed() <= 600 else Color.GRAY, HudReeval.VISIBILITY_STRING_AND_COLOR)
    hudSubheader([player for player in getAllPlayers() if player.settlementCardEnd == null], STR_HUD_SERVER_LOAD.format(getAverageServerLoad()), HudPosition.RIGHT, -2, Color.GRAY, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    
    # --------------------------------------------------------------------------------------------------------------------------------
    # World Effects
    # --------------------------------------------------------------------------------------------------------------------------------
    creditsPointEffects()
    wait(0.5)
    
    # 3rd person camera
    interactionPointEffects()
