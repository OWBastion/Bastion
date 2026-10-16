#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine filterEventHardEligible

# Event IDs in these groups share a dynamic hard eligibility gate. Groups only control
# candidate inclusion; weights and selection remain attached to each event.
macro EVENT_GROUP_HEART_STEEL = [
    EventId.GAMBLER_SPEED_CHALLENGE,
    EventId.GAMBLER_HEART_OF_STEEL,
    EventId.GAMBLER_ALL_IN_ART_5
]

# 动态硬资格的唯一定义：就地过滤 eventTempIndex，统一候选池与强制类型标量抽样（单元素数组）共用。
# 每条门槛一条扁平语句，避免把全部门槛折叠成一个深嵌套表达式（Workshop 导入对表达式嵌套深度敏感）；新增门槛只在此登记。
def filterEventHardEligible():
    @Name "[VishkarEvent]: filter hard-eligible event candidates"

    if eventPlayer.heart_steel[HeartSteelData.STACKS] <= 0:
        eventPlayer.eventTempIndex = eventPlayer.eventTempIndex.filter(lambda candidateIndex: candidateIndex not in EVENT_GROUP_HEART_STEEL)
    if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] == TemperHeartState.COMPLETED:
        eventPlayer.eventTempIndex.remove(EventId.TEMPER_HEART)
    if eventPlayer.eventForceType == EventType.DEBUFF:
        eventPlayer.eventTempIndex.remove(EventId.SELFLESS_GIVEAWAY)
    if gamblerHeartsteelJackpot < EVT_MECH_24_POOL_MIN or eventPlayer.heart_steel[HeartSteelData.STACKS] < EVT_MECH_24_PLAYER_STACKS_MIN:
        eventPlayer.eventTempIndex.remove(EventId.GAMBLER_WINNER_TAKE_ALL)
    if eventPlayer.mod_dmg_perma <= 0 and eventPlayer.mod_speed_perma >= 0 and eventPlayer.mod_heal_perma >= 0 and eventPlayer.heart_steel[HeartSteelData.STACKS] >= 0:
        eventPlayer.eventTempIndex.remove(EventId.MIRROR_INVERSION)
