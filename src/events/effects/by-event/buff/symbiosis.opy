# Event: BuffEventId.SYMBIOSIS
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 有我有你 (Initiator - Control Logic)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.SYMBIOSIS]) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    # Exception: this initiator/receiver pair is state-sync workflow, not cadence loop.
    # 1. 寻找目标 (排除自己、已获胜、已从属于他人、已被附身的玩家)
    wait(0.032, Wait.ABORT_WHEN_FALSE)
    # 这里把 possessed 视为数组判断，len(p.possessed) == 0 代表未被附身
    eventPlayer.possess = sorted([player for player in getLivingPlayers(Team.1) if player != eventPlayer and player.isWinner != true and len(player.possessed) == 0 and distance(eventPlayer, player) < 40], lambda i: distance(eventPlayer, i))
    
    wait(0.032)
    smallMessage(eventPlayer, "  {0}".format("附近未找到可附身目标" if len(eventPlayer.possess) == 0 else "附身目标：{0}".format(eventPlayer.possess[0])))
    
    if len(eventPlayer.possess) == 0:
        goto lbl_0

    # 2. 发起附身 (写入数据)
    # 目标变量 possessed 结构: [0:来源玩家, 1:治疗增益, 2:减伤, 3:移速, 4:血池ID(预留), 5:最大生命值]
    # 先写入除 ID 外的数据，ID 由目标生成后填入
    eventPlayer.possess[0].possessed[0] = eventPlayer
    eventPlayer.possess[0].possessed[1] = eventPlayer.mod_heal_event
    eventPlayer.possess[0].possessed[2] = eventPlayer.mod_dmg_taken
    eventPlayer.possess[0].possessed[3] = eventPlayer.mod_speed_event
    eventPlayer.possess[0].possessed[5] = eventPlayer.getMaxHealth()
    # possess: [0:目标玩家, 1:附身开始时自身heroNumber, 2:附身开始时目标heroNumber]
    eventPlayer.possess = [eventPlayer.possess[0], eventPlayer.heroNumber, eventPlayer.possess[0].heroNumber]
    
    # 3. 附身连接
    eventPlayer.teleport(eventPlayer.possess[0].getPosition())
    eventPlayer.attachTo(eventPlayer.possess[0], vect(0, 1, -1))

    if eventPlayer.getHero() in phaseHero[0]:
        eventPlayer.disallowButton(Button.ABILITY_1)
        eventPlayer.setAbility1Enabled(false)

    if eventPlayer.getHero() in phaseHero[1]:
        eventPlayer.disallowButton(Button.ABILITY_2)
        eventPlayer.setAbility2Enabled(false)
    
    smallMessage(eventPlayer.possess[0], "  {0}  你已被 {1}（{2}） 附身".format(abilityIconString(Hero.MERCY, Button.ULTIMATE), eventPlayer, eventPlayer.getHero()))
    
    # 自身状态：消散 (不可选取/受到伤害)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
     # 自身状态：无敌 (双重保险)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)

    lbl_0:
    # 4. 维持阶段
    # 等待直到：目标死亡、自身按蹲、目标掉线、时间结束、或者目标被意外清除了附身状态
    waitUntil(eventPlayer.possess[0].isDead() or eventPlayer.isHoldingButton(Button.CROUCH) or not entityExists(eventPlayer.possess[0]) or eventPlayer.isDead() or len(eventPlayer.possess[0].possessed) == 0 or eventPlayer.eventDuration == 0, eventPlayer.eventDuration)

    removeHealthPool(eventPlayer.possess[0].healthId[4])
    
    # 5. 清理阶段
    eventPlayer.detach()
    
    # 清除目标状态
    if entityExists(eventPlayer.possess[0]):
        # removeHealthPool(eventPlayer.possess[0].possessed[4])
        
        eventPlayer.possess[0].possessed = []

    # 若附身期间目标触发了终点结算（heroNumber 变化），且附身者还未进阶，则在重生室补一次进阶
    if all([
        eventPlayer.isInSpawnRoom() == true,
        eventPlayer.possess != null,
        eventPlayer.possess[0] != null,
        entityExists(eventPlayer.possess[0]),
        eventPlayer.possess[1] != null,
        eventPlayer.possess[2] != null,
        eventPlayer.heroNumber == eventPlayer.possess[1],
        eventPlayer.possess[0].heroNumber != eventPlayer.possess[2],
        eventPlayer.heroNumber + 1 < len(heroList),
        eventPlayer.getHero() == heroList[eventPlayer.heroNumber]
    ]):
        progressHero()

    # 三合一地图控制点同步：若被附身目标在附身期间完成了传送点推进，
    # 解除附身后将附身者的 controlJumpIndex 同步到不落后于目标，
    # 避免“目标已过图但附身者仍停留上一图索引”导致后续传送失效。
    if all([
        controlRespawnPosition != null,
        eventPlayer.possess != null,
        eventPlayer.possess[0] != null,
        entityExists(eventPlayer.possess[0]),
        eventPlayer.possess[0].controlJumpIndex > eventPlayer.controlJumpIndex
    ]):
        eventPlayer.controlJumpIndex = eventPlayer.possess[0].controlJumpIndex
    
    # 寻找安全落脚点
    # 使用标准重生室判定：若附身者已在重生室，则不再执行落脚传送
    if all([
        eventPlayer.isInSpawnRoom() != true,
        eventPlayer.possess != null,
        eventPlayer.possess[0] != null,
        entityExists(eventPlayer.possess[0])
    ]):
        eventPlayer.teleport(nearestWalkablePosition(eventPlayer.possess[0].getPosition() + vect(random.randint(-1, 1), 0.5, random.randint(-1, 1))))
    
    # 自身重置
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)

    if eventPlayer.getHero() in phaseHero[0]:
        eventPlayer.allowButton(Button.ABILITY_1)
        eventPlayer.setAbility1Enabled(true)

    if eventPlayer.getHero() in phaseHero[1]:
        eventPlayer.allowButton(Button.ABILITY_2)
        eventPlayer.setAbility2Enabled(true)
    eventPlayer.possess = null
    wait(2)


# ==============================================================================
# Rule 2: 被动方 - 属性同步与加成 (Receiver Logic)
# ==============================================================================

rule "[VishkarEvent]: 有我有你 (Receiver - Stats Sync)":
    @Event eachPlayer
    @Team 1
    # 触发条件：possessed 数组非空 (有人附身)
    @Condition len(eventPlayer.possessed) > 0
    @Condition eventPlayer.possessed[0] != null
    
    # 1. 应用属性叠加 (读取数据)
    eventPlayer.mod_heal_event += eventPlayer.possessed[1]
    eventPlayer.mod_dmg_taken += eventPlayer.possessed[2]
    eventPlayer.mod_speed_event += eventPlayer.possessed[3]
    
    # 刷新自身属性
    updatePlayerStats()
    
    # 2. 添加额外生命值 (数值来自 possessed[5])
    # 将生成的 Health Pool ID 存回 possessed[4] 以便后续删除
    removeHealthPool(eventPlayer.healthId[4])
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.possessed[5], true, false)
    eventPlayer.healthId[4] = getLastCreatedHealthPool()
    
    
    # 3. 等待附身结束 (监听数组是否被置空)
    # Exception: waitUntil is required to sync with initiator detach lifecycle.
    # 同时监控来源玩家状态，如果来源玩家中途退游戏，也需要自动清理
    waitUntil(eventPlayer.possessed[0].eventDuration <= 2 or len(eventPlayer.possessed) == 0 or not entityExists(eventPlayer.possessed[0]), 9999)
    
    # 4. 移除属性 (减去快照数据)
    eventPlayer.mod_heal_event -= eventPlayer.possessed[1]
    eventPlayer.mod_dmg_taken -= eventPlayer.possessed[2]
    eventPlayer.mod_speed_event -= eventPlayer.possessed[3]
    
    # 移除额外生命值
    # if eventPlayer.possessed[4] != null:
    removeHealthPool(eventPlayer.healthId[4])
    
    # 刷新并清理
    updatePlayerStats()
    
    # 最终确保置空 (如果是因来源玩家掉线触发的，需要自己清空数组)
    eventPlayer.possessed = []
