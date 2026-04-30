#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "Juno disable Ability 1 if possess":
    @Event eachPlayer
    @Team 1
    @Disabled

    wait(0.032)
