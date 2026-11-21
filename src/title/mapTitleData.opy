#!mainFile "../main.opy"

#!optimizeStrict

# 地图称号持有者表：每张地图一行，按地图本身存放，与别名无关。
# MAP_TITLE_KEYS / MAP_TITLE_DATA / MAP_TITLE_OVR 按位置一一对应。
# 别名（自定义图 raycast 哈希、花村冬季版等）只在 MAP_TITLE_ALIAS_KEYS 登记，并在 MAP_TITLE_ALIAS_TARGETS 同位置写出所属地图。
#!define MAP_TITLE_KEYS [ \
    Map.VOLSKAYA, \
    Map.THRONE_OF_ANUBIS, \
    Map.TEMPLE_OF_ANUBIS, \
    Map.SURAVASA, \
    Map.SHAMBALI_MONASTERY, \
    Map.SAMOA, \
    Map.RUNASAPI, \
    Map.ROUTE66, \
    Map.RIALTO, \
    Map.PARIS, \
    Map.PARAISO, \
    Map.OASIS, \
    Map.NUMBANI, \
    Map.NEW_QUEEN_STREET, \
    Map.NEW_JUNK_CITY, \
    Map.NEPAL, \
    Map.NEON_JUNCTION, \
    Map.MIDTOWN, \
    Map.LIJIANG_TOWER, \
    Map.KINGS_ROW, \
    Map.JUNKERTOWN, \
    Map.ILIOS, \
    Map.HORIZON_LUNAR_COLONY, \
    Map.HOLLYWOOD, \
    Map.HAVANA, \
    Map.HANAOKA, \
    Map.HANAMURA, \
    Map.GRIMSVOTN, \
    Map.WATCHPOINT_GIBRALTAR, \
    Map.ESPERANCA, \
    Map.EICHENWALDE, \
    Map.DORADO, \
    Map.COLOSSEO, \
    Map.CIRCUIT_ROYAL, \
    Map.BUSAN, \
    Map.BLIZZ_WORLD, \
    Map.AYUTTHAYA, \
    Map.ANTARCTIC_PENINSULA, \
    Map.AATLIS \
]

#!define MAP_TITLE_ALIAS_KEYS [ \
    886, \
    13628, \
    8048, \
    3099, \
    -6860, \
    3676, \
    742, \
    1505, \
    2601, \
    1848, \
    Map.HANAMURA_WINTER, \
    276, \
    2147, \
    1228, \
    1826, \
    6177 \
]

#!define MAP_TITLE_ALIAS_TARGETS [ \
    Map.THRONE_OF_ANUBIS, \
    Map.SAMOA, \
    Map.RUNASAPI, \
    Map.NEW_JUNK_CITY, \
    Map.NEON_JUNCTION, \
    Map.LIJIANG_TOWER, \
    Map.KINGS_ROW, \
    Map.HOLLYWOOD, \
    Map.HANAOKA, \
    Map.HANAMURA, \
    Map.HANAMURA, \
    Map.ESPERANCA, \
    Map.COLOSSEO, \
    Map.BLIZZ_WORLD, \
    Map.AYUTTHAYA, \
    Map.ANTARCTIC_PENINSULA \
]

# 行格式：[先锋, 征服者, 主宰, 经典版持有者(无则 null), 经典版变体 id(无则 null)]，与 KEYS 平行
#!define MAP_TITLE_DATA [ \
    DATA_VOLSKAYA_PACKED, \
    DATA_THRONE_OF_ANUBIS_PACKED, \
    DATA_TEMPLE_OF_ANUBIS_PACKED, \
    DATA_SURAVASA_PACKED, \
    DATA_SHAMBALI_MONASTERY_PACKED, \
    DATA_SAMOA_PACKED, \
    DATA_RUNASAPI_PACKED, \
    DATA_ROUTE66_PACKED, \
    DATA_RIALTO_PACKED, \
    DATA_PARIS_PACKED, \
    DATA_PARAISO_PACKED, \
    DATA_OASIS_PACKED, \
    DATA_NUMBANI_PACKED, \
    DATA_NEW_QUEEN_STREET_PACKED, \
    DATA_NEW_JUNK_CITY_PACKED, \
    DATA_NEPAL_PACKED, \
    DATA_NEON_JUNCTION_PACKED, \
    DATA_MIDTOWN_PACKED, \
    DATA_LIJIANG_TOWER_PACKED, \
    DATA_KINGS_ROW_PACKED, \
    DATA_JUNKERTOWN_PACKED, \
    DATA_ILIOS_PACKED, \
    DATA_HORIZON_LUNAR_COLONY_PACKED, \
    DATA_HOLLYWOOD_PACKED, \
    DATA_HAVANA_PACKED, \
    DATA_HANAOKA_PACKED, \
    DATA_HANAMURA_PACKED, \
    DATA_NEW_A021ED61_PACKED, \
    DATA_WATCHPOINT_GIBRALTAR_PACKED, \
    DATA_ESPERANCA_PACKED, \
    DATA_EICHENWALDE_PACKED, \
    DATA_DORADO_PACKED, \
    DATA_COLOSSEO_PACKED, \
    DATA_CIRCUIT_ROYAL_PACKED, \
    DATA_BUSAN_PACKED, \
    DATA_BLIZZARD_WORLD_PACKED, \
    DATA_AYUTTHAYA_PACKED, \
    DATA_ANTARCTIC_PENINSULA_PACKED, \
    DATA_AATLIS_PACKED \
]
#!define MAP_TITLE_OVR "␞␞荷鲁斯之眼‖␞瓦拉纳西‖守护者␞␞␞␞␞␞␞‖黄金节拍␞␞␞␞␞␞桥元御守‖␞␞␞␞␞␞␞␞␞␞龙神之剑‖␞‖永别了牢笼␞␞␞␞␞␞␞␞␞大城‖守护者␞科研先锋‖␞织金‖门徒"

rule "Load CN map title holders":
    @Condition __currentMapText___

    if not __currentMapPioneerText___:
        __currentMapPioneerText___ = __currentMapText___
    if not __currentMapClassicText___:
        __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format(__currentMapText___)
    __currentPioneerText___ = null

    # __mapTitleNorm = 称号所属的地图：别名折回所属地图；南极半岛/斗兽场未进 __currentMap___ 常量集，改用规范化地图名
    __mapTitleNorm = __currentMap___
    if getCurrentMap() in [Map.ANTARCTIC_PENINSULA, Map.COLOSSEO]:
        __mapTitleNorm = getCurrentMap()
    elif __mapTitleNorm in MAP_TITLE_ALIAS_KEYS:
        __mapTitleNorm = MAP_TITLE_ALIAS_TARGETS[MAP_TITLE_ALIAS_KEYS.index(__mapTitleNorm)]
    __mapTitleKey = MAP_TITLE_KEYS.index(__mapTitleNorm)
    if __mapTitleKey != -1:
        mapTitlePlayersByKey = MAP_TITLE_OVR.split("␞")[__mapTitleKey]
        if __mapTitleNorm == Map.WATCHPOINT_GIBRALTAR:
            __currentMapPioneerText___ = "守望先锋" if random.randint(0, 99) < 50 else "黑爪特工"
            __currentPioneerText___ = ""
        elif mapTitlePlayersByKey != "":
            mapTitlePlayersByKey = mapTitlePlayersByKey.split("‖")
            __currentMapPioneerText___ = mapTitlePlayersByKey[0]
            __currentPioneerText___ = mapTitlePlayersByKey[1]
        mapTitlePlayersByKey = MAP_TITLE_DATA[__mapTitleKey].split("|")
        if (classicMapVariant == CLASSIC_MAP_VARIANT_PARIS and __mapTitleNorm == Map.PARIS) or (classicMapVariant == CLASSIC_MAP_VARIANT_HANAMURA and __mapTitleNorm == Map.HANAMURA) or (classicMapVariant == CLASSIC_MAP_VARIANT_CIRCUIT_ROYAL and __mapTitleNorm == Map.CIRCUIT_ROYAL):
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

    if __mapTitleNorm == Map.NEON_JUNCTION:
        waitUntil(len(titleText) > TITLE.PIONEER, Math.INFINITY)
        titleColor[TITLE.PIONEER] = [vect(250, 120, 115)]
    elif __mapTitleNorm == Map.ANTARCTIC_PENINSULA:
        waitUntil(len(titleText) > TITLE.PIONEER, Math.INFINITY)
        titleColor[TITLE.PIONEER] = [vect(109, 171, 235)]
    elif __mapTitleNorm == Map.WATCHPOINT_GIBRALTAR:
        waitUntil(len(titleText) > TITLE.PIONEER, Math.INFINITY)
        if __currentMapPioneerText___ == "守望先锋":
            titleColor[TITLE.PIONEER] = [vect(240, 101, 20)]
        else:
            titleColor[TITLE.PIONEER] = [vect(227, 3, 3)]
