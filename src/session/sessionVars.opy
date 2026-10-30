#Global variables

subroutine waitLoadBrief
subroutine waitLoadShort
subroutine waitLoadLong
subroutine waitHeroMatch
subroutine waitTick2

globalvar bastionPosition 0
globalvar resetPosition 2
globalvar creditsPosition 3
globalvar endPosition 4
globalvar heroList 5
globalvar missingHeroes 6
globalvar maxDeath 7
globalvar kills 9
globalvar bastionBotTargetPrefer 10
globalvar textIDs 16

globalvar devList 23
globalvar __currentMap___ 24
globalvar dmgReduction 25

globalvar rebootTime 27
globalvar targetPlayer 28
globalvar targetPlayerIndex 29
globalvar thirdPersonPosition 30
globalvar debugMode 31
globalvar bastionBotSeconFire 34

globalvar controlCenterPosition 36
globalvar controlJumpPosition 37
globalvar controlRespawnPosition 38
globalvar controlRespawnAxis 39
globalvar controlRespawnAxisThreshold 40
globalvar turnSpeedMultiplier 55
globalvar berserkerTime 56
globalvar eventDuration 58
globalvar eventName 59
globalvar eventDesc 60
globalvar eventCount 61
globalvar eventType 63
globalvar eventDurationHud 64
globalvar eventWeight 65
globalvar hashTag 69
globalvar gamblerHeartsteelJackpot 70
globalvar vishkarEventActivated 72
globalvar eventCatalogId 82
globalvar eventCatalogType
globalvar eventCatalogWeight
globalvar obstrucVis 89
globalvar heroColor 90
globalvar breathPalette 91
globalvar springBoardPosition 100
globalvar portalPosition 101
globalvar phaseHero 103
globalvar __currentMapText___ 105
globalvar classicMapVariant 108
globalvar __currentMapClassicText___
globalvar devEventCategory
globalvar devEventIndex
globalvar challengeTitleIds
globalvar hashTagWeightVerifyState
globalvar masteryRunCode
globalvar runCodeWeightTotal
globalvar eventCatalogWeightTotal
globalvar prophetViewers

#Player variables

playervar heroNumber 0
playervar progressionDeathCount 1
playervar skipCount 2
playervar isWinner 3
playervar dmgReduc 4
playervar anaSleepLimit 5
playervar temp 6
playervar attacker 7
playervar target 9
playervar aimPosition 10
playervar turnSpeed 11
playervar tempAimPosition 12
playervar nearestTargetOutOfLoS 13
playervar dvaStart 14
playervar healID 15
playervar isInPosition 16
playervar rainbowOff 17
playervar runDeathCount 18
playervar joinTime 19
playervar menu 20
playervar menuTextID 21
playervar isDev 22
playervar third 24
playervar hasNano 25
playervar nanoEffect 26
playervar invincible 27
playervar invincibleEffect 28
playervar isAirWalkEnabled 29
playervar isPortalEnabled 30
playervar controlCenterIndex 31
playervar controlJumpIndex 32
playervar controlPlayerRespawnPosition 33
playervar winnerTime 42
playervar eventMission 58
playervar eventEffectPlayers 59
playervar eventId 60
playervar eventLastId 61
playervar eventType 62
playervar eventDuration 63
playervar eventName 64
playervar eventDesc 65
playervar eventCount 66
playervar eventLucky 67
playervar eventEffect 68
playervar eventDurationHud 69
playervar eventLoopCount 70
playervar eventIsSelected 71
playervar eventCandidateIndex 72
playervar eventTempIndex 74
playervar eventCompatibleBasePool
playervar eventCategoryCommitted
playervar mod_speed_event 76
playervar mod_speed_perma 77
playervar mod_heal_event 78
playervar heal_recv 79
playervar mod_dmg_taken 81
playervar mod_dmg_perma 82
playervar healthId 85
playervar hack_timer 86
playervar targetWeight 87
playervar targetSilence 88
playervar hudTextId 89
playervar heart_steel 90
playervar obstrucVis 91
playervar sizeHealth 92
playervar empProMax 95
playervar setPlayerHP 96
playervar dlcTimeChallenge 97
playervar knockback 99
playervar phaseState 100
playervar hp_data 101
# 强制下一个事件类型契约（EventType；-1 = 无契约，因 0==null 会与 BUFF 混淆）。由作弊/赌徒事件写入，drawForcedEvent 消费
playervar eventForceType 102
playervar eventForceCount 103
# 挂起强制契约的来源事件 ID（与 eventForceType 同生命周期；-1 = 无），供连锁挑战追踪「通过某事件触发某事件」
playervar eventForceSourceId
# 强制类型抽样中正在校验的标量候选（drawForcedEvent 内部暂存）
playervar eventForceIndex
playervar eventSize 104
playervar eventTargetHP 105
playervar lastThreatTime 108
playervar hudText 109
playervar eventMissionGoal 110
# 事件持有的伤害/治疗修正 ID，以单元素数组存放（空数组 = 未持有；ID 0 与 null 相等）
playervar eventModificationId
playervar altFormActive 111
playervar playerOnceEventState
playervar menuHeroIndex
playervar mod_heal_perma
playervar thiefBuffStolen
playervar eventMatchCounters
playervar eventNextIndex
playervar eventEndTime
playervar prophetTextId

playervar savedDataIndex

# 通关结算卡显示截止时间（绝对时刻，null = 不显示）：通关置 now+20，玩家菜单"显示结算卡"重置为 now+20；持久 20s 窗口无法复用事件 scratch 槽
playervar settlementCardEnd
