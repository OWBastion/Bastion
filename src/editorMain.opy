# Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

#!postCompileHook "postCompileHook.js"

#!include "env/envEditor.opy"
#!include "locales/zh-CN.opy"
#!define ENTRY_SPECTATOR_SLOTS LOBBY_SPECTATOR_SLOTS_DEV
#!define ENTRY_ALLOW_PLAYERS_IN_QUEUE true
#!define ENTRY_AUTOREBOOT_HOURS SETTING_AUTOREBOOT_HOURS
#!define ENTRY_CLASSIC_MAP_VARIANT CLASSIC_MAP_VARIANT_OFF
#!define ENTRY_DIFFICULTY SETTING_DIFFICULTY_DEFAULT
# Compile-time definitions
#!include "events/eventConstants.opy"
#!include "events/eventIds.opy"
#!include "events/eventManifest.opy"
#!include "composition/modeConstants.opy"
#!include "map/classicVariants.opy"
#!include "env/macros.opy"
#!include "heroes/settings/teamRules.opy"
#!include "heroes/settings/allTeams.opy"

# Lobby, mode, and hero settings
settings {
    "main": {
        "description": STR_EDITOR_DESC,
        "modeName": STR_EDITOR_MODE_NAME
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

# Variable slots and Workshop extensions
#!include "session/sessionVars.opy"
#!include "session/editorVars.opy"

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

# Session initialization and profile policy
#!include "session/sessionGame.opy"
#!include "session/titleVars.opy"
#!include "composition/profileEditor.opy"

# Runtime modules
#!include "map/mapDetection.opy"
#!include "blacklist/initBlacklist.opy"
#!include "blacklist/removeFromBlacklist.opy"

#!include "session/setDifficulty.opy"

#!include "player/thirdPerson.opy"

#!include "bastion/createBastionBot.opy"

# Maps
#!include "map/setupAllMap.opy"

#!include "bastion/initBastion.opy"

#!include "map/controlJump.opy"

#!include "effects/initEffects.opy"
#!include "map/interactions.opy"

# Map editor
#!include "editor/editorPoints.opy"
#!include "editor/editorEditMode.opy"
#!include "editor/editorJoin.opy"
#!include "editor/editorHud.opy"
