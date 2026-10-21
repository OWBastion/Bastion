#!mainFile "../main.opy"

#!optimizeStrict

# 地图称号持有者表：键支持 Map 常量与自定义图 raycast 哈希别名。
# 表按历史分支顺序倒排，使重复别名（1826）保持"后写覆盖"语义（命中阿育陀耶）。
#!define MAP_TITLE_KEYS [ \
    Map.VOLSKAYA, \
    Map.THRONE_OF_ANUBIS, 886, \
    Map.TEMPLE_OF_ANUBIS, \
    Map.SURAVASA, \
    Map.SHAMBALI_MONASTERY, \
    Map.SAMOA, 13628, \
    Map.RUNASAPI, 8048, \
    Map.ROUTE66, \
    Map.RIALTO, \
    Map.PARIS, \
    Map.PARAISO, \
    Map.OASIS, \
    Map.NUMBANI, \
    Map.NEW_QUEEN_STREET, \
    Map.NEW_JUNK_CITY, 3099, \
    Map.NEPAL, \
    Map.NEON_JUNCTION, -6860, \
    Map.MIDTOWN, \
    Map.LIJIANG_TOWER, 3676, \
    Map.KINGS_ROW, 742, \
    Map.JUNKERTOWN, \
    Map.ILIOS, \
    Map.HORIZON_LUNAR_COLONY, \
    Map.HOLLYWOOD, 1505, \
    Map.HAVANA, \
    Map.HANAOKA, 2601, \
    Map.HANAMURA, 1848, Map.HANAMURA_WINTER, \
    Map.GRIMSVOTN, \
    Map.WATCHPOINT_GIBRALTAR, \
    Map.ESPERANCA, 276, \
    Map.EICHENWALDE, \
    Map.DORADO, \
    Map.COLOSSEO, 2147, \
    Map.CIRCUIT_ROYAL, \
    Map.BUSAN, \
    Map.BLIZZ_WORLD, 1228, \
    Map.AYUTTHAYA, 1826, \
    Map.ANTARCTIC_PENINSULA, 6177, \
    Map.AATLIS \
]

# 行格式：[先锋, 征服者, 主宰, 经典版持有者(无则 null), 经典版变体 id(无则 null)]，与 KEYS 平行
#!define MAP_TITLE_DATA [ \
    DATA_VOLSKAYA_PACKED, \
    DATA_THRONE_OF_ANUBIS_PACKED, \
    DATA_THRONE_OF_ANUBIS_PACKED, \
    DATA_TEMPLE_OF_ANUBIS_PACKED, \
    DATA_SURAVASA_PACKED, \
    DATA_SHAMBALI_MONASTERY_PACKED, \
    DATA_SAMOA_PACKED, \
    DATA_SAMOA_PACKED, \
    DATA_RUNASAPI_PACKED, \
    DATA_RUNASAPI_PACKED, \
    DATA_ROUTE66_PACKED, \
    DATA_RIALTO_PACKED, \
    DATA_PARIS_PACKED, \
    DATA_PARAISO_PACKED, \
    DATA_OASIS_PACKED, \
    DATA_NUMBANI_PACKED, \
    DATA_NEW_QUEEN_STREET_PACKED, \
    DATA_NEW_JUNK_CITY_PACKED, \
    DATA_NEW_JUNK_CITY_PACKED, \
    DATA_NEPAL_PACKED, \
    DATA_NEON_JUNCTION_PACKED, \
    DATA_NEON_JUNCTION_PACKED, \
    DATA_MIDTOWN_PACKED, \
    DATA_LIJIANG_TOWER_PACKED, \
    DATA_LIJIANG_TOWER_PACKED, \
    DATA_KINGS_ROW_PACKED, \
    DATA_KINGS_ROW_PACKED, \
    DATA_JUNKERTOWN_PACKED, \
    DATA_ILIOS_PACKED, \
    DATA_HORIZON_LUNAR_COLONY_PACKED, \
    DATA_HOLLYWOOD_PACKED, \
    DATA_HOLLYWOOD_PACKED, \
    DATA_HAVANA_PACKED, \
    DATA_HANAOKA_PACKED, \
    DATA_HANAOKA_PACKED, \
    DATA_HANAMURA_PACKED, \
    DATA_HANAMURA_PACKED, \
    DATA_HANAMURA_PACKED, \
    DATA_NEW_A021ED61_PACKED, \
    DATA_WATCHPOINT_GIBRALTAR_PACKED, \
    DATA_ESPERANCA_PACKED, \
    DATA_ESPERANCA_PACKED, \
    DATA_EICHENWALDE_PACKED, \
    DATA_DORADO_PACKED, \
    DATA_COLOSSEO_PACKED, \
    DATA_COLOSSEO_PACKED, \
    DATA_CIRCUIT_ROYAL_PACKED, \
    DATA_BUSAN_PACKED, \
    DATA_BLIZZARD_WORLD_PACKED, \
    DATA_BLIZZARD_WORLD_PACKED, \
    DATA_AYUTTHAYA_PACKED, DATA_AYUTTHAYA_PACKED, \
    DATA_ANTARCTIC_PENINSULA_PACKED, \
    DATA_ANTARCTIC_PENINSULA_PACKED, \
    DATA_AATLIS_PACKED \
]
#!define MAP_TITLE_OVR "␞␞␞␞瓦拉纳西‖守护者␞␞␞␞␞␞␞␞␞‖黄金节拍␞␞␞␞␞␞␞桥元御守‖␞桥元御守‖␞␞␞␞␞␞␞␞␞␞␞␞␞␞␞␞␞‖永别了牢笼␞␞␞␞␞␞␞␞␞␞␞␞大城‖守护者␞织金‖门徒␞科研先锋‖␞科研先锋‖␞织金‖门徒"

rule "Load CN map title holders":
    @Condition __currentMapText___ != null

    if __currentMapPioneerText___ == null:
        __currentMapPioneerText___ = __currentMapText___
    if __currentMapClassicText___ == null:
        __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format(__currentMapText___)
    __currentPioneerText___ = null
    __mapTitleNorm = getCurrentMap()

    # 规范化查表键：南极半岛/斗兽场未进 __currentMap___ 常量集，改用规范化地图名兜底
    __mapTitleKey = __currentMap___
    if __mapTitleNorm in [Map.ANTARCTIC_PENINSULA, Map.COLOSSEO]:
        __mapTitleKey = __mapTitleNorm
    __mapTitleKey = MAP_TITLE_KEYS.index(__mapTitleKey)
    if __mapTitleKey != -1:
        mapTitlePlayersByKey = MAP_TITLE_OVR.split("␞")[__mapTitleKey]
        if __currentMap___ == Map.WATCHPOINT_GIBRALTAR:
            __currentMapPioneerText___ = "守望先锋" if random.randint(0, 99) < 50 else "黑爪特工"
            __currentPioneerText___ = ""
        elif mapTitlePlayersByKey != "":
            mapTitlePlayersByKey = mapTitlePlayersByKey.split("‖")
            __currentMapPioneerText___ = mapTitlePlayersByKey[0]
            __currentPioneerText___ = mapTitlePlayersByKey[1]
        mapTitlePlayersByKey = MAP_TITLE_DATA[__mapTitleKey].split("|")
        if (classicMapVariant == CLASSIC_MAP_VARIANT_PARIS and __currentMap___ == Map.PARIS) or (classicMapVariant == CLASSIC_MAP_VARIANT_HANAMURA and __currentMap___ in [Map.HANAMURA, 1848, Map.HANAMURA_WINTER]) or (classicMapVariant == CLASSIC_MAP_VARIANT_CIRCUIT_ROYAL and __currentMap___ == Map.CIRCUIT_ROYAL):
            mapTitlePlayersByKey = [[], [], [], mapTitlePlayersByKey[3].split("-")]
        else:
            mapTitlePlayersByKey = [
                mapTitlePlayersByKey[0].split("-"),
                mapTitlePlayersByKey[1].split("-"),
                mapTitlePlayersByKey[2].split("-"),
                [] if mapTitlePlayersByKey[3] == "" else mapTitlePlayersByKey[3].split("-")
            ]

    if mapTitlePlayersByKey == null:
        mapTitlePlayersByKey = [[], [], [], []]

    if __currentMap___ == Map.NEON_JUNCTION or __currentMap___ == -6860:
        waitUntil(len(titleText) > TITLE.PIONEER, Math.INFINITY)
        titleColor[TITLE.PIONEER] = [vect(250, 120, 115)]
    elif __mapTitleNorm == Map.ANTARCTIC_PENINSULA or __currentMap___ == 6177:
        waitUntil(len(titleText) > TITLE.PIONEER, Math.INFINITY)
        titleColor[TITLE.PIONEER] = [vect(109, 171, 235)]
    elif __currentMap___ == Map.WATCHPOINT_GIBRALTAR:
        waitUntil(len(titleText) > TITLE.PIONEER, Math.INFINITY)
        if __currentMapPioneerText___ == "守望先锋":
            titleColor[TITLE.PIONEER] = [vect(240, 101, 20)]
        else:
            titleColor[TITLE.PIONEER] = [vect(227, 3, 3)]
