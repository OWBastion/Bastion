#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

#!define playerNameToIndex(names) __script__("../tools/playerNameToIndex.js")
#!define playerNameToIndexDelimited(names, sep) __script__("../tools/playerNameToIndexDelimited.js")

# ------------------------------
# 1. 定义称号枚举 (Enums)
# ------------------------------
# BEGIN AUTO-GENERATED TITLE ENUM
enum TITLE:
    PIONEER,          # 0 开拓者
    TEST_LONG,        # 1 这是一个超长的称号测试字段如果到这里还没有被截断说明确实很长你说得对但是广告位招租啊哈大OW是我的家乡
    NOT_MY_MAP,       # 2 地图不是我做的
    WILD_DEV,         # 3 野生开发者
    ARCHITECT,        # 4 堡垒建筑师
    MAINTAINER,       # 5 友善的地图维护者
    THREE_IN_ONE,     # 6 三合一地图作者
    BLACK_SHEEP,      # 7 骇人鲸
    PURE_HARM,        # 8 纯害战士
    CONQUEROR,        # 9 征服者
    DOMINATOR,        # 10 主宰
    SURVIVOR_EXPERT,  # 11 专家幸存者
    CHALLENGER_LEGEND,# 12 传奇挑战者
    TRAVELER_HELL,    # 13 地狱穿梭者
    DODGE_ULTIMATE,   # 14 终极闪避
    LIGHT_PACK,       # 15 轻装上阵
    FLAWLESS,         # 16 完美无缺
    NEVER_GIVE_UP,    # 17 永不言弃
    PERSEVERANCE,     # 18 坚韧不拔
    SPEEDRUN,         # 19 速通传奇
    DODGE_GOD,        # 20 闪避の神
    ZENYATTA,         # 21 智瞳开拓者
    HARD_TO_KILL,     # 22 大难不死
    WIN_HEAVEN,       # 23 胜天半子
    IDOL,             # 24 堡垒の偶像
    EGG_FIRST,        # 25 第一颗蛋
    EAT_MORE,         # 26 我还能吃
    ALL_IN_ONE,       # 27 万象归一
    TRAVELER,         # 28 守望旅行家
    SKY,              # 29 万域天穹
    FLAME,            # 30 狂暴烈焰
    PASS_EGGS,        # 31 万蛋丛中过
    CHOSEN,           # 32 天选之子
    LUCKY_STAR,       # 33 幸运星
    GAMBLE_KING,      # 34 赌王
    LUCKY_SHINE,      # 35 福星高照
    UNLUCKY,          # 36 倒霉蛋
    MANBA,            # 37 What can i say
    MY_FATE,          # 38 我命由我
    GOD_GAMBLER,      # 39 赌神
    LAO_DA,           # 40 牢 大
    V_50,             # 41 V我50
    STEEL,            # 42 钢门
    HACKING,          # 43 开了
    RED_PACKET,       # 44 红包收藏家
    GOOD_LUCK,        # 45 好运来
    LONE_WALKER,      # 46 千里独行
    GREEN_MOUNTAIN,   # 47 踏遍青山
    SUAN_BU_LA,       # 48 我不会放过你的酸不辣
    EVENT5_GAMBLE_SAINT,# 49 赌圣
    EVENT5_BLACK_SHEEP,# 50 害群之马
    EVENT5_I_WANT_TO_CHECK_CARDS,# 51 我要验牌
    EVENT5_CARDS_ARE_FINE,# 52 牌没有问题
    GREAT_BENEFACTOR, # 53 大舍天下
    BREAK_ATMOSPHERE, # 54 冲出地表
    LIST_THEM,        # 55 把他们上市
    LIFE_GUARDS_LIFE, # 56 生命守护生命
    PHANTOM_THIEF,    # 57 怪盗
    CLASSIC           # 58 老兵
# END AUTO-GENERATED TITLE ENUM


enum MapTITLEKey:
  PIONEER = 0
  CONQUEROR = 1
  DOMINATOR = 2
  CLASSIC = 3

# ------------------------------
# 2. 定义玩家数据 (Database)
# 注意：Key (name, titles) 必须不加引号，否则 splitDictArray 会报错
# ------------------------------
# BEGIN AUTO-GENERATED PLAYER_TITLE_SET_POOL
#!define TP_ALL [TITLE.PIONEER, TITLE.TEST_LONG, TITLE.NOT_MY_MAP, TITLE.WILD_DEV, TITLE.ARCHITECT, TITLE.MAINTAINER, TITLE.THREE_IN_ONE, TITLE.BLACK_SHEEP, TITLE.PURE_HARM, TITLE.CONQUEROR, TITLE.DOMINATOR, TITLE.SURVIVOR_EXPERT, TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.DODGE_ULTIMATE, TITLE.LIGHT_PACK, TITLE.FLAWLESS, TITLE.NEVER_GIVE_UP, TITLE.PERSEVERANCE, TITLE.SPEEDRUN, TITLE.DODGE_GOD, TITLE.ZENYATTA, TITLE.HARD_TO_KILL, TITLE.WIN_HEAVEN, TITLE.IDOL, TITLE.EGG_FIRST, TITLE.EAT_MORE, TITLE.ALL_IN_ONE, TITLE.TRAVELER, TITLE.SKY, TITLE.FLAME, TITLE.PASS_EGGS, TITLE.CHOSEN, TITLE.LUCKY_STAR, TITLE.GAMBLE_KING, TITLE.LUCKY_SHINE, TITLE.UNLUCKY, TITLE.MANBA, TITLE.MY_FATE, TITLE.GOD_GAMBLER, TITLE.LAO_DA, TITLE.V_50, TITLE.STEEL, TITLE.HACKING, TITLE.RED_PACKET, TITLE.GOOD_LUCK, TITLE.LONE_WALKER, TITLE.GREEN_MOUNTAIN, TITLE.SUAN_BU_LA, TITLE.EVENT5_GAMBLE_SAINT, TITLE.EVENT5_BLACK_SHEEP, TITLE.EVENT5_I_WANT_TO_CHECK_CARDS, TITLE.EVENT5_CARDS_ARE_FINE, TITLE.GREAT_BENEFACTOR, TITLE.BREAK_ATMOSPHERE, TITLE.LIST_THEM, TITLE.LIFE_GUARDS_LIFE, TITLE.PHANTOM_THIEF, TITLE.CLASSIC]
#!define player_title_set_pool [ \
    [TITLE.TEST_LONG, TITLE.NOT_MY_MAP, TITLE.WILD_DEV, TITLE.ARCHITECT, TITLE.MAINTAINER, TITLE.THREE_IN_ONE, TITLE.BLACK_SHEEP, TITLE.PURE_HARM, TITLE.SURVIVOR_EXPERT, TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.DODGE_ULTIMATE, TITLE.LIGHT_PACK, TITLE.FLAWLESS, TITLE.NEVER_GIVE_UP, TITLE.PERSEVERANCE, TITLE.SPEEDRUN, TITLE.DODGE_GOD, TITLE.ZENYATTA, TITLE.HARD_TO_KILL, TITLE.WIN_HEAVEN, TITLE.IDOL, TITLE.EGG_FIRST, TITLE.EAT_MORE, TITLE.ALL_IN_ONE, TITLE.TRAVELER, TITLE.SKY, TITLE.FLAME, TITLE.PASS_EGGS, TITLE.CHOSEN, TITLE.LUCKY_STAR, TITLE.GAMBLE_KING, TITLE.LUCKY_SHINE, TITLE.UNLUCKY, TITLE.MANBA, TITLE.MY_FATE, TITLE.GOD_GAMBLER, TITLE.LAO_DA, TITLE.V_50, TITLE.STEEL, TITLE.HACKING, TITLE.RED_PACKET, TITLE.GOOD_LUCK, TITLE.LONE_WALKER, TITLE.GREEN_MOUNTAIN, TITLE.SUAN_BU_LA, TITLE.EVENT5_GAMBLE_SAINT, TITLE.EVENT5_BLACK_SHEEP, TITLE.EVENT5_I_WANT_TO_CHECK_CARDS, TITLE.EVENT5_CARDS_ARE_FINE, TITLE.GREAT_BENEFACTOR, TITLE.BREAK_ATMOSPHERE, TITLE.LIST_THEM, TITLE.LIFE_GUARDS_LIFE, TITLE.PHANTOM_THIEF], \
    [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.DODGE_ULTIMATE, TITLE.LIGHT_PACK, TITLE.FLAWLESS, TITLE.NEVER_GIVE_UP, TITLE.SPEEDRUN, TITLE.HARD_TO_KILL, TITLE.ALL_IN_ONE, TITLE.TRAVELER, TITLE.SKY, TITLE.CHOSEN, TITLE.LUCKY_STAR, TITLE.LUCKY_SHINE, TITLE.UNLUCKY, TITLE.MANBA, TITLE.V_50, TITLE.STEEL, TITLE.HACKING, TITLE.EVENT5_GAMBLE_SAINT, TITLE.EVENT5_CARDS_ARE_FINE], \
    [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.DODGE_ULTIMATE, TITLE.FLAWLESS, TITLE.SPEEDRUN, TITLE.HARD_TO_KILL, TITLE.ALL_IN_ONE, TITLE.TRAVELER, TITLE.SKY, TITLE.LUCKY_STAR, TITLE.UNLUCKY, TITLE.MANBA, TITLE.V_50, TITLE.HACKING, TITLE.RED_PACKET, TITLE.GOOD_LUCK, TITLE.GREEN_MOUNTAIN], \
    [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.SPEEDRUN, TITLE.HARD_TO_KILL, TITLE.UNLUCKY, TITLE.MANBA, TITLE.HACKING], \
    [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.DODGE_ULTIMATE, TITLE.FLAWLESS, TITLE.SPEEDRUN, TITLE.LUCKY_STAR, TITLE.UNLUCKY, TITLE.HACKING], \
    [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.DODGE_ULTIMATE, TITLE.FLAWLESS, TITLE.SPEEDRUN, TITLE.LUCKY_STAR, TITLE.UNLUCKY, TITLE.V_50], \
    [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.ALL_IN_ONE, TITLE.SKY, TITLE.LUCKY_STAR, TITLE.UNLUCKY, TITLE.V_50, TITLE.STEEL, TITLE.EVENT5_CARDS_ARE_FINE], \
    [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.FLAWLESS], \
    [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL], \
    [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.DODGE_ULTIMATE, TITLE.FLAWLESS, TITLE.SPEEDRUN, TITLE.ALL_IN_ONE, TITLE.SKY, TITLE.LUCKY_STAR, TITLE.UNLUCKY, TITLE.MANBA, TITLE.V_50, TITLE.STEEL, TITLE.HACKING, TITLE.EVENT5_GAMBLE_SAINT, TITLE.EVENT5_BLACK_SHEEP, TITLE.EVENT5_I_WANT_TO_CHECK_CARDS, TITLE.EVENT5_CARDS_ARE_FINE, TITLE.GREAT_BENEFACTOR], \
    [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.DODGE_ULTIMATE, TITLE.FLAWLESS, TITLE.SPEEDRUN, TITLE.ALL_IN_ONE, TITLE.SKY, TITLE.LUCKY_STAR, TITLE.UNLUCKY, TITLE.MANBA, TITLE.V_50, TITLE.STEEL, TITLE.EVENT5_GAMBLE_SAINT, TITLE.EVENT5_CARDS_ARE_FINE] \
]
# END AUTO-GENERATED PLAYER_TITLE_SET_POOL
# BEGIN AUTO-GENERATED TITLE PLAYER DATABASE
#!define player_database [ \
    { \
        name: "他又", \
        titleSetIndex: 0 \
    }, \
    { \
        name: "吾携秋水揽星河", \
        titleSetIndex: 1 \
    }, \
    { \
        name: "卖核弹的小女孩", \
        titleSetIndex: 2 \
    }, \
    { \
        name: "EruIluvatar", \
        titleSetIndex: 3 \
    }, \
    { \
        name: "天树是只臭猫", \
        titleSetIndex: 4 \
    }, \
    { \
        name: "銀狼", \
        titleSetIndex: 5 \
    }, \
    { \
        name: "训犬大师", \
        titleSetIndex: 6 \
    }, \
    { \
        name: "自律达人游十三", \
        titleSetIndex: 7 \
    }, \
    { \
        name: "FAJACY", \
        titleSetIndex: 8 \
    }, \
    { \
        name: "嘤嘤嘤丶", \
        titleSetIndex: 9 \
    }, \
    { \
        name: "八月八月八", \
        titleSetIndex: 10 \
    } \
]
# END AUTO-GENERATED TITLE PLAYER DATABASE



# ------------------------------
# 3. 定义地图数据宏 (Map Macros)
# ------------------------------
# 称号包 (TITLE Packs)
#!define TP_CONQUEROR [TITLE.CONQUEROR]
#!define TP_9_10 [TITLE.CONQUEROR, TITLE.DOMINATOR]
#!define TP_9_10_0 [TITLE.CONQUEROR, TITLE.DOMINATOR, TITLE.PIONEER]
# 地图数据块 (Data Blocks)
# BEGIN AUTO-GENERATED MAP_TITLE_DATA
# 阿特利斯
#!define DATA_AATLIS [ \
   playerNameToIndexDelimited(["卖核弹的小女孩", "他又"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "八月八月八", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "八月八月八", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 南极半岛
#!define DATA_ANTARCTIC_PENINSULA [ \
   playerNameToIndexDelimited(["吾携秋水揽星河"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 阿育陀耶
#!define DATA_AYUTTHAYA [ \
   playerNameToIndexDelimited(["他又"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 暴雪世界
#!define DATA_BLIZZARD_WORLD [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "他又", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "他又", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 釜山
#!define DATA_BUSAN [ \
   playerNameToIndexDelimited(["吾携秋水揽星河"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 皇家赛道
#!define DATA_CIRCUIT_ROYAL [ \
   playerNameToIndexDelimited(["他又"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 斗兽场
#!define DATA_COLOSSEO [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "他又", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "他又", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 多拉多
#!define DATA_DORADO [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 艾兴瓦尔德
#!define DATA_EICHENWALDE [ \
   playerNameToIndexDelimited(["吾携秋水揽星河"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 埃斯佩兰萨
#!define DATA_ESPERANCA [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 花村
#!define DATA_HANAMURA [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 花冈
#!define DATA_HANAOKA [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 哈瓦那
#!define DATA_HAVANA [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "他又", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "他又", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 好莱坞
#!define DATA_HOLLYWOOD [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 月球基地
#!define DATA_HORIZON_LUNAR_COLONY [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 伊利奥斯
#!define DATA_ILIOS [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "自律达人游十三", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "自律达人游十三", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 渣客镇
#!define DATA_JUNKERTOWN [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 国王大道
#!define DATA_KINGS_ROW [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "八月八月八", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "八月八月八", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 漓江塔
#!define DATA_LIJIANG_TOWER [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "八月八月八", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "八月八月八", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 中城
#!define DATA_MIDTOWN [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 霓虹枢纽
#!define DATA_NEON_JUNCTION [ \
   playerNameToIndexDelimited(["他又"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "训犬大师"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "训犬大师"], "-"), \
   []\
]

# 尼泊尔
#!define DATA_NEPAL [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "卖核弹的小女孩"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "八月八月八", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "八月八月八", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 新渣客城
#!define DATA_NEW_JUNK_CITY [ \
   playerNameToIndexDelimited(["吾携秋水揽星河"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 新皇后街
#!define DATA_NEW_QUEEN_STREET [ \
   playerNameToIndexDelimited(["吾携秋水揽星河"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 努巴尼
#!define DATA_NUMBANI [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 绿洲城
#!define DATA_OASIS [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 帕拉伊苏
#!define DATA_PARAISO [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 巴黎
#!define DATA_PARIS [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 里阿尔托
#!define DATA_RIALTO [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 66号公路
#!define DATA_ROUTE66 [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 鲁纳塞彼
#!define DATA_RUNASAPI [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 萨摩亚
#!define DATA_SAMOA [ \
   [], \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "FAJACY", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 香巴里寺院
#!define DATA_SHAMBALI_MONASTERY [ \
   playerNameToIndexDelimited(["他又"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 苏拉瓦萨
#!define DATA_SURAVASA [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "卖核弹的小女孩", "他又"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 阿努比斯神殿
#!define DATA_TEMPLE_OF_ANUBIS [ \
   playerNameToIndexDelimited(["吾携秋水揽星河"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 阿努比斯王座
#!define DATA_THRONE_OF_ANUBIS [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "卖核弹的小女孩"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "天树是只臭猫", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 沃斯卡娅工业区
#!define DATA_VOLSKAYA [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "卖核弹的小女孩"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]

# 直布罗陀
#!define DATA_WATCHPOINT_GIBRALTAR [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "卖核弹的小女孩"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师", "EruIluvatar"], "-"), \
   []\
]
# END AUTO-GENERATED MAP_TITLE_DATA

# ------------------------------
# 4. 初始化变量
# ------------------------------
rule "initialize title array":
    wait(getAverageServerLoad() / 100 * 0.5)
    waitUntil(__currentMap___ != null, Math.INFINITY)
    # BEGIN AUTO-GENERATED ALL_TITLE
    titleText = [
        # 0: PIONEER
        "{0}{1}".format(__currentMapPioneerText___ if __currentMapPioneerText___ != null else getCurrentMap(), __currentPioneerText___ if __currentPioneerText___ != null else "开拓者"),
        # 1: TEST_LONG
        "这是一个超长的称号测试字段如果到这里还没有被截断说明确实很长你说得对但是广告位招租啊哈大OW是我的家乡",
        # 2: NOT_MY_MAP
        "地图不是我做的",
        # 3: WILD_DEV
        "野生开发者",
        # 4: ARCHITECT
        "堡垒建筑师",
        # 5: MAINTAINER
        "友善的地图维护者",
        # 6: THREE_IN_ONE
        "三合一地图作者",
        # 7: BLACK_SHEEP
        "骇人鲸",
        # 8: PURE_HARM
        "纯害战士",
        # 9: CONQUEROR
        "{0}征服者".format(__currentMapText___ if __currentMapText___ != null else getCurrentMap()),
        # 10: DOMINATOR
        "{0}主宰".format(__currentMapText___ if __currentMapText___ != null else getCurrentMap()),
        # 11: SURVIVOR_EXPERT
        "专家幸存者",
        # 12: CHALLENGER_LEGEND
        "传奇挑战者",
        # 13: TRAVELER_HELL
        "地狱穿梭者",
        # 14: DODGE_ULTIMATE
        "终极闪避",
        # 15: LIGHT_PACK
        "轻装上阵",
        # 16: FLAWLESS
        "完美无缺",
        # 17: NEVER_GIVE_UP
        "永不言弃",
        # 18: PERSEVERANCE
        "坚韧不拔",
        # 19: SPEEDRUN
        "速通传奇",
        # 20: DODGE_GOD
        "闪避の神",
        # 21: ZENYATTA
        "智瞳开拓者",
        # 22: HARD_TO_KILL
        "大难不死",
        # 23: WIN_HEAVEN
        "胜天半子",
        # 24: IDOL
        "堡垒の偶像",
        # 25: EGG_FIRST
        "第一颗蛋",
        # 26: EAT_MORE
        "我还能吃",
        # 27: ALL_IN_ONE
        "万象归一",
        # 28: TRAVELER
        "守望旅行家",
        # 29: SKY
        "万域天穹",
        # 30: FLAME
        "狂暴烈焰",
        # 31: PASS_EGGS
        "万蛋丛中过",
        # 32: CHOSEN
        "天选之子",
        # 33: LUCKY_STAR
        "幸运星",
        # 34: GAMBLE_KING
        "赌王",
        # 35: LUCKY_SHINE
        "福星高照",
        # 36: UNLUCKY
        "倒霉蛋",
        # 37: MANBA
        "What can i say",
        # 38: MY_FATE
        "我命由我",
        # 39: GOD_GAMBLER
        "赌神",
        # 40: LAO_DA
        "牢 大",
        # 41: V_50
        "V我50",
        # 42: STEEL
        "钢门",
        # 43: HACKING
        "开了",
        # 44: RED_PACKET
        "红包收藏家",
        # 45: GOOD_LUCK
        "好运来",
        # 46: LONE_WALKER
        "千里独行",
        # 47: GREEN_MOUNTAIN
        "踏遍青山",
        # 48: SUAN_BU_LA
        "我不会放过你的酸不辣",
        # 49: EVENT5_GAMBLE_SAINT
        "赌圣",
        # 50: EVENT5_BLACK_SHEEP
        "害群之马",
        # 51: EVENT5_I_WANT_TO_CHECK_CARDS
        "我要验牌",
        # 52: EVENT5_CARDS_ARE_FINE
        "牌没有问题",
        # 53: GREAT_BENEFACTOR
        "大舍天下",
        # 54: BREAK_ATMOSPHERE
        "冲出地表",
        # 55: LIST_THEM
        "把他们上市",
        # 56: LIFE_GUARDS_LIFE
        "生命守护生命",
        # 57: PHANTOM_THIEF
        "怪盗",
        # 58: CLASSIC
        __currentMapClassicText___
    ]
    titleColor = [
        # 0: PIONEER
        heroColor[12],
        # 1: TEST_LONG
        null,
        # 2: NOT_MY_MAP
        null,
        # 3: WILD_DEV
        null,
        # 4: ARCHITECT
        null,
        # 5: MAINTAINER
        null,
        # 6: THREE_IN_ONE
        null,
        # 7: BLACK_SHEEP
        null,
        # 8: PURE_HARM
        null,
        # 9: CONQUEROR
        heroColor[43],
        # 10: DOMINATOR
        heroColor[44],
        # 11: SURVIVOR_EXPERT
        vect(236, 153, 0),
        # 12: CHALLENGER_LEGEND
        vect(200, 0, 19),
        # 13: TRAVELER_HELL
        vect(161, 73, 197),
        # 14: DODGE_ULTIMATE
        heroColor[1],
        # 15: LIGHT_PACK
        heroColor[2],
        # 16: FLAWLESS
        vect(0, 230, 151),
        # 17: NEVER_GIVE_UP
        vect(0, 230, 151),
        # 18: PERSEVERANCE
        vect(255, 255, 255),
        # 19: SPEEDRUN
        vect(0, 230, 151),
        # 20: DODGE_GOD
        heroColor[28],
        # 21: ZENYATTA
        heroColor[12],
        # 22: HARD_TO_KILL
        heroColor[45],
        # 23: WIN_HEAVEN
        breathPalette.orange,
        # 24: IDOL
        vect(200, 0, 19),
        # 25: EGG_FIRST
        vect(200, 0, 19),
        # 26: EAT_MORE
        vect(238, 75, 43),
        # 27: ALL_IN_ONE
        breathPalette.red,
        # 28: TRAVELER
        heroColor[33],
        # 29: SKY
        breathPalette.purple,
        # 30: FLAME
        heroColor[28],
        # 31: PASS_EGGS
        heroColor[28],
        # 32: CHOSEN
        heroColor[11],
        # 33: LUCKY_STAR
        heroColor[3],
        # 34: GAMBLE_KING
        breathPalette.gold,
        # 35: LUCKY_SHINE
        heroColor[32],
        # 36: UNLUCKY
        heroColor[22],
        # 37: MANBA
        heroColor[11],
        # 38: MY_FATE
        breathPalette.blue,
        # 39: GOD_GAMBLER
        breathPalette.gold,
        # 40: LAO_DA
        null,
        # 41: V_50
        heroColor[37],
        # 42: STEEL
        heroColor[11],
        # 43: HACKING
        heroColor[20],
        # 44: RED_PACKET
        heroColor[43],
        # 45: GOOD_LUCK
        breathPalette.gold,
        # 46: LONE_WALKER
        heroColor[33],
        # 47: GREEN_MOUNTAIN
        vect(0, 200, 50),
        # 48: SUAN_BU_LA
        heroColor[18],
        # 49: EVENT5_GAMBLE_SAINT
        breathPalette.gold,
        # 50: EVENT5_BLACK_SHEEP
        heroColor[3],
        # 51: EVENT5_I_WANT_TO_CHECK_CARDS
        heroColor[3],
        # 52: EVENT5_CARDS_ARE_FINE
        heroColor[3],
        # 53: GREAT_BENEFACTOR
        vect(0, 200, 50),
        # 54: BREAK_ATMOSPHERE
        vect(192, 192, 192),
        # 55: LIST_THEM
        breathPalette.gold,
        # 56: LIFE_GUARDS_LIFE
        heroColor[28],
        # 57: PHANTOM_THIEF
        heroColor[22],
        # 58: CLASSIC
        heroColor[43]
    ]
    # END AUTO-GENERATED ALL_TITLE
    playerTitleRelation = player_title_set_pool
    splitDictArray({
        name: titlePlayer,
        titleSetIndex: playerTitleSetIndex
    }, player_database, true)
