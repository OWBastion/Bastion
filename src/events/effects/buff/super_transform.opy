# Event: BuffEventId.SUPER_TRANSFORM
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 超级变换形态 (触发)":
    @Event eachPlayer
    @Team 1
    @Condition all([
        dlcVishkarEvent,
        eventPlayer.hasSpawned(),
        eventPlayer.eventType == 0,
        eventPlayer.eventId == BuffEventId.SUPER_TRANSFORM,
        eventPlayer.altFormTrigger != true,
        eventPlayer.isInAlternateForm(),
        any([
            eventPlayer.getHero() == Hero.DVA,
            eventPlayer.getHero() == Hero.WRECKING_BALL,
            eventPlayer.getHero() == Hero.BASTION,
            eventPlayer.getHero() == Hero.TORBJORN,
            eventPlayer.getHero() == Hero.LUCIO,
            eventPlayer.getHero() == Hero.MERCY,
            eventPlayer.getHero() == Hero.LIFEWEAVER,
            eventPlayer.getHero() == Hero.JETPACK_CAT
        ])
    ]) == true

    eventPlayer.altFormTrigger = true
    eventPlayer.addHealthPool(Health.NORMAL, round(EVT_26_HP_FLAT + eventPlayer.getMaxHealth() * EVT_26_HP_MAXHP_FACTOR), false, false)
    eventPlayer.hp_data.append([[getTotalTimeElapsed() + EVT_26_OVERHEALTH_DURATION, getLastCreatedHealthPool(), eventPlayer.eventId]])
    wait(EVT_26_TRIGGER_GCD)

rule "[VishkarEvent]: 超级变换形态 (状态重置)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.SUPER_TRANSFORM, eventPlayer.altFormTrigger == true, not eventPlayer.isInAlternateForm()]) == true

    eventPlayer.altFormTrigger = false
