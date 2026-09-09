#!mainFile "../main.opy"

#!optimizeStrict

rule "Initialize CN title effects":
    # 成就禁用
    hudSubheader(null if hashTag else localPlayer, STR_HUD_ACHIEVEMENT_DISABLED.format(iconString(Icon.WARNING)), HudPosition.LEFT, 5, rgb(160, 169, 186), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)


    # 成就挑战
    hudSubheader(
    localPlayer if (hashTag == true and len(localPlayer.earnedAchievements) > 0 and len(titleText) > 43) else null,
        "\r\n{0}".format(
            "{0}{1}{2}".format(
                # 第1行
                "{0} {1}".format(
                    titleText[localPlayer.earnedAchievements[0]],
                    iconString(Icon.CHECKMARK)
                ),

                # 第2行
                ("\r\n{0} {1}".format(
                    titleText[localPlayer.earnedAchievements[1]],
                    iconString(Icon.CHECKMARK)
                ) if len(localPlayer.earnedAchievements) > 1 else ""),

                # 第3~8行：用嵌套拼接来突破参数限制
                (
                    "\r\n{0} {1}{2}".format(
                        titleText[localPlayer.earnedAchievements[2]],
                        iconString(Icon.CHECKMARK),

                        "{0}{1}".format(
                            # 第4行
                            ("\r\n{0} {1}".format(
                                titleText[localPlayer.earnedAchievements[3]],
                                iconString(Icon.CHECKMARK)
                            ) if len(localPlayer.earnedAchievements) > 3 else ""),

                            "{0}{1}".format(
                                # 第5行
                                ("\r\n{0} {1}".format(
                                    titleText[localPlayer.earnedAchievements[4]],
                                    iconString(Icon.CHECKMARK)
                                ) if len(localPlayer.earnedAchievements) > 4 else ""),

                                "{0}{1}".format(
                                    # 第6行
                                    ("\r\n{0} {1}".format(
                                        titleText[localPlayer.earnedAchievements[5]],
                                        iconString(Icon.CHECKMARK)
                                    ) if len(localPlayer.earnedAchievements) > 5 else ""),

                                    "{0}{1}".format(
                                        # 第7行
                                        ("\r\n{0} {1}".format(
                                            titleText[localPlayer.earnedAchievements[6]],
                                            iconString(Icon.CHECKMARK)
                                        ) if len(localPlayer.earnedAchievements) > 6 else ""),

                                        # 第8行
                                        ("\r\n{0} {1}".format(
                                            titleText[localPlayer.earnedAchievements[7]],
                                            iconString(Icon.CHECKMARK)
                                        ) if len(localPlayer.earnedAchievements) > 7 else "")
                                    )
                                )
                            )
                        )
                    ) if len(localPlayer.earnedAchievements) > 2 else ""
                )
            )
        ),
        HudPosition.LEFT,
        100,
        rgb(heroColor[5].x, heroColor[5].y, heroColor[5].z),
        HudReeval.VISIBILITY_AND_STRING
    )
