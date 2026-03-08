#!mainFile "../../main.opy"


#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

#!define HEALTH_POOL_CLEANUP_MAX_REMOVALS 6
#!define HEALTH_POOL_WAIT_MIN 0.496
#!define HEALTH_POOL_WAIT_MAX 0.96
#!define HEALTH_POOL_WAIT_LOAD_MIN 85
#!define HEALTH_POOL_WAIT_LOAD_MAX 115


rule "Logic: Health Pool Cleaner":
    @Event eachPlayer
    @Team 1
    @Condition len(eventPlayer.hp_data) > 0
    
    eventPlayer.hp_data = [player for player in eventPlayer.hp_data if player != null]
    if len(eventPlayer.hp_data) > 1:
        eventPlayer.hp_data = sorted(eventPlayer.hp_data, lambda i: i[0])
    for I in range(HEALTH_POOL_CLEANUP_MAX_REMOVALS):
        if len(eventPlayer.hp_data) == 0 or eventPlayer.hp_data[0][0] > getTotalTimeElapsed():
            goto lbl_cleanup_done
        removeHealthPool(eventPlayer.hp_data[0][1])
        del eventPlayer.hp_data[0]
        wait(
            HEALTH_POOL_WAIT_MIN +
            max(0, min(1, (getServerLoad() - HEALTH_POOL_WAIT_LOAD_MIN) / (HEALTH_POOL_WAIT_LOAD_MAX - HEALTH_POOL_WAIT_LOAD_MIN))) *
            (HEALTH_POOL_WAIT_MAX - HEALTH_POOL_WAIT_MIN)
        )
    lbl_cleanup_done:
    eventPlayer.hp_data = [player for player in eventPlayer.hp_data if player[0] > getTotalTimeElapsed()]
    wait(max(1, getServerLoad() / 100 * 0.032))
    if ruleCondition:
        loop()
