#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Title"

rule "Initialize title colors":
    rgbList = [vect(255, 0, 0), vect(255, 165, 0), vect(255, 255, 0), vect(0, 255, 0), vect(0, 0, 255), vect(75, 0, 130), vect(238, 130, 238)]

# 称号当前颜色：titleCycleAB = [起点 A, 位移 B−A]，按三角波在两端点间往返，
# 单程 2.5s 与原 chaseOverTime 段速一致；delta=0 的单色称号退化为静态色
macro Player.titleCyclePhase = 1 - abs(((getTotalTimeElapsed() - self.titleCycleT0) / 2.5) % 2 - 1)
macro Player.titleColorNow = rgb(
    self.titleCycleAB[0].x + self.titleCycleAB[1].x * self.titleCyclePhase,
    self.titleCycleAB[0].y + self.titleCycleAB[1].y * self.titleCyclePhase,
    self.titleCycleAB[0].z + self.titleCycleAB[1].z * self.titleCyclePhase)

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
