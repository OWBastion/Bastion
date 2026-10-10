#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Title"

rule "Initialize title colors":
    rgbList = [vect(255, 0, 0), vect(255, 165, 0), vect(255, 255, 0), vect(0, 255, 0), vect(0, 0, 255), vect(75, 0, 130), vect(238, 130, 238)]
    # 与 breathPalette 同一机制原地展开为 140 档，供称号时间查表取色
    titlePaletteSrc = rgbList
    expandTitleCycleStops()
    rgbList = titlePaletteDest

# 称号当前颜色：按 (已运行时间 - 换色起点) 在稠密色板中查表。
# len=1 的单色称号经 % len 退化为静态色；140 档 = 2.5s/段 × 20 档 = 8Hz 步进
macro Player.titleColorNow = rgb(
    self.titleCycleStops[floor((getTotalTimeElapsed() - self.titleCycleT0) * 8) % len(self.titleCycleStops)].x,
    self.titleCycleStops[floor((getTotalTimeElapsed() - self.titleCycleT0) * 8) % len(self.titleCycleStops)].y,
    self.titleCycleStops[floor((getTotalTimeElapsed() - self.titleCycleT0) * 8) % len(self.titleCycleStops)].z)

rule "Create in-world title":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.playerTitleAndColor != null
    @Condition eventPlayer.titleTextID == null

    wait(eventPlayer.getSlot() * 0.08)

    createInWorldText(
        getAllPlayers(),
        "{0} {1}".format(
                abilityIconString(Hero.TORBJORN, Button.ABILITY_2) if eventPlayer.isDev else "",
                titleText[eventPlayer.playerTitleAndColor]
            ),
            eventPlayer,
            1 if eventPlayer.isDev else 0.8,
            Clip.NONE,
            WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
            eventPlayer.titleColorNow
        )
    eventPlayer.titleTextID = getLastCreatedText()
