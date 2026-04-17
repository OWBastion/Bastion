# Event: BuffEventId.DEATH_DELAY
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 死亡延迟（预备态）":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.DEATH_DELAY, eventPlayer.hasStatus(Status.UNKILLABLE) != true]) == true

    eventPlayer.setStatusEffect(eventPlayer, Status.UNKILLABLE, eventPlayer.eventDuration)

rule "[VishkarEvent]: 死亡延迟":
    @Event playerTookDamage
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.DEATH_DELAY, attacker.getHero() != eventPlayer.getHero(), eventPlayer.invincibleEffect == null, eventPlayer.hasStatus(Status.UNKILLABLE)]) == true
    @Condition (any([eventDamage >= eventPlayer.getHealth(), eventPlayer.getHealth() <= eventPlayer.getMaxHealth() * EVT_9_TRIGGER_HP_PERCENT, eventAbility == Button.SECONDARY_FIRE and attacker.getHero() == Hero.BASTION and eventPlayer.getMaxHealth() <= EVT_9_BASTION_EXECUTE_HP])) == true

    createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.invincibleEffect = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED_SOUND, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    smallMessage(eventPlayer, "  {0}  已触发死亡延迟，致命伤害已延后".format(abilityIconString(Hero.BAPTISTE, Button.ABILITY_2)))
    waitUntil(any([eventPlayer.eventId == -1, eventPlayer.isDead()]), eventPlayer.eventDuration)
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)
    destroyEffect(eventPlayer.invincibleEffect)
    eventPlayer.invincibleEffect = null
    clearEventEffect()
    if eventPlayer.isDead():
        return
    wait()
    if any([eventPlayer.hasStatus(Status.PHASED_OUT), eventPlayer.hasStatus(Status.INVINCIBLE), eventPlayer.hasStatus(Status.UNKILLABLE), eventPlayer.hasSpawned() != true, eventPlayer.isAlive() != true]):
        goto lbl_0
    smallMessage(eventPlayer, "  {0} 死亡延迟：致命伤害已施加".format(
    iconString(Icon.SKULL)))
    damage(eventPlayer, attacker, EVT_9_EXECUTE_DAMAGE)
    lbl_0:


# ==============================================================================
# Rule 1: 主动方 - 寻找目标、发起连接与控制
# ==============================================================================
