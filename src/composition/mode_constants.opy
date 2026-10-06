#!mainFile "../main.opy"

#!define FULL_DESCRIPTION \
    STR_DESC_EVENT_STATUS "\n" \
    STR_DESC_GAMEPLAY_TAG "\n" \
    "————————————————\n" \
    STR_MODE_CODE "\n" \
    STR_DESC_LAST_UPDATE_PREFIX VERSION "\n\n" \
    "github.com/OWBastion/Bastion\n\n" \
    STR_DESC_CONTACT_INFO "\n\n" \
    STR_DESC_ORIGINAL_CREDIT

# ========= lobby（房间容量/常改项）=========
#!define LOBBY_TEAM1_SLOTS 8
#!define LOBBY_TEAM2_SLOTS 0
#!define LOBBY_SPECTATOR_SLOTS_MAIN 2
#!define LOBBY_SPECTATOR_SLOTS_DEV 2
#!define LOBBY_SPECTATOR_SLOTS LOBBY_SPECTATOR_SLOTS_DEV

# =========================
# General（百分比类最适合常量化）
# =========================
#!define PERK_GENERATION_PCT 500
#!define RESPAWN_TIME_PCT 10
#!define HEALTHPACK_RESPAWN_TIME_PCT 75

# =========================
# Workshop Settings（UI/逻辑会复用）
# =========================
#!define SETTING_AUTOREBOOT_HOURS 2
#!define SETTING_DIFFICULTY_DEFAULT 4
