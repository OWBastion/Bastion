# Event: BuffEventId.OATH
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 誓约 - Healing Trigger":
    @Event playerDealtHealing
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.OATH]) == true
    @Condition eventPlayer != healee
    @Condition healee != null
    @Condition healee.getTeam() == Team.1
    @Condition healee.oathActive != true

    healee.oathActive = true
    healee.oathExpireAt = getTotalTimeElapsed() + EVT_30_TARGET_DURATION
    healee.mod_dmg_taken += EVT_30_DMG_TAKEN
    healee.mod_speed_event += EVT_30_SPEED_BOOST
    healee.setMoveSpeed(100 + healee.mod_speed_perma + healee.mod_speed_event)
    healee.setDamageReceived(100 + healee.mod_dmg_perma + healee.mod_dmg_taken)
    healee.setHealingDealt(100 + healee.mod_heal_event)
    healee.setHealingReceived(100 + healee.heal_recv)
    healee.setKnockbackReceived(100 + healee.knockback)


rule "[VishkarEvent]: 誓约 - Cleanup":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.oathActive == true
    @Condition eventPlayer.oathExpireAt != null

    wait(0.25, Wait.ABORT_WHEN_FALSE)
    if getTotalTimeElapsed() < eventPlayer.oathExpireAt:
        loop()
    eventPlayer.mod_dmg_taken -= EVT_30_DMG_TAKEN
    eventPlayer.mod_speed_event -= EVT_30_SPEED_BOOST
    eventPlayer.oathActive = false
    eventPlayer.oathExpireAt = null
    updatePlayerStats()
