#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Hero/Torbjorn"


# lobby 的"部署炮台: 关闭"在周年版本未生效（炮台仍可部署），运行时兜底禁用。
rule "Disable turret":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.getHero() == Hero.TORBJORN
    @Condition eventPlayer.isWinner != true

    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.setAbility1Enabled(false)
    waitUntil(eventPlayer.isWinner == true or eventPlayer.getHero() != Hero.TORBJORN, Math.INFINITY)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.setAbility1Enabled(true)
