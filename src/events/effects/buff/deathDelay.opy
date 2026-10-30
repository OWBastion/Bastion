#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.DEATH_DELAY
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

rule "[VishkarEvent]: 死亡延迟（预备态）":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() and eventPlayer.isAlive() and eventPlayer.eventId == EventId.DEATH_DELAY and eventPlayer.eventEndTime > getTotalTimeElapsed() and not eventPlayer.hasStatus(Status.UNKILLABLE)

    eventPlayer.setStatusEffect(eventPlayer, Status.UNKILLABLE, Math.INFINITY)

rule "[VishkarEvent]: 死亡延迟":
    @Event playerTookDamage
    @Team 1
    @Condition eventPlayer.hasSpawned() and eventPlayer.isAlive() and eventPlayer.eventId == EventId.DEATH_DELAY and attacker.getHero() != eventPlayer.getHero() and not eventPlayer.invincibleEffect[InvincibleEffectSlot.DEATH_DELAY] and eventPlayer.hasStatus(Status.UNKILLABLE)
    @Condition ((eventDamage >= eventPlayer.getHealth() or eventPlayer.healthAtMostPercent(EVT_9_TRIGGER_HP_PERCENT * 100) or eventAbility == Button.SECONDARY_FIRE and attacker.getHero() == Hero.BASTION and eventPlayer.getMaxHealth() <= EVT_9_BASTION_EXECUTE_HP)) == true

    createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.invincibleEffect[InvincibleEffectSlot.DEATH_DELAY] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED_SOUND, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    smallMessage(eventPlayer, "  {0}  已触发死亡延迟，致命伤害已延后".format(abilityIconString(Hero.BAPTISTE, Button.ABILITY_2)))
    waitUntil((eventPlayer.eventId == -1 or eventPlayer.isDead() or eventPlayer.eventEndTime <= getTotalTimeElapsed()), Math.INFINITY)
    if eventPlayer.eventId == -1 or eventPlayer.eventEndTime <= getTotalTimeElapsed():
        return
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)
    destroyEffect(eventPlayer.invincibleEffect[InvincibleEffectSlot.DEATH_DELAY])
    eventPlayer.invincibleEffect[InvincibleEffectSlot.DEATH_DELAY] = null
    if eventPlayer.isDead():
        return
    wait()
    if (eventPlayer.untargetable() or not eventPlayer.hasSpawned() or not eventPlayer.isAlive()):
        goto lbl_0
    smallMessage(eventPlayer, "  {0} 死亡延迟：致命伤害已施加".format(
    iconString(Icon.SKULL)))
    damage(eventPlayer, attacker, EVT_9_EXECUTE_DAMAGE)
    lbl_0:


# ==============================================================================
# Rule 1: 主动方 - 寻找目标、发起连接与控制
# ==============================================================================
