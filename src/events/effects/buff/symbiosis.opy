#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/有我有你"

# Event: BuffEventId.SYMBIOSIS
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。
#
# 2026 周年简化版：与合法队友发生实际接触即附身并跟随（attachTo），附身期间处于
# 消散（PHASED_OUT）状态——堡垒 AI 目标筛选会排除消散目标；按住下蹲主动脱离。
# 已移除旧版的传送建立路径与对宿主的属性共享（治疗强度/减伤/移速/额外生命值）。

rule "[VishkarEvent]: 有我有你（附身）":
    @Event eachPlayer
    @Team 2
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.SYMBIOSIS, eventPlayer.possess == null, eventPlayer.eventDuration > 0, eventPlayer.hasStatus(Status.PHASED_OUT) != true]) == true
    @Condition len(getLivingPlayers(Team.2).filter(lambda p: p != eventPlayer and p.isWinner != true and p.possess == null and (len(p.possessed) == 0 or not entityExists(p.possessed[0])) and distance(p, eventPlayer) <= EVT_10_CONTACT_RADIUS)) > 0

    # Exception: 附身建立后由 waitUntil 同步生命周期，非节奏循环。
    # 选取最近的合法接触目标；possessed[0] 存放附身者引用，兼作宿主占用标记
    eventPlayer.possess = sorted(getLivingPlayers(Team.2).filter(lambda p: p != eventPlayer and p.isWinner != true and p.possess == null and (len(p.possessed) == 0 or not entityExists(p.possessed[0])) and distance(p, eventPlayer) <= EVT_10_CONTACT_RADIUS), lambda i: distance(eventPlayer, i))
    if len(eventPlayer.possess) == 0:
        eventPlayer.possess = null
        wait(2)
        return
    eventPlayer.possess[0].possessed = [eventPlayer]
    # possess: [0:宿主, 1:附身开始时自身heroNumber, 2:附身开始时宿主heroNumber]
    eventPlayer.possess = [eventPlayer.possess[0], eventPlayer.heroNumber, eventPlayer.possess[0].heroNumber]

    # 仅建立跟随关系，不向宿主传送
    eventPlayer.attachTo(eventPlayer.possess[0], vect(0, 1, -1))

    if eventPlayer.getHero() in phaseHero[0]:
        eventPlayer.disallowButton(Button.ABILITY_1)
        eventPlayer.setAbility1Enabled(false)
    if eventPlayer.getHero() in phaseHero[1]:
        eventPlayer.disallowButton(Button.ABILITY_2)
        eventPlayer.setAbility2Enabled(false)

    smallMessage(eventPlayer, "  {0}  已附身 {1}（{2}），按住 {3} 脱离".format(abilityIconString(Hero.MERCY, Button.ULTIMATE), eventPlayer.possess[0], eventPlayer.possess[0].getHero(), Button.CROUCH))
    smallMessage(eventPlayer.possess[0], "  {0}  你已被 {1}（{2}）附身".format(abilityIconString(Hero.MERCY, Button.ULTIMATE), eventPlayer, eventPlayer.getHero()))

    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)

    # 维持阶段：下蹲脱离、任一方死亡/失效、宿主占用标记被外部清除（终点结算）、事件结束
    waitUntil(eventPlayer.eventId != BuffEventId.SYMBIOSIS or eventPlayer.possess == null or eventPlayer.isHoldingButton(Button.CROUCH) or eventPlayer.isDead() or not entityExists(eventPlayer.possess[0]) or eventPlayer.possess[0].isDead() or len(eventPlayer.possess[0].possessed) == 0, eventPlayer.eventDuration)

    eventPlayer.detach()

    if entityExists(eventPlayer.possess[0]):
        eventPlayer.possess[0].possessed = []

    # 若附身期间宿主触发了终点结算（heroNumber 变化），且附身者还未进阶，则在重生室补一次进阶
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

    # 三合一地图控制点同步：若宿主在附身期间完成了传送点推进，
    # 解除附身后将附身者的 controlJumpIndex 同步到不落后于宿主，
    # 避免“宿主已过图但附身者仍停留上一图索引”导致后续传送失效。
    if all([
        controlRespawnPosition != null,
        eventPlayer.possess != null,
        eventPlayer.possess[0] != null,
        entityExists(eventPlayer.possess[0]),
        eventPlayer.possess[0].controlJumpIndex > eventPlayer.controlJumpIndex
    ]):
        eventPlayer.controlJumpIndex = eventPlayer.possess[0].controlJumpIndex

    # 宿主处于悬空/ hazard 位置时，为脱离的附身者寻找安全落脚点；已在重生室则不传送
    if all([
        eventPlayer.isInSpawnRoom() != true,
        eventPlayer.possess != null,
        eventPlayer.possess[0] != null,
        entityExists(eventPlayer.possess[0])
    ]):
        eventPlayer.teleport(nearestWalkablePosition(eventPlayer.possess[0].getPosition() + vect(random.randint(-1, 1), 0.5, random.randint(-1, 1))))

    eventPlayer.clearStatusEffect(Status.PHASED_OUT)

    if eventPlayer.getHero() in phaseHero[0]:
        eventPlayer.allowButton(Button.ABILITY_1)
        eventPlayer.setAbility1Enabled(true)
    if eventPlayer.getHero() in phaseHero[1]:
        eventPlayer.allowButton(Button.ABILITY_2)
        eventPlayer.setAbility2Enabled(true)
    eventPlayer.possess = null
    wait(2)

rule "[VishkarEvent]: 有我有你（宿主标记自清）":
    @Event eachPlayer
    @Team 2
    @Condition len(eventPlayer.possessed) > 0
    @Condition not entityExists(eventPlayer.possessed[0]) or eventPlayer.possessed[0].possess == null or eventPlayer.possessed[0].possess[0] != eventPlayer

    # 附身者离场、被重置或其 possess 已不指向本宿主时，回收残留的占用标记
    eventPlayer.possessed = []
