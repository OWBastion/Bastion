# Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

#!postCompileHook "post-compile-hook.js"

#!include "env/env.opy"
#!include "locales/zh-CN.opy"
#!define ENTRY_SPECTATOR_SLOTS LOBBY_SPECTATOR_SLOTS_MAIN
#!define ENTRY_ALLOW_PLAYERS_IN_QUEUE false
#!define ENTRY_AUTOREBOOT_HOURS 2
#!define ENTRY_CLASSIC_MAP_VARIANT CLASSIC_MAP_VARIANT_OFF
#!define ENTRY_DIFFICULTY 4
# Compile-time definitions
#!include "events/event_constants.opy"
#!include "events/event_ids.opy"
#!include "events/event_manifest.opy"
#!include "composition/mode_constants.opy"
#!include "map/classic_variants.opy"
#!include "utilities/macros.opy"
#!include "heroes/settings/team_rules.opy"
#!include "heroes/settings/all_teams.opy"

# Lobby, mode, and hero settings
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

# Variable slots and Workshop extensions
#!include "session/vars.opy"

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
#!include "session/game.opy"
#!include "session/title-vars.opy"
#!include "title/title-cn.opy"
#!include "composition/profile-cn.opy"
#!include "events/catalog/eventCatalogMain.opy"
#!include "events/catalog/eventCatalog.opy"

# Runtime modules in emission order
#!include "map/mapDetection.opy"
#!include "blacklist/init.opy"
#!include "blacklist/removeFromBlacklist.opy"
#!include "events/lifecycle/detectFlag.opy"

#!include "heroes/all_hero.opy"

#!include "events/allocation/buildCompatibleEventPool.opy"

#!include "events/allocation/buildCandidatePool.opy"

#!include "events/allocation/rejectSampling.opy"

# Player progression and event services
#!include "events/effects/healthPool.opy"

#!include "events/effects/dashDetector.opy"

#!include "player/savePlayerData.opy"

#!include "player/progressHero.opy"

#!include "player/playerRegen.opy"

#!include "session/setDifficulty.opy"

#!include "player/thirdPerson.opy"

#!include "bastion/createBastionBot.opy"

#!include "events/integrity/hashtag.opy"

# Player attributes and event lifecycle
#!include "player/updatePlayerStats.opy"

#!include "events/lifecycle/setEventDuration.opy"

#!include "events/lifecycle/resetPlayerCD.opy"

#!include "player/setPlayerSize.opy"

#!include "events/lifecycle/clearEventEffect.opy"

#!include "events/lifecycle/setPlayerEvent.opy"

#!include "events/lifecycle/clearPlayerEvent.opy"

#!include "player/setPlayerHP.opy"

#!include "player/startCombatRegen.opy"

#!include "events/allocation/assignPlayerEvent.opy"

#!include "events/effects/buffEffects.opy"

#!include "events/effects/debuffEffects.opy"

#!include "events/effects/mechEffects.opy"

# Maps
#!include "map/setup_all_map.opy"

#!include "bastion/init.opy"

#!include "map/controlJump.opy"
#!include "player/finishSettlement.opy"
#!include "events/integrity/masteryRunCode.opy"

#!include "effects/init.opy"
#!include "map/interactions.opy"
#!include "effects/nano.opy"
#!include "effects/player.opy"

# 事件完整重置入口；保持在 status.opy 前以维持子程序索引与规则顺序
#!include "events/lifecycle/resetPlayerEventState.opy"
#!include "player/status.opy"
#!include "player/init.opy"


#!include "utilities/system/autoReboot.opy"

# Player, host, and developer menus
#!include "menu/frame.opy"
#!include "menu/hero.opy"
#!include "menu/dev/pages.opy"
#!include "menu/player.opy"
#!include "menu/dev/difficulty.opy"
#!include "menu/host/reboot.opy"
#!include "menu/dev/restart.opy"
#!include "menu/host/moderation.opy"
#!include "menu/dev/admin.opy"
#!include "menu/dev/movement.opy"
#!include "menu/dev/actions.opy"
#!include "menu/dev/weights.opy"

# CN titles and achievements
#!include "title/map-title-data.opy"
#!include "title/setPlayerTitle.opy"
#!include "title/applyTitleColor.opy"
#!include "player/unlockAchievement.opy"
#!include "title/init.opy"
#!include "title/hashtag.opy"
#!include "title/effects.opy"
#!include "title/player-init.opy"
#!include "menu/title.opy"
#!include "player/achievement.opy"
