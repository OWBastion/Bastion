#!mainFile "../main.opy"

#!optimizeStrict

rule "Load CN map title holders":

    wait(0.032)
    __currentMapPioneerText___ = __currentMapText___
    __currentPioneerText___ = null
    if (__currentMap___ == Map.AATLIS or __currentMap___ == 1826) == true:
        __currentMapPioneerText___ = "织金"
        __currentPioneerText___ = "门徒"
    elif __currentMap___ == Map.WATCHPOINT_GIBRALTAR:
        __currentMapPioneerText___ = "守望先锋" if random.randint(0, 99) < 50 else "黑爪特工"
        __currentPioneerText___ = ""
    elif __currentMap___ == Map.PARAISO:
        __currentMapPioneerText___ = ""
        __currentPioneerText___ = "黄金节拍"
    elif (__currentMap___ == Map.AYUTTHAYA or __currentMap___ == 1826) == true:
        __currentMapPioneerText___ = "大城"
        __currentPioneerText___ = "守护者"
    elif (__currentMap___ == Map.NEON_JUNCTION or __currentMap___ == -6860) == true:
        __currentMapPioneerText___ = "桥元御守"
        __currentPioneerText___ = ""
    elif (getCurrentMap() == Map.ANTARCTIC_PENINSULA or __currentMap___ == 6177) == true:
        __currentMapPioneerText___ = "科研先锋"
        __currentPioneerText___ = ""
    elif __currentMap___ == Map.SURAVASA:
        __currentMapPioneerText___ = "瓦拉纳西"
        __currentPioneerText___ = "守护者"
    if (__currentMap___ == Map.AATLIS or __currentMap___ == 1826) == true:
        mapTitlePlayersByKey = [
            DATA_AATLIS[0].split("-"),
            DATA_AATLIS[1].split("-"),
            DATA_AATLIS[2].split("-"),
            []
        ]
    if (getCurrentMap() == Map.ANTARCTIC_PENINSULA or __currentMap___ == 6177) == true:
        mapTitlePlayersByKey = [
            DATA_ANTARCTIC_PENINSULA[0].split("-"),
            DATA_ANTARCTIC_PENINSULA[1].split("-"),
            DATA_ANTARCTIC_PENINSULA[2].split("-"),
            []
        ]
    if (__currentMap___ == Map.AYUTTHAYA or __currentMap___ == 1826) == true:
        mapTitlePlayersByKey = [
            DATA_AYUTTHAYA[0].split("-"),
            DATA_AYUTTHAYA[1].split("-"),
            DATA_AYUTTHAYA[2].split("-"),
            []
        ]
    if (__currentMap___ == Map.BLIZZ_WORLD or __currentMap___ == 1228) == true:
        mapTitlePlayersByKey = [
            DATA_BLIZZARD_WORLD[0].split("-"),
            DATA_BLIZZARD_WORLD[1].split("-"),
            DATA_BLIZZARD_WORLD[2].split("-"),
            []
        ]
    if __currentMap___ == Map.BUSAN:
        mapTitlePlayersByKey = [
            DATA_BUSAN[0].split("-"),
            DATA_BUSAN[1].split("-"),
            DATA_BUSAN[2].split("-"),
            []
        ]
    if __currentMap___ == Map.CIRCUIT_ROYAL:
        if classicMapVariant == CLASSIC_MAP_VARIANT_CIRCUIT_ROYAL:
            mapTitlePlayersByKey = [
                [],
                [],
                [],
                DATA_CIRCUIT_ROYAL[3].split("-")
            ]
        else:
            mapTitlePlayersByKey = [
                DATA_CIRCUIT_ROYAL[0].split("-"),
                DATA_CIRCUIT_ROYAL[1].split("-"),
                DATA_CIRCUIT_ROYAL[2].split("-"),
                DATA_CIRCUIT_ROYAL[3].split("-")
            ]
    if (getCurrentMap() == Map.COLOSSEO or __currentMap___ == 2147) == true:
        mapTitlePlayersByKey = [
            DATA_COLOSSEO[0].split("-"),
            DATA_COLOSSEO[1].split("-"),
            DATA_COLOSSEO[2].split("-"),
            []
        ]
    if __currentMap___ == Map.DORADO:
        mapTitlePlayersByKey = [
            DATA_DORADO[0].split("-"),
            DATA_DORADO[1].split("-"),
            DATA_DORADO[2].split("-"),
            []
        ]
    if (__currentMap___ == Map.EICHENWALDE) == true:
        mapTitlePlayersByKey = [
            DATA_EICHENWALDE[0].split("-"),
            DATA_EICHENWALDE[1].split("-"),
            DATA_EICHENWALDE[2].split("-"),
            []
        ]
    if (__currentMap___ == Map.ESPERANCA or __currentMap___ == 276) == true:
        mapTitlePlayersByKey = [
            DATA_ESPERANCA[0].split("-"),
            DATA_ESPERANCA[1].split("-"),
            DATA_ESPERANCA[2].split("-"),
            []
        ]
    if __currentMap___ == Map.WATCHPOINT_GIBRALTAR:
        mapTitlePlayersByKey = [
            DATA_WATCHPOINT_GIBRALTAR[0].split("-"),
            DATA_WATCHPOINT_GIBRALTAR[1].split("-"),
            DATA_WATCHPOINT_GIBRALTAR[2].split("-"),
            []
        ]
    if (__currentMap___ == Map.HANAMURA or __currentMap___ == 1848 or __currentMap___ == Map.HANAMURA_WINTER) == true:
        if classicMapVariant == CLASSIC_MAP_VARIANT_HANAMURA:
            mapTitlePlayersByKey = [
                [],
                [],
                [],
                DATA_HANAMURA[3].split("-")
            ]
        else:
            mapTitlePlayersByKey = [
                DATA_HANAMURA[0].split("-"),
                DATA_HANAMURA[1].split("-"),
                DATA_HANAMURA[2].split("-"),
                DATA_HANAMURA[3].split("-")
            ]
    if (__currentMap___ == Map.HANAOKA or __currentMap___ == 2601) == true:
        mapTitlePlayersByKey = [
            DATA_HANAOKA[0].split("-"),
            DATA_HANAOKA[1].split("-"),
            DATA_HANAOKA[2].split("-"),
            []
        ]
    if __currentMap___ == Map.HAVANA:
        mapTitlePlayersByKey = [
            DATA_HAVANA[0].split("-"),
            DATA_HAVANA[1].split("-"),
            DATA_HAVANA[2].split("-"),
            []
        ]
    if (__currentMap___ == Map.HOLLYWOOD or __currentMap___ == 1505) == true:
        mapTitlePlayersByKey = [
            DATA_HOLLYWOOD[0].split("-"),
            DATA_HOLLYWOOD[1].split("-"),
            DATA_HOLLYWOOD[2].split("-"),
            []
        ]
    if __currentMap___ == Map.HORIZON_LUNAR_COLONY:
        mapTitlePlayersByKey = [
            DATA_HORIZON_LUNAR_COLONY[0].split("-"),
            DATA_HORIZON_LUNAR_COLONY[1].split("-"),
            DATA_HORIZON_LUNAR_COLONY[2].split("-"),
            []
        ]
    if __currentMap___ == Map.ILIOS:
        mapTitlePlayersByKey = [
            DATA_ILIOS[0].split("-"),
            DATA_ILIOS[1].split("-"),
            DATA_ILIOS[2].split("-"),
            []
        ]
    if __currentMap___ == Map.JUNKERTOWN:
        mapTitlePlayersByKey = [
            DATA_JUNKERTOWN[0].split("-"),
            DATA_JUNKERTOWN[1].split("-"),
            DATA_JUNKERTOWN[2].split("-"),
            []
        ]
    if (__currentMap___ == Map.KINGS_ROW or __currentMap___ == 742) == true:
        mapTitlePlayersByKey = [
            DATA_KINGS_ROW[0].split("-"),
            DATA_KINGS_ROW[1].split("-"),
            DATA_KINGS_ROW[2].split("-"),
            []
        ]
    if (__currentMap___ == Map.LIJIANG_TOWER or __currentMap___ == 3676) == true:
        mapTitlePlayersByKey = [
            DATA_LIJIANG_TOWER[0].split("-"),
            DATA_LIJIANG_TOWER[1].split("-"),
            DATA_LIJIANG_TOWER[2].split("-"),
            []
        ]
    if __currentMap___ == Map.MIDTOWN:
        mapTitlePlayersByKey = [
            DATA_MIDTOWN[0].split("-"),
            DATA_MIDTOWN[1].split("-"),
            DATA_MIDTOWN[2].split("-"),
            []
        ]
    if (__currentMap___ == Map.NEON_JUNCTION or __currentMap___ == -6860) == true:
        mapTitlePlayersByKey = [
            DATA_NEON_JUNCTION[0].split("-"),
            DATA_NEON_JUNCTION[1].split("-"),
            DATA_NEON_JUNCTION[2].split("-"),
            []
        ]
    if __currentMap___ == Map.NEPAL:
        mapTitlePlayersByKey = [
            DATA_NEPAL[0].split("-"),
            DATA_NEPAL[1].split("-"),
            DATA_NEPAL[2].split("-"),
            []
        ]
    if (__currentMap___ == Map.NEW_JUNK_CITY or __currentMap___ == 3099) == true:
        mapTitlePlayersByKey = [
            DATA_NEW_JUNK_CITY[0].split("-"),
            DATA_NEW_JUNK_CITY[1].split("-"),
            DATA_NEW_JUNK_CITY[2].split("-"),
            []
        ]
    if __currentMap___ == Map.NEW_QUEEN_STREET:
        mapTitlePlayersByKey = [
            DATA_NEW_QUEEN_STREET[0].split("-"),
            DATA_NEW_QUEEN_STREET[1].split("-"),
            DATA_NEW_QUEEN_STREET[2].split("-"),
            []
        ]
    if __currentMap___ == Map.NUMBANI:
        mapTitlePlayersByKey = [
            DATA_NUMBANI[0].split("-"),
            DATA_NUMBANI[1].split("-"),
            DATA_NUMBANI[2].split("-"),
            []
        ]
    if __currentMap___ == Map.OASIS:
        mapTitlePlayersByKey = [
            DATA_OASIS[0].split("-"),
            DATA_OASIS[1].split("-"),
            DATA_OASIS[2].split("-"),
            []
        ]
    if __currentMap___ == Map.PARAISO:
        mapTitlePlayersByKey = [
            DATA_PARAISO[0].split("-"),
            DATA_PARAISO[1].split("-"),
            DATA_PARAISO[2].split("-"),
            []
        ]
    if __currentMap___ == Map.PARIS:
        if classicMapVariant == CLASSIC_MAP_VARIANT_PARIS:
            mapTitlePlayersByKey = [
                [],
                [],
                [],
                DATA_PARIS[3].split("-")
            ]
        else:
            mapTitlePlayersByKey = [
                DATA_PARIS[0].split("-"),
                DATA_PARIS[1].split("-"),
                DATA_PARIS[2].split("-"),
                DATA_PARIS[3].split("-")
            ]
    if __currentMap___ == Map.RIALTO:
        mapTitlePlayersByKey = [
            DATA_RIALTO[0].split("-"),
            DATA_RIALTO[1].split("-"),
            DATA_RIALTO[2].split("-"),
            []
        ]
    if __currentMap___ == Map.ROUTE66:
        mapTitlePlayersByKey = [
            DATA_ROUTE66[0].split("-"),
            DATA_ROUTE66[1].split("-"),
            DATA_ROUTE66[2].split("-"),
            []
        ]
    if (__currentMap___ == Map.RUNASAPI or __currentMap___ == 8048) == true:
        mapTitlePlayersByKey = [
            DATA_RUNASAPI[0].split("-"),
            DATA_RUNASAPI[1].split("-"),
            DATA_RUNASAPI[2].split("-"),
            []
        ]
    if (__currentMap___ == Map.SAMOA or __currentMap___ == 13628) == true:
        mapTitlePlayersByKey = [
            DATA_SAMOA[0].split("-"),
            DATA_SAMOA[1].split("-"),
            DATA_SAMOA[2].split("-"),
            []
        ]
    if __currentMap___ == Map.SHAMBALI_MONASTERY:
        mapTitlePlayersByKey = [
            DATA_SHAMBALI_MONASTERY[0].split("-"),
            DATA_SHAMBALI_MONASTERY[1].split("-"),
            DATA_SHAMBALI_MONASTERY[2].split("-"),
            []
        ]
    if __currentMap___ == Map.SURAVASA:
        mapTitlePlayersByKey = [
            DATA_SURAVASA[0].split("-"),
            DATA_SURAVASA[1].split("-"),
            DATA_SURAVASA[2].split("-"),
            []
        ]
    if __currentMap___ == Map.TEMPLE_OF_ANUBIS:
        mapTitlePlayersByKey = [
            DATA_TEMPLE_OF_ANUBIS[0].split("-"),
            DATA_TEMPLE_OF_ANUBIS[1].split("-"),
            DATA_TEMPLE_OF_ANUBIS[2].split("-"),
            []
        ]
    if (__currentMap___ == Map.THRONE_OF_ANUBIS or __currentMap___ == 886) == true:
        mapTitlePlayersByKey = [
            DATA_THRONE_OF_ANUBIS[0].split("-"),
            DATA_THRONE_OF_ANUBIS[1].split("-"),
            DATA_THRONE_OF_ANUBIS[2].split("-"),
            []
        ]
    if __currentMap___ == Map.VOLSKAYA:
        mapTitlePlayersByKey = [
            DATA_VOLSKAYA[0].split("-"),
            DATA_VOLSKAYA[1].split("-"),
            DATA_VOLSKAYA[2].split("-"),
            []
        ]

    if __currentMap___ == Map.NEON_JUNCTION or __currentMap___ == -6860:
        waitUntil(len(titleText) > TITLE.PIONEER, Math.INFINITY)
        titleColor[TITLE.PIONEER] = vect(250, 120, 115)
    elif getCurrentMap() == Map.ANTARCTIC_PENINSULA or __currentMap___ == 6177:
        waitUntil(len(titleText) > TITLE.PIONEER, Math.INFINITY)
        titleColor[TITLE.PIONEER] = vect(109, 171, 235)
    elif __currentMap___ == Map.WATCHPOINT_GIBRALTAR:
        waitUntil(len(titleText) > TITLE.PIONEER, Math.INFINITY)
        if __currentMapPioneerText___ == "守望先锋":
            titleColor[TITLE.PIONEER] = vect(240, 101, 20)
        else:
            titleColor[TITLE.PIONEER] = vect(227, 3, 3)
