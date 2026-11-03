#!mainFile "../editorMain.opy"

#!optimizeStrict
#!rulePrefix "Editor"

# 开火模式由 composition/profileEditor.opy 的 BASTION_FIRE_CONDITION / BASTION_TARGETING_CONDITION 接入堡垒规则：
# 开火（0）、仅瞄准（1，仍索敌并转向，不开火）、关闭（2，不索敌）。不使用 targetSilence，事件会设置并清除它。

rule "Cycle bastion fire mode":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 1
    @Condition eventPlayer.editorPanelPage == 2
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    editorFireMode = (editorFireMode + 1) % 3


# 进入仅瞄准或关闭时，立刻松开已被强制的开火按键。
rule "Stop bastion fire outside fire mode":
    @Condition editorFireMode != 0

    getPlayers(Team.2).stopForcingButton(Button.PRIMARY_FIRE)
    getPlayers(Team.2).stopForcingButton(Button.SECONDARY_FIRE)


# 仅瞄准时，从堡垒眼部到目标显示光束。
rule "Show aim beam":
    @Event playerJoined
    @Team 2

    createBeam(getPlayers(Team.1) if editorFireMode == 1 and eventPlayer.target != null else null, Beam.BAD, eventPlayer.getEyePosition(), eventPlayer.target.getEyePosition(), Color.RED, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.editorBeam = getLastCreatedEntity()


rule "Remove aim beam when bastion leaves":
    @Event playerLeft
    @Team 2

    destroyEffect(eventPlayer.editorBeam)
    eventPlayer.editorBeam = null
