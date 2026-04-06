#!mainFile "../main.opy"

# Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

enum BuffEventId:
    # legacy numeric id: 0
    OLIVIA_GIFT = 0
    # legacy numeric id: 1
    GALE_BLESSING
    # legacy numeric id: 2
    IRON_BULWARK
    # legacy numeric id: 3
    ADRENALINE
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
    # legacy numeric id: 10
    SYMBIOSIS
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
    # legacy numeric id: 17
    STAT_POWER
    # legacy numeric id: 18
    ULT_MOMENTUM
    # legacy numeric id: 19
    PHASE_SURGE
    # legacy numeric id: 20
    BODYGUARD
    # legacy numeric id: 21
    MARTYR_TRIAL
    # legacy numeric id: 22
    HYPERACTIVE_HEAL
    # legacy numeric id: 23
    MORALE_BOOST_PROMAX
    # legacy numeric id: 24
    F5_REFRESH
    # legacy numeric id: 25
    HEALING_TOWER_PROMAX
    # legacy numeric id: 26
    SUPER_TRANSFORM
    # legacy numeric id: 27
    DRAW_FIRE
    # legacy numeric id: 29
    MAGIC_MASTER
    # sentinel only for integrity checks (do not register as an event)
    COUNT

#!define BUFF_EVENT_ID_COUNT BuffEventId.COUNT
