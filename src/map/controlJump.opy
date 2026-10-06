#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[Core] ..." 前缀不变
#!rulePrefix "Core"

rule "Reset to control respawn":
    @Event eachPlayer
    @Team 1
    @Condition controlRespawnPosition != null
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isInSpawnRoom() == true
    @Condition controlRespawnPosition[eventPlayer.controlJumpIndex] != null
    @Condition (any([controlRespawnAxis == 0 and distance(vect(eventPlayer.getPosition().x, 0, 0), vect(controlRespawnPosition[eventPlayer.controlJumpIndex].x, 0, 0)) >= controlRespawnAxisThreshold, controlRespawnAxis == 1 and distance(vect(0, eventPlayer.getPosition().y, 0), vect(0, controlRespawnPosition[eventPlayer.controlJumpIndex].y, 0)) >= controlRespawnAxisThreshold, controlRespawnAxis == 2 and distance(vect(0, 0, eventPlayer.getPosition().z), vect(0, 0, controlRespawnPosition[eventPlayer.controlJumpIndex].z)) >= controlRespawnAxisThreshold])) == true

    eventPlayer.teleport(controlRespawnPosition[eventPlayer.controlJumpIndex])
    eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), controlJumpPosition[eventPlayer.controlJumpIndex].getPosition()), Relativity.TO_WORLD)
    wait(0.032)


rule "Advance control jump":
    @Event eachPlayer
    @Team 1
    @Condition controlRespawnPosition != null
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.isMoving() == true
    @Condition controlJumpPosition[eventPlayer.controlJumpIndex] != null
    #@Condition eventPlayer.getPosition().y >= controlJumpPosition[eventPlayer.controlJumpIndex].y
    #@Condition distance(eventPlayer.getPosition() * vect(1, 0, 1), controlJumpPosition[eventPlayer.controlJumpIndex] * vect(1, 0, 1)) <= 4

    wait(0.032, Wait.ABORT_WHEN_FALSE)
    wait(0.2)
    if (eventPlayer.anchorPos(eventPlayer.possess).y >= controlJumpPosition[eventPlayer.controlJumpIndex].y):
        if distance(eventPlayer.anchorPos(eventPlayer.possess) * vect(1, 0, 1), controlJumpPosition[eventPlayer.controlJumpIndex] * vect(1, 0, 1)) <= 4:
            eventPlayer.controlJumpIndex++
            wait()
            if any([eventPlayer.hasStatus(Status.PHASED_OUT), eventPlayer.hasStatus(Status.INVINCIBLE)]):
                goto lbl_1
            eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 0.5)
            eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 0.5)
            lbl_1:
            eventPlayer.teleport(controlRespawnPosition[eventPlayer.controlJumpIndex])
            eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), controlJumpPosition[eventPlayer.controlJumpIndex].getPosition()), Relativity.TO_WORLD)
            wait(2.16)
    lbl_0:
    loop()
