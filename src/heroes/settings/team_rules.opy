# =========================
# Team 1（通用英雄参数）
# =========================
#!define TEAM1_ABILITY_COOLDOWN_PCT 40

# =========================
# Team 2 - General（阵营基调，常会调）
# =========================
#!define TEAM2_DAMAGE_RECEIVED_PCT 25
#!define TEAM2_ABILITY_COOLDOWN_PCT 0
#!define TEAM2_HEALTH_PCT 500

# Team 2 - Bastion（核心Boss向配置，建议抽）
#!define BOSS_BASTION_SEC_FIRE_COOLDOWN_PCT 0
#!define BOSS_BASTION_SEC_FIRE_KB_PCT 200
#!define BOSS_BASTION_PROJECTILE_SPEED_PCT 175
#!define BOSS_BASTION_INFINITE_AMMO true
#!define BOSS_BASTION_HEALTH_PCT 500


macro HERO_SETTINGS_TEAM1 = {
    "general": {
        "abilityCooldown%": TEAM1_ABILITY_COOLDOWN_PCT
    }
}

macro HERO_SETTINGS_TEAM2 = {
    "bastion": {
        "secondaryFireCooldown%": BOSS_BASTION_SEC_FIRE_COOLDOWN_PCT,
        "secondaryFireKb%": BOSS_BASTION_SEC_FIRE_KB_PCT,
        "projectileSpeed%": BOSS_BASTION_PROJECTILE_SPEED_PCT,
        "enableInfiniteAmmo": BOSS_BASTION_INFINITE_AMMO,
        "health%": BOSS_BASTION_HEALTH_PCT
    },
    "general": {
        "damageReceived%": TEAM2_DAMAGE_RECEIVED_PCT,
        "abilityCooldown%": TEAM2_ABILITY_COOLDOWN_PCT,
        "health%": TEAM2_HEALTH_PCT
    }
}
