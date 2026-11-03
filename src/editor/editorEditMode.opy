#!mainFile "../editorMain.opy"

#!optimizeStrict
#!rulePrefix "Editor"

#!define EDITOR_FLY_SPEED 300
#!define EDITOR_ASCEND_STEP 0.5
#!define EDITOR_ASCEND_DT 0.05
#!define EDITOR_SELECT_MAX_DISTANCE 50
#!define EDITOR_SELECT_MAX_ANGLE 10
#!define EDITOR_GROUND_SNAP_DISTANCE 50

subroutine enterEditorEditMode
subroutine leaveEditorEditMode

def enterEditorEditMode():
    @Name "enter edit mode"

    if eventPlayer.eventId != -1:
        clearPlayerEvent()
    eventPlayer.eventNextIndex = -1
    eventPlayer.setGravity(0)
    eventPlayer.setMoveSpeed(EDITOR_FLY_SPEED)
    eventPlayer.disableEnvironmentCollision(true)
    # 阶段隐身使堡垒不索敌编辑者；编辑按键由规则读取，英雄动作被禁用。
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 99999)
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.disallowButton(Button.RELOAD)

def leaveEditorEditMode():
    @Name "leave edit mode"

    eventPlayer.setGravity(100)
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.RELOAD)


rule "Apply edit mode":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 0
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()

    enterEditorEditMode()


rule "Hold position in edit mode":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 0
    @Condition eventPlayer.getThrottle() == vect(0, 0, 0)
    @Condition eventPlayer.getSpeed() > 0.1

    eventPlayer.applyImpulse(Vector.UP, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    eventPlayer.applyImpulse(negToPos(eventPlayer.getVelocity()), 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)


rule "Ascend in edit mode":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 0
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isHoldingButton(Button.JUMP)

    eventPlayer.teleport(eventPlayer.getPosition() + Vector.UP * EDITOR_ASCEND_STEP)
    wait(EDITOR_ASCEND_DT, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()


rule "Descend in edit mode":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 0
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)

    eventPlayer.teleport(eventPlayer.getPosition() + Vector.DOWN * EDITOR_ASCEND_STEP)
    wait(EDITOR_ASCEND_DT, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()


rule "Previous tool":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 0
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)

    eventPlayer.editorTool = (eventPlayer.editorTool + 4) % 5
    eventPlayer.editorSelectedIndex = -1
    refreshEditorOutlines()


rule "Next tool":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 0
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)

    eventPlayer.editorTool = (eventPlayer.editorTool + 1) % 5
    eventPlayer.editorSelectedIndex = -1
    refreshEditorOutlines()


# 点位取脚下位置而不是射线命中点：悬空点会被 "Lock elevated position" 重新传送。
rule "Place or move point":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 0
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    # 编辑者悬空飞行；点位向正下方吸附到地面，未命中则不放置。
    eventPlayer.editorGroundPoint = raycastHitPosition(eventPlayer.getPosition() + Vector.UP, eventPlayer.getPosition() + Vector.DOWN * EDITOR_GROUND_SNAP_DISTANCE, null, getAllPlayers(), false)
    if raycastHitNormal(eventPlayer.getPosition() + Vector.UP, eventPlayer.getPosition() + Vector.DOWN * EDITOR_GROUND_SNAP_DISTANCE, null, getAllPlayers(), false) == vect(0, 0, 0):
        smallMessage(eventPlayer, STR_EDITOR_MSG_NO_GROUND)
        return
    if eventPlayer.editorSelectedIndex != -1:
        bastionPosition[eventPlayer.editorSelectedIndex] = eventPlayer.editorGroundPoint
    elif eventPlayer.editorTool == 0:
        bastionPosition.append(eventPlayer.editorGroundPoint)
    elif eventPlayer.editorTool == 1:
        resetPosition = eventPlayer.editorGroundPoint
    elif eventPlayer.editorTool == 2:
        endPosition = eventPlayer.editorGroundPoint
    elif eventPlayer.editorTool == 3:
        thirdPersonPosition = eventPlayer.editorGroundPoint
    else:
        creditsPosition = eventPlayer.editorGroundPoint
    rebuildEditorMarkers()


rule "Select bastion under crosshair":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 0
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    eventPlayer.editorCandidates = bastionPosition.filter(lambda point: distance(eventPlayer.getEyePosition(), point) <= EDITOR_SELECT_MAX_DISTANCE and angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), point + Vector.UP)) <= EDITOR_SELECT_MAX_ANGLE)
    if len(eventPlayer.editorCandidates) == 0:
        eventPlayer.editorSelectedIndex = -1
    else:
        eventPlayer.editorCandidateIndex = bastionPosition.index(sorted(eventPlayer.editorCandidates, lambda point: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), point + Vector.UP)))[0])
        eventPlayer.editorSelectedIndex = -1 if eventPlayer.editorSelectedIndex == eventPlayer.editorCandidateIndex else eventPlayer.editorCandidateIndex
        eventPlayer.editorTool = 0
    refreshEditorOutlines()


# 删除下标 i：移除点位与最后一个机器人，并清除所有玩家中下标 >= i 的选中。不支持撤销。
rule "Delete selected bastion":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 0
    @Condition eventPlayer.editorSelectedIndex != -1
    @Condition eventPlayer.isHoldingButton(Button.MELEE)

    eventPlayer.editorCandidateIndex = eventPlayer.editorSelectedIndex
    getPlayers(Team.2).stopForcingOutlineFor(getPlayers(Team.1).filter(lambda player: player.editorSelectedIndex >= eventPlayer.editorCandidateIndex))
    getPlayers(Team.1).filter(lambda player: player.editorSelectedIndex >= eventPlayer.editorCandidateIndex).editorSelectedIndex = -1
    del bastionPosition[eventPlayer.editorCandidateIndex]
    destroyDummy(Team.2, len(bastionPosition))
    kills[len(bastionPosition)] = 0
    rebuildEditorMarkers()


rule "Teleport to selected bastion":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 0
    @Condition eventPlayer.editorSelectedIndex != -1
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)

    eventPlayer.teleport(bastionPosition[eventPlayer.editorSelectedIndex])
