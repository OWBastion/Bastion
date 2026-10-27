#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

#!define playerNameToIndex(names) __script__("playerNameToIndex.js")
#!define playerNameToIndexDelimited(names, sep) __script__("playerNameToIndexDelimited.js")

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
    CLASSIC,          # 58 老兵
    EMOTICON_CONFUSED,# 59 ？？？
    EMOTICON_GRIMACE, # 60 ＞_＜
    EMOTICON_SURPRISED,# 61 o_O
    I_THINK_NO,       # 62 我觉得不行
    I_THINK_YES,      # 63 我觉得可以
    ANNIVERSARY_2026, # 64 到此一游
    PROPHET,          # 65 先知：麦迪文
    QUANTUM_UNLUCKY,  # 66 哪里有完美的时间线
    TASKS_COMPLETED,  # 67 哈！哈！哈！我滴任务完成辣！
    CHALLENGE_89683D0A # 68 我大受震撼
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
#!define player_title_set_flat compressed([12, 13, 16, 19, 22, 36, 37, 56, 64, 56, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 33, 36, 37, 41, 42, 49, 52, 55, 67, 22, 25, 31, 32, 36, 37, 41, 64, 66, 28, 29, 33, 36, 37, 41, 45, 47, 55, 56, 28, 35, 36, 60, 61, 64, 37, 49, 50, 53, 55, 64, 65, 67, 12, 13, 14, 16, 19, 12, 13, 14, 15, 16, 19, 22, 33, 36, 41, 42, 12, 13, 14, 16, 19, 22, 45, 12, 13, 14, 16, 19, 41, 12, 13, 14, 16, 19, 22, 27, 29, 41, 7, 8, 39, 41, 59, 60, 61, 59, 67, 16, 22, 33, 36, 37, 41, 43, 55, 56, 66, 12, 13, 14, 16, 19, 33, 36, 37, 41, 64, 66, 63, 14, 16, 19, 33, 37, 41, 64, 65, 66, 67])
#!define player_title_set_off [0, 3, 9, 10, 79, 88, 97, 107, 113, 121, 126, 133, 137, 144, 150, 159, 166, 168, 177, 178, 187, 189, 189, 190, 200]
# END AUTO-GENERATED PLAYER_TITLE_SET_POOL
# BEGIN AUTO-GENERATED TITLE PLAYER DATABASE
#!define player_name_list "自律达人游十三‖EruIluvatar‖Fajacy‖他又‖八月八月八‖初一‖卖核弹的小女孩‖吾携秋水揽星河‖嘤嘤嘤丶‖墙上静止的钟‖天树是只臭猫‖眼镜小宅‖训犬大师‖豆本豆豆奶‖銀狼‖锄禾日当午‖别感冒‖好男人从不过夜‖雨鸢‖东子云梦‖黑洛‖一杯美式‖用户‖轩一‖风子修‖南城花开‖Cresc3nt‖听心语‖小满都未满"
#!define player_title_set_index [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 18, 19, 20, 21, 22, 21, 21, 21, 23]
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
   playerNameToIndexDelimited(["卖核弹的小女孩", "他又", "别感冒"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "天树是只臭猫", "雨鸢", "训犬大师", "东子云梦", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "天树是只臭猫", "雨鸢", "训犬大师", "东子云梦", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_AATLIS_PACKED "6-3-16|17-8-7-14-6-15-4-22-21-5-28-13-9-10-18-12-19-1|17-8-7-14-6-15-4-22-21-5-28-13-9-10-18-12-19-1|"

# 南极半岛
#!define DATA_ANTARCTIC_PENINSULA [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "卖核弹的小女孩"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "轩一", "锄禾日当午", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "小满都未满", "墙上静止的钟", "雨鸢", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "轩一", "锄禾日当午", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "小满都未满", "墙上静止的钟", "雨鸢", "训犬大师", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_ANTARCTIC_PENINSULA_PACKED "7-6|17-8-7-6-23-15-4-22-21-2-5-28-9-18-12-1|17-8-7-6-23-15-4-22-21-2-5-28-9-18-12-1|"

# 阿育陀耶
#!define DATA_AYUTTHAYA [ \
   playerNameToIndexDelimited(["他又", "别感冒"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_AYUTTHAYA_PACKED "3-16|17-8-7-6-15-4-22-21-5-28-13-10-18-12-11-1|17-8-7-6-15-4-22-21-5-28-13-10-18-12-11-1|"

# 暴雪世界
#!define DATA_BLIZZARD_WORLD [ \
   [], \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "他又", "锄禾日当午", "八月八月八", "一杯美式", "Fajacy", "初一", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "东子云梦", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "他又", "锄禾日当午", "八月八月八", "一杯美式", "Fajacy", "初一", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "东子云梦", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_BLIZZARD_WORLD_PACKED "|17-8-7-14-6-3-15-4-21-2-5-28-13-18-12-19-1|17-8-7-14-6-3-15-4-21-2-5-28-13-18-12-19-1|"

# 釜山
#!define DATA_BUSAN [ \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "Fajacy", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "小满都未满", "雨鸢", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "小满都未满", "雨鸢", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_BUSAN_PACKED "8-2-1|17-4-22-21-2-5-28-18-1|17-4-22-21-2-5-28-18-1|"

# 皇家赛道
#!define DATA_CIRCUIT_ROYAL [ \
   playerNameToIndexDelimited(["他又", "别感冒"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "小满都未满", "训犬大师"], "-")\
]
#!define DATA_CIRCUIT_ROYAL_PACKED "3-16|17-8-7-6-15-4-22-21-28-13-18-12-11-1|17-8-7-6-15-4-22-21-28-13-18-12-11-1|8-7-6-4-28-12"

# 斗兽场
#!define DATA_COLOSSEO [ \
   playerNameToIndexDelimited(["豆本豆豆奶"], "-"), \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "他又", "锄禾日当午", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "Cresc3nt", "风子修", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "眼镜小宅", "东子云梦", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "他又", "锄禾日当午", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "Cresc3nt", "风子修", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "眼镜小宅", "东子云梦", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_COLOSSEO_PACKED "13|25-17-8-7-6-3-15-4-22-21-2-5-26-24-28-13-18-12-11-19-1|25-17-8-7-6-3-15-4-22-21-2-5-26-24-28-13-18-12-11-19-1|"

# 多拉多
#!define DATA_DORADO [ \
   [], \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "风子修", "小满都未满", "自律达人游十三", "豆本豆豆奶", "墙上静止的钟", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "东子云梦", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "风子修", "小满都未满", "自律达人游十三", "豆本豆豆奶", "墙上静止的钟", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "东子云梦", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_DORADO_PACKED "|25-17-8-7-6-15-4-22-21-2-5-24-28-0-13-9-10-18-12-11-19-1|25-17-8-7-6-15-4-22-21-2-5-24-28-0-13-9-10-18-12-11-19-1|"

# 艾兴瓦尔德
#!define DATA_EICHENWALDE [ \
   playerNameToIndexDelimited(["卖核弹的小女孩", "八月八月八", "小满都未满", "训犬大师"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "黑洛", "用户", "一杯美式", "Fajacy", "初一", "小满都未满", "雨鸢", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "黑洛", "用户", "一杯美式", "Fajacy", "初一", "小满都未满", "雨鸢", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_EICHENWALDE_PACKED "6-4-28-12|17-20-22-21-2-5-28-18-1|17-20-22-21-2-5-28-18-1|"

# 埃斯佩兰萨
#!define DATA_ESPERANCA [ \
   playerNameToIndexDelimited(["豆本豆豆奶", "眼镜小宅"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "雨鸢", "训犬大师", "眼镜小宅", "东子云梦", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "雨鸢", "训犬大师", "眼镜小宅", "东子云梦", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_ESPERANCA_PACKED "13-11|17-8-7-6-15-4-21-5-28-13-9-18-12-11-19-1|17-8-7-6-15-4-21-5-28-13-9-18-12-11-19-1|"

# 花村
#!define DATA_HANAMURA [ \
   playerNameToIndexDelimited(["豆本豆豆奶"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "小满都未满", "训犬大师"], "-")\
]
#!define DATA_HANAMURA_PACKED "13|17-8-7-6-15-4-22-21-5-28-13-18-12-11-1|17-8-7-6-15-4-22-21-5-28-13-18-12-11-1|8-7-6-4-28-12"

# 花冈
#!define DATA_HANAOKA [ \
   [], \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "轩一", "锄禾日当午", "八月八月八", "用户", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "轩一", "锄禾日当午", "八月八月八", "用户", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_HANAOKA_PACKED "|17-8-7-6-23-15-4-22-21-5-28-13-9-18-12-11-1|17-8-7-6-23-15-4-22-21-5-28-13-9-18-12-11-1|"

# 哈瓦那
#!define DATA_HAVANA [ \
   [], \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "他又", "锄禾日当午", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "别感冒", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "雨鸢", "训犬大师", "眼镜小宅", "东子云梦", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "他又", "锄禾日当午", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "别感冒", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "雨鸢", "训犬大师", "眼镜小宅", "东子云梦", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_HAVANA_PACKED "|17-8-7-6-3-15-4-22-21-2-5-16-28-13-9-18-12-11-19-1|17-8-7-6-3-15-4-22-21-2-5-16-28-13-9-18-12-11-19-1|"

# 好莱坞
#!define DATA_HOLLYWOOD [ \
   [], \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "小满都未满", "豆本豆豆奶", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "东子云梦", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "小满都未满", "豆本豆豆奶", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "东子云梦", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_HOLLYWOOD_PACKED "|17-8-7-6-15-4-22-21-2-5-28-13-10-18-12-11-19-1|17-8-7-6-15-4-22-21-2-5-28-13-10-18-12-11-19-1|"

# 月球基地
#!define DATA_HORIZON_LUNAR_COLONY [ \
   [], \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "Fajacy", "初一", "风子修", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "Fajacy", "初一", "风子修", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_HORIZON_LUNAR_COLONY_PACKED "|25-17-8-7-6-15-4-21-2-5-24-28-13-9-10-18-12-11-1|25-17-8-7-6-15-4-21-2-5-24-28-13-9-10-18-12-11-1|"

# 伊利奥斯
#!define DATA_ILIOS [ \
   [], \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "黑洛", "卖核弹的小女孩", "轩一", "锄禾日当午", "八月八月八", "一杯美式", "Fajacy", "初一", "风子修", "小满都未满", "自律达人游十三", "豆本豆豆奶", "墙上静止的钟", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "轩一", "锄禾日当午", "八月八月八", "一杯美式", "Fajacy", "初一", "风子修", "小满都未满", "自律达人游十三", "豆本豆豆奶", "墙上静止的钟", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_ILIOS_PACKED "|25-17-8-7-20-6-23-15-4-21-2-5-24-28-0-13-9-10-18-12-11-1|25-17-8-7-6-23-15-4-21-2-5-24-28-0-13-9-10-18-12-11-1|"

# 渣客镇
#!define DATA_JUNKERTOWN [ \
   [], \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_JUNKERTOWN_PACKED "|17-8-7-6-15-4-21-5-28-13-10-18-12-11-1|17-8-7-6-15-4-21-5-28-13-10-18-12-11-1|"

# 国王大道
#!define DATA_KINGS_ROW [ \
   [], \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "黑洛", "銀狼", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "黑洛", "銀狼", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_KINGS_ROW_PACKED "|17-8-7-20-14-6-15-4-22-21-2-5-28-13-9-10-18-12-11-1|17-8-7-20-14-6-15-4-22-21-2-5-28-13-9-10-18-12-11-1|"

# 漓江塔
#!define DATA_LIJIANG_TOWER [ \
   [], \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "黑洛", "銀狼", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "初一", "风子修", "小满都未满", "豆本豆豆奶", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "黑洛", "銀狼", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "初一", "风子修", "小满都未满", "豆本豆豆奶", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_LIJIANG_TOWER_PACKED "|25-17-8-7-20-14-6-15-4-22-21-5-24-28-13-10-18-12-11-1|25-17-8-7-20-14-6-15-4-22-21-5-24-28-13-10-18-12-11-1|"

# 中城
#!define DATA_MIDTOWN [ \
   [], \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_MIDTOWN_PACKED "|17-8-7-6-15-4-22-21-5-28-13-18-12-11-1|17-8-7-6-15-4-22-21-5-28-13-18-12-11-1|"

# 霓虹枢纽
#!define DATA_NEON_JUNCTION [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "卖核弹的小女孩", "他又", "八月八月八", "别感冒", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "Fajacy", "风子修", "小满都未满", "雨鸢", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "Fajacy", "风子修", "小满都未满", "雨鸢", "训犬大师", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_NEON_JUNCTION_PACKED "7-6-3-4-16-12-1|25-17-8-7-6-15-4-22-2-24-28-18-12-1|25-17-8-7-6-15-4-22-2-24-28-18-12-1|"

# 尼泊尔
#!define DATA_NEPAL [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "卖核弹的小女孩", "豆本豆豆奶"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "Fajacy", "初一", "小满都未满", "豆本豆豆奶", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "Fajacy", "初一", "小满都未满", "豆本豆豆奶", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_NEPAL_PACKED "7-6-13|17-8-7-14-6-15-4-21-2-5-28-13-10-18-12-11-1|17-8-7-14-6-15-4-21-2-5-28-13-10-18-12-11-1|"

# 监测站：格里姆火山
#!define DATA_NEW_A021ED61 [ \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "用户", "Fajacy", "风子修", "雨鸢", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "风子修", "小满都未满", "雨鸢", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "风子修", "小满都未满", "雨鸢", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_NEW_A021ED61_PACKED "25-17-8-7-6-4-22-2-24-18-1|25-17-8-7-6-4-22-21-2-5-24-28-18-1|25-17-8-7-6-4-22-21-2-5-24-28-18-1|"

# 新渣客城
#!define DATA_NEW_JUNK_CITY [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "眼镜小宅"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_NEW_JUNK_CITY_PACKED "7-11|17-8-7-6-15-4-21-5-28-13-18-12-11-1|17-8-7-6-15-4-21-5-28-13-18-12-11-1|"

# 新皇后街
#!define DATA_NEW_QUEEN_STREET [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "眼镜小宅"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "风子修", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "风子修", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_NEW_QUEEN_STREET_PACKED "7-11|17-8-7-6-15-4-22-21-2-5-24-28-13-9-18-12-11-1|17-8-7-6-15-4-22-21-2-5-24-28-13-9-18-12-11-1|"

# 努巴尼
#!define DATA_NUMBANI [ \
   [], \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "初一", "风子修", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "眼镜小宅", "听心语", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "初一", "风子修", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "眼镜小宅", "听心语", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_NUMBANI_PACKED "|17-8-7-6-15-4-22-21-5-24-28-13-18-12-11-27-1|17-8-7-6-15-4-22-21-5-24-28-13-18-12-11-27-1|"

# 绿洲城
#!define DATA_OASIS [ \
   playerNameToIndexDelimited(["豆本豆豆奶"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "Fajacy", "初一", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "Fajacy", "初一", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_OASIS_PACKED "13|17-8-7-6-15-4-21-2-5-28-13-9-18-12-11-1|17-8-7-6-15-4-21-2-5-28-13-9-18-12-11-1|"

# 帕拉伊苏
#!define DATA_PARAISO [ \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "小满都未满", "训犬大师", "眼镜小宅"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "八月八月八", "用户", "初一", "小满都未满", "豆本豆豆奶", "雨鸢", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "八月八月八", "用户", "初一", "小满都未满", "豆本豆豆奶", "雨鸢", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_PARAISO_PACKED "8-7-6-4-28-12-11|17-8-4-22-5-28-13-18-1|17-8-4-22-5-28-13-18-1|"

# 巴黎
#!define DATA_PARIS [ \
   [], \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "Fajacy", "初一", "小满都未满", "豆本豆豆奶", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "东子云梦", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "Fajacy", "初一", "小满都未满", "豆本豆豆奶", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "东子云梦", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "小满都未满", "训犬大师"], "-")\
]
#!define DATA_PARIS_PACKED "|17-8-7-6-15-4-21-2-5-28-13-10-18-12-11-19-1|17-8-7-6-15-4-21-2-5-28-13-10-18-12-11-19-1|8-7-6-4-28-12"

# 里阿尔托
#!define DATA_RIALTO [ \
   playerNameToIndexDelimited(["豆本豆豆奶"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "初一", "风子修", "小满都未满", "豆本豆豆奶", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "听心语", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "初一", "风子修", "小满都未满", "豆本豆豆奶", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "听心语", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_RIALTO_PACKED "13|17-8-7-6-15-4-22-21-5-24-28-13-10-18-12-11-27-1|17-8-7-6-15-4-22-21-5-24-28-13-10-18-12-11-27-1|"

# 66号公路
#!define DATA_ROUTE66 [ \
   [], \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "风子修", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "Fajacy", "初一", "风子修", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_ROUTE66_PACKED "|25-17-8-7-6-15-4-22-21-2-5-24-28-13-9-18-12-11-1|25-17-8-7-6-15-4-22-21-2-5-24-28-13-9-18-12-11-1|"

# 鲁纳塞彼
#!define DATA_RUNASAPI [ \
   [], \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "Fajacy", "初一", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "Fajacy", "初一", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_RUNASAPI_PACKED "|17-8-7-6-15-4-21-2-5-28-13-9-18-12-11-1|17-8-7-6-15-4-21-2-5-28-13-9-18-12-11-1|"

# 萨摩亚
#!define DATA_SAMOA [ \
   [], \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "Fajacy", "初一", "小满都未满", "豆本豆豆奶", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "Fajacy", "初一", "小满都未满", "豆本豆豆奶", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_SAMOA_PACKED "|17-8-7-6-15-4-21-2-5-28-13-10-18-12-11-1|17-8-7-6-15-4-21-2-5-28-13-10-18-12-11-1|"

# 香巴里寺院
#!define DATA_SHAMBALI_MONASTERY [ \
   playerNameToIndexDelimited(["他又", "别感冒"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_SHAMBALI_MONASTERY_PACKED "3-16|17-8-7-6-15-4-21-5-28-13-9-18-12-11-1|17-8-7-6-15-4-21-5-28-13-9-18-12-11-1|"

# 苏拉瓦萨
#!define DATA_SURAVASA [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "卖核弹的小女孩", "他又", "别感冒", "雨鸢", "眼镜小宅"], "-"), \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "初一", "风子修", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["南城花开", "好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "用户", "一杯美式", "初一", "风子修", "小满都未满", "豆本豆豆奶", "墙上静止的钟", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_SURAVASA_PACKED "7-6-3-16-18-11|25-17-8-7-6-15-4-22-21-5-24-28-13-9-18-12-11-1|25-17-8-7-6-15-4-22-21-5-24-28-13-9-18-12-11-1|"

# 阿努比斯神殿
#!define DATA_TEMPLE_OF_ANUBIS [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "豆本豆豆奶"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "銀狼", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_TEMPLE_OF_ANUBIS_PACKED "7-13|17-8-7-14-6-15-4-21-5-28-13-18-12-11-1|17-8-7-14-6-15-4-21-5-28-13-18-12-11-1|"

# 阿努比斯王座
#!define DATA_THRONE_OF_ANUBIS [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "卖核弹的小女孩", "初一", "豆本豆豆奶"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "Fajacy", "初一", "小满都未满", "豆本豆豆奶", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "Fajacy", "初一", "小满都未满", "豆本豆豆奶", "天树是只臭猫", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_THRONE_OF_ANUBIS_PACKED "7-6-5-13|17-8-7-6-15-4-21-2-5-28-13-10-18-12-11-1|17-8-7-6-15-4-21-2-5-28-13-10-18-12-11-1|"

# 沃斯卡娅工业区
#!define DATA_VOLSKAYA [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "卖核弹的小女孩", "眼镜小宅"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "初一", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "眼镜小宅", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_VOLSKAYA_PACKED "7-6-11|17-8-7-6-15-4-21-5-28-13-18-12-11-1|17-8-7-6-15-4-21-5-28-13-18-12-11-1|"

# 直布罗陀
#!define DATA_WATCHPOINT_GIBRALTAR [ \
   playerNameToIndexDelimited(["吾携秋水揽星河", "卖核弹的小女孩"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "EruIluvatar"], "-"), \
   playerNameToIndexDelimited(["好男人从不过夜", "嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "锄禾日当午", "八月八月八", "一杯美式", "小满都未满", "豆本豆豆奶", "雨鸢", "训犬大师", "EruIluvatar"], "-"), \
   []\
]
#!define DATA_WATCHPOINT_GIBRALTAR_PACKED "7-6|17-8-7-6-15-4-21-28-13-18-12-1|17-8-7-6-15-4-21-28-13-18-12-1|"
# END AUTO-GENERATED MAP_TITLE_DATA

# ------------------------------
# 4. 初始化变量
# ------------------------------
rule "initialize title array":
    @Condition mapTitlePlayersByKey != null

    wait(getAverageServerLoad() / 100 * 0.5)
    # BEGIN AUTO-GENERATED ALL_TITLE
    titleText = ["{0}{1}".format(__currentMapPioneerText___ if __currentMapPioneerText___ != null else getCurrentMap(), __currentPioneerText___ if __currentPioneerText___ != null else "开拓者")].concat("这是一个超长的称号测试字段如果到这里还没有被截断说明确实很长你说得对但是广告位招租啊哈大OW是我的家乡‖地图不是我做的‖野生开发者‖堡垒建筑师‖友善的地图维护者‖三合一地图作者‖骇人鲸‖纯害战士".split("‖")).concat(["{0}征服者".format(__currentMapText___ if __currentMapText___ != null else getCurrentMap())]).concat(["{0}主宰".format(__currentMapText___ if __currentMapText___ != null else getCurrentMap())]).concat("专家幸存者‖传奇挑战者‖地狱穿梭者‖终极闪避‖轻装上阵‖完美无缺‖永不言弃‖坚韧不拔‖速通传奇‖闪避の神‖智瞳开拓者‖大难不死‖胜天半子‖堡垒の偶像‖第一颗蛋‖我还能吃‖万象归一‖守望旅行家‖万域天穹‖狂暴烈焰‖万蛋丛中过‖天选之子‖幸运星‖赌王‖福星高照‖倒霉蛋‖What can i say‖我命由我‖赌神‖牢 大‖V我50‖钢门‖开了‖红包收藏家‖好运来‖千里独行‖踏遍青山‖我不会放过你的酸不辣‖赌圣‖害群之马‖我要验牌‖牌没有问题‖大舍天下‖冲出地表‖把他们上市‖生命守护生命‖怪盗".split("‖")).concat([__currentMapClassicText___]).concat("？？？‖＞_＜‖o_O‖我觉得不行‖我觉得可以‖到此一游‖先知：麦迪文‖哪里有完美的时间线‖哈！哈！哈！我滴任务完成辣！‖我大受震撼".split("‖"))
    titleColor = [
        # 0: PIONEER
        [heroColor[12]],
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
        [heroColor[43]],
        # 10: DOMINATOR
        [heroColor[44]],
        # 11: SURVIVOR_EXPERT
        [vect(236, 153, 0)],
        # 12: CHALLENGER_LEGEND
        [vect(200, 0, 19)],
        # 13: TRAVELER_HELL
        [vect(161, 73, 197)],
        # 14: DODGE_ULTIMATE
        [heroColor[1]],
        # 15: LIGHT_PACK
        [heroColor[2]],
        # 16: FLAWLESS
        [vect(0, 230, 151)],
        # 17: NEVER_GIVE_UP
        [vect(0, 230, 151)],
        # 18: PERSEVERANCE
        [vect(255, 255, 255)],
        # 19: SPEEDRUN
        [vect(0, 230, 151)],
        # 20: DODGE_GOD
        [heroColor[28]],
        # 21: ZENYATTA
        [heroColor[12]],
        # 22: HARD_TO_KILL
        [heroColor[45]],
        # 23: WIN_HEAVEN
        breathPalette.orange,
        # 24: IDOL
        [vect(200, 0, 19)],
        # 25: EGG_FIRST
        [vect(200, 0, 19)],
        # 26: EAT_MORE
        [vect(238, 75, 43)],
        # 27: ALL_IN_ONE
        breathPalette.red,
        # 28: TRAVELER
        [heroColor[33]],
        # 29: SKY
        breathPalette.purple,
        # 30: FLAME
        [heroColor[28]],
        # 31: PASS_EGGS
        [heroColor[28]],
        # 32: CHOSEN
        [heroColor[11]],
        # 33: LUCKY_STAR
        [heroColor[3]],
        # 34: GAMBLE_KING
        breathPalette.gold,
        # 35: LUCKY_SHINE
        [heroColor[32]],
        # 36: UNLUCKY
        [heroColor[22]],
        # 37: MANBA
        [heroColor[11]],
        # 38: MY_FATE
        breathPalette.blue,
        # 39: GOD_GAMBLER
        breathPalette.gold,
        # 40: LAO_DA
        null,
        # 41: V_50
        [heroColor[37]],
        # 42: STEEL
        [heroColor[11]],
        # 43: HACKING
        [heroColor[20]],
        # 44: RED_PACKET
        [heroColor[43]],
        # 45: GOOD_LUCK
        breathPalette.gold,
        # 46: LONE_WALKER
        [heroColor[33]],
        # 47: GREEN_MOUNTAIN
        [vect(0, 200, 50)],
        # 48: SUAN_BU_LA
        [heroColor[18]],
        # 49: EVENT5_GAMBLE_SAINT
        breathPalette.gold,
        # 50: EVENT5_BLACK_SHEEP
        [heroColor[3]],
        # 51: EVENT5_I_WANT_TO_CHECK_CARDS
        [heroColor[3]],
        # 52: EVENT5_CARDS_ARE_FINE
        [heroColor[3]],
        # 53: GREAT_BENEFACTOR
        [vect(0, 200, 50)],
        # 54: BREAK_ATMOSPHERE
        [vect(192, 192, 192)],
        # 55: LIST_THEM
        breathPalette.gold,
        # 56: LIFE_GUARDS_LIFE
        [heroColor[11]],
        # 57: PHANTOM_THIEF
        [heroColor[22]],
        # 58: CLASSIC
        [heroColor[43]],
        # 59: EMOTICON_CONFUSED
        [heroColor[11]],
        # 60: EMOTICON_GRIMACE
        [heroColor[11]],
        # 61: EMOTICON_SURPRISED
        [heroColor[11]],
        # 62: I_THINK_NO
        [heroColor[11]],
        # 63: I_THINK_YES
        [heroColor[11]],
        # 64: ANNIVERSARY_2026
        breathPalette.gold,
        # 65: PROPHET
        breathPalette.purple,
        # 66: QUANTUM_UNLUCKY
        breathPalette.blue,
        # 67: TASKS_COMPLETED
        breathPalette.orange,
        # 68: CHALLENGE_89683D0A
        breathPalette.purple
    ]
    # END AUTO-GENERATED ALL_TITLE
    titlePlayer = player_name_list.split("‖")
    playerTitleSetIndex = player_title_set_index
