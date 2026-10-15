#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine buildCandidatePool

# Event IDs in these groups share a dynamic hard eligibility gate. Groups only control
# candidate inclusion; weights and selection remain attached to each event.
macro EVENT_GROUP_HEART_STEEL = [
    EventId.GAMBLER_SPEED_CHALLENGE,
    EventId.GAMBLER_HEART_OF_STEEL,
    EventId.GAMBLER_ALL_IN_ART_5
]

# Whether this hero is currently using its supported phase-trigger input.
macro Player.usesPhaseTrigger():
    any([
        (self.getHero() in phaseHero[0] and self.isUsingAbility1()),
        (self.getHero() in phaseHero[1] and self.isUsingAbility2()),
        (self.getHero() in phaseHero[2] and self.isFiringSecondaryFire()),
        (self.getHero() in phaseHero[3] and self.isHoldingButton(Button.JUMP)),
        (isHero(self, Hero.BRIGITTE) and self.isFiringSecondaryFire() and self.isHoldingButton(Button.PRIMARY_FIRE)),
        (self.getHero() in phaseHero[4] and self.zenSnapKick)
    ])

# 动态硬资格谓词：统一候选池过滤与强制类型标量抽样共用同一套门槛，新增门槛只在此登记。
# 每个子句表示“条件不满足时该目录槽位不可被抽中”；事件组只表达资格，不携带概率。
macro Player.eventHardEligible(candidateId):
    all([
        # EVENT_GROUP_HEART_STEEL：依赖当前正向心之钢层数
        self.heart_steel[HeartSteelData.STACKS] > 0 or candidateId not in EVENT_GROUP_HEART_STEEL,
        # TEMPER_HEART：一次性事件，完成后不再抽入
        self.playerOnceEventState == null or len(self.playerOnceEventState) <= PlayerOnceEventSlot.TEMPER_HEART or self.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] != TemperHeartState.COMPLETED or candidateId != EventId.TEMPER_HEART,
        # SELFLESS_GIVEAWAY：强制减益契约存续期间不重复抽入
        self.eventForceType != EventType.DEBUFF or candidateId != EventId.SELFLESS_GIVEAWAY,
        # GAMBLER_WINNER_TAKE_ALL：奖池与个人层数双门槛
        (gamblerHeartsteelJackpot >= EVT_MECH_24_POOL_MIN and self.heart_steel[HeartSteelData.STACKS] >= EVT_MECH_24_PLAYER_STACKS_MIN) or candidateId != EventId.GAMBLER_WINNER_TAKE_ALL,
        # MIRROR_INVERSION：无可反转的正向修饰时不抽
        not (self.mod_dmg_perma <= 0 and self.mod_speed_perma >= 0 and self.mod_heal_perma >= 0 and self.heart_steel[HeartSteelData.STACKS] >= 0) or candidateId != EventId.MIRROR_INVERSION
    ])

def buildCandidatePool():
    @Name "[VishkarEvent]: build player event candidate pool"

    eventPlayer.eventTempIndex = eventPlayer.eventCompatibleBasePool.filter(lambda candidateIndex: eventCatalogWeight[candidateIndex] > 0)
    wait(getAverageServerLoad() / 100 * 0.032)
    # 窃贼只改写自然分配的增益机会；强制类型契约不经过候选池（见 drawForcedEvent）
    if eventPlayer.thiefBuffStolen == true:
        eventPlayer.eventTempIndex = eventPlayer.eventTempIndex.filter(lambda candidateIndex: eventCatalogType[candidateIndex] != EventType.BUFF)
    eventPlayer.eventTempIndex = eventPlayer.eventTempIndex.filter(lambda candidateIndex: eventPlayer.eventHardEligible(candidateIndex))

    # 有难同当同一时间全队至多一名持有者：他人已生效或已预取锁定（eventCandidateIndex）的都算占位；多人同持会让旁观者承伤叠加超过单个承伤者
    if len(getPlayers(Team.1).filter(lambda other: other != eventPlayer and (other.eventId == EventId.SHARE_THE_PAIN or other.eventCandidateIndex == EventId.SHARE_THE_PAIN))) > 0:
        eventPlayer.eventTempIndex.remove(EventId.SHARE_THE_PAIN)

    if eventPlayer.eventLastId != null:
        eventPlayer.eventCandidateIndex = eventPlayer.eventTempIndex.filter(lambda candidateIndex: candidateIndex not in eventPlayer.eventLastId)
        if len(eventPlayer.eventCandidateIndex) > 0:
            eventPlayer.eventTempIndex = eventPlayer.eventCandidateIndex

    eventPlayer.eventTempIndex = eventPlayer.eventTempIndex.unique()
