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
    BLACK_SHEEP,      # 7 害群之马
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
    SUAN_BU_LA        # 48 我不会放过你的酸不辣
# END AUTO-GENERATED TITLE ENUM


enum MapTITLEKey:
  PIONEER = 0
  CONQUEROR = 1
  DOMINATOR = 2

# ------------------------------
# 2. 定义玩家数据 (Database)
# 注意：Key (name, titles) 必须不加引号，否则 splitDictArray 会报错
# ------------------------------
# BEGIN AUTO-GENERATED TITLE PLAYER DATABASE
#!define TP_ALL [TITLE.PIONEER, TITLE.TEST_LONG, TITLE.NOT_MY_MAP, TITLE.WILD_DEV, TITLE.ARCHITECT, TITLE.MAINTAINER, TITLE.THREE_IN_ONE, TITLE.BLACK_SHEEP, TITLE.PURE_HARM, TITLE.CONQUEROR, TITLE.DOMINATOR, TITLE.SURVIVOR_EXPERT, TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.DODGE_ULTIMATE, TITLE.LIGHT_PACK, TITLE.FLAWLESS, TITLE.NEVER_GIVE_UP, TITLE.PERSEVERANCE, TITLE.SPEEDRUN, TITLE.DODGE_GOD, TITLE.ZENYATTA, TITLE.HARD_TO_KILL, TITLE.WIN_HEAVEN, TITLE.IDOL, TITLE.EGG_FIRST, TITLE.EAT_MORE, TITLE.ALL_IN_ONE, TITLE.TRAVELER, TITLE.SKY, TITLE.FLAME, TITLE.PASS_EGGS, TITLE.CHOSEN, TITLE.LUCKY_STAR, TITLE.GAMBLE_KING, TITLE.LUCKY_SHINE, TITLE.UNLUCKY, TITLE.MANBA, TITLE.MY_FATE, TITLE.GOD_GAMBLER, TITLE.LAO_DA, TITLE.V_50, TITLE.STEEL, TITLE.HACKING, TITLE.RED_PACKET, TITLE.GOOD_LUCK, TITLE.LONE_WALKER, TITLE.GREEN_MOUNTAIN, TITLE.SUAN_BU_LA]
#!define player_database [ \
    { \
        name: "他又", \
        titles: [TITLE.PIONEER, TITLE.TEST_LONG, TITLE.NOT_MY_MAP, TITLE.WILD_DEV, TITLE.ARCHITECT, TITLE.MAINTAINER, TITLE.THREE_IN_ONE, TITLE.BLACK_SHEEP, TITLE.PURE_HARM, TITLE.CONQUEROR, TITLE.DOMINATOR, TITLE.SURVIVOR_EXPERT, TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.DODGE_ULTIMATE, TITLE.LIGHT_PACK, TITLE.FLAWLESS, TITLE.NEVER_GIVE_UP, TITLE.PERSEVERANCE, TITLE.SPEEDRUN, TITLE.DODGE_GOD, TITLE.ZENYATTA, TITLE.HARD_TO_KILL, TITLE.WIN_HEAVEN, TITLE.IDOL, TITLE.EGG_FIRST, TITLE.EAT_MORE, TITLE.ALL_IN_ONE, TITLE.TRAVELER, TITLE.SKY, TITLE.FLAME, TITLE.PASS_EGGS, TITLE.CHOSEN, TITLE.LUCKY_STAR, TITLE.GAMBLE_KING, TITLE.LUCKY_SHINE, TITLE.UNLUCKY, TITLE.MANBA, TITLE.MY_FATE, TITLE.GOD_GAMBLER, TITLE.LAO_DA, TITLE.V_50, TITLE.STEEL, TITLE.HACKING, TITLE.SUAN_BU_LA, TITLE.RED_PACKET, TITLE.GOOD_LUCK, TITLE.LONE_WALKER, TITLE.GREEN_MOUNTAIN] \
    }, \
    { \
        name: "别感冒", \
        titles: [TITLE.PIONEER, TITLE.TEST_LONG, TITLE.NOT_MY_MAP, TITLE.WILD_DEV, TITLE.ARCHITECT, TITLE.MAINTAINER, TITLE.THREE_IN_ONE, TITLE.BLACK_SHEEP, TITLE.PURE_HARM, TITLE.CONQUEROR, TITLE.DOMINATOR, TITLE.SURVIVOR_EXPERT, TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.DODGE_ULTIMATE, TITLE.LIGHT_PACK, TITLE.FLAWLESS, TITLE.NEVER_GIVE_UP, TITLE.PERSEVERANCE, TITLE.SPEEDRUN, TITLE.DODGE_GOD, TITLE.ZENYATTA, TITLE.HARD_TO_KILL, TITLE.WIN_HEAVEN, TITLE.IDOL, TITLE.EGG_FIRST, TITLE.EAT_MORE, TITLE.ALL_IN_ONE, TITLE.TRAVELER, TITLE.SKY, TITLE.FLAME, TITLE.PASS_EGGS, TITLE.CHOSEN, TITLE.LUCKY_STAR, TITLE.GAMBLE_KING, TITLE.LUCKY_SHINE, TITLE.UNLUCKY, TITLE.MANBA, TITLE.MY_FATE, TITLE.GOD_GAMBLER, TITLE.LAO_DA, TITLE.V_50, TITLE.STEEL, TITLE.HACKING, TITLE.SUAN_BU_LA, TITLE.RED_PACKET, TITLE.GOOD_LUCK, TITLE.LONE_WALKER, TITLE.GREEN_MOUNTAIN] \
    }, \
    { \
        name: "草艮", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL] \
    }, \
    { \
        name: "烛台与南九", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.EGG_FIRST] \
    }, \
    { \
        name: "顾北酒笙", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.FLAWLESS, TITLE.SPEEDRUN, TITLE.TRAVELER_HELL] \
    }, \
    { \
        name: "WildRage", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.HARD_TO_KILL, TITLE.EGG_FIRST] \
    }, \
    { \
        name: "尘风歌者", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.FLAWLESS, TITLE.PERSEVERANCE, TITLE.SPEEDRUN, TITLE.LIGHT_PACK, TITLE.DODGE_ULTIMATE, TITLE.HARD_TO_KILL, TITLE.EGG_FIRST, TITLE.PASS_EGGS] \
    }, \
    { \
        name: "吾携秋水揽星河", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.FLAWLESS, TITLE.NEVER_GIVE_UP, TITLE.TRAVELER_HELL, TITLE.SPEEDRUN, TITLE.HARD_TO_KILL, TITLE.LIGHT_PACK, TITLE.DODGE_ULTIMATE, TITLE.ALL_IN_ONE, TITLE.TRAVELER, TITLE.SKY, TITLE.CHOSEN, TITLE.LUCKY_STAR, TITLE.LUCKY_SHINE, TITLE.HACKING, TITLE.MANBA] \
    }, \
    { \
        name: "寒霜冰湮", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.FLAWLESS, TITLE.NEVER_GIVE_UP, TITLE.TRAVELER_HELL, TITLE.SPEEDRUN, TITLE.HARD_TO_KILL, TITLE.LIGHT_PACK, TITLE.DODGE_ULTIMATE, TITLE.TRAVELER, TITLE.LUCKY_STAR, TITLE.MANBA] \
    }, \
    { \
        name: "Cold", \
        titles: [TITLE.FLAWLESS, TITLE.NEVER_GIVE_UP, TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.SPEEDRUN, TITLE.HARD_TO_KILL, TITLE.LIGHT_PACK, TITLE.DODGE_ULTIMATE, TITLE.EGG_FIRST, TITLE.PASS_EGGS, TITLE.MANBA] \
    }, \
    { \
        name: "豆本豆豆奶", \
        titles: [TITLE.FLAWLESS, TITLE.CHALLENGER_LEGEND, TITLE.NEVER_GIVE_UP, TITLE.SPEEDRUN, TITLE.TRAVELER_HELL, TITLE.HARD_TO_KILL, TITLE.DODGE_ULTIMATE, TITLE.EGG_FIRST, TITLE.GOOD_LUCK, TITLE.UNLUCKY] \
    }, \
    { \
        name: "神之岛風咲", \
        titles: [TITLE.FLAWLESS] \
    }, \
    { \
        name: "溪云初起日沉阁", \
        titles: [TITLE.SPEEDRUN, TITLE.FLAWLESS, TITLE.NEVER_GIVE_UP, TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.HARD_TO_KILL, TITLE.EGG_FIRST, TITLE.UNLUCKY] \
    }, \
    { \
        name: "卖核弹的小女孩", \
        titles: [TITLE.SPEEDRUN, TITLE.FLAWLESS, TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.HARD_TO_KILL, TITLE.TRAVELER, TITLE.LUCKY_STAR, TITLE.MANBA, TITLE.HACKING, TITLE.UNLUCKY, TITLE.RED_PACKET, TITLE.GOOD_LUCK, TITLE.GREEN_MOUNTAIN, TITLE.DODGE_ULTIMATE] \
    }, \
    { \
        name: "挽风", \
        titles: [TITLE.LIGHT_PACK, TITLE.DODGE_ULTIMATE, TITLE.SPEEDRUN, TITLE.FLAWLESS, TITLE.CHALLENGER_LEGEND] \
    }, \
    { \
        name: "水濑祈", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.HARD_TO_KILL] \
    }, \
    { \
        name: "别打老顾我啊", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.FLAWLESS, TITLE.SPEEDRUN, TITLE.HARD_TO_KILL] \
    }, \
    { \
        name: "看啊情", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.FLAWLESS, TITLE.TRAVELER_HELL, TITLE.HARD_TO_KILL] \
    }, \
    { \
        name: "眼镜小宅", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.DODGE_ULTIMATE, TITLE.LIGHT_PACK, TITLE.FLAWLESS, TITLE.SPEEDRUN, TITLE.HARD_TO_KILL, TITLE.LUCKY_STAR] \
    }, \
    { \
        name: "初一吖", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.FLAWLESS, TITLE.HARD_TO_KILL, TITLE.EGG_FIRST, TITLE.PASS_EGGS, TITLE.CHOSEN, TITLE.MANBA, TITLE.UNLUCKY] \
    }, \
    { \
        name: "锦木千束", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.FLAWLESS] \
    }, \
    { \
        name: "她说话有股孩子气", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.FLAWLESS, TITLE.SPEEDRUN] \
    }, \
    { \
        name: "白银之鹰", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.SPEEDRUN] \
    }, \
    { \
        name: "蝎子莱莱", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.FLAWLESS, TITLE.SPEEDRUN, TITLE.HARD_TO_KILL] \
    }, \
    { \
        name: "雨鸢", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.HARD_TO_KILL, TITLE.LUCKY_STAR, TITLE.HACKING, TITLE.UNLUCKY, TITLE.MANBA, TITLE.SPEEDRUN, TITLE.DODGE_ULTIMATE, TITLE.FLAWLESS] \
    }, \
    { \
        name: "Jargon", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.HARD_TO_KILL] \
    }, \
    { \
        name: "我心飞扬", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL] \
    }, \
    { \
        name: "绿里奇迹", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.SPEEDRUN] \
    }, \
    { \
        name: "EruIluvatar", \
        titles: [TITLE.ALL_IN_ONE, TITLE.SKY, TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.SPEEDRUN, TITLE.HARD_TO_KILL, TITLE.HACKING, TITLE.UNLUCKY] \
    }, \
    { \
        name: "糯米进脑子", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.SPEEDRUN, TITLE.HARD_TO_KILL] \
    }, \
    { \
        name: "半夜汽笛", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.HARD_TO_KILL, TITLE.MANBA] \
    }, \
    { \
        name: "雷个大憨憨", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL] \
    }, \
    { \
        name: "一痕沙", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.HARD_TO_KILL] \
    }, \
    { \
        name: "Augenstern", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.HARD_TO_KILL, TITLE.LUCKY_STAR] \
    }, \
    { \
        name: "明月有时", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.HARD_TO_KILL] \
    }, \
    { \
        name: "旅店老板", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.HARD_TO_KILL] \
    }, \
    { \
        name: "谁能体谅我的雨天", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.HARD_TO_KILL] \
    }, \
    { \
        name: "锄禾日当午", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.HARD_TO_KILL, TITLE.HACKING, TITLE.LUCKY_STAR, TITLE.UNLUCKY, TITLE.MANBA] \
    }, \
    { \
        name: "板鸭", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.MANBA, TITLE.LUCKY_STAR, TITLE.HACKING] \
    }, \
    { \
        name: "八十万萝莉总教头", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.UNLUCKY, TITLE.MANBA, TITLE.HACKING, TITLE.LUCKY_STAR] \
    }, \
    { \
        name: "岂不六哉", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL] \
    }, \
    { \
        name: "我想吃烤地瓜", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL] \
    }, \
    { \
        name: "云雀", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.HACKING, TITLE.LUCKY_STAR] \
    }, \
    { \
        name: "嘤嘤嘤丶", \
        titles: [TITLE.ALL_IN_ONE, TITLE.SKY, TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.HACKING, TITLE.FLAWLESS, TITLE.SPEEDRUN, TITLE.LUCKY_STAR, TITLE.MANBA, TITLE.UNLUCKY, TITLE.DODGE_ULTIMATE] \
    }, \
    { \
        name: "八月八月八", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.MANBA, TITLE.UNLUCKY, TITLE.LUCKY_STAR] \
    }, \
    { \
        name: "天树是只臭猫", \
        titles: [TITLE.HACKING, TITLE.UNLUCKY, TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL, TITLE.LUCKY_STAR] \
    }, \
    { \
        name: "好男人从不过夜", \
        titles: [TITLE.CHALLENGER_LEGEND, TITLE.TRAVELER_HELL] \
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
# 暴雪世界
#!define DATA_BLIZZARD_WORLD [ \
   [], \
   playerNameToIndexDelimited(["他又", "吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "雨鸢", "EruIluvatar", "糯米进脑子", "Augenstern", "嘤嘤嘤丶"], "-"), \
   playerNameToIndexDelimited(["他又", "吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "雨鸢", "EruIluvatar", "糯米进脑子", "Augenstern", "嘤嘤嘤丶"], "-")\
]

# 多拉多
#!define DATA_DORADO [ \
   [], \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "卖核弹的小女孩", "看啊情", "眼镜小宅", "初一吖", "EruIluvatar", "糯米进脑子", "明月有时", "雨鸢", "岂不六哉", "八月八月八", "嘤嘤嘤丶"], "-"), \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "卖核弹的小女孩", "看啊情", "眼镜小宅", "初一吖", "EruIluvatar", "糯米进脑子", "明月有时", "雨鸢", "岂不六哉", "八月八月八", "嘤嘤嘤丶"], "-")\
]

# 艾兴瓦尔德
#!define DATA_EICHENWALDE [ \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "眼镜小宅", "初一吖", "锦木千束"], "-"), \
   playerNameToIndexDelimited(["顾北酒笙", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "挽风", "看啊情", "眼镜小宅", "初一吖", "锦木千束", "她说话有股孩子气", "EruIluvatar", "雨鸢", "嘤嘤嘤丶", "八月八月八"], "-"), \
   playerNameToIndexDelimited(["顾北酒笙", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "锦木千束", "EruIluvatar", "雨鸢", "嘤嘤嘤丶", "八月八月八"], "-")\
]

# 直布罗陀
#!define DATA_WATCHPOINT_GIBRALTAR [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "卖核弹的小女孩"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "卖核弹的小女孩", "八十万萝莉总教头", "嘤嘤嘤丶", "锄禾日当午", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "卖核弹的小女孩", "八十万萝莉总教头", "嘤嘤嘤丶", "锄禾日当午", "EruIluvatar"], "-")\
]

# 哈瓦那
#!define DATA_HAVANA [ \
   [], \
   playerNameToIndexDelimited(["他又", "别感冒", "顾北酒笙", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "嘤嘤嘤丶", "八月八月八"], "-"), \
   playerNameToIndexDelimited(["他又", "别感冒", "顾北酒笙", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "嘤嘤嘤丶", "八月八月八"], "-")\
]

# 好莱坞
#!define DATA_HOLLYWOOD [ \
   [], \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "糯米进脑子", "EruIluvatar", "锄禾日当午", "岂不六哉", "云雀", "板鸭", "嘤嘤嘤丶", "八月八月八", "天树是只臭猫", "八十万萝莉总教头"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "糯米进脑子", "EruIluvatar", "锄禾日当午", "岂不六哉", "云雀", "板鸭", "嘤嘤嘤丶", "八月八月八", "天树是只臭猫", "八十万萝莉总教头"], "-")\
]

# 月球基地
#!define DATA_HORIZON_LUNAR_COLONY [ \
   [], \
   playerNameToIndexDelimited(["烛台与南九", "顾北酒笙", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "云雀", "锄禾日当午", "EruIluvatar", "八月八月八", "嘤嘤嘤丶", "天树是只臭猫"], "-"), \
   playerNameToIndexDelimited(["烛台与南九", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "云雀", "锄禾日当午", "EruIluvatar", "八月八月八", "嘤嘤嘤丶", "天树是只臭猫"], "-")\
]

# 渣客镇
#!define DATA_JUNKERTOWN [ \
   [], \
   playerNameToIndexDelimited(["WildRage", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "看啊情", "眼镜小宅", "初一吖", "EruIluvatar", "雨鸢", "八十万萝莉总教头", "八月八月八", "嘤嘤嘤丶"], "-"), \
   playerNameToIndexDelimited(["WildRage", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "看啊情", "眼镜小宅", "初一吖", "EruIluvatar", "雨鸢", "八十万萝莉总教头", "八月八月八", "嘤嘤嘤丶"], "-")\
]

# 国王大道
#!define DATA_KINGS_ROW [ \
   [], \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "一痕沙", "天树是只臭猫", "嘤嘤嘤丶", "八月八月八"], "-"), \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "天树是只臭猫", "嘤嘤嘤丶", "八月八月八"], "-")\
]

# 中城
#!define DATA_MIDTOWN [ \
   [], \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "雨鸢", "EruIluvatar", "糯米进脑子", "嘤嘤嘤丶", "八月八月八"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "雨鸢", "EruIluvatar", "糯米进脑子", "嘤嘤嘤丶", "八月八月八"], "-")\
]

# 努巴尼
#!define DATA_NUMBANI [ \
   [], \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "旅店老板", "板鸭", "八月八月八", "嘤嘤嘤丶", "八十万萝莉总教头"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "旅店老板", "板鸭", "八月八月八", "嘤嘤嘤丶", "八十万萝莉总教头"], "-")\
]

# 帕拉伊苏
#!define DATA_PARAISO [ \
   [], \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "谁能体谅我的雨天", "嘤嘤嘤丶"], "-"), \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "嘤嘤嘤丶"], "-")\
]

# 巴黎
#!define DATA_PARIS [ \
   [], \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "初一吖", "她说话有股孩子气", "EruIluvatar", "雨鸢", "云雀", "锄禾日当午", "嘤嘤嘤丶", "八月八月八"], "-"), \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "初一吖", "她说话有股孩子气", "EruIluvatar", "雨鸢", "云雀", "锄禾日当午", "嘤嘤嘤丶", "八月八月八"], "-")\
]

# 里阿尔托
#!define DATA_RIALTO [ \
   playerNameToIndexDelimited(["草艮", "寒霜冰湮", "Cold", "豆本豆豆奶"], "-"), \
   playerNameToIndexDelimited(["草艮", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "糯米进脑子", "嘤嘤嘤丶"], "-"), \
   playerNameToIndexDelimited(["草艮", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "糯米进脑子", "嘤嘤嘤丶"], "-")\
]

# 66号公路
#!define DATA_ROUTE66 [ \
   [], \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "锄禾日当午", "EruIluvatar", "嘤嘤嘤丶", "八月八月八", "八十万萝莉总教头"], "-"), \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "锄禾日当午", "EruIluvatar", "嘤嘤嘤丶", "八月八月八", "八十万萝莉总教头"], "-")\
]

# 香巴里寺院
#!define DATA_SHAMBALI_MONASTERY [ \
   playerNameToIndexDelimited(["他又", "别感冒"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "嘤嘤嘤丶", "八月八月八"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "嘤嘤嘤丶", "八月八月八"], "-")\
]

# 阿努比斯神殿
#!define DATA_TEMPLE_OF_ANUBIS [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "看啊情"], "-"), \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "看啊情", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "嘤嘤嘤丶", "八月八月八"], "-"), \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "嘤嘤嘤丶", "八月八月八"], "-")\
]

# 沃斯卡娅工业区
#!define DATA_VOLSKAYA [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "卖核弹的小女孩", "眼镜小宅"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "旅店老板", "EruIluvatar", "八月八月八", "嘤嘤嘤丶", "蝎子莱莱", "板鸭"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "旅店老板", "EruIluvatar", "八月八月八", "嘤嘤嘤丶", "蝎子莱莱", "板鸭"], "-")\
]

# 埃斯佩兰萨
#!define DATA_ESPERANCA [ \
   playerNameToIndexDelimited(["WildRage", "尘风歌者", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "眼镜小宅"], "-"), \
   playerNameToIndexDelimited(["WildRage", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "锄禾日当午", "八月八月八", "嘤嘤嘤丶"], "-"), \
   playerNameToIndexDelimited(["WildRage", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "锄禾日当午", "八月八月八", "嘤嘤嘤丶"], "-")\
]

# 斗兽场
#!define DATA_COLOSSEO [ \
   playerNameToIndexDelimited(["Cold", "豆本豆豆奶"], "-"), \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "他又", "豆本豆豆奶", "八月八月八", "云雀", "嘤嘤嘤丶", "好男人从不过夜"], "-"), \
   playerNameToIndexDelimited(["他又", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "八月八月八", "云雀", "嘤嘤嘤丶", "好男人从不过夜"], "-")\
]

# 鲁纳塞彼
#!define DATA_RUNASAPI [ \
   [], \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "EruIluvatar", "雨鸢", "八月八月八", "嘤嘤嘤丶", "八十万萝莉总教头"], "-"), \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "EruIluvatar", "雨鸢", "八月八月八", "嘤嘤嘤丶", "八十万萝莉总教头"], "-")\
]

# 新皇后街
#!define DATA_NEW_QUEEN_STREET [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "溪云初起日沉阁", "眼镜小宅"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "Cold", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "嘤嘤嘤丶", "八十万萝莉总教头", "EruIluvatar", "锄禾日当午"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "Cold", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "嘤嘤嘤丶", "八十万萝莉总教头", "EruIluvatar", "锄禾日当午"], "-")\
]

# 皇家赛道
#!define DATA_CIRCUIT_ROYAL [ \
   playerNameToIndexDelimited(["他又", "别感冒"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "眼镜小宅", "EruIluvatar", "雨鸢", "锄禾日当午", "八十万萝莉总教头", "嘤嘤嘤丶"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "眼镜小宅", "EruIluvatar", "雨鸢", "锄禾日当午", "八十万萝莉总教头", "嘤嘤嘤丶"], "-")\
]

# 花村
#!define DATA_HANAMURA [ \
   playerNameToIndexDelimited(["尘风歌者", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "看啊情"], "-"), \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "看啊情", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "板鸭", "蝎子莱莱", "八月八月八", "嘤嘤嘤丶", "好男人从不过夜"], "-"), \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "卖核弹的小女孩", "看啊情", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "板鸭", "蝎子莱莱", "八月八月八", "嘤嘤嘤丶", "好男人从不过夜"], "-")\
]

# 伊利奥斯
#!define DATA_ILIOS [ \
   [], \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "别打老顾我啊", "眼镜小宅", "初一吖", "蝎子莱莱", "雨鸢", "EruIluvatar", "锄禾日当午", "嘤嘤嘤丶", "八十万萝莉总教头", "八月八月八", "好男人从不过夜"], "-"), \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "蝎子莱莱", "雨鸢", "EruIluvatar", "锄禾日当午", "嘤嘤嘤丶", "八十万萝莉总教头", "八月八月八", "好男人从不过夜"], "-")\
]

# 漓江塔
#!define DATA_LIJIANG_TOWER [ \
   [], \
   playerNameToIndexDelimited(["草艮", "烛台与南九", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "卖核弹的小女孩", "水濑祈", "看啊情", "眼镜小宅", "初一吖", "我心飞扬", "EruIluvatar", "雨鸢", "锄禾日当午", "嘤嘤嘤丶", "八月八月八"], "-"), \
   playerNameToIndexDelimited(["草艮", "烛台与南九", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "卖核弹的小女孩", "水濑祈", "看啊情", "眼镜小宅", "初一吖", "我心飞扬", "EruIluvatar", "雨鸢", "锄禾日当午", "嘤嘤嘤丶", "八月八月八"], "-")\
]

# 萨摩亚
#!define DATA_SAMOA [ \
   [], \
   playerNameToIndexDelimited(["草艮", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "EruIluvatar", "锄禾日当午", "雨鸢", "天树是只臭猫", "嘤嘤嘤丶", "八月八月八"], "-"), \
   playerNameToIndexDelimited(["草艮", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "EruIluvatar", "锄禾日当午", "雨鸢", "天树是只臭猫", "嘤嘤嘤丶", "八月八月八"], "-")\
]

# 釜山
#!define DATA_BUSAN [ \
   playerNameToIndexDelimited(["草艮", "顾北酒笙", "WildRage", "尘风歌者", "吾携秋水揽星河"], "-"), \
   playerNameToIndexDelimited(["草艮", "顾北酒笙", "WildRage", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "EruIluvatar", "糯米进脑子", "半夜汽笛", "雷个大憨憨", "板鸭", "雨鸢", "嘤嘤嘤丶"], "-"), \
   playerNameToIndexDelimited(["尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "EruIluvatar", "糯米进脑子", "半夜汽笛", "雷个大憨憨", "板鸭", "雨鸢", "嘤嘤嘤丶"], "-")\
]

# 绿洲城
#!define DATA_OASIS [ \
   playerNameToIndexDelimited(["尘风歌者", "豆本豆豆奶"], "-"), \
   playerNameToIndexDelimited(["WildRage", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "锄禾日当午", "嘤嘤嘤丶"], "-"), \
   playerNameToIndexDelimited(["WildRage", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "锄禾日当午", "嘤嘤嘤丶"], "-")\
]

# 新渣客城
#!define DATA_NEW_JUNK_CITY [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "溪云初起日沉阁", "眼镜小宅"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "嘤嘤嘤丶", "八月八月八", "云雀"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "Cold", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "嘤嘤嘤丶", "八月八月八", "云雀"], "-")\
]

# 尼泊尔
#!define DATA_NEPAL [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "EruIluvatar", "雨鸢", "旅店老板", "云雀", "八十万萝莉总教头", "嘤嘤嘤丶", "八月八月八", "天树是只臭猫"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "溪云初起日沉阁", "卖核弹的小女孩", "眼镜小宅", "初一吖", "EruIluvatar", "雨鸢", "旅店老板", "云雀", "八十万萝莉总教头", "嘤嘤嘤丶", "八月八月八", "天树是只臭猫"], "-")\
]

# 阿努比斯王座
#!define DATA_THRONE_OF_ANUBIS [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "初一吖", "Jargon"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "Jargon", "EruIluvatar", "嘤嘤嘤丶", "八十万萝莉总教头"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "Jargon", "EruIluvatar", "嘤嘤嘤丶", "八十万萝莉总教头"], "-")\
]

# 花冈
#!define DATA_HANAOKA [ \
   [], \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "嘤嘤嘤丶", "八月八月八", "云雀", "锄禾日当午"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "初一吖", "雨鸢", "EruIluvatar", "嘤嘤嘤丶", "八月八月八", "云雀", "锄禾日当午"], "-")\
]

# 苏拉瓦萨
#!define DATA_SURAVASA [ \
   playerNameToIndexDelimited(["他又", "别感冒", "吾携秋水揽星河", "寒霜冰湮", "卖核弹的小女孩", "眼镜小宅", "雨鸢", "我想吃烤地瓜"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "雨鸢", "我想吃烤地瓜", "Augenstern", "EruIluvatar", "嘤嘤嘤丶", "八月八月八", "云雀"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "雨鸢", "我想吃烤地瓜", "Augenstern", "EruIluvatar", "嘤嘤嘤丶", "八月八月八", "云雀"], "-")\
]

# 阿育陀耶
#!define DATA_AYUTTHAYA [ \
   playerNameToIndexDelimited(["他又", "别感冒"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "EruIluvatar", "嘤嘤嘤丶", "雨鸢", "锄禾日当午", "八十万萝莉总教头", "八月八月八", "天树是只臭猫"], "-"), \
   playerNameToIndexDelimited(["吾携秋水揽星河", "寒霜冰湮", "豆本豆豆奶", "卖核弹的小女孩", "眼镜小宅", "EruIluvatar", "嘤嘤嘤丶", "雨鸢", "锄禾日当午", "八十万萝莉总教头", "八月八月八", "天树是只臭猫"], "-")\
]

# 阿特利斯
#!define DATA_AATLIS [ \
   playerNameToIndexDelimited(["他又", "别感冒", "卖核弹的小女孩"], "-"), \
   playerNameToIndexDelimited(["卖核弹的小女孩", "EruIluvatar", "吾携秋水揽星河", "初一吖", "雨鸢", "八月八月八", "嘤嘤嘤丶"], "-"), \
   playerNameToIndexDelimited(["卖核弹的小女孩", "EruIluvatar", "吾携秋水揽星河", "初一吖", "雨鸢", "八月八月八", "嘤嘤嘤丶"], "-")\
]
# END AUTO-GENERATED MAP_TITLE_DATA

# ------------------------------
# 4. 初始化变量
# ------------------------------
rule "initialize title array":
    wait(getAverageServerLoad() / 100 * 0.5)
    waitUntil(__currentMap___ != null, MAX_TIME)
    # BEGIN AUTO-GENERATED ALL_TITLE
    allTitle = [
        # 0: PIONEER
        ["{0}{1}".format(__currentMapPioneerText___ if __currentMapPioneerText___ != null else getCurrentMap(), __currentPioneerText___ if __currentPioneerText___ != null else "开拓者"), heroColor[12]],
        # 1: TEST_LONG
        ["这是一个超长的称号测试字段如果到这里还没有被截断说明确实很长你说得对但是广告位招租啊哈大OW是我的家乡", null],
        # 2: NOT_MY_MAP
        ["地图不是我做的", null],
        # 3: WILD_DEV
        ["野生开发者", null],
        # 4: ARCHITECT
        ["堡垒建筑师", null],
        # 5: MAINTAINER
        ["友善的地图维护者", null],
        # 6: THREE_IN_ONE
        ["三合一地图作者", null],
        # 7: BLACK_SHEEP
        ["害群之马", null],
        # 8: PURE_HARM
        ["纯害战士", null],
        # 9: CONQUEROR
        ["{0}征服者".format(__currentMapText___ if __currentMapText___ != null else getCurrentMap()), heroColor[43]],
        # 10: DOMINATOR
        ["{0}主宰".format(__currentMapText___ if __currentMapText___ != null else getCurrentMap()), heroColor[44]],
        # 11: SURVIVOR_EXPERT
        ["专家幸存者", vect(236, 153, 0)],
        # 12: CHALLENGER_LEGEND
        ["传奇挑战者", vect(200, 0, 19)],
        # 13: TRAVELER_HELL
        ["地狱穿梭者", vect(161, 73, 197)],
        # 14: DODGE_ULTIMATE
        ["终极闪避", heroColor[1]],
        # 15: LIGHT_PACK
        ["轻装上阵", heroColor[2]],
        # 16: FLAWLESS
        ["完美无缺", vect(0, 230, 151)],
        # 17: NEVER_GIVE_UP
        ["永不言弃", vect(0, 230, 151)],
        # 18: PERSEVERANCE
        ["坚韧不拔", vect(255, 255, 255)],
        # 19: SPEEDRUN
        ["速通传奇", vect(0, 230, 151)],
        # 20: DODGE_GOD
        ["闪避の神", heroColor[28]],
        # 21: ZENYATTA
        ["智瞳开拓者", heroColor[12]],
        # 22: HARD_TO_KILL
        ["大难不死", heroColor[45]],
        # 23: WIN_HEAVEN
        ["胜天半子", breathOrange],
        # 24: IDOL
        ["堡垒の偶像", vect(200, 0, 19)],
        # 25: EGG_FIRST
        ["第一颗蛋", vect(200, 0, 19)],
        # 26: EAT_MORE
        ["我还能吃", vect(238, 75, 43)],
        # 27: ALL_IN_ONE
        ["万象归一", breathRed],
        # 28: TRAVELER
        ["守望旅行家", heroColor[33]],
        # 29: SKY
        ["万域天穹", breathPurple],
        # 30: FLAME
        ["狂暴烈焰", heroColor[28]],
        # 31: PASS_EGGS
        ["万蛋丛中过", heroColor[28]],
        # 32: CHOSEN
        ["天选之子", heroColor[11]],
        # 33: LUCKY_STAR
        ["幸运星", heroColor[3]],
        # 34: GAMBLE_KING
        ["赌王", breathGold],
        # 35: LUCKY_SHINE
        ["福星高照", heroColor[32]],
        # 36: UNLUCKY
        ["倒霉蛋", heroColor[22]],
        # 37: MANBA
        ["What can i say", heroColor[11]],
        # 38: MY_FATE
        ["我命由我", breathBlue],
        # 39: GOD_GAMBLER
        ["赌神", breathGold],
        # 40: LAO_DA
        [" 牢 大 ", null],
        # 41: V_50
        ["V我50", heroColor[37]],
        # 42: STEEL
        ["钢门", heroColor[11]],
        # 43: HACKING
        ["开了", heroColor[20]],
        # 44: RED_PACKET
        ["红包收藏家", heroColor[43]],
        # 45: GOOD_LUCK
        ["好运来", breathGold],
        # 46: LONE_WALKER
        ["千里独行", heroColor[33]],
        # 47: GREEN_MOUNTAIN
        ["踏遍青山", vect(0, 200, 50)],
        # 48: SUAN_BU_LA
        ["我不会放过你的酸不辣", heroColor[18]]
    ]
    # END AUTO-GENERATED ALL_TITLE
    splitDictArray({
        name: titlePlayer,
        titles: playerTitleRelation
    }, player_database)
