#!mainFile "../main.opy"

# Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

enum MechEventId:
    # legacy numeric id: 0
    EXTREME_CHALLENGE = 0
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
    # sentinel only for integrity checks (do not register as an event)
    COUNT

#!define MECH_EVENT_ID_COUNT MechEventId.COUNT
