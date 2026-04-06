

# 核心信息
#!define STR_MODE_NAME "躲避堡垒3"
#!define STR_MODE_CODE "代码【SVMQK】"

# 描述文本 - 标题与状态
#!define STR_DESC_EVENT_STATUS "随机事件 4.0 命运之环 已上线"
#!define STR_DESC_GAMEPLAY_TAG "!!!使用全英雄逃出生天!!!"

# 描述文本 - 元数据
#!define STR_DESC_LAST_UPDATE_PREFIX "最近更新："
#!define STR_DESC_CONTACT_INFO "企鹅聊天群：445152554"
#!define STR_DESC_ORIGINAL_CREDIT "原作［OW2 PASTION ESCAPE］"

#!define STR_LICENSE_TITLE "声明：本模式代码不得用于商业用途"
#!define STR_LICENSE_PERMIT "在模式描述中保留原作者署名与原模式代码的前提下，你可基于本模式及其代码进行二次创作与发布"

# 设置分类
#!define STR_SETTING_CAT_GAME "1. 游戏"
#!define STR_SETTING_CAT_DLC "2. DLC 扩展内容"

# 设置项名称
#!define STR_SETTING_DLC_VISHKAR "随机事件扩展包"
#!define STR_SETTING_REBOOT_TIME "自动重开时间间隔（小时）"
#!define STR_SETTING_DEBUG "Debug 模式"
#!define STR_SETTING_BASTION_TARGET "AI 堡垒瞄准规则"
#!define STR_SETTING_DIFFICULTY "难度"
#!define STR_SETTING_ULT_CHARGE "全英雄威能充能"
#!define STR_SETTING_BASTION_GRENADE "AI 堡垒使用榴弹（忽略难度）"
#!define STR_SETTING_CLASSIC_MAP_VARIANT "经典版地图"

# 枚举选项 (数组格式)
# 不定义整个数组，而是定义单个选项
#!define STR_OPT_TARGET_0 "自动"
#!define STR_OPT_TARGET_1 "近距离优先"
#!define STR_OPT_TARGET_2 "低生命值优先"
#!define STR_ENUM_TARGET_OPTIONS ["自动", "近距离优先", "低生命值优先"]

#!define STR_OPT_DIFF_0 "简单"
#!define STR_OPT_DIFF_1 "一般"
#!define STR_OPT_DIFF_2 "困难"
#!define STR_OPT_DIFF_3 "专家"
#!define STR_OPT_DIFF_4 "传奇"
#!define STR_OPT_DIFF_5 "地狱：无法跳过英雄"
# ... 以此类推

#!define STR_ENUM_DIFFICULTY_OPTIONS ["简单", "一般", "困难", "专家", "传奇", "地狱：无法跳过英雄"]
#!define STR_OPT_CLASSIC_MAP_VARIANT_0 "关闭"
#!define STR_OPT_CLASSIC_MAP_VARIANT_1 "皇家赛道"
#!define STR_ENUM_CLASSIC_MAP_VARIANT_OPTIONS ["关闭", "皇家赛道"]

# ------------------------------------------------
# 全局事件 (Global Events)
# ------------------------------------------------
#!define STR_EVT_GLOBAL_0_TITLE "势不可挡"
#!define STR_EVT_GLOBAL_0_DESC "堡垒获得控制免疫"
#!define STR_EVT_GLOBAL_1_TITLE "超算进化"
#!define STR_EVT_GLOBAL_1_DESC "堡垒发射榴弹会附带1.5秒的控制特效"
#!define STR_EVT_GLOBAL_2_TITLE "任务：生存"
#!define STR_EVT_GLOBAL_2_DESC "持续期间内玩家团队总阵亡次数不超过10次"
#!define STR_EVT_GLOBAL_3_TITLE "任务：占领"
#!define STR_EVT_GLOBAL_3_DESC "倒计时结束时目标点范围内有4名玩家"
#!define STR_EVT_GLOBAL_4_TITLE "任务：竞速"
#!define STR_EVT_GLOBAL_4_DESC "倒计时结束时有 50% 以上的玩家挑战进度过半"

# ------------------------------------------------
# 增益事件 (Buff Events)
# ------------------------------------------------
#!define STR_EVT_BUFF_0_TITLE "奥利维娅的礼物"
#!define STR_EVT_BUFF_0_DESC "你好"
#!define STR_EVT_BUFF_1_TITLE "疾风祝福"
#!define STR_EVT_BUFF_1_DESC "移动速度提高{0}%"
#!define STR_EVT_BUFF_2_TITLE "钢铁防线"
#!define STR_EVT_BUFF_2_DESC "获得{0}点临时护甲与{1}%伤害减免"
#!define STR_EVT_BUFF_3_TITLE "肾上腺素"
#!define STR_EVT_BUFF_3_DESC "获得{0}%伤害减免\n并额外获得{1}%治疗增益"
#!define STR_EVT_BUFF_4_TITLE "生命源泉"
#!define STR_EVT_BUFF_4_DESC "每秒恢复{0}%最大生命值"
#!define STR_EVT_BUFF_5_TITLE "黑粉来袭"
#!define STR_EVT_BUFF_5_DESC "被堡垒锁定时\n获得{0}+{1}%临时生命值\n与{2}%移速加成"
#!define STR_EVT_BUFF_6_TITLE "足力健"
#!define STR_EVT_BUFF_6_DESC "持续移动获得{0}%可叠加的移动速度"
#!define STR_EVT_BUFF_7_TITLE "血肉再生"
#!define STR_EVT_BUFF_7_DESC "获得{0}+{1}%最大生命值的临时生命值\n每{2}秒自动刷新"
#!define STR_EVT_BUFF_8_TITLE "心之钢"
#!define STR_EVT_BUFF_8_DESC "阵亡后获得{0}层\n每层永久提供{1}%最大生命值"
#!define STR_EVT_BUFF_9_TITLE "死亡延迟"
#!define STR_EVT_BUFF_9_DESC "受到致命伤害时\n该伤害将被延迟到事件结束后"
#!define STR_EVT_BUFF_10_TITLE "有我有你"
#!define STR_EVT_BUFF_10_DESC "长按{0}附身一名队友\n队友获得你100%最大生命值\n与所有加成效果"
#!define STR_EVT_BUFF_11_TITLE "↑↑↓↓←→←→BABA"
#!define STR_EVT_BUFF_11_DESC "阵亡后在{0}秒前的位置复活"
#!define STR_EVT_BUFF_12_TITLE "费斯卡光子护盾"
#!define STR_EVT_BUFF_12_DESC "所有人获得一个可恢复的护盾\n数值为你{0}%最大生命值\n护盾持续到你阵亡或事件结束"
#!define STR_EVT_BUFF_13_TITLE "向我靠拢"
#!define STR_EVT_BUFF_13_DESC "你和你附近的队友每{0}秒获得{1}秒无敌"
#!define STR_EVT_BUFF_14_TITLE "胜利意志"
#!define STR_EVT_BUFF_14_DESC "生命值低于{0}%触发\n获得{1}秒无敌并清除负面状态"
#!define STR_EVT_BUFF_15_TITLE "任务：菲迪皮德斯之力"
#!define STR_EVT_BUFF_15_DESC "持续移动{0}秒后永久获得{1}%移速加成"
#!define STR_EVT_BUFF_16_TITLE "心之钢 Pro"
#!define STR_EVT_BUFF_16_DESC "获得{0}层心之钢\n基于层数临时提升最大生命值\n数值为心之钢层数×{1}"
#!define STR_EVT_BUFF_17_TITLE "数值之力"
#!define STR_EVT_BUFF_17_DESC "获得 {0}% 治疗增益"
#!define STR_EVT_BUFF_18_TITLE "我按Q辣"
#!define STR_EVT_BUFF_18_DESC "持续移动获得终极技能充能\n终极技能持续期间获得{0}%伤害减免"

# ------------------------------------------------
# 减益事件 (Debuff Events)
# ------------------------------------------------
#!define STR_EVT_DEBUFF_0_TITLE "重力异常"
#!define STR_EVT_DEBUFF_0_DESC "移动速度降低{0}%\n跳跃高度降低{1}%"
#!define STR_EVT_DEBUFF_1_TITLE "电磁脉冲"
#!define STR_EVT_DEBUFF_1_DESC "被侵入，无法使用技能"
#!define STR_EVT_DEBUFF_2_TITLE "献祭"
#!define STR_EVT_DEBUFF_2_DESC "队友使用技能时\n消耗你 {0}% 最大生命值"
#!define STR_EVT_DEBUFF_3_TITLE "易损"
#!define STR_EVT_DEBUFF_3_DESC "受到的所有伤害提高{0}%"
#!define STR_EVT_DEBUFF_4_TITLE "限速40"
#!define STR_EVT_DEBUFF_4_DESC "移动时每秒损失{0}+{1}%最大生命值"
#!define STR_EVT_DEBUFF_5_TITLE "引力异常"
#!define STR_EVT_DEBUFF_5_DESC "被持续性拉向最近的堡垒\n移动速度降低{0}%"
#!define STR_EVT_DEBUFF_6_TITLE "骨质疏松"
#!define STR_EVT_DEBUFF_6_DESC "移动速度随时间降低，最多{0}%"
#!define STR_EVT_DEBUFF_7_TITLE "电磁脉冲 ProMax"
#!define STR_EVT_DEBUFF_7_DESC "被侵入\n并扩散至{0}米以内的队友"
#!define STR_EVT_DEBUFF_8_TITLE "能量泄漏"
#!define STR_EVT_DEBUFF_8_DESC "使用技能会消耗{0}%生命值"
#!define STR_EVT_DEBUFF_9_TITLE "有难同当"
#!define STR_EVT_DEBUFF_9_DESC "受到的{0}%伤害扩散给{1}米内的友方"
#!define STR_EVT_DEBUFF_10_TITLE "狂欢盛宴"
#!define STR_EVT_DEBUFF_10_DESC "当你在盛宴期间内阵亡\n堡垒将进入{0}秒狂暴状态"
#!define STR_EVT_DEBUFF_11_TITLE "无能的丈夫/妻子"
#!define STR_EVT_DEBUFF_11_DESC "附近的友方将被击倒{0}秒"
#!define STR_EVT_DEBUFF_12_TITLE "重伤"
#!define STR_EVT_DEBUFF_12_DESC "造成治疗与受到的治疗降低{0}%"
#!define STR_EVT_DEBUFF_13_TITLE "减半"
#!define STR_EVT_DEBUFF_13_DESC "每{0}秒损失{1}%生命值\n当生命值低于{2}%时立即阵亡"
#!define STR_EVT_DEBUFF_14_TITLE "舍己为人"
#!define STR_EVT_DEBUFF_14_DESC "基于玩家数量损失心之钢层数\n每名玩家损失{0}层，由其他玩家均分"

# ------------------------------------------------
# 机制事件 (Mech Events)
# ------------------------------------------------
#!define STR_EVT_MECH_0_TITLE "极限挑战"
#!define STR_EVT_MECH_0_DESC "获得{0}%伤害减免\n生命值被锁定在{1}%\n获得禁疗"
#!define STR_EVT_MECH_1_TITLE "赌徒"
#!define STR_EVT_MECH_1_DESC "长按{0}触发\n{1}%概率永久损失/获得{2}层心之钢"
#!define STR_EVT_MECH_2_TITLE "迷你形态"
#!define STR_EVT_MECH_2_DESC "体积缩小{0}%，最大生命值降低{1}%\n获得{2}%移速加成"
#!define STR_EVT_MECH_3_TITLE "悄悄滴进村"
#!define STR_EVT_MECH_3_DESC "下蹲隐身，移动速度降低{0}%"
#!define STR_EVT_MECH_4_TITLE "刹车失灵"
#!define STR_EVT_MECH_4_DESC "不受控的向前移动\n移动速度会逐渐提高至{0}%"
#!define STR_EVT_MECH_5_TITLE "屁动力"
#!define STR_EVT_MECH_5_DESC "长按{0}朝你的前方飞行\n飞行时获得{1}%伤害减免"
#!define STR_EVT_MECH_6_TITLE "赌徒：竞速挑战"
#!define STR_EVT_MECH_6_DESC "长按{0}消耗{1}%生命值\n{2}%概率永久获得/损失{3}%移速加成\n{4}%概率永久获得/损失{5}%移速加成"

# ------------------------------------------------
# 随机事件包 4：增益 (Buff Events Pack 4)
# ------------------------------------------------
#!define STR_EVT_BUFF_19_TITLE "相位猛冲"
#!define STR_EVT_BUFF_19_DESC "位移技能获得{0}%移速加成"
#!define STR_EVT_BUFF_20_TITLE "保镖"
#!define STR_EVT_BUFF_20_DESC "位移技能为最近友方提供护甲"
#!define STR_EVT_BUFF_21_TITLE "任务：殉道者"
# {0}=堡垒数量
#!define STR_EVT_BUFF_21_DESC "被不同的堡垒击杀\n奖励：{0}% 永久伤害减免"
#!define STR_EVT_BUFF_22_TITLE "多动症"
#!define STR_EVT_BUFF_22_DESC "位移回复{0}+{1}% 最大生命值"
#!define STR_EVT_BUFF_23_TITLE "鼓舞士气 ProMax"
#!define STR_EVT_BUFF_23_DESC "每秒治疗{0}米内的友方{1}+{2}%最大生命值"
#!define STR_EVT_BUFF_24_TITLE "F5"
#!define STR_EVT_BUFF_24_DESC "每{0}秒重置所有技能冷却"
#!define STR_EVT_BUFF_25_TITLE "治疗光塔 ProMax"
#!define STR_EVT_BUFF_25_DESC "无视距离，每秒为全队提供{0}+{1}%最大生命值的治疗"
#!define STR_EVT_BUFF_26_TITLE "超级变换形态"
#!define STR_EVT_BUFF_26_DESC "切换形态时获得{0}+{1}最大生命值的临时生命值"
#!define STR_EVT_BUFF_27_TITLE "向我开炮"
#!define STR_EVT_BUFF_27_DESC "获得{0}点可恢复护甲与{1}%伤害减免\n成为堡垒的优先攻击目标"
#!define STR_EVT_BUFF_29_TITLE "魔术大师"
#!define STR_EVT_BUFF_29_DESC "使用表情时进入隐身状态\n并获得{0}%移速加成"
#!define STR_EVT_BUFF_30_TITLE "赌徒：心之钢"
#!define STR_EVT_BUFF_30_DESC "长按{0}触发结算\n{1}%概率心之钢层数变为{2}倍，{3}%概率失去{4}%层数（向上取整）"

# ------------------------------------------------
# 随机事件包 4：减益 (Debuff Events Pack 4)
# ------------------------------------------------
#!define STR_EVT_DEBUFF_15_TITLE "保持距离"
#!define STR_EVT_DEBUFF_15_DESC "距离队友越近受到伤害越高"
#!define STR_EVT_DEBUFF_16_TITLE "404"
#!define STR_EVT_DEBUFF_16_DESC "随机禁用一个技能"
#!define STR_EVT_DEBUFF_17_TITLE "连锁过载"
#!define STR_EVT_DEBUFF_17_DESC "使用技能会导致\n所有技能进入冷却"
#!define STR_EVT_DEBUFF_18_TITLE "我和你"
#!define STR_EVT_DEBUFF_18_DESC "生命值与最低血量的队友同步"
#!define STR_EVT_DEBUFF_19_TITLE "吸血鬼"
#!define STR_EVT_DEBUFF_19_DESC "吸取队友生命值来治疗自己"
#!define STR_EVT_DEBUFF_20_TITLE "登月火箭"
#!define STR_EVT_DEBUFF_20_DESC "被随机射向天空\n并在空中无法控制方向"

# ------------------------------------------------
# 随机事件包 4：机制 (Mech Events Pack 4)
# ------------------------------------------------
#!define STR_EVT_MECH_7_TITLE "作弊：我要验牌"
#!define STR_EVT_MECH_7_DESC "长按{0}永久损失{1}层心之钢（约{2}%最大生命值）\n下个事件必为增益"
#!define STR_EVT_MECH_8_TITLE "赌徒：短期投资"
#!define STR_EVT_MECH_8_DESC "长按{0}锁定{1}个减益\n{2}%概率获得{3}层心之钢"
#!define STR_EVT_MECH_9_TITLE "命运共同体"
#!define STR_EVT_MECH_9_DESC "与随机一名友方共享下一次抽取的事件类别"
#!define STR_EVT_MECH_10_TITLE "作弊：跳过"
#!define STR_EVT_MECH_10_DESC "长按{0}跳过当前英雄且不计入挑战进度"
#!define STR_EVT_MECH_11_TITLE "俄罗斯套娃"
#!define STR_EVT_MECH_11_DESC "阵亡{0}秒后复活\n每次复活变小{1}%并加速{2}%"
#!define STR_EVT_MECH_12_TITLE "赌徒：长期投资"
#!define STR_EVT_MECH_12_DESC "长按{0}锁定{1}个减益\n{2}%概率获得{3}层心之钢"
#!define STR_EVT_MECH_13_TITLE "瓦尔基里降临"
#!define STR_EVT_MECH_13_DESC "生命值提高{0}%，获得禁疗\n受到伤害获得大招充能\n大招持续期间最多回复{1}%生命值"
#!define STR_EVT_MECH_14_TITLE "三位一体"
#!define STR_EVT_MECH_14_DESC "100HP→{0}%减伤，1%减伤→{1}%移速\n每{2}秒获得1层心之钢"
#!define STR_EVT_MECH_15_TITLE "赌徒：掷骰狂人"
#!define STR_EVT_MECH_15_DESC "持续{0}秒，长按{1}{2}秒掷骰\n1: -{3}层心之钢 | 2: -{4}%移速\n3: -{5}%减伤和治疗增益 | 4: +{4}%移速\n5: +{3}层心之钢 | 6: +{5}%减伤和治疗增益"


# 设置菜单分类 (Pack)
#!define STR_CAT_RANDOM_PACK "随机事件包"
#!define STR_CAT_RANDOM_PACK_1 "随机事件包 1"
#!define STR_CAT_RANDOM_PACK_2 "随机事件包 2"
#!define STR_CAT_RANDOM_PACK_3 "随机事件包 3"
#!define STR_CAT_RANDOM_PACK_4 "随机事件包 4"
#!define STR_CAT_RANDOM_PACK_5 "随机事件包 5"
#!define STR_CAT_RANDOM_PACK_1_BUFF "随机事件包 1：增益"
#!define STR_CAT_RANDOM_PACK_2_BUFF "随机事件包 2：增益"
#!define STR_CAT_RANDOM_PACK_3_BUFF "随机事件包 3：增益"
#!define STR_CAT_RANDOM_PACK_1_DEBUFF "随机事件包 1：减益"
#!define STR_CAT_RANDOM_PACK_2_DEBUFF "随机事件包 2：减益"
#!define STR_CAT_RANDOM_PACK_3_DEBUFF "随机事件包 3：减益"
#!define STR_CAT_RANDOM_PACK_1_MECH "随机事件包 1：机制"
#!define STR_CAT_RANDOM_PACK_2_MECH "随机事件包 2：机制"
#!define STR_CAT_RANDOM_PACK_3_MECH "随机事件包 3：机制"
#!define STR_CAT_RANDOM_PACK_4_BUFF "随机事件包 4：增益"
#!define STR_CAT_RANDOM_PACK_4_DEBUFF "随机事件包 4：减益"
#!define STR_CAT_RANDOM_PACK_4_MECH "随机事件包 4：机制"
#!define STR_CAT_RANDOM_PACK_5_MECH "随机事件包 5：机制"
#!define STR_CAT_BUFF "增益"
#!define STR_CAT_DEBUFF "减益"
#!define STR_CAT_MECH "机制"

# ------------------------------------------------
# 游戏内提示信息 (In-game Notifications)
# ------------------------------------------------
# 原文："{0} 触发事件：{1}（{2}）"
# {0}=图标, {1}=事件名, {2}=持续时间
#!define STR_MSG_EVENT_TRIGGER "  {0}  触发事件：{1}（{2}）"

# 原文："{0}秒"
# {0}=秒数
#!define STR_MSG_DURATION_SEC "{0}秒"

# 原文："一次性"
#!define STR_MSG_DURATION_INSTANT "一次性"

# 原文："{0} 事件效果：{1}"
# {0}=图标, {1}=事件描述
#!define STR_MSG_EVENT_EFFECT "  {0}  事件效果：{1}"
#!define STR_MSG_EVENT_ENDED "  {0} 事件已结束"
#!define STR_MSG_PROGRESS_SAVED "  你的挑战进度已保存"
#!define STR_MSG_HOST_WARNING_RESET "  如果当前游戏重开，所有人的进度数据将被清空"
#!define STR_MSG_HOST_ENDORSEMENT_HINT "  为了保证房间处于公开状态，请确保房主赞赏等级为 3 级或以上"
#!define STR_MSG_ANTI_CRASH_WORKING "  防炸房系统工作中..."

# {0}=技能图标
#!define STR_MSG_PASSIVE_HEAL_START "  {0}  脱战自动回复启动 "

#!define STR_MSG_MERCY_NEARBY "附近有 天使 等待复活..."
#!define STR_MSG_I_AM_UP "{0} 我起了！ {0}时间到了！"

# 通关公告
# {0}=玩家名, {1}=详细统计(STR_MSG_WIN_STATS), {2}=耗时字符串
#!define STR_MSG_WIN_ANNOUNCE "祝贺 {0} 以 {1} 耗时 {2} 通关!"

# 统计详情
# {0}=死亡数, {1}=跳过数
#!define STR_MSG_WIN_STATS "{0} 次阵亡 & {1} 次跳过"

# 时间单位
#!define STR_TIME_UNIT_HOUR "{0} 小时"
#!define STR_TIME_UNIT_MIN "{0} 分"
#!define STR_TIME_UNIT_SEC "{0} 秒"
#!define STR_TIME_UNIT_ZERO_SEC "0 秒"

# 结尾提示
# {0}=图标
#!define STR_MSG_WIN_HINT "  {0} 你已通关，可以加入聊天群 发送截图 获取通关称号"
# ------------------------------------------------
# 系统文本 - 重启提示
# ------------------------------------------------
#!define STR_TEXT_HOST_RESTARTING "主机开始了游戏模式.\n这将导致智械危机.\n\n                      正在重开..."

# ------------------------------------------------
# 机器人名称格式
# ------------------------------------------------
# {0}=编号 (Slot+1), {1}=击杀数
#!define STR_BOT_NAME_FORMAT "看守{0} 击杀{1}"

# ------------------------------------------------
# HUD 文本
# ------------------------------------------------
#!define STR_HUD_DEATHS "阵亡"
#!define STR_HUD_DEATHS_VAL "{0} / {1}"
#!define STR_HUD_HEROES "英雄"
#!define STR_HUD_HEROES_VAL "{0} / {1}"
#!define STR_HUD_NEXT_HERO "下一个英雄"
#!define STR_HUD_ESCAPED "逃脱成功"
#!define STR_HUD_UNLOCKED "{0} 已解锁！"
#!define STR_HUD_CHALLENGE_COMPLETE "挑战完成"
#!define STR_HUD_ACHIEVEMENT_DISABLED "成就挑战已禁用 {0}"
#!define STR_HUD_RUN_DEATHS "本轮共计 {0} 次阵亡"
#!define STR_HUD_RUN_SKIPS "本轮共计 {0} 次跳过"
#!define STR_HUD_SURVIVOR "大难不死 {0} "
#!define STR_HUD_GAMBLER_KING "赌王 {0} "
#!define STR_HUD_TOTAL_TIME "\n通关总计耗时\n{0}"
#!define STR_HUD_SKIP_HINT "[秘籍] 使用终极技能跳过（{0}） "
#!define STR_HUD_WELCOME_MULTI "欢迎来到三合一大地图！你需要挑战所有小地图并到达终点！阵亡 {0} 次之后可跳过英雄"
#!define STR_HUD_WELCOME_MULTI_HARD "欢迎来到三合一大地图！你需要挑战所有小地图并到达终点！当前难度无法跳过英雄，加油吧！"
#!define STR_HUD_WELCOME_NORMAL "使用全部英雄通关，一旦你解锁了一个英雄就可以在后续的游戏中随时使用！当阵亡 {0} 次之后可跳过英雄"
#!define STR_HUD_WELCOME_NORMAL_HARD "使用全部英雄通关！当前难度无法跳过英雄，加油吧！"
#!define STR_HUD_MAP_CLASSIC_SUFFIX "{0}·经典版"
#!define STR_HUD_FOOTER_INFO "500强交流群：445152554 | 加群给你喜欢的事件点赞 \n"
#!define STR_HUD_EVENT_GLOBAL "全局事件：{0} {1}（{2}）"
#!define STR_HUD_EVENT_DESC "{0} {1}"
#!define STR_HUD_EVENT_STATS "{0}/{1}/{2} 增益/减益/总计"
#!define STR_HUD_RANDOM_EVENTS "［随机事件］"
#!define STR_HUD_AUTO_RESTART "距自动重开 {0}"
#!define STR_HUD_SERVER_UPTIME "已运行 {0}"
#!define STR_HUD_SERVER_LOAD "  服务器负载 {0}"
#!define STR_HUD_VERSION "版本"

# ------------------------------------------------
# HUD 面板结构 (4.0 New)
# ------------------------------------------------
#!define STR_HUD_PANEL_TOP "┌───────────┐"
#!define STR_HUD_PANEL_BOTTOM "└───────────┘"

# 统计面板内容 (多行格式)
# {0}=阵亡/跳过数值, {1}=事件统计(可选), {2}=通关总耗时
#!define STR_HUD_STATS_PANEL "{0}\r\n{1}\r\n{2}{3}"

# 阵亡/跳过
# {0}=阵亡数, {1}=跳过数
#!define STR_HUD_STATS_DEATH_SKIP "总计阵亡/跳过 \n{0}/{1}"

# 事件统计
# {0}=增益, {1}=减益, {2}=总计
#!define STR_HUD_STATS_EVENT "增益/减益/总计\r\n{0}/{1}/{2} "

# 随机事件 4.0 标题
#!define STR_HUD_RANDOM_EVENTS_V4 "［随机事件 4.0］"

# 事件详情格式 (HUD Text)
# {0}=名称, {1}=时间, {2}=描述
#!define STR_HUD_EVENT_DETAIL "{0}（{1}）\n{2}"

# 玩家属性面板
# {0}=心之钢层数, {1}=永久移速加成, {2}=永久减伤, {3}=治疗强度
#!define STR_HUD_ATTR_PANEL "心之钢/移速/减伤/治疗%\r\n{0}/{1}/{2}/{3}%"


# ------------------------------------------------
# World Text (In-World)
# ------------------------------------------------
#!define STR_WORLD_THIRD_PERSON "      按{0}切换第三人称视角\n                    {1}"
#!define STR_WORLD_RESET_PROGRESS "重置进度\n                {0}"
#!define STR_WORLD_SPRINGBOARD "      按{0}向上弹射\n                    {1}"

# ------------------------------------------------
# Hero Specific HUD Text
# ------------------------------------------------
# D.Va
#!define STR_DVA_DISTANCE_GOAL "目标距离:{0} m"

# Ana
# {0}=Skill Icon, {1}=Cooldown Seconds (30)
#!define STR_ANA_SLEEP_LIMIT_HINT "{0} 麻醉镖限制: \n 每个堡垒每 {1} 秒只能被麻醉一次"
# {0}=Remaining Seconds
#!define STR_ANA_SLEEP_LIMIT_BAR "麻醉限制: 剩余 {0} 秒 "

# Zenyatta (Disabled rule, but good to have)
#!define STR_ZEN_KICK_HINT "踹击地面可以向后击退 {0}\n按住跳跃可以悬浮 {1}"

# ------------------------------------------------
# 游戏机制 - 进度与跳过
# ------------------------------------------------
#!define STR_MSG_SKIP_AVAILABLE "可跳过当前英雄"
#!define STR_MSG_HOLD_RELOAD_RESET "长按装填键重置"
#!define STR_MSG_RESETTING_PROGRESS "  正在重置进度..."
#!define STR_MSG_PLAYER_RESET_PROGRESS "  {0} 重置了进度"

# ------------------------------------------------
# 菜单标题
# ------------------------------------------------
#!define STR_MENU_TITLE_DEV "开发者模式"
#!define STR_MENU_TITLE_INGAME "游戏内面板"
#!define STR_MENU_TITLE_DEV_PANEL "开发者面板"
#!define STR_MENU_TITLE_WEIGHT_MANAGE "事件权重管理"

# ------------------------------------------------
# 菜单状态显示
# ------------------------------------------------
#!define STR_MENU_STATE_ON "O"
#!define STR_MENU_STATE_OFF "X"
#!define STR_MENU_STATE_NULL "空"
#!define STR_MENU_TARGET_PLAYER "{0}（{1}）"

# ------------------------------------------------
# 菜单选项 (Page 1 - General/Host)
# ------------------------------------------------
# {0}=Button, {1}=Next Line
#!define STR_MENU_OPT_RESTART_EXTEND "{0}    自动重开：延长5分钟    \n{1}"
#!define STR_MENU_OPT_RESTART_REDUCE "{0}    自动重开：缩短5分钟    \n{1}"
#!define STR_MENU_OPT_TITLE_PREV "{0}    上一个称号    \n{1}"
#!define STR_MENU_OPT_TITLE_NEXT "{0}    下一个称号    \n{1}"
#!define STR_MENU_OPT_DIFF_INC "{0}    增加难度    \n{1}"
#!define STR_MENU_OPT_DIFF_DEC "{0}    降低难度    \n{1}"
#!define STR_MAP_CIRCUIT_ROYAL "皇家赛道"
# {0}=Button, {1}=State, {2}=Next Line
#!define STR_MENU_OPT_THIRD_PERSON "{0}    第三人称视角    {1}\n{2}"
#!define STR_MENU_OPT_MARK_PLAYER "{0}    标记玩家    {1}\n{2}"
#!define STR_MENU_OPT_UNMARK_BLOCK "{0}    移除标记玩家并临时拉黑    \n{1}"
#!define STR_MENU_OPT_NEXT_PAGE "{0}    下一页    "

# ------------------------------------------------
# 菜单选项 (Page 2 - Dev Control)
# ------------------------------------------------
#!define STR_MENU_OPT_DEBUG_INFO "{0}    Debug 信息    {1}\n{2}"
#!define STR_MENU_OPT_UNLOCK_ALL "{0}    解锁全英雄    {1}\n{2}"
#!define STR_MENU_OPT_RESTART_NOW "{0}    立即重开    \n{1}"
#!define STR_MENU_OPT_UNMARK_PLAYER "{0}    移除标记玩家    \n{1}"
#!define STR_MENU_OPT_TP_TO_TARGET "{0}    传送到标记玩家    \n{1}"
#!define STR_MENU_OPT_DMG_REDUCE "{0}    受到伤害降低    {1}\n{2}"
#!define STR_MENU_OPT_INVINCIBLE "{0}    无敌    {1}\n{2}"

# ------------------------------------------------
# 菜单选项 (Page 3 - Dev Develop)
# ------------------------------------------------
#!define STR_MENU_OPT_AIR_WALK "{0}    浮空    {1}\n{2}"
#!define STR_MENU_OPT_NOCLIP "{0}    穿墙    {1}\n{2}"
#!define STR_MENU_OPT_SELECT_INDEX "{0}    选择目标点索引    {1}\n{2}"
#!define STR_MENU_OPT_TP_TO_INDEX "{0}    传送到目标点    \n{1}"
#!define STR_MENU_OPT_HERO_PAGE_TITLE "英雄选择/切换"
#!define STR_MENU_OPT_HERO_NEXT "{0}    选择英雄：{1}    \n{2}"
#!define STR_MENU_OPT_HERO_PREV "{0}    上一个英雄：{1}    \n{2}"
#!define STR_MENU_OPT_HERO_APPLY "{0}    应用切换（重生室）    \n{1}"

# ------------------------------------------------
# Host/Dev Administration Messages
# ------------------------------------------------
# {0}=Icon
#!define STR_MSG_ADMIN_NO_TARGET "  {0}  没有可标记的玩家"

# {0}=Icon, {1}=Player Name, {2}=Hero
#!define STR_MSG_ADMIN_MARKED "  {0}  房主操作： 已标记 {1}（{2}）"

# {0}=Icon, {1}=Button, {2}=Player Name
#!define STR_MSG_ADMIN_HOLD_TO_KICK "  {0}  房主操作： 长按 {1} 移除 {2}"

# {0}=Icon, {1}=Player Name
#!define STR_MSG_ADMIN_KICK_WARNING "  {0}  房主操作： 即将移除玩家 {1}"

# {0}=Icon, {1}=Player Name
#!define STR_MSG_ADMIN_KICK_SUCCESS "  {0}  房主操作： 已移除玩家 {1}"

#!define STR_MSG_ADMIN_BLACKLIST_SUCCESS "  {0}  {1} 已被拉入临时黑名单"

# ------------------------------------------------
# 自动重开倒计时
# ------------------------------------------------
#!define STR_MSG_AUTO_RESTART_1MIN "游戏将在 1 分钟后自动重开"
