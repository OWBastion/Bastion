#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "auto reboot":
    @Condition getTotalTimeElapsed() >= rebootTime - 60
    
    bigMessage(getAllPlayers(), STR_MSG_AUTO_RESTART_1MIN)
    wait(60)
    restartMatch()