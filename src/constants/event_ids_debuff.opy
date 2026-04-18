#!mainFile "../main.opy"

# Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

enum DebuffEventId:
    # legacy numeric id: 0
    GRAVITY_ANOMALY = 0
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
    # legacy numeric id: 12
    GRIEVOUS_WOUNDS
    # legacy numeric id: 13
    HALVED
    # legacy numeric id: 14
    SELFLESS_GIVEAWAY
    # legacy numeric id: 15
    KEEP_DISTANCE_AURA
    # legacy numeric id: 17
    CHAIN_OVERLOAD
    # legacy numeric id: 18
    HEALTH_SYNC
    # legacy numeric id: 19
    MOON_ROCKET
    # legacy numeric id: 20
    ADLERSBRUNN_WRAITH
    # legacy numeric id: 21
    WITHER
    # sentinel only for integrity checks (do not register as an event)
    COUNT

#!define DEBUFF_EVENT_ID_COUNT DebuffEventId.COUNT
