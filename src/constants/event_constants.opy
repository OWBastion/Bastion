#!mainFile "../dev_main.opy"

# ==============================================================================
# 事件效果参数配置 (Event Effect Configuration)
# ==============================================================================

# 事件系统全局参数
# 初始事件权重基准（用于整体权重缩放/校准）
#!define EVT_INIT_EVENT_WEIGHT 2.5

# -----------------------------------------------------------------------------
# BUFF 事件（按ID排序）
# -----------------------------------------------------------------------------

# --- ID 0 ---
# Duration（秒）
#!define EVT_BUFF_0_DURATION 5
# Weight（权重）
#!define EVT_BUFF_0_WEIGHT 1.8

# --- ID 1: 疾风祝福 ---
# Duration（秒）
#!define EVT_BUFF_1_DURATION 25
# Weight（权重）
#!define EVT_BUFF_1_WEIGHT 1.4
#!define EVT_1_SPEED_BOOST 50
#!define EVT_1_EFFECT Effect.SOLDIER_SPRINTING

# --- ID 2: 钢铁防线 ---
# Duration（秒）
#!define EVT_BUFF_2_DURATION 25
# Weight（权重）
#!define EVT_BUFF_2_WEIGHT 1.1
#!define EVT_2_ARMOR_AMOUNT 800
#!define EVT_2_DMG_TAKEN -25
#!define EVT_2_EFFECT DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR

# --- ID 3: 肾上腺素 ---
# Duration（秒）
#!define EVT_BUFF_3_DURATION 20
# Weight（权重）
#!define EVT_BUFF_3_WEIGHT 1.4
#!define EVT_3_DMG_TAKEN -50
#!define EVT_3_HEAL_BOOST 50
#!define EVT_3_EFFECT Effect.ANA_NANO_BOOSTED

# --- ID 4: 生命源泉 ---
# Duration（秒）
#!define EVT_BUFF_4_DURATION 30
# Weight（权重）
#!define EVT_BUFF_4_WEIGHT 1.1
#!define EVT_4_HEAL_INTERVAL 20
# 15% Max HP
#!define EVT_4_HEAL_PERCENT 0.15
#!define EVT_4_EFFECT Effect.HEAL_TARGET_ACTIVE

# --- ID 5 ---
# Duration（秒）
#!define EVT_BUFF_5_DURATION 45
# Weight（权重）
#!define EVT_BUFF_5_WEIGHT 1.2
#!define EVT_5_HEALTH_TYPE Health.NORMAL
#!define EVT_5_HEALTH_FLAT 25
#!define EVT_5_HEALTH_MAXHP_FACTOR 0.5

# --- ID 6: 足力健 ---
# Duration（秒）
#!define EVT_BUFF_6_DURATION 45
# Weight（权重）
#!define EVT_BUFF_6_WEIGHT 1.3
#!define EVT_6_SPEED_INC_PER_SEC 3
#!define EVT_6_EFFECT Effect.SOLDIER_SPRINTING

# --- ID 7: 血肉再生 ---
# Duration（秒）
#!define EVT_BUFF_7_DURATION 90
# Weight（权重）
#!define EVT_BUFF_7_WEIGHT 1.3
#!define EVT_7_HEALTH_PERCENT 0.25
#!define EVT_7_BASE_HEALTH 75
#!define EVT_7_REGEN_INTERVAL 5

# --- ID 8: 心之钢 ---
# Duration（秒）
#!define EVT_BUFF_8_DURATION 120
# Weight（权重）
#!define EVT_BUFF_8_WEIGHT 1
#!define EVT_8_HP_PERCENT_PER_STACK 0.75
#!define EVT_8_HP_LAYER_PER_DEATH 1
#!define EVT_8_VISUAL_EFFECT Effect.WINSTON_PRIMAL_RAGE

# --- ID 9: 危险感知 ---
# Duration（秒）
#!define EVT_BUFF_9_DURATION 20
# Weight（权重）
#!define EVT_BUFF_9_WEIGHT 1.2
#!define EVT_9_SPEED_BOOST 60
#!define EVT_9_DMG_TAKEN -25
#!define EVT_9_LINGER_TIME 1

# --- ID 10: 反应装甲 ---
# Duration（秒）
#!define EVT_BUFF_10_DURATION 60
# Weight（权重）
#!define EVT_BUFF_10_WEIGHT 0.8
#!define EVT_10_ARMOR_AMOUNT 150
# --- ID 10: 反应装甲 (反伤晕眩逻辑) ---
#!define EVT_10_STUN_DURATION 1
#!define EVT_10_STUN_COOLDOWN 1

# --- ID 11: 死亡延迟 ---
# Duration（秒）
#!define EVT_BUFF_11_DURATION 45
# Weight（权重）
#!define EVT_BUFF_11_WEIGHT 0.7
# 15% 血量触发
#!define EVT_11_TRIGGER_HP_PERCENT 0.15
# 处决伤害
#!define EVT_11_EXECUTE_DAMAGE 9999999999
# 堡垒右键处决阈值
#!define EVT_11_BASTION_EXECUTE_HP 500
#!define EVT_11_EFFECT Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED
#!define EVT_11_SOUND Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED_SOUND

# --- ID 12 ---
# Duration（秒）
#!define EVT_BUFF_12_DURATION 120
# Weight（权重）
#!define EVT_BUFF_12_WEIGHT 1.2

# --- ID 13: ↑↑↓↓←→←→BABA (魂斗罗/动态存档) ---
# Duration（秒）
#!define EVT_BUFF_13_DURATION 120
# Weight（权重）
#!define EVT_BUFF_13_WEIGHT 0.6
# 存档更新频率 (秒)
#!define EVT_13_CHECKPOINT_INTERVAL 5
# 死亡后复活延迟
#!define EVT_13_RESPAWN_DELAY 3
#!define EVT_13_EFFECT_SAVE Effect.SPARKLES
#!define EVT_13_EFFECT_DIE DynamicEffect.TRACER_RECALL_DISAPPEAR
#!define EVT_13_EFFECT_RESURRECT DynamicEffect.TRACER_RECALL_REAPPEAR

# --- ID 14: 费斯卡光子护盾 (团队共享盾) ---
# Duration（秒）
#!define EVT_BUFF_14_DURATION 120
# Weight（权重）
#!define EVT_BUFF_14_WEIGHT 0.9
# 给予最大生命值 20% 的护盾
#!define EVT_14_SHIELD_PERCENT 0.2
# 最小护盾值
#!define EVT_14_MIN_SHIELD 75
# 护盾池 ID 索引
#!define EVT_14_HEALTH_ID 2

# --- ID 15 ---
# Duration（秒）
#!define EVT_BUFF_15_DURATION 90
# Weight（权重）
#!define EVT_BUFF_15_WEIGHT 0

# --- ID 16: 向我靠拢 (无敌光环) ---
# Duration（秒）
#!define EVT_BUFF_16_DURATION 30
# Weight（权重）
#!define EVT_BUFF_16_WEIGHT 0.5
# 检测间隔 (秒)
#!define EVT_16_CHECK_INTERVAL 5

# 光环生效半径 (米)
#!define EVT_16_RADIUS 15

# 获得的无敌持续时间 (秒)
#!define EVT_16_INVINCIBLE_DURATION 2.5

# 无敌视觉特效
#!define EVT_16_EFFECT Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED

# 变量数组索引定义
# invincible[0] = 是否激活 (bool)
# invincible[1] = 来源玩家 (Entity)
# invincible[2] = 持续时间 (Number)

# --- ID 17: 我独自闯关 ---
# Duration（秒）
#!define EVT_BUFF_17_DURATION 120
# Weight（权重）
#!define EVT_BUFF_17_WEIGHT 1.1
# 检测半径
#!define EVT_17_CHECK_RADIUS 8

# 状态 1：有队友时的数值 (普通)
#!define EVT_17_MODE1_DMG_TAKEN -15
#!define EVT_17_MODE1_HEAL_BOOST 30
#!define EVT_17_MODE1_SPEED 12.5
# 受到75%击退 = 25% 抵抗
#!define EVT_17_MODE1_KNOCKBACK 75

# 状态 2：独自一人时的数值 (强力)
#!define EVT_17_MODE2_DMG_TAKEN -30
#!define EVT_17_MODE2_HEAL_BOOST 60
#!define EVT_17_MODE2_SPEED 25
# 受到50%击退 = 50% 抵抗
#!define EVT_17_MODE2_KNOCKBACK 50

# --- ID 18: 坚定 ---
# Duration（秒）
#!define EVT_BUFF_18_DURATION 90
# Weight（权重）
#!define EVT_BUFF_18_WEIGHT 0.5
# 基础属性
# 95% 击退抵抗 (mod 值，不是 setKnockbackReceived)
#!define EVT_18_KNOCKBACK_RESISTANCE -95

# 受击触发属性
# 每次受到击退增加 5% 减伤
#!define EVT_18_DMG_REDUCE_PER_STACK 5
# 最大减伤上限 (负数表示减伤)
#!define EVT_18_MAX_DMG_REDUCE -75
# 每次受到击退回复 8% 最大生命
#!define EVT_18_HEAL_PERCENT 0.08

# --- ID 19: 胜利意志 ---
# Duration（秒）
#!define EVT_BUFF_19_DURATION 30
# Weight（权重）
#!define EVT_BUFF_19_WEIGHT 1.2
# 触发阈值 (血量百分比)
#!define EVT_19_TRIGGER_HP_PERCENT 0.3

# 无敌持续时间 (秒)
#!define EVT_19_INVINCIBLE_DURATION 5

# 视觉与音效
#!define EVT_19_EFFECT Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED
#!define EVT_19_SOUND Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED_SOUND

# --- ID 20: 菲迪皮德斯之力 ---
# Duration（秒）
#!define EVT_BUFF_20_DURATION 45
# Weight（权重）
#!define EVT_BUFF_20_WEIGHT 0.8
#!define EVT_20_DISTANCE_GOAL 42.195
#!define EVT_20_DISTANCE_INC 0.5
#!define EVT_20_REWARD_SPEED 7.5

# --- ID 21: 心之钢 Pro ---
# Duration（秒）
#!define EVT_BUFF_21_DURATION 90
# Weight（权重）
#!define EVT_BUFF_21_WEIGHT 0.9
#!define EVT_21_HP_GAIN_FLAT 12
#!define EVT_21_HP_MULTIPLIER 2

# --- ID 22: 数值之力 ---
# Duration（秒）
#!define EVT_BUFF_22_DURATION 90
# Weight（权重）
#!define EVT_BUFF_22_WEIGHT 0.5
#!define EVT_22_HEAL_BOOST 500
#!define EVT_22_RADIUS 200

# --- ID 23: 我按Q辣 ---
# Duration（秒）
#!define EVT_BUFF_23_DURATION 120
# Weight（权重）
#!define EVT_BUFF_23_WEIGHT 1.2
#!define EVT_23_ULT_CHARGE_PER_SEC 10
#!define EVT_23_DMG_REDUCTION_DURING_ULT 75

# --- ID 24: 相位猛冲 (智能检测版) ---
# Duration（秒）
#!define EVT_BUFF_24_DURATION 45
# Weight（权重）
#!define EVT_BUFF_24_WEIGHT 1.2
#!define EVT_24_SPEED_BOOST 200
#!define EVT_24_DURATION 2
#!define EVT_24_EFFECT_RADIUS 200
#!define EVT_24_EFFECT Effect.SOLDIER_SPRINTING

# --- ID 25: 保镖 (Bodyguard) ---
# Duration（秒）
#!define EVT_BUFF_25_DURATION 75
# Weight（权重）
#!define EVT_BUFF_25_WEIGHT 1
# 搜索队友半径 (米)
#!define EVT_25_ALLY_RADIUS 12

# 护甲池数值 = round( flat + MaxHP * factor )
#!define EVT_25_HEALTH_TYPE Health.ARMOR
#!define EVT_25_ARMOR_FLAT 25
#!define EVT_25_ARMOR_MAXHP_FACTOR 0.2

# 护甲持续时间 (秒)：写入 hp_data 的到期偏移
#!define EVT_25_ARMOR_DURATION 4

# 动态特效播放半径 (米) - 仅视觉表现
#!define EVT_25_VFX_RADIUS 200

# 事件尾部等待 (秒)
#!define EVT_25_POST_WAIT 3

# --- ID 26: 任务：殉道者 ---
# Duration（秒）
#!define EVT_BUFF_26_DURATION 120
# Weight（权重）
#!define EVT_BUFF_26_WEIGHT 0.8
# 任务目标最小值
#!define EVT_26_GOAL_MIN 6

# 任务目标最大值 = max(EVT_26_GOAL_MIN, round(len(bastionPosition) * factor))
#!define EVT_26_GOAL_MAX_FACTOR 0.75

# 完成奖励：永久减伤数值（与 mod_dmg_perma 的单位保持一致）
#!define EVT_26_REWARD_DMG_PERMA 5

# waitUntil 超时时间（秒）
#!define EVT_26_WAITUNTIL_TIMEOUT 3

#!define MARTYR_GOAL_MAX max(EVT_26_GOAL_MIN, round(len(bastionPosition) * EVT_26_GOAL_MAX_FACTOR))

# --- ID 27: 多动症 (触发回血) ---
# Duration（秒）
#!define EVT_BUFF_27_DURATION 90
# Weight（权重）
#!define EVT_BUFF_27_WEIGHT 0.7
# 冷却缩减：仅当当前冷却 > threshold 才生效
#!define EVT_27_CD_THRESHOLD 1
#!define EVT_27_CD_FACTOR 0.5

# 持续治疗 (HOT)
#!define EVT_27_HOT_DURATION 2

# HOT 每秒治疗量 = round(flat + MaxHP * factor) / divisor
#!define EVT_27_HOT_FLAT 50
#!define EVT_27_HOT_MAXHP_FACTOR 0.25
#!define EVT_27_HOT_DIVISOR 1

# 触发后等待 (秒)
#!define EVT_27_POST_WAIT 2.5

# --- ID 28: 鼓舞士气 ProMax ---
# Duration（秒）
#!define EVT_BUFF_28_DURATION 60
# Weight（权重）
#!define EVT_BUFF_28_WEIGHT 0.4
#!define EVT_28_HEAL_RADIUS 5
#!define EVT_28_HOT_DURATION 1
#!define EVT_28_HOT_FLAT 75
#!define EVT_28_HOT_MAXHP_FACTOR 0.5
#!define EVT_28_TICK_INTERVAL 1

# --- ID 29: 成吨的增益 (初始化与属性) ---
# Duration（秒）
#!define EVT_BUFF_29_DURATION 30
# Weight（权重）
#!define EVT_BUFF_29_WEIGHT 0.3
#!define EVT_29_SPEED_DELTA 50
#!define EVT_29_DMG_TAKEN_DELTA 50
#!define EVT_29_HEAL_DEALT_DELTA 50
#!define EVT_29_HEAL_RECV_DELTA 50
#!define EVT_29_SIZE_HEALTH_SCALE 1.5

# --- ID 30: F5 (循环刷新) ---
# Duration（秒）
#!define EVT_BUFF_30_DURATION 60
# Weight（权重）
#!define EVT_BUFF_30_WEIGHT 0.25
#!define EVT_30_REFRESH_INTERVAL 5

# --- ID 31: 治疗光塔 ProMax (全图奶) ---
# Duration（秒）
#!define EVT_BUFF_31_DURATION 90
# Weight（权重）
#!define EVT_BUFF_31_WEIGHT 0.1
#!define EVT_31_HOT_DURATION 2
#!define EVT_31_HEAL_FLAT 50
#!define EVT_31_HEAL_MAXHP_FACTOR 0.75

# --- ID 32: 超级变换形态 ---
# Duration（秒）
#!define EVT_BUFF_32_DURATION 30
# Weight（权重）
#!define EVT_BUFF_32_WEIGHT 1.6
#!define EVT_32_HP_FLAT 50
#!define EVT_32_HP_MAXHP_FACTOR 0.1
#!define EVT_32_OVERHEALTH_DURATION 5
#!define EVT_32_TRIGGER_GCD 0.1

# --- ID 33: 向我开炮 ---
# Duration（秒）
#!define EVT_BUFF_33_DURATION 45
# Weight（权重）
#!define EVT_BUFF_33_WEIGHT 1.4
#!define EVT_33_DMG_TAKEN -50
#!define EVT_33_ARMOR_AMOUNT 350
#!define EVT_33_TARGET_WEIGHT 999

# --- ID 34: 坚韧 ---
# Duration（秒）
#!define EVT_BUFF_34_DURATION 120
# Weight（权重）
#!define EVT_BUFF_34_WEIGHT 1.2
#!define EVT_34_TRIGGER_HP_PERCENT 0.4
#!define EVT_34_HEAL_DURATION 1.25
#!define EVT_34_HEAL_MAXHP_FACTOR 0.6
#!define EVT_34_TRIGGER_COOLDOWN 5
#!define EVT_34_HEAL_PER_SEC_MAXHP_FACTOR (EVT_34_HEAL_MAXHP_FACTOR / EVT_34_HEAL_DURATION)

#!define EVT_BUFF_35_DURATION 5
#!define EVT_BUFF_35_WEIGHT 0.6
#!define EVT_35_DMG_TAKEN_DELTA 10
#!define EVT_35_SPEED_DELTA 20
#!define EVT_35_HP_LAYER 6

# -----------------------------------------------------------------------------
# DEBUFF 事件（按ID排序）
# -----------------------------------------------------------------------------

# --- ID 0 (Debuff): 重力异常 ---
# Duration（秒）
#!define EVT_DEBUFF_0_DURATION 20
# Weight（权重）
#!define EVT_DEBUFF_0_WEIGHT 1.4
#!define EVT_DEBUFF_0_SPEED -40
# 100 + 70
#!define EVT_DEBUFF_0_GRAVITY 70

# --- ID 1 (Debuff): 电磁脉冲 ---
# Duration（秒）
# 本事件的 Duration 遵循 HACK_DURATION
#!define EVT_DEBUFF_1_HACK_DURATION 5
# Weight（权重）
#!define EVT_DEBUFF_1_WEIGHT 1.5

# --- ID 2 (Debuff): 吸血鬼 ---
# Duration（秒）
#!define EVT_DEBUFF_2_DURATION 30
# Weight（权重）
#!define EVT_DEBUFF_2_WEIGHT 0.8
#!define EVT_DEBUFF_2_DMG_PERCENT 0.1

# --- ID 3 (Debuff): 易损 ---
# Duration（秒）
#!define EVT_DEBUFF_3_DURATION 25
# Weight（权重）
#!define EVT_DEBUFF_3_WEIGHT 1.2
#!define EVT_DEBUFF_3_DMG_TAKEN 35

# --- ID 4 (Debuff): 限速40 ---
# Duration（秒）
#!define EVT_DEBUFF_4_DURATION 25
# Weight（权重）
#!define EVT_DEBUFF_4_WEIGHT 1.1
# 燃烧状态持续时间
#!define EVT_DEBUFF_4_BURN_DURATION 3

# DOT 伤害基数
#!define EVT_DEBUFF_4_DMG_BASE 25

# DOT 伤害百分比系数 (最大生命值)
#!define EVT_DEBUFF_4_DMG_PERCENT 0.075

# 检测周期 (秒)
#!define EVT_DEBUFF_4_CHECK_INTERVAL 1

# --- ID 5 (Debuff): 引力异常 ---
# Duration（秒）
#!define EVT_DEBUFF_5_DURATION 20
# Weight（权重）
#!define EVT_DEBUFF_5_WEIGHT 1.2
# 减速数值
#!define EVT_DEBUFF_5_SPEED_REDUCTION 25

# 牵引力度 (空中)
#!define EVT_DEBUFF_5_PULL_AIR 0.425

# 牵引力度 (地面)
#!define EVT_DEBUFF_5_PULL_GROUND 0.825

# 视觉特效
#!define EVT_DEBUFF_5_EFFECT Effect.SIGMA_GRAVITIC_FLUX_TARGET
#!define EVT_DEBUFF_5_SOUND Effect.SIGMA_GRAVITIC_FLUX_TARGET_SOUND

# --- ID 6 (Debuff): 骨质疏松 ---
# Duration（秒）
#!define EVT_DEBUFF_6_DURATION 30
# Weight（权重）
#!define EVT_DEBUFF_6_WEIGHT 1.2
# 每秒减少的速度 (%)
#!define EVT_DEBUFF_6_SPEED_DEC_PER_SEC 5

# 最大减速上限 (%)
#!define EVT_DEBUFF_6_MAX_SPEED_DEC -50

# --- ID 7 (Debuff): 电磁脉冲 ProMax ---
# Duration（秒）
#!define EVT_DEBUFF_7_DURATION 8
# Weight（权重）
#!define EVT_DEBUFF_7_WEIGHT 1.3
# 爆炸半径 (米)
#!define EVT_DEBUFF_7_RADIUS 75

# 基础黑客入侵持续时间 (秒)
#!define EVT_DEBUFF_7_HACK_BASE_DURATION 8

# 距离衰减系数 (每米减少的黑客时间)
#!define EVT_DEBUFF_7_DIST_FACTOR 0.08

# 黑客生效的最小阈值 (秒，低于此值不显示特效)
#!define EVT_DEBUFF_7_MIN_HACK_THRESHOLD 0.9

# EMP 视觉特效
#!define EVT_DEBUFF_7_EXPLOSION_EFFECT DynamicEffect.SOMBRA_EMP_EXPLOSION_EFFECT
#!define EVT_DEBUFF_7_HACK_EFFECT DynamicEffect.SOMBRA_HACKED_STARTING

# --- ID 8 (Debuff): 能量泄漏 ---
# Duration（秒）
#!define EVT_DEBUFF_8_DURATION 30
# Weight（权重）
#!define EVT_DEBUFF_8_WEIGHT 1.1
# 每次使用技能扣除的最大生命值百分比
#!define EVT_DEBUFF_8_DMG_PERCENT 0.25

# 触发间隔 (防止瞬发技能多次触发)
#!define EVT_DEBUFF_8_COOLDOWN 1

# --- ID 9 (Debuff): 生命在于运动 ---
# Duration（秒）
#!define EVT_DEBUFF_9_DURATION 45
# Weight（权重）
#!define EVT_DEBUFF_9_WEIGHT 1.3
# 移动时的伤害系数 (最大生命值百分比)
#!define EVT_DEBUFF_9_DMG_MOVING 0.05

# 静止时的伤害系数 (最大生命值百分比)
#!define EVT_DEBUFF_9_DMG_STILL 0.02

# 燃烧状态时长
#!define EVT_DEBUFF_9_BURN_DURATION 1

# 循环间隔 (秒)
#!define EVT_DEBUFF_9_TICK_RATE 0.96

# --- ID 10 (Debuff): 有难同当 (伤害分摊) ---
# Duration（秒）
#!define EVT_DEBUFF_10_DURATION 30
# Weight（权重）
#!define EVT_DEBUFF_10_WEIGHT 1.3
# 伤害扩散半径 (米)
#!define EVT_DEBUFF_10_RADIUS 20

# 扩散伤害系数 (承受原始伤害的百分比)
#!define EVT_DEBUFF_10_DMG_FACTOR 0.75

# 视觉特效
#!define EVT_DEBUFF_10_EFFECT Effect.TORBJORN_OVERLOADING

# --- ID 11 (Debuff): 狂欢盛宴 (阵亡惩罚) ---
# Duration（秒）
#!define EVT_DEBUFF_11_DURATION 45
# Weight（权重）
#!define EVT_DEBUFF_11_WEIGHT 0.8
# 增加的狂暴时间 (秒)
#!define EVT_DEBUFF_11_BERSERK_ADD 10

# 冷却时间/触发间隔 (秒)
#!define EVT_DEBUFF_11_COOLDOWN 5

# --- ID 12 (Debuff): 无能的丈夫/妻子 ---
# Duration（秒）
#!define EVT_DEBUFF_12_DURATION 2
# Weight（权重）
#!define EVT_DEBUFF_12_WEIGHT 1.0
# 影响半径
#!define EVT_DEBUFF_12_RADIUS 45

# 击倒持续时间
#!define EVT_DEBUFF_12_KNOCKDOWN_DURATION 2

# --- ID 13 (Debuff): 重伤 ---
# Duration（秒）
#!define EVT_DEBUFF_13_DURATION 45
# Weight（权重）
#!define EVT_DEBUFF_13_WEIGHT 1.5
# 治疗输出减少量 (%)
#!define EVT_DEBUFF_13_HEAL_DEALT_RED -80

# 治疗接收减少量 (%)
#!define EVT_DEBUFF_13_HEAL_RECV_RED -80

# 视觉特效
#!define EVT_DEBUFF_13_EFFECT Effect.ANA_BIOTIC_GRENADE_NO_HEALING
#!define EVT_DEBUFF_13_SOUND DynamicEffect.ANA_BIOTIC_GRENAGE_NO_HEALING_SOUND

# --- ID 14 (Debuff): 减半 ---
# Duration（秒）
#!define EVT_DEBUFF_14_DURATION 30
# Weight（权重）
#!define EVT_DEBUFF_14_WEIGHT 1.2
# 斩杀阈值 (5%)
#!define EVT_DEBUFF_14_EXECUTE_THRESHOLD 0.05

# 扣血比例 (当前血量的 50%)
#!define EVT_DEBUFF_14_DAMAGE_PERCENT 0.5

# 触发间隔 (秒)
#!define EVT_DEBUFF_14_INTERVAL 3

# 斩杀特效
#!define EVT_DEBUFF_14_EXECUTE_EFFECT DynamicEffect.DVA_SELF_DESTRUCT_EXPLOSION

# 扣血特效
#!define EVT_DEBUFF_14_DAMAGE_EFFECT DynamicEffect.ZARYA_PARTICLE_CANNON_EXPLOSION

# --- ID 15 (Debuff): 舍己为人 ---
# Duration（秒）
#!define EVT_DEBUFF_15_DURATION 5
# Weight（权重）
#!define EVT_DEBUFF_15_WEIGHT 0.4
# 触发事件所需的最低最大生命值 (避免脆皮触发后直接暴毙)
#!define EVT_DEBUFF_15_MIN_MAX_HP 125

# 转移给每个队友的心之钢层数
#!define EVT_DEBUFF_15_STACKS_GIVE 1

# 自身扣除的心之钢层数系数 (每有一个队友扣除多少层)
#!define EVT_DEBUFF_15_STACKS_TAKE 1

# 视觉特效
#!define EVT_DEBUFF_15_EFFECT_TAKE DynamicEffect.ORISA_HALT_IMPLOSION
#!define EVT_DEBUFF_15_EFFECT_GIVE DynamicEffect.GOOD_PICKUP_EFFECT

# --- ID 16 (Debuff): 保持距离 (易伤光环) ---
# Duration（秒）
#!define EVT_DEBUFF_16_DURATION 45
# Weight（权重）
#!define EVT_DEBUFF_16_WEIGHT 1.1
#!define EVT_DEBUFF_16_RADIUS 25

# 易伤计算：vul = clamp( (START_DIST - dist) * FACTOR, 0, MAX )
#!define EVT_DEBUFF_16_START_DIST 25
#!define EVT_DEBUFF_16_FACTOR 2
#!define EVT_DEBUFF_16_MAX 50

# 循环间隔 (秒)
#!define EVT_DEBUFF_16_INTERVAL 1

# --- ID 17 (Debuff): （未写事件块） ---
# Duration（秒）
#!define EVT_DEBUFF_17_DURATION 25
# Weight（权重）
#!define EVT_DEBUFF_17_WEIGHT 1.1

# --- ID 18 (Debuff): （未写事件块） ---
# Duration（秒）
#!define EVT_DEBUFF_18_DURATION 25
# Weight（权重）
#!define EVT_DEBUFF_18_WEIGHT 0.85

# --- ID 19 (Debuff): （未写事件块） ---
# Duration（秒）
#!define EVT_DEBUFF_19_DURATION 45
# Weight（权重）
#!define EVT_DEBUFF_19_WEIGHT 0.7

# --- ID 20 (Debuff): 吸血鬼 (按需吸血) ---
# Duration（秒）
#!define EVT_DEBUFF_20_DURATION 60
# Weight（权重）
#!define EVT_DEBUFF_20_WEIGHT 0.6
#!define EVT_DEBUFF_20_RADIUS 45

# 每个目标受到的伤害
#!define EVT_DEBUFF_20_DAMAGE_PER_TARGET 25

# 自身治疗量 = 目标数量 * HEAL_PER_TARGET
#!define EVT_DEBUFF_20_HEAL_PER_TARGET 25

# 循环间隔 (秒)
#!define EVT_DEBUFF_20_INTERVAL 1

# --- ID 21 (Debuff): （未写事件块） ---
# Duration（秒）
#!define EVT_DEBUFF_21_DURATION 30
# Weight（权重）
#!define EVT_DEBUFF_21_WEIGHT 0.2

# --- ID 22 (Debuff): 登月火箭 ---
# Duration（秒）
#!define EVT_DEBUFF_22_DURATION 5
# Weight（权重）
#!define EVT_DEBUFF_22_WEIGHT 1.2
#!define EVT_DEBUFF_22_GRAVITY 5
#!define EVT_DEBUFF_22_UPWARD_IMPULSE 85


# -----------------------------------------------------------------------------
# MECH 事件（按ID排序）
# -----------------------------------------------------------------------------

# --- ID 0 (Mech/Special): 极限挑战 ---
# Duration（秒）
#!define EVT_MECH_0_DURATION 60
# Weight（权重）
#!define EVT_MECH_0_WEIGHT 0.8
# 锁定的生命值比例 (30%)
#!define EVT_MECH_0_HP_PERCENT 0.2

# 获得的伤害减免 (%) -99% 几乎无敌
#!define EVT_MECH_0_DMG_TAKEN -99

# 禁疗数值 (绝对禁止)
#!define EVT_MECH_0_HEAL_BAN -1000

# 视觉特效
#!define EVT_MECH_0_EFFECT Effect.ANA_BIOTIC_GRENADE_NO_HEALING
#!define EVT_MECH_0_SOUND DynamicEffect.ANA_BIOTIC_GRENAGE_NO_HEALING_SOUND

# --- ID 1 (Mech): 纳米战甲 ---
# Duration（秒）
#!define EVT_MECH_1_DURATION 15
# Weight（权重）
#!define EVT_MECH_1_WEIGHT 1.2
# 额外生命值倍率 (8倍)
#!define EVT_MECH_1_HP_MULTIPLIER 5

# 速度惩罚 (%)
#!define EVT_MECH_1_SPEED_PENALTY -20

# 生命池索引
#!define EVT_MECH_1_POOL_IDX 0

# --- ID 2 (Mech): 赌徒 ---
# Duration（秒）
#!define EVT_MECH_2_DURATION 15
# Weight（权重）
#!define EVT_MECH_2_WEIGHT 1.4
# 获胜概率 (%)
#!define EVT_MECH_2_WIN_RATE 50

# 单次赌注 (心之钢层数 / HP百分比)
#!define EVT_MECH_2_STAKE 5

# 赌徒连胜计数上限 (用于HUD显示赌王称号等)
#!define EVT_MECH_2_WIN_STREAK_CAP 5

# --- ID 3 (Mech): 有点松弛 ---
# Duration（秒）
#!define EVT_MECH_3_DURATION 45
# Weight（权重）
#!define EVT_MECH_3_WEIGHT 0
# 烟雾/云雾效果半径
#!define EVT_MECH_3_CLOUD_RADIUS 12

# 烟雾生成间隔 (秒)
#!define EVT_MECH_3_SPAWN_INTERVAL 1

# 视觉特效 (自身火焰)
#!define EVT_MECH_3_SELF_EFFECT Effect.WRECKING_BALL_PILEDRIVER_FIRE

# 视觉特效 (干扰烟雾)
#!define EVT_MECH_3_CLOUD_EFFECT Effect.CLOUD

# --- ID 4 (Mech): 迷你形态 ---
# Duration（秒）
#!define EVT_MECH_4_DURATION 60
# Weight（权重）
#!define EVT_MECH_4_WEIGHT 1.2
# 生命倍率 (用于 setPlayerHP 计算)
#!define EVT_MECH_4_HP_SCALE 0.5

# 模型缩放比例
#!define EVT_MECH_4_MODEL_SCALE 0.4

# 语音语调 (尖细)
#!define EVT_MECH_4_VOICE_PITCH 1.5

# 移动速度加成 (%)
#!define EVT_MECH_4_SPEED_BOOST 25

# --- ID 5 (Mech): 悄悄地进村 ---
# Duration（秒）
#!define EVT_MECH_5_DURATION 30
# Weight（权重）
#!define EVT_MECH_5_WEIGHT 1.3
# 蹲下时的移速惩罚 (%)
#!define EVT_MECH_5_SPEED_PENALTY 25

# --- ID 6 (Mech): 紧急避障 ---
# Duration（秒）
#!define EVT_MECH_6_DURATION 45
# Weight（权重）
#!define EVT_MECH_6_WEIGHT 1.2
# 受伤触发的加速 (%)
#!define EVT_MECH_6_SPEED_BOOST 30

# 加速持续时间 (秒)
#!define EVT_MECH_6_SPEED_DURATION 3

# --- ID 7 (Mech): 刹车失灵 ---
# Duration（秒）
#!define EVT_MECH_7_DURATION 45
# Weight（权重）
#!define EVT_MECH_7_WEIGHT 0.9
# 最大加速上限 (%)
#!define EVT_MECH_7_MAX_SPEED 75

# 加速步长 (%)
#!define EVT_MECH_7_SPEED_INC 5

# 最大减伤上限 (%)
#!define EVT_MECH_7_MAX_DMG_TAKEN -50

# 减伤步长 (%)
#!define EVT_MECH_7_DMG_TAKEN_INC 5

# 更新间隔 (秒)
#!define EVT_MECH_7_INTERVAL 1

# --- ID 8 (Mech): 屁动力 ---
# Duration（秒）
#!define EVT_MECH_8_DURATION 30
# Weight（权重）
#!define EVT_MECH_8_WEIGHT 1.0
# 喷射造成的减伤 (%)
#!define EVT_MECH_8_DMG_TAKEN -40

# 喷射力度
#!define EVT_MECH_8_IMPULSE 15

# 视觉特效
#!define EVT_MECH_8_EFFECT Effect.ANA_NANO_BOOSTED

# --- ID 9 (Mech): 赌徒：竞速挑战 ---
# Duration（秒）
#!define EVT_MECH_9_DURATION 15
# Weight（权重）
#!define EVT_MECH_9_WEIGHT 0.8
# 触发赌博的血量惩罚 (当前生命值变为 50% 最大生命值)
#!define EVT_MECH_9_HP_PENALTY 0.5

# 普通胜利概率阈值 (0-49) => 50%
#!define EVT_MECH_9_PROB_WIN_NORMAL 49

# 普通失败概率阈值 (50-98) => 49%
#!define EVT_MECH_9_PROB_LOSE_NORMAL 98

# 稀有胜利概率阈值 (99) => 1%
#!define EVT_MECH_9_PROB_WIN_RARE 99
# (剩余 100 就是稀有失败)

# 普通奖励/惩罚数值 (移速 %)
#!define EVT_MECH_9_VAL_NORMAL 5

# 稀有奖励/惩罚数值 (移速 %)
#!define EVT_MECH_9_VAL_RARE 12

# --- ID 10 (Mech/Special): 作弊：我要验牌 ---
# Duration（秒）
#!define EVT_MECH_10_DURATION 15
# Weight（权重）
#!define EVT_MECH_10_WEIGHT 1.2
#!define EVT_MECH_10_HEART_STEEL_COST 2
#!define EVT_MECH_10_FORCE_ROLL 20

# --- ID 11 (Mech/Special): 作弊：回溯 ---
# Duration（秒）
#!define EVT_MECH_11_DURATION 30
# Weight（权重）
#!define EVT_MECH_11_WEIGHT 1
#!define EVT_MECH_11_RECORD_INTERVAL 3
#!define EVT_MECH_11_TRIGGER_HP_COST 0.1

# --- ID 12 (Mech/Special): 赌徒：短期投资 (交易) ---
# Duration（秒）
#!define EVT_MECH_12_DURATION 15
# Weight（权重）
#!define EVT_MECH_12_WEIGHT 1.1

# 胜率阈值：random.randint(0,99) < 阈值 则胜
#!define EVT_MECH_12_WIN_CHANCE 75

# 胜利奖励：心之钢层数
#!define EVT_MECH_12_REWARD_STACKS 4

# 强制下次投掷/强制次数
#!define EVT_MECH_12_FORCE_ROLL 50
#!define EVT_MECH_12_FORCE_COUNT 2

# 提示文本：合约生效的“未来 N 个事件”
#!define EVT_MECH_12_CONTRACT_EVENTS 3

# --- ID 13 (Mech): （未写事件块） ---
# Duration（秒）
#!define EVT_MECH_13_DURATION 5
# Weight（权重）
#!define EVT_MECH_13_WEIGHT 0.8

# --- ID 14 (Mech): （跳过） ---
# Duration（秒）
#!define EVT_MECH_14_DURATION 30
# Weight（权重）
#!define EVT_MECH_14_WEIGHT 0.5

# --- ID 15 (Mech/Special): 俄罗斯方块 (变大复活) ---
# Duration（秒）
#!define EVT_MECH_15_DURATION 90
# Weight（权重）
#!define EVT_MECH_15_WEIGHT 0.6

# 复活等待时间 (秒)
#!define EVT_MECH_15_RESURRECT_DELAY 2

# 体型缩放：scale = 1 + step * eventSize
#!define EVT_MECH_15_SIZE_STEP 0.05

# 语音音高：pitch = max(minPitch, 1 - step * eventSize)
#!define EVT_MECH_15_PITCH_STEP 0.05
#!define EVT_MECH_15_PITCH_MIN 0.2

# 额外生命倍率步长（用于 sizeHealth）
#!define EVT_MECH_15_SIZE_HEALTH_STEP 0.05

# --- ID 16 (Mech/Special): 俄罗斯套娃 (变小复活) ---
# Duration（秒）
#!define EVT_MECH_16_DURATION 90
# Weight（权重）
#!define EVT_MECH_16_WEIGHT 0.6

# 复活等待时间 (秒)
#!define EVT_MECH_16_RESURRECT_DELAY 2

# 体型缩放：scale = max(minScale, 1 - step * eventSize)
#!define EVT_MECH_16_SIZE_STEP 0.05
#!define EVT_MECH_16_SIZE_MIN 0.2

# 语音音高：pitch = max(minPitch, 1 + step * eventSize)
#!define EVT_MECH_16_PITCH_STEP 0.05
#!define EVT_MECH_16_PITCH_MIN 1.8

# 死亡后获得的移速加成（叠加到 mod_speed_event）
#!define EVT_MECH_16_SPEED_STEP 5

# --- ID 17 (Mech/Special): 作弊：0CD (血量换CD) ---
# Duration（秒）
#!define EVT_MECH_17_DURATION 15
# Weight（权重）
#!define EVT_MECH_17_WEIGHT 0.8

# waitUntil 超时 (秒)
#!define EVT_MECH_17_WAITUNTIL_TIMEOUT 2

# 触发代价：自伤 = MaxHP * percent
#!define EVT_MECH_17_HP_COST_PERCENT 0.25

# 循环间隔 (秒)
#!define EVT_MECH_17_INTERVAL 0.25

# --- ID 18 (Mech/Special): 赌徒：长期投资 (豪赌) ---
# Duration（秒）
#!define EVT_MECH_18_DURATION 15
# Weight（权重）
#!define EVT_MECH_18_WEIGHT 0.4

# 胜率阈值：random.randint(0,99) < 阈值 则胜
#!define EVT_MECH_18_WIN_CHANCE 33

# 胜利奖励：心之钢层数
#!define EVT_MECH_18_REWARD_STACKS 20

# 强制下次投掷/强制次数
#!define EVT_MECH_18_FORCE_ROLL 50
#!define EVT_MECH_18_FORCE_COUNT 4

# 提示文本：合约生效的“未来 N 个事件”
#!define EVT_MECH_18_CONTRACT_EVENTS 5

# --- ID 19 (Mech/Special): 瓦尔基里降临 ---
# Duration（秒）
#!define EVT_MECH_19_DURATION 120
# Weight（权重）
#!define EVT_MECH_19_WEIGHT 0.4

# 体型血量倍率（用于 sizeHealth）
#!define EVT_MECH_19_SIZE_HEALTH 10

# --- ID 19 (Mech/Special): 瓦尔基里降临 (受击充能/开大回血) ---

# 受击时增加的大招充能
#!define EVT_MECH_19_ULT_CHARGE_GAIN 10

# 受击充能触发间隔 (秒)
#!define EVT_MECH_19_ULT_CHARGE_INTERVAL 0.5

# eventTargetHP 平滑系数
#!define EVT_MECH_19_HEAL_SMOOTHING 0.85

# 每跳回血：MaxHP * percent
#!define EVT_MECH_19_HEAL_TICK_PERCENT 0.04

# 回血 tick 间隔 (秒)
#!define EVT_MECH_19_HEAL_TICK_INTERVAL 0.2

# --- ID 20 (Mech/Special): 三位一体 (SSR) ---
# Duration（秒）
#!define EVT_MECH_20_DURATION 120
# Weight（权重）
#!define EVT_MECH_20_WEIGHT 0.4

# 减伤上限 (%)
#!define EVT_MECH_20_DMG_REDUCE_CAP 85

# 减伤成长：reduce = min(cap, MaxHP / divisor)
#!define EVT_MECH_20_DMG_REDUCE_DIVISOR 25

# 移速系数：speed = (-mod_dmg_taken) * factor
#!define EVT_MECH_20_SPEED_FACTOR 2.5

# 心之钢每跳增加量
#!define EVT_MECH_20_HEART_STEEL_PER_TICK 0.25

# 循环间隔 (秒)
#!define EVT_MECH_20_INTERVAL 1
