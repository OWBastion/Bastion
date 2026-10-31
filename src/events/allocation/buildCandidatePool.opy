#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine buildCandidatePool

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

def buildCandidatePool():
    @Name "[VishkarEvent]: build player event candidate pool"

    eventPlayer.eventTempIndex = eventPlayer.eventCompatibleBasePool.filter(lambda candidateIndex: eventCatalogWeight[candidateIndex] > 0)
    wait(getAverageServerLoad() * 0.00032)
    # 窃贼只改写自然分配的增益机会；强制类型契约不经过候选池（见 drawForcedEvent）
    if eventPlayer.thiefBuffStolen == true:
        eventPlayer.eventTempIndex = eventPlayer.eventTempIndex.filter(lambda candidateIndex: eventCatalogType[candidateIndex] != EventType.BUFF)
    filterEventHardEligible()

    # 有难同当同一时间全队至多一名持有者：他人已生效或已预取锁定（eventCandidateIndex）的都算占位；多人同持会让旁观者承伤叠加超过单个承伤者
    if len(getPlayers(Team.1).filter(lambda other: other != eventPlayer and (other.eventId == EventId.SHARE_THE_PAIN or other.eventCandidateIndex == EventId.SHARE_THE_PAIN))) > 0:
        eventPlayer.eventTempIndex.remove(EventId.SHARE_THE_PAIN)
    # Unique 事件：先知同一时间最多一名。他人已生效、已承诺（eventNextIndex）或正预取锁定（eventCandidateIndex）的都算占位
    if len(getPlayers(Team.1).filter(lambda other: other != eventPlayer and (other.eventId == EventId.PROPHET or other.eventNextIndex == EventId.PROPHET or other.eventCandidateIndex == EventId.PROPHET))) > 0:
        eventPlayer.eventTempIndex.remove(EventId.PROPHET)

    if eventPlayer.eventLastId != null:
        eventPlayer.eventCandidateIndex = eventPlayer.eventTempIndex.filter(lambda candidateIndex: candidateIndex not in eventPlayer.eventLastId)
        if len(eventPlayer.eventCandidateIndex) > 0:
            eventPlayer.eventTempIndex = eventPlayer.eventCandidateIndex

    eventPlayer.eventTempIndex = eventPlayer.eventTempIndex.unique()
