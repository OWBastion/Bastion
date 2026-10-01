#!mainFile "../main.opy"

# Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

enum EventId:
    # ---- Buff ----
    # legacy numeric id: 0
    OLIVIA_GIFT = 0
    # legacy numeric id: 1
    GALE_BLESSING
    # legacy numeric id: 2
    IRON_BULWARK
    # legacy numeric id: 4
    LIFE_SPRING
    # legacy numeric id: 5
    BLACK_FANS_ASSAULT
    # legacy numeric id: 6
    SPEED_STACK
    # legacy numeric id: 7
    FLESH_REGEN
    # legacy numeric id: 8
    HEART_OF_STEEL
    # legacy numeric id: 9
    DEATH_DELAY
    # legacy numeric id: 11
    KONAMI_CODE
    # legacy numeric id: 12
    PHOTON_SHIELD
    # legacy numeric id: 13
    REGROUP_CALL
    # legacy numeric id: 14
    WILL_TO_WIN
    # legacy numeric id: 15
    PHEIDIPPIDES_TRIAL
    # legacy numeric id: 16
    HEART_OF_STEEL_PRO
    # legacy numeric id: 18
    ULT_MOMENTUM
    # legacy numeric id: 19
    PHASE_SURGE
    # legacy numeric id: 20
    BODYGUARD
    # legacy numeric id: 21
    MARTYR_TRIAL
    # legacy numeric id: 24
    F5_REFRESH
    # legacy numeric id: 25
    HEALING_TOWER_PROMAX
    # legacy numeric id: 29
    MAGIC_MASTER
    # legacy numeric id: 30
    DIVINE_REINFORCEMENT
    # legacy numeric id: 31
    TEMPER_HEART
    # legacy numeric id: 32
    BATTLEFIELD_MEDIC
    # ---- Debuff ----
    # legacy numeric id: 0
    GRAVITY_ANOMALY
    # legacy numeric id: 1
    EMP
    # legacy numeric id: 2
    SACRIFICE
    # legacy numeric id: 3
    VULNERABLE
    # legacy numeric id: 4
    SPEED_LIMIT_40
    # legacy numeric id: 5
    GRAVITY_PULL
    # legacy numeric id: 6
    OSTEOPOROSIS
    # legacy numeric id: 7
    EMP_PROMAX
    # legacy numeric id: 8
    ENERGY_LEAK
    # legacy numeric id: 9
    SHARE_THE_PAIN
    # legacy numeric id: 10
    FEAST_FRENZY
    # legacy numeric id: 11
    POWERLESS_SPOUSE
    # legacy numeric id: 13
    HALVED
    # legacy numeric id: 14
    SELFLESS_GIVEAWAY
    # legacy numeric id: 15
    KEEP_DISTANCE_AURA
    # legacy numeric id: 19
    MOON_ROCKET
    # legacy numeric id: 20
    ADLERSBRUNN_WRAITH
    # legacy numeric id: 21
    WAYWARD_NAVIGATION
    # legacy numeric id: 22
    OVERWEIGHT_PACK
    # ---- Mech ----
    # legacy numeric id: 0
    EXTREME_CHALLENGE
    # legacy numeric id: 1
    GAMBLER
    # legacy numeric id: 2
    MINI_FORM
    # legacy numeric id: 3
    STEALTH_CROUCH
    # legacy numeric id: 4
    BRAKE_FAILURE
    # legacy numeric id: 5
    JUMP_THRUST
    # legacy numeric id: 6
    GAMBLER_SPEED_CHALLENGE
    # legacy numeric id: 7
    CHEAT_CARD_COUNTING
    # legacy numeric id: 8
    GAMBLER_SHORT_INVESTMENT
    # legacy numeric id: 10
    CHEAT_SKIP_HERO
    # legacy numeric id: 11
    NESTING_DOLL
    # legacy numeric id: 12
    GAMBLER_LONG_INVESTMENT
    # legacy numeric id: 13
    VALKYRIE_DESCENT
    # legacy numeric id: 14
    TRINITY_SSR
    # legacy numeric id: 15
    GAMBLER_DICE_MANIAC
    # legacy numeric id: 16
    GAMBLER_HEART_OF_STEEL
    # legacy numeric id: 17
    GAMBLER_ALL_IN_ART_5
    # legacy numeric id: 18
    VAMPIRE
    # legacy numeric id: 18
    THIEF
    # legacy numeric id: 19
    GAMBLER_HELPFUL_SOUL
    # legacy numeric id: 22
    CHEAT_BACKROOM_DEAL
    # legacy numeric id: 23
    MIRROR_INVERSION
    # legacy numeric id: 24
    GAMBLER_WINNER_TAKE_ALL
    # ---- Anniversary 2026 ----
    # legacy numeric id: buff 33
    WHERE_YOU_FALL
    # legacy numeric id: debuff 25
    STATIC_FIELD
    # legacy numeric id: mech 25
    PROPHET
    # legacy numeric id: debuff 26
    BLACK_HOLE
    # legacy numeric id: mech 27
    EQUIVALENT_EXCHANGE
    # legacy numeric id: mech 28
    CYCLE_REPLAY
    # legacy numeric id: mech 29
    LIFE_PULSE
    # legacy numeric id: buff 10 (retired event reintroduced)
    SYMBIOSIS
    # legacy numeric id: mech 30 (retired event reintroduced)
    TOXIC_FOG
    # sentinel only for integrity checks (do not register as an event)
    COUNT
