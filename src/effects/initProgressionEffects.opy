#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "initialize progression effects":
    wait(random.uniform(1, 2))

    # 下一个英雄
    hudText(null if localPlayer.isWinner or localPlayer.getHero() != heroList[localPlayer.heroNumber] or localPlayer.settlementCardEnd != null else localPlayer, " ", STR_HUD_NEXT_HERO, "{0} {1}".format(heroIcon(heroList[localPlayer.heroNumber + 1]) if localPlayer.heroNumber + 1 < len(heroList) else iconString(Icon.FLAG), heroList[localPlayer.heroNumber + 1] if localPlayer.heroNumber + 1 < len(heroList) else STR_HUD_ESCAPED), HudPosition.LEFT, 2, rgb(36, 205, 244), Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)

    hudText(null if localPlayer.isWinner or localPlayer.getHero() == heroList[localPlayer.heroNumber] or localPlayer.settlementCardEnd != null else localPlayer, iconString(Icon.NO), STR_HUD_NEXT_HERO, STR_HUD_UNLOCKED.format(heroIcon(heroList[localPlayer.heroNumber])), HudPosition.LEFT, 2, rgb(235, 45, 79), rgb(235, 45, 79), rgb(235, 45, 79), HudReeval.VISIBILITY_AND_STRING)

    hudText(localPlayer if localPlayer.isWinner and localPlayer.settlementCardEnd == null else null, iconString(Icon.CHECKMARK), STR_HUD_NEXT_HERO, STR_HUD_CHALLENGE_COMPLETE, HudPosition.LEFT, 2, Color.GREEN, Color.GREEN, Color.GREEN, HudReeval.VISIBILITY_AND_STRING)

    # 英雄 x/y · 阵亡 x/y
    hudSubheader(localPlayer if localPlayer.heroNumber + 1 < len(heroList) and localPlayer.getHero() == heroList[localPlayer.heroNumber] and localPlayer.settlementCardEnd == null else null, STR_HUD_STATS_HERO_DEATH.format(heroList.index(localPlayer.getHero()) + 1, len(heroList), localPlayer.progressionDeathCount, maxDeath if difficulty != 5 else "∞"), HudPosition.LEFT, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)

    # 跳过提示
    hudSubheader(localPlayer if difficulty != 5 and localPlayer.progressionDeathCount == maxDeath and localPlayer.settlementCardEnd == null else null, STR_HUD_SKIP_HINT.format(inputBindingString(Button.ULTIMATE)), HudPosition.LEFT, 6, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)

    # --------------------------------------------------------------------------------------------------------------------------------
    # 通关结算卡 (顶部中央, 仅本人, settlementCardEnd 期间显示)
    # --------------------------------------------------------------------------------------------------------------------------------
    hudHeader(
        localPlayer if localPlayer.settlementCardEnd != null else null,
        STR_HUD_CARD_TITLE.format(hhmmss(localPlayer.winnerTime)),
        HudPosition.TOP, 6, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )

    hudSubheader(
        localPlayer if localPlayer.settlementCardEnd != null else null,
        STR_HUD_CARD_PLAYER.format(localPlayer, masteryRunCode),
        HudPosition.TOP, 7, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )

    hudSubheader(
        localPlayer if localPlayer.settlementCardEnd != null else null,
        STR_HUD_CARD_MAP.format(getCurrentMap() if __currentMapText___ == null else __currentMapText___, difficultyText[0], VERSION),
        HudPosition.TOP, 8, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )

    hudSubheader(
        localPlayer if localPlayer.settlementCardEnd != null else null,
        STR_HUD_CARD_STATS.format(localPlayer.runDeathCount, localPlayer.skipCount),
        HudPosition.TOP, 9, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )

    hudSubheader(
        localPlayer if localPlayer.settlementCardEnd != null else null,
        STR_HUD_CARD_TITLES.format(
            STR_HUD_ACHIEVEMENT_DISABLED.format(iconString(Icon.WARNING)) if hashTag == false else ("{0}{1}{2}".format(
                titleText[localPlayer.earnedAchievements[0]],
                " · {0}".format(titleText[localPlayer.earnedAchievements[1]]) if len(localPlayer.earnedAchievements) > 1 else "",
                "{0}{1}".format(
                    " · {0}".format(titleText[localPlayer.earnedAchievements[2]]) if len(localPlayer.earnedAchievements) > 2 else "",
                    "{0}{1}".format(
                        " · {0}".format(titleText[localPlayer.earnedAchievements[3]]) if len(localPlayer.earnedAchievements) > 3 else "",
                        "{0}{1}".format(
                            " · {0}".format(titleText[localPlayer.earnedAchievements[4]]) if len(localPlayer.earnedAchievements) > 4 else "",
                            "{0}{1}".format(
                                " · {0}".format(titleText[localPlayer.earnedAchievements[5]]) if len(localPlayer.earnedAchievements) > 5 else "",
                                "{0}{1}".format(
                                    " · {0}".format(titleText[localPlayer.earnedAchievements[6]]) if len(localPlayer.earnedAchievements) > 6 else "",
                                    " · {0}".format(titleText[localPlayer.earnedAchievements[7]]) if len(localPlayer.earnedAchievements) > 7 else ""
                                )
                            )
                        )
                    )
                )
            ) if localPlayer.earnedAchievements != null and len(localPlayer.earnedAchievements) > 0 else "—")
        ),
        HudPosition.TOP, 10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )

    hudSubheader(
        localPlayer if localPlayer.settlementCardEnd != null else null,
        STR_HUD_CARD_COUNTDOWN.format(ceil(localPlayer.settlementCardEnd - getTotalTimeElapsed()) if localPlayer.settlementCardEnd != null else 0),
        HudPosition.TOP, 11, rgb(160, 169, 186), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )

    if controlJumpPosition != null and portalPosition == null:
        hudSubtext([player for player in getAllPlayers() if player.settlementCardEnd == null], STR_HUD_WELCOME_MULTI.format(maxDeath) if difficulty != 5 else STR_HUD_WELCOME_MULTI_HARD, HudPosition.TOP, 0, rgb(255, 255, 255, 125), HudReeval.VISIBILITY_AND_STRING)
    else:
        hudSubtext([player for player in getAllPlayers() if player.settlementCardEnd == null], STR_HUD_WELCOME_NORMAL.format(maxDeath) if difficulty != 5 else STR_HUD_WELCOME_NORMAL_HARD, HudPosition.TOP, 0, rgb(255, 255, 255, 125), HudReeval.VISIBILITY_AND_STRING)

    # --------------------------------------------------------------------------------------------------------------------------------
    # Progression World Effects
    # --------------------------------------------------------------------------------------------------------------------------------
    wait(0.5)
    # reset progress ring
    createEffect(localPlayer if localPlayer.heroNumber > 0 or localPlayer.runDeathCount > 0 else null, Effect.RING, Color.RED, resetPosition, 1.2, EffectReeval.VISIBILITY)
    createInWorldText(localPlayer if localPlayer.heroNumber > 0 or localPlayer.runDeathCount > 0 else null, STR_WORLD_RESET_PROGRESS.format(iconString(Icon.ARROW_DOWN)), resetPosition + Vector.UP * 1.3, 1.2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
