#!mainFile "../../main.opy"


#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "OverPy Map Detection":
    if getCurrentMap() in [Map.AYUTTHAYA, Map.BLACK_FOREST, Map.BLIZZ_WORLD, Map.BUSAN, Map.CASTILLO, Map.CHATEAU_GUILLARD, Map.AATLIS, Map.CIRCUIT_ROYAL, Map.COLOSSEO, Map.DORADO, Map.ECOPOINT_ANTARCTICA, Map.EICHENWALDE, Map.EICHENWALDE, Map.ESPERANCA, Map.THRONE_OF_ANUBIS, Map.HANAMURA, Map.HAVANA, Map.HOLLYWOOD, Map.HOLLYWOOD, Map.HORIZON_LUNAR_COLONY, Map.ILIOS, Map.SURAVASA, Map.JUNKERTOWN, Map.NEW_JUNK_CITY, Map.KINGS_ROW, Map.LIJIANG_CONTROL_CENTER, Map.LIJIANG_GARDEN, Map.LIJIANG_NIGHT_MARKET, Map.LIJIANG_TOWER, Map.MALEVENTO, Map.MIDTOWN, Map.NECROPOLIS, Map.NEPAL, Map.NEPAL, Map.NEPAL, Map.NEPAL, Map.NEPAL, Map.NEW_QUEEN_STREET, Map.NUMBANI, Map.OASIS, Map.PARAISO, Map.PARIS, Map.PETRA, Map.PRACTICE_RANGE, Map.RIALTO, Map.ROUTE66, Map.TEMPLE_OF_ANUBIS, Map.VOLSKAYA, Map.WATCHPOINT_GIBRALTAR, Map.NEON_JUNCTION, Map.WORKSHOP_EXPANSE, Map.WORKSHOP_GREEN_SCREEN, Map.WORKSHOP_ISLAND, Map.SHAMBALI_MONASTERY]:
        __currentMap___ = getCurrentMap()
        return
    __currentMap___ = raycast(vect(500, 100, 500), vect(-500, -100, -500), null, null, false).getHitPosition()
    if __currentMap___ == vect(0, 0, 0) or __currentMap___ == vect(-500, -100, -500):
        __currentMap___ = raycast(vect(30, 5, 0), vect(-30, -10, -10), null, null, false).getHitPosition()
        if __currentMap___ == vect(-30, -10, -10):
            __currentMap___ = raycast(vect(200, 20, 100), vect(100, -100, -100), null, null, false).getHitPosition()
            if __currentMap___ == vect(100, -100, -100):
                __currentMap___ = raycast(vect(300, 20, -100), vect(300, -100, 100), null, null, false).getHitPosition()
                if __currentMap___ == vect(300, -100, 100):
                    __currentMap___ = raycast(vect(50, 100, -150), vect(-50, -100, -160), null, null, false).getHitPosition()
                    if __currentMap___ == vect(-50, -100, -160):
                        __currentMap___ = raycast(vect(0, 300, 340), vect(0, -100, -300), null, null, false).getHitPosition()
                        if __currentMap___ == vect(0, -100, -300):
                            __currentMap___ = raycast(vect(140, 10, -240), vect(200, -10, -300), null, null, false).getHitPosition()
                            if __currentMap___ == vect(200, -10, -300):
                                __currentMap___ = raycast(vect(-180, 30, 60), vect(-180, -50, -60), null, null, false).getHitPosition()
    __currentMap___ = 100 * ceil(__currentMap___.y) + 10 * round(__currentMap___.x) + floor(__currentMap___.z)
    if __currentMap___ == 10121:
        __currentMap___ = raycast(vect(-60, 20, -60), vect(60, -10, 60), null, null, false).getHitPosition()
        if __currentMap___ == vect(60, -10, 60):
            __currentMap___ = raycast(vect(-180, -70, 60), vect(-180, -100, -60), null, null, false).getHitPosition()
        __currentMap___ = 100 * ceil(__currentMap___.y) + 10 * round(__currentMap___.x) + floor(__currentMap___.z)
    controlCenterPosition = [getObjectivePosition(0), getObjectivePosition(1), getObjectivePosition(2)]