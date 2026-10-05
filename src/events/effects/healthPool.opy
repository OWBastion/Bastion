#!mainFile "../../main.opy"


#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "System"

#!define HEALTH_POOL_CLEANUP_MAX_REMOVALS 6
#!define HEALTH_POOL_CLEANUP_ITEM_DT 0.8
#!define HEALTH_POOL_CLEANUP_LOOP_DT 1


rule "Clean expired health pools":
    @Event eachPlayer
    @Team 1
    @Condition len(eventPlayer.hp_data) > 0

    eventPlayer.hp_data = [player for player in eventPlayer.hp_data if player != null]
    if len(eventPlayer.hp_data) > 1:
        eventPlayer.hp_data = sorted(eventPlayer.hp_data, lambda i: -1 if len(i) > 2 and eventPlayer.eventId != i[2] else i[0])
    for I in range(HEALTH_POOL_CLEANUP_MAX_REMOVALS):
        if len(eventPlayer.hp_data) == 0 or (
            eventPlayer.hp_data[0][0] > getTotalTimeElapsed() and
            (len(eventPlayer.hp_data[0]) <= 2 or eventPlayer.eventId == eventPlayer.hp_data[0][2])
        ):
            goto lbl_cleanup_done
        removeHealthPool(eventPlayer.hp_data[0][1])
        del eventPlayer.hp_data[0]
        wait(HEALTH_POOL_CLEANUP_ITEM_DT)
    lbl_cleanup_done:
    wait(HEALTH_POOL_CLEANUP_LOOP_DT)
    if ruleCondition:
        loop()
