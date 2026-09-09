#!include "../constants/"
#!include "../utilities/dev_support/macros.opy"
#!include "../heroes/settings/team_rules.opy"
#!include "../heroes/settings/all_teams.opy"

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
        "spectatorSlots": ENTRY_SPECTATOR_SLOTS,
        "returnToLobby": "never",
        "allowPlayersInQueue": ENTRY_ALLOW_PLAYERS_IN_QUEUE
    },
    "gamemodes": {
        "ctf": {
            "enabledMaps": ["ayutthaya"],
            "flagScoreRespawnTime": 15,
            "flagReturnTime": 4,
            "flagDroppedLockTime": 5
        },
        "skirmish": {
            "disabledMaps": ["kingsRow", "workshopChamber", "workshopIsland", "workshopIslandNight", "workshopExpanse", "workshopExpanseNight", "workshopGreenScreen", "blizzWorld"]
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
        "自动重开时间间隔（小时）": ENTRY_AUTOREBOOT_HOURS,
        "经典版地图": [ENTRY_CLASSIC_MAP_VARIANT],
        "难度": [ENTRY_DIFFICULTY]
    }
}

#!include "../env/vars.opy"

#!extension buffStatusEffects
#!extension debuffStatusEffects
#!extension buffAndDebuffSounds
#!extension energyExplosionEffects
#!extension spawnMoreDummyBots

#!optimizeStrict
#!rulePrefixTemplate f"[{$prefix}] {$rule}" if $prefix and $rule and not $isDelimiter else $rule

rule STR_LICENSE_TITLE:
    @Disabled
    @Delimiter

rule STR_LICENSE_PERMIT:
    @Disabled
    @Delimiter
