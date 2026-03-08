#!include "env/env.opy"
#!include "locales/zh-CN.opy"
# Useful constants and macros
#!include "constants/"
#!include "utilities/dev_support/macros.opy"
#!include "heroes/settings/shared_team_rules.opy"
#!include "heroes/settings/shared_all_teams.opy"
#!include "heroes/settings/main_overrides.opy"
#!include "heroes/settings/main_heroes_settings.opy"

settings {
    "main": {
        "description": FULL_DESCRIPTION,
        "modeName": STR_MODE_NAME
    },
    "lobby": {
        "mapRotation": "afterGame",
        "enableMatchVoiceChat": true,
        "team1Slots": LOBBY_TEAM1_SLOTS,
        "team2Slots": LOBBY_TEAM2_SLOTS,
        "spectatorSlots": LOBBY_SPECTATOR_SLOTS_MAIN,
        "returnToLobby": "never",
        "allowPlayersInQueue": true
    },
    "gamemodes": {
        "ctf": {
            "enabledMaps": [
                "ayutthaya"
            ],
            "flagScoreRespawnTime": 15,
            "flagReturnTime": 4,
            "flagDroppedLockTime": 5
        },
        "skirmish": {
            "disabledMaps": [
                "kingsRow",
                "workshopChamber",
                "workshopIsland",
                "workshopIslandNight",
                "workshopExpanse",
                "workshopExpanseNight",
                "workshopGreenScreen",
                "blizzWorld"
            ]
        },
        "general": {
            "enablePerks": true,
            "perkGeneration%": PERK_GENERATION_PCT,
            "respawnTime%": RESPAWN_TIME_PCT,
            "healthPackRespawnTime%": HEALTHPACK_RESPAWN_TIME_PCT,
            "enableEnemyHealthBars": false,
            "gamemodeStartTrigger": "manual",
            "heroLimit": "off",
            "enableKillCam": false
        }
    },
    "heroes": {
        "team1": HERO_SETTINGS_TEAM1,
        "team2": HERO_SETTINGS_TEAM2,
        "allTeams": HERO_SETTINGS_ALL_TEAMS
    },
    "workshop": {
        "自动重开时间间隔（小时）": 2,
        "难度": [
            4
        ]
    }
}

#Global variables

globalvar bastionPosition 0
globalvar heroRingPosition 1
globalvar resetPosition 2
globalvar creditsPosition 3
globalvar endPosition 4
globalvar heroList 5
globalvar missingHeroes 6
globalvar maxDeath 7
globalvar kills 9
globalvar bastionBotTargetPrefer 10
globalvar scoreboardArray 12
globalvar firstPlace 13
globalvar secondPlace 14
globalvar thirdPlace 15
globalvar textIDs 16

globalvar devList 23
globalvar __currentMap___ 24
globalvar dmgReduction 25

globalvar rebootTime 27
globalvar targetPlayer 28
globalvar targetPlayerIndex 29
globalvar thirdPersonPosition 30
globalvar debugMode 31
globalvar debugInfo 32
globalvar devPlayer 33
globalvar bastionBotSeconFire 34

globalvar controlCenterPosition 36
globalvar controlJumpPosition 37
globalvar controlRespawnPosition 38
globalvar controlRespawnAxis 39
globalvar controlRespawnAxisThreshold 40
globalvar mapTitlePlayersByKey 43
globalvar allTitle 44
globalvar titlePlayer 45
globalvar playerTitleRelation 47
globalvar rgbList 48
globalvar turnSpeedMultiplier 55
globalvar berserkerTime 56
globalvar eventId 57
globalvar eventDuration 58
globalvar eventName 59
globalvar eventDesc 60
globalvar eventCount 61
globalvar eventRoll 62
globalvar eventType 63
globalvar eventDurationHud 64
globalvar eventWeight 65
globalvar hashTag 69
globalvar dlcBerserker 70
globalvar dlcVishkarEvent 71
globalvar vishkarEventActivated 72
globalvar globalEvent 79
globalvar globalEventId 80
globalvar buffEvent 81
globalvar buffEventId 82
globalvar debuffEvent 83
globalvar debuffEventId 84
globalvar mechEvent 85
globalvar mechEventId 86
globalvar obstrucVis 89
globalvar heroColor 90
globalvar breathRed 91
globalvar breathPurple 92
globalvar breathBlue 93
globalvar breathOrange 94
globalvar breathGold 95
globalvar springBoardPosition 100
globalvar portalPosition 101
globalvar phaseHero 103
globalvar __currentMapText___ 105
globalvar __currentPioneerText___ 106
globalvar __currentMapPioneerText___ 107
globalvar devEventCategory
globalvar devEventIndex
globalvar challengeTitleIds

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
playervar debugInfo 23
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
playervar playerTitleAndColor 37
playervar titleTextID 38
playervar rgb_vect 39
playervar info_pvar 40
playervar rgb_activated 41
playervar winnerTime 42
playervar playerTitles 43
playervar playerTitleIndex 44
playervar playerTitleRelationIndex 45
playervar A36TGrenadeAlive 53
playervar ignoreObstrucVis 57
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
playervar eventTempId 72
playervar eventTempWeight 73
playervar categoryRoll 74
playervar mod_speed_event 76
playervar mod_speed_perma 77
playervar mod_heal_event 78
playervar heal_recv 79
playervar healing_global 80
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
playervar possess 93
playervar possessed 94
playervar empProMax 95
playervar setPlayerHP 96
playervar dlcTimeChallenge 97
playervar toggleSpectate 98
playervar knockback 99
playervar phase_trigger 100
playervar hp_data 101
playervar eventForceRoll 102
playervar eventForceCount 103
playervar eventSize 104
playervar eventTargetHP 105
playervar lastThreatTime 108
playervar hudText 109
playervar eventMissionGoal 110
playervar altFormTrigger 111
playervar tempUnlockId
playervar earnedAchievements
playervar menuHeroIndex

#Activated extensions

#!extension buffStatusEffects
#!extension debuffStatusEffects
#!extension buffAndDebuffSounds
#!extension energyExplosionEffects
#!extension spawnMoreDummyBots

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule STR_LICENSE_TITLE:
    @Disabled
    @Delimiter

rule STR_LICENSE_PERMIT:
    @Disabled
    @Delimiter

#!include "utilities/system/mapDetection.opy"

#!include "blacklist/init.opy"

#!include "utilities/system/removeFromBlacklist.opy"
    
#!include "env/game.opy"

#!include "title/title-cn.opy"

#!include "events/init/detectFlag.opy"

#!include "heroes/all_hero.opy"

#!include "./config/eventConfig.opy"

#!include "events/allocation/rejectSampling.opy"

## Utilities: system
#!include "utilities/system/healthPool.opy"

#!include "utilities/system/dashDetector.opy"

#!include "utilities/system/savePlayerData.opy"

#!include "utilities/system/progressHero.opy"

#!include "utilities/system/playerRegen.opy"

#!include "utilities/system/setDifficulty.opy"

#!include "utilities/system/setThirdPerson.opy"

#!include "utilities/system/createBastionBot.opy"

#!include "utilities/system/setPlayerTitle.opy"

#!include "utilities/system/hashtag.opy"

#!include "utilities/system/unlockAchievement.opy"

## Utilities: event_core
#!include "utilities/event_core/updatePlayerStats.opy"

#!include "utilities/event_core/setEventDuration.opy"

#!include "utilities/event_core/resetPlayerCD.opy"

#!include "utilities/event_core/setPlayerSize.opy"

#!include "utilities/event_core/clearEventEffect.opy"

#!include "utilities/event_core/setPlayerEvent.opy"

#!include "utilities/event_core/clearPlayerEvent.opy"

#!include "utilities/event_core/setPlayerHP.opy"

#!include "utilities/event_core/startCombatRegen.opy"

#!include "events/allocation/assignPlayerEvent.opy"

#!include "events/effects/buffEffects.opy"

#!include "events/effects/debuffEffects.opy"

#!include "events/effects/mechEffects.opy"

# Maps
#!include "map/setup_all_map.opy"

#!include "bastion/init.opy"

rule "players pick up speed while not targeted for 3 seconds":
    @Event eachPlayer
    @Team 1
    @Condition dlcVishkarEvent == false
    @Condition eventPlayer.isMoving()
    @Condition getPlayersInRadius(eventPlayer, 60, Team.2, LosCheck.SURFACES)[0] == false
    
    wait(3, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setMoveSpeed(160)
    waitUntil(not eventPlayer.isMoving() or getPlayersInRadius(eventPlayer, 60, Team.2, LosCheck.SURFACES)[0], MAX_TIME)
    eventPlayer.setMoveSpeed(100)


rule "when players reaches the end and not respawn at first respawn point, they move to the first respawn point.":
    @Event eachPlayer
    @Team 1
    @Condition controlRespawnPosition != null
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isInSpawnRoom() == true
    @Condition (any([controlRespawnAxis == 0 and distance(vect(eventPlayer.getPosition().x, 0, 0), vect(controlRespawnPosition[eventPlayer.controlJumpIndex].x, 0, 0)) >= controlRespawnAxisThreshold, controlRespawnAxis == 1 and distance(vect(0, eventPlayer.getPosition().y, 0), vect(0, controlRespawnPosition[eventPlayer.controlJumpIndex].y, 0)) >= controlRespawnAxisThreshold, controlRespawnAxis == 2 and distance(vect(0, 0, eventPlayer.getPosition().z), vect(0, 0, controlRespawnPosition[eventPlayer.controlJumpIndex].z)) >= controlRespawnAxisThreshold])) == true
    
    eventPlayer.teleport(controlRespawnPosition[eventPlayer.controlJumpIndex])
    eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), controlJumpPosition[eventPlayer.controlJumpIndex].getPosition()), Relativity.TO_WORLD)
    wait(0.032)


rule "when a player reaches the control jump point, they move on to the next map":
    @Event eachPlayer
    @Team 1
    @Condition controlRespawnPosition != null
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.isMoving() == true
    #@Condition eventPlayer.getPosition().y >= controlJumpPosition[eventPlayer.controlJumpIndex].y
    #@Condition distance(eventPlayer.getPosition() * vect(1, 0, 1), controlJumpPosition[eventPlayer.controlJumpIndex] * vect(1, 0, 1)) <= 4
    
    wait(0.032, Wait.ABORT_WHEN_FALSE)
    wait(0.2)
    if all([((eventPlayer.possess[0].getPosition() if (eventPlayer.possess != null and eventPlayer.possess[0] != null and entityExists(eventPlayer.possess[0])) else eventPlayer.getPosition()).y >= controlJumpPosition[eventPlayer.controlJumpIndex].y), distance((eventPlayer.possess[0].getPosition() if (eventPlayer.possess != null and eventPlayer.possess[0] != null and entityExists(eventPlayer.possess[0])) else eventPlayer.getPosition()) * vect(1, 0, 1), controlJumpPosition[eventPlayer.controlJumpIndex] * vect(1, 0, 1)) <= 4]):
        if controlJumpPosition[eventPlayer.controlJumpIndex] == null:
            goto lbl_0
        eventPlayer.controlJumpIndex++
        wait()
        if any([eventPlayer.hasStatus(Status.PHASED_OUT), eventPlayer.hasStatus(Status.INVINCIBLE)]):
            goto lbl_1
        eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 0.5)
        eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 0.5)
        lbl_1:
        eventPlayer.teleport(controlRespawnPosition[eventPlayer.controlJumpIndex])
        eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), controlJumpPosition[eventPlayer.controlJumpIndex].getPosition()), Relativity.TO_WORLD)
        wait(2.16)
    lbl_0:
    loop()

rule "when a player reaches the end, they move on to the next hero or win if they're bastion":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() == true
    @Condition (eventPlayer.possess[0].getPosition() if (eventPlayer.possess != null and eventPlayer.possess[0] != null and entityExists(eventPlayer.possess[0])) else eventPlayer.getPosition()).y >= endPosition.y
    @Condition distance((eventPlayer.possess[0].getPosition() if (eventPlayer.possess != null and eventPlayer.possess[0] != null and entityExists(eventPlayer.possess[0])) else eventPlayer.getPosition()) * vect(1, 0, 1), endPosition * vect(1, 0, 1)) <= 4
    
    if len(eventPlayer.possessed) > 0:
        eventPlayer.possessed = []
    eventPlayer.respawn()
    wait(0.032)
    if controlRespawnPosition == null:
        goto lbl_0
    eventPlayer.controlJumpIndex = 0
    eventPlayer.teleport(controlRespawnPosition[0])
    wait(0.032)
    eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), controlJumpPosition[0].getPosition()), Relativity.TO_WORLD)
    lbl_0:
    if eventPlayer.heroNumber + 1 < len(heroList) and eventPlayer.getHero() == heroList[eventPlayer.heroNumber]:
        progressHero()
    elif eventPlayer.getHero() == heroList.last() and not eventPlayer.isWinner:
        eventPlayer.isWinner = true
        eventPlayer.winnerTime = evalOnce(getTotalTimeElapsed()) - eventPlayer.joinTime
        if any([eventPlayer.dmgReduc, eventPlayer.invincible, eventPlayer.isPortalEnabled, eventPlayer.isAirWalkEnabled]):
            goto lbl_1
        bigMessage(
            getPlayers(Team.1),
            STR_MSG_WIN_ANNOUNCE.format(
                eventPlayer,
                # 统计部分
                STR_MSG_WIN_STATS.format(eventPlayer.runDeathCount, eventPlayer.skipCount),
                # 时间部分
                "{0}{1}{2}".format(
                    # 小时部分
                    STR_TIME_UNIT_HOUR.format(floor(eventPlayer.winnerTime / 3600)) if (eventPlayer.winnerTime != null and eventPlayer.winnerTime >= 3600) else "",
                    
                    # 分钟部分
                    STR_TIME_UNIT_MIN.format(floor((eventPlayer.winnerTime % 3600) / 60)) if (eventPlayer.winnerTime != null and eventPlayer.winnerTime >= 60) else "",
                    
                    # 秒部分
                    STR_TIME_UNIT_SEC.format(floor(eventPlayer.winnerTime % 60)) if (eventPlayer.winnerTime != null) else STR_TIME_UNIT_ZERO_SEC
                )
            )
        )
        lbl_1:
        smallMessage(eventPlayer, STR_MSG_WIN_HINT.format(iconString(Icon.CHECKMARK)))
        savePlayerData()


rule "winners earn their ult once per minute":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isWinner != false
    @Condition eventPlayer.getUltCharge() < 100
    @Condition eventPlayer.isUsingUltimate() == false
    
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 5)
    wait(3)
    if ruleCondition:
        loop()

#!include "effects/init.opy"
#!include "effects/nano.opy"
#!include "effects/player.opy"

#!include "player/status.opy"
#!include "player/init.opy"
#!include "title/init.opy"


rule "auto reboot":
    @Condition getTotalTimeElapsed() >= rebootTime - 60
    
    bigMessage(getAllPlayers(), STR_MSG_AUTO_RESTART_1MIN)
    wait(60)
    restartMatch()

#!include "utilities/dev_support/devTool.opy"

#!include "player/achievement.opy"
