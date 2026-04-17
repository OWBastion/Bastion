# 核心信息
#!define STR_MODE_NAME "Bastion Escape 3"
#!define STR_MODE_CODE "Code [SVMQK]"

# 描述文本 - 标题与状态
#!define STR_DESC_EVENT_STATUS "Random Events 3.0 is Live!"
#!define STR_DESC_GAMEPLAY_TAG "!!!Escape with All Heroes!!!"

# 描述文本 - 元数据
#!define STR_DESC_LAST_UPDATE_PREFIX "Last Updated: "
# 英文版通常不放QQ群，可以改为Discord或者仅保留网站，这里做直译备用
#!define STR_DESC_CONTACT_INFO "Discord: 445152554" 
#!define STR_DESC_ORIGINAL_CREDIT "Based on [OW2 BASTION ESCAPE]"

#!define STR_LICENSE_TITLE "Disclaimer: This code is for non-commercial use only"
#!define STR_LICENSE_PERMIT "You may modify and republish this mode, provided you credit the original author and include the original mode code in the description."

# Settings Categories
#!define STR_SETTING_CAT_GAME "1. Game"
#!define STR_SETTING_CAT_DLC "2. DLC Content"

# Setting Names
#!define STR_SETTING_DLC_VISHKAR "Random Events Expansion Pack"
#!define STR_SETTING_REBOOT_TIME "Auto-Restart Interval (Hours)"
#!define STR_SETTING_DEBUG "Debug Mode"
#!define STR_SETTING_BASTION_TARGET "AI Bastion Targeting Rule"
#!define STR_SETTING_DIFFICULTY "Difficulty"
#!define STR_SETTING_ULT_CHARGE "Global Ultimate Charge"
#!define STR_SETTING_BASTION_GRENADE "AI Bastion Uses Grenade (Ignore Difficulty)"
#!define STR_SETTING_CLASSIC_MAP_VARIANT "Classic Map Variant"

# Enum Options
#!define STR_OPT_TARGET_0 "Auto"
#!define STR_OPT_TARGET_1 "Closest Priority"
#!define STR_OPT_TARGET_2 "Low HP Priority"
#!define STR_ENUM_TARGET_OPTIONS ["Auto", "Closest Priority", "Low HP Priority"]
#!define STR_OPT_DIFF_0 "Easy"
#!define STR_OPT_DIFF_1 "Normal"
#!define STR_OPT_DIFF_2 "Hard"
#!define STR_OPT_DIFF_3 "Expert"
#!define STR_OPT_DIFF_4 "Legendary"
#!define STR_OPT_DIFF_5 "Hell: No Hero Skips"
#!define STR_ENUM_DIFFICULTY_OPTIONS ["Easy", "Normal", "Hard", "Expert", "Legendary", "Hell: No Hero Skips"]
#!define STR_OPT_CLASSIC_MAP_VARIANT_0 "Off"
#!define STR_OPT_CLASSIC_MAP_VARIANT_1 "Circuit Royal"
#!define STR_ENUM_CLASSIC_MAP_VARIANT_OPTIONS ["Off", "Circuit Royal"]

# ------------------------------------------------
# Global Events
# ------------------------------------------------
#!define STR_EVT_GLOBAL_0_TITLE "Unstoppable"
#!define STR_EVT_GLOBAL_0_DESC "Bastions are immune to CC."
#!define STR_EVT_GLOBAL_1_TITLE "Supercomputer Evolution"
#!define STR_EVT_GLOBAL_1_DESC "Bastion grenades stun players for 1.5s."
#!define STR_EVT_GLOBAL_2_TITLE "Mission: Survival"
#!define STR_EVT_GLOBAL_2_DESC "Total team deaths must not exceed 10."
#!define STR_EVT_GLOBAL_3_TITLE "Mission: Capture"
#!define STR_EVT_GLOBAL_3_DESC "Have 4 players on the objective when time expires."
#!define STR_EVT_GLOBAL_4_TITLE "Mission: Race"
#!define STR_EVT_GLOBAL_4_DESC "50% of players must reach halfway point."

# ------------------------------------------------
# Buff Events
# ------------------------------------------------
#!define STR_EVT_BUFF_0_TITLE "Olivia's Gift"
#!define STR_EVT_BUFF_0_DESC "Aloha!"
#!define STR_EVT_BUFF_1_TITLE "Wind Blessing"
#!define STR_EVT_BUFF_1_DESC "Movement speed increased by 50%."
#!define STR_EVT_BUFF_2_TITLE "Ironclad Defense"
#!define STR_EVT_BUFF_2_DESC "Gain 1500 temporary armor and 25% damage reduction."
#!define STR_EVT_BUFF_3_TITLE "Adrenaline"
#!define STR_EVT_BUFF_3_DESC "Gain 50% extra damage reduction.\nAlso gain +50% healing boost."
#!define STR_EVT_BUFF_4_TITLE "Fountain of Life"
#!define STR_EVT_BUFF_4_DESC "Regenerate 15% max HP per second."
#!define STR_EVT_BUFF_5_TITLE "Fan Attack"
#!define STR_EVT_BUFF_5_DESC "While targeted by Bastions, gain {0} + {1}% max HP as overhealth and {2}% bonus movement speed."
#!define STR_EVT_BUFF_6_TITLE "Power Walk"
#!define STR_EVT_BUFF_6_DESC "Moving for 1s grants 3% stacking movement speed."
#!define STR_EVT_BUFF_7_TITLE "Flesh Regeneration"
#!define STR_EVT_BUFF_7_DESC "Gain 50 + 25% max HP as overhealth, refreshes every 4s."
#!define STR_EVT_BUFF_8_TITLE "Heartsteel"
#!define STR_EVT_BUFF_8_DESC "Permanently gain 0.75% max HP upon death."
#!define STR_EVT_BUFF_9_TITLE "Death Delay"
#!define STR_EVT_BUFF_9_DESC "Fatal damage is delayed until the event ends."
#!define STR_EVT_BUFF_10_TITLE "I Am With You"
#!define STR_EVT_BUFF_10_DESC "Hold {0} to attach to a teammate.\nThey gain 5% of your max HP as damage reduction.\nYou gain 25% healing dealt and heal them."
#!define STR_EVT_BUFF_11_TITLE "Konami Code"
#!define STR_EVT_BUFF_11_DESC "If you die, respawn at your position 5s ago and end the event."
#!define STR_EVT_BUFF_12_TITLE "Vishkar Photon Shield"
#!define STR_EVT_BUFF_12_DESC "Everyone gains a recoverable shield\nequal to 20% of max HP.\nShield lasts until death or event end."
#!define STR_EVT_BUFF_13_TITLE "Rally to Me"
#!define STR_EVT_BUFF_13_DESC "You and nearby teammates gain 2.5s damage immunity every 5s."
#!define STR_EVT_BUFF_14_TITLE "Will to Win"
#!define STR_EVT_BUFF_14_DESC "Triggered below 30% HP: 5s damage immunity, cleanse debuffs, restore lost HP."
#!define STR_EVT_BUFF_15_TITLE "Mission: Marathon"
#!define STR_EVT_BUFF_15_DESC "Move continuously for {0}s to permanently gain {1}% speed."
#!define STR_EVT_BUFF_16_TITLE "Heartsteel Pro"
#!define STR_EVT_BUFF_16_DESC "Gain max HP based on Heartsteel stacks (Stacks x 2)."
#!define STR_EVT_BUFF_17_TITLE "Stat Check"
#!define STR_EVT_BUFF_17_DESC "Gain 500% healing dealt and received."
#!define STR_EVT_BUFF_18_TITLE "Q to Win"
#!define STR_EVT_BUFF_18_DESC "Moving charges Ultimate. Using Ultimate grants 75% damage reduction."

# ------------------------------------------------
# Debuff Events
# ------------------------------------------------
#!define STR_EVT_DEBUFF_0_TITLE "Gravity Anomaly"
#!define STR_EVT_DEBUFF_0_DESC "Speed reduced by 50%, jump height reduced by 70%."
#!define STR_EVT_DEBUFF_1_TITLE "EMP"
#!define STR_EVT_DEBUFF_1_DESC "Hacked. Abilities disabled."
#!define STR_EVT_DEBUFF_2_TITLE "Sacrifice"
#!define STR_EVT_DEBUFF_2_DESC "When teammates use abilities, you lose 10% of your max HP."
#!define STR_EVT_DEBUFF_3_TITLE "Vulnerable"
#!define STR_EVT_DEBUFF_3_DESC "Damage taken increased by 25%."
#!define STR_EVT_DEBUFF_4_TITLE "Speed Limit 40"
#!define STR_EVT_DEBUFF_4_DESC "Moving drains 25 + 7.5% max HP per second."
#!define STR_EVT_DEBUFF_5_TITLE "Gravitational Pull"
#!define STR_EVT_DEBUFF_5_DESC "Pulled towards nearest Bastion. Speed reduced by 25%."
#!define STR_EVT_DEBUFF_6_TITLE "Osteoporosis"
#!define STR_EVT_DEBUFF_6_DESC "Speed decreases over time, up to 50%."
#!define STR_EVT_DEBUFF_7_TITLE "EMP ProMax"
#!define STR_EVT_DEBUFF_7_DESC "Hacked. Spreads to teammates within 75m."
#!define STR_EVT_DEBUFF_8_TITLE "Energy Leak"
#!define STR_EVT_DEBUFF_8_DESC "Using abilities costs 25% HP."
#!define STR_EVT_DEBUFF_9_TITLE "Shared Pain"
#!define STR_EVT_DEBUFF_9_DESC "75% of damage taken spreads to allies within 15m."
#!define STR_EVT_DEBUFF_10_TITLE "Carnival Feast"
#!define STR_EVT_DEBUFF_10_DESC "Dying during the feast enrages Bastions for 10s."
#!define STR_EVT_DEBUFF_11_TITLE "Incompetent Spouse"
#!define STR_EVT_DEBUFF_11_DESC "Nearby allies are knocked down for 2s."
#!define STR_EVT_DEBUFF_12_TITLE "Mortal Wounds"
#!define STR_EVT_DEBUFF_12_DESC "Healing dealt and received reduced by 85%."
#!define STR_EVT_DEBUFF_13_TITLE "Halved"
#!define STR_EVT_DEBUFF_13_DESC "Lose 50% current HP every 5s. Die instantly if below 5%."
#!define STR_EVT_DEBUFF_14_TITLE "Self-Sacrifice"
#!define STR_EVT_DEBUFF_14_DESC "Max HP reduced by 1% per player count. Distributed from others."

# ------------------------------------------------
# Mech Events
# ------------------------------------------------
#!define STR_EVT_MECH_0_TITLE "Extreme Challenge"
#!define STR_EVT_MECH_0_DESC "99% DR, HP locked at 30%, no healing allowed."
#!define STR_EVT_MECH_1_TITLE "Gambler"
#!define STR_EVT_MECH_1_DESC "Hold {0}: 50% chance to gain/lose 10% max HP permanently."
#!define STR_EVT_MECH_2_TITLE "Mini Form"
#!define STR_EVT_MECH_2_DESC "Size -60%, Max HP -50%, gain 25% speed."
#!define STR_EVT_MECH_3_TITLE "Sneaky Beaky"
#!define STR_EVT_MECH_3_DESC "Crouch to turn invisible. Speed -25%."
#!define STR_EVT_MECH_4_TITLE "Brake Failure"
#!define STR_EVT_MECH_4_DESC "Forced forward movement, accelerating to 175%."
#!define STR_EVT_MECH_5_TITLE "Fart Power"
#!define STR_EVT_MECH_5_DESC "Hold {0} to fly forward with 50% DR."
#!define STR_EVT_MECH_6_TITLE "Gambler: Speedrun"
#!define STR_EVT_MECH_6_DESC "Hold {0} (Costs 50% HP)\n49% chance: +/- 5% permanent speed\n2% chance: +/- 12% permanent speed"

# ------------------------------------------------
# Random Pack 4: Buffs
# ------------------------------------------------
#!define STR_EVT_BUFF_19_TITLE "Phase Rush"
#!define STR_EVT_BUFF_19_DESC "Movement abilities grant 300% speed boost."
#!define STR_EVT_BUFF_20_TITLE "Bodyguard"
#!define STR_EVT_BUFF_20_DESC "Movement abilities grant temp armor to nearby allies."
#!define STR_EVT_BUFF_21_TITLE "Mission: Martyr"
#!define STR_EVT_BUFF_21_DESC "Die to {0} different Bastions. Reward: 5% Permanent DR."
#!define STR_EVT_BUFF_22_TITLE "ADHD"
#!define STR_EVT_BUFF_22_DESC "Movement cooldowns halved. Using them heals you."
#!define STR_EVT_BUFF_23_TITLE "Inspire ProMax"
#!define STR_EVT_BUFF_23_DESC "Heals allies within 5m for 50 + 50% Max HP per second."
#!define STR_EVT_BUFF_24_TITLE "F5"
#!define STR_EVT_BUFF_24_DESC "Resets all cooldowns every 5s."
#!define STR_EVT_BUFF_25_TITLE "Healing Pylon ProMax"
#!define STR_EVT_BUFF_25_DESC "Global range. Heals team for 25 + 125% Max HP/s."
#!define STR_EVT_BUFF_26_TITLE "Super Transform Form"
#!define STR_EVT_BUFF_26_DESC "Entering alternate form grants {0} + {1} Max HP overhealth for {2}s."
#!define STR_EVT_BUFF_27_TITLE "Fire at Me"
#!define STR_EVT_BUFF_27_DESC "Gain {0} recoverable armor and {1}% damage reduction.\nBastions prioritize targeting you."
#!define STR_EVT_BUFF_29_TITLE "Magic Master"
#!define STR_EVT_BUFF_29_DESC "Become invisible while using emotes.\nGain {0}% bonus movement speed."

# ------------------------------------------------
# Random Pack 4: Debuffs
# ------------------------------------------------
#!define STR_EVT_DEBUFF_15_TITLE "Social Distancing"
#!define STR_EVT_DEBUFF_15_DESC "Taking damage increases when closer to allies."
#!define STR_EVT_DEBUFF_16_TITLE "404"
#!define STR_EVT_DEBUFF_16_DESC "Randomly disables one ability."
#!define STR_EVT_DEBUFF_17_TITLE "Chain Overload"
#!define STR_EVT_DEBUFF_17_DESC "Using an ability puts ALL abilities on cooldown."
#!define STR_EVT_DEBUFF_18_TITLE "You and Me"
#!define STR_EVT_DEBUFF_18_DESC "HP synced with the lowest HP teammate."
#!define STR_EVT_DEBUFF_20_TITLE "Moon Rocket"
#!define STR_EVT_DEBUFF_20_DESC "Randomly launches you skyward\nand scrambles your flight direction."

# ------------------------------------------------
# Random Pack 5: Debuffs
# ------------------------------------------------
#!define STR_EVT_DEBUFF_21_TITLE "Adlersbrunn's Wraith"
#!define STR_EVT_DEBUFF_21_DESC "Gain 1 curse every {0}s.\nEach curse reduces healing power by {1}%.\nHold {2}: pay {3}% max HP to remove 1 curse.\nOn end, lose {1}% permanent healing power per remaining curse."

# ------------------------------------------------
# Random Pack 4: Mechanics
# ------------------------------------------------
#!define STR_EVT_MECH_7_TITLE "Cheat: Check Cards"
#!define STR_EVT_MECH_7_DESC "Hold {0}: Lose 10% Max HP permanently. Next event guaranteed Buff."
#!define STR_EVT_MECH_8_TITLE "Gambler: Short Term"
#!define STR_EVT_MECH_8_DESC "Hold {0}: Lock 3 Debuffs.\n75% chance to gain 4 Heartsteel stacks."
#!define STR_EVT_MECH_10_TITLE "Cheat: Skip"
#!define STR_EVT_MECH_10_DESC "Hold {0}: Skip current hero (Doesn't count for challenge)."
#!define STR_EVT_MECH_11_TITLE "Matryoshka"
#!define STR_EVT_MECH_11_DESC "Respawn after 2s.\nEach respawn: -5% Size & +5% Speed."
#!define STR_EVT_MECH_12_TITLE "Gambler: Long Term"
#!define STR_EVT_MECH_12_DESC "Hold {0}: Lock 5 Debuffs.\n33% chance to gain 20 Heartsteel stacks."
#!define STR_EVT_MECH_13_TITLE "Valkyrie's Descent"
#!define STR_EVT_MECH_13_DESC "Become BOSS: 500% HP.\nNo healing received. Heal via Ultimate."
#!define STR_EVT_MECH_14_TITLE "Trinity"
#!define STR_EVT_MECH_14_DESC "100HP->4% DR, 1% DR->2.5% Speed, 100% Speed/s->1 Heartsteel."
#!define STR_EVT_MECH_15_TITLE "Gambler: Dice Maniac"
#!define STR_EVT_MECH_15_DESC "Lasts {0}s. Hold {1} for {2}s to roll.\n1: -{3} Heartsteel | 2: -{4}% Speed\n3: -{5}% DR & Healing | 4: +{4}% Speed\n5: +{3} Heartsteel | 6: +{5}% DR & Healing"
#!define STR_EVT_MECH_16_TITLE "Gambler: Heart of Steel"
#!define STR_EVT_MECH_16_DESC "Hold {0} to settle.\n{1}% chance to multiply Heartsteel stacks by {2}; {3}% chance to lose {4}% stacks (rounded up)."
#!define STR_EVT_MECH_17_TITLE "Gambler: All-in Art"
#!define STR_EVT_MECH_17_DESC "Tap {0} to bet, up to {1} times.\nEach bet is {2}% of current Heartsteel (min 1 stack).\nAt end: {3}% chance to gain total bet x{4}, otherwise lose total bet."
#!define STR_EVT_MECH_18_TITLE "Vampire"
#!define STR_EVT_MECH_18_DESC "Drain all allies for {0} + {1}% max HP per second.\nEach allied kill grants +{2}% permanent healing dealt."


# Settings Categories
#!define STR_CAT_RANDOM_PACK "Random Events Pack"
#!define STR_CAT_RANDOM_PACK_1 "Random Events Pack 1"
#!define STR_CAT_RANDOM_PACK_2 "Random Events Pack 2"
#!define STR_CAT_RANDOM_PACK_3 "Random Events Pack 3"
#!define STR_CAT_RANDOM_PACK_4 "Random Events Pack 4"
#!define STR_CAT_RANDOM_PACK_5 "Random Events Pack 5"
#!define STR_CAT_RANDOM_PACK_1_BUFF "Random Pack 1: Buffs"
#!define STR_CAT_RANDOM_PACK_2_BUFF "Random Pack 2: Buffs"
#!define STR_CAT_RANDOM_PACK_3_BUFF "Random Pack 3: Buffs"
#!define STR_CAT_RANDOM_PACK_4_BUFF "Random Pack 4: Buffs"
#!define STR_CAT_RANDOM_PACK_5_BUFF "Random Pack 5: Buffs"
#!define STR_CAT_RANDOM_PACK_1_DEBUFF "Random Pack 1: Debuffs"
#!define STR_CAT_RANDOM_PACK_2_DEBUFF "Random Pack 2: Debuffs"
#!define STR_CAT_RANDOM_PACK_3_DEBUFF "Random Pack 3: Debuffs"
#!define STR_CAT_RANDOM_PACK_4_DEBUFF "Random Pack 4: Debuffs"
#!define STR_CAT_RANDOM_PACK_5_DEBUFF "Random Pack 5: Debuffs"
#!define STR_CAT_RANDOM_PACK_1_MECH "Random Pack 1: Mechanics"
#!define STR_CAT_RANDOM_PACK_2_MECH "Random Pack 2: Mechanics"
#!define STR_CAT_RANDOM_PACK_3_MECH "Random Pack 3: Mechanics"
#!define STR_CAT_RANDOM_PACK_4_MECH "Random Pack 4: Mechanics"
#!define STR_CAT_RANDOM_PACK_5_MECH "Random Pack 5: Mechanics"
#!define STR_CAT_BUFF "Buff"
#!define STR_CAT_DEBUFF "Debuff"
#!define STR_CAT_MECH "Mechanic"

# ------------------------------------------------
# In-game Notifications
# ------------------------------------------------
# {0}=Icon, {1}=Event Name, {2}=Duration
#!define STR_MSG_EVENT_TRIGGER "  {0}  Event Triggered: {1} ({2})"

# {0}=Seconds
#!define STR_MSG_DURATION_SEC "{0}s"

#!define STR_MSG_DURATION_INSTANT "Instant"

# {0}=Icon, {1}=Description
#!define STR_MSG_EVENT_EFFECT "  {0}  Effect: {1}"
#!define STR_MSG_EVENT_ENDED "  {0} Event Ended"
#!define STR_MSG_PROGRESS_SAVED "  Your challenge progress has been saved"
#!define STR_MSG_HOST_WARNING_RESET "  If the game restarts, all progress data will be cleared"
#!define STR_MSG_HOST_ENDORSEMENT_HINT "  To keep the lobby public, ensure the host has Endorsement Level 3 or higher"
#!define STR_MSG_ANTI_CRASH_WORKING "  Anti-Crash System Active..."

# {0}=Ability Icon
#!define STR_MSG_PASSIVE_HEAL_START "  {0}  Auto-Regen Activated "

#!define STR_MSG_MERCY_NEARBY "A Mercy is nearby, waiting to resurrect..."
#!define STR_MSG_I_AM_UP "{0} I'm Up! {0} Time's Up!"

# Victory Announcement
# {0}=Player, {1}=Stats, {2}=Time
#!define STR_MSG_WIN_ANNOUNCE "Congratulations {0}! Completed with {1} in {2}!"

# Stats Details
# {0}=Deaths, {1}=Skips
#!define STR_MSG_WIN_STATS "{0} Deaths & {1} Skips"

# Time Units (Compact format looks better in English logs)
#!define STR_TIME_UNIT_HOUR "{0}h "
#!define STR_TIME_UNIT_MIN "{0}m "
#!define STR_TIME_UNIT_SEC "{0}s"
#!define STR_TIME_UNIT_ZERO_SEC "0s"

# Ending Hint
# {0}=Icon
#!define STR_MSG_WIN_HINT "  {0} You have completed the run! Join our Discord to share your clear with the community!"
# ------------------------------------------------
# System Text - Restarting
# ------------------------------------------------
# 保持原格式的换行和缩进风格
#!define STR_TEXT_HOST_RESTARTING "The host has started the game mode.\nThis will trigger the Omnic Crisis.\n\n                      Restarting..."

# ------------------------------------------------
# Robot Name Format
# ------------------------------------------------
# {0}=Index, {1}=Kills
#!define STR_BOT_NAME_FORMAT "Warden{0} Kill{1}"

# ------------------------------------------------
# System Notification - Anti-Crash
# ------------------------------------------------

# ------------------------------------------------
# HUD Text
# ------------------------------------------------
#!define STR_HUD_DEATHS "Deaths"
#!define STR_HUD_DEATHS_VAL "{0} / {1}"
#!define STR_HUD_HEROES "Hero"
#!define STR_HUD_HEROES_VAL "{0} / {1}"
#!define STR_HUD_NEXT_HERO "Next Hero"
#!define STR_HUD_ESCAPED "Escaped"
#!define STR_HUD_UNLOCKED "{0} Unlocked!"
#!define STR_HUD_CHALLENGE_COMPLETE "Challenge Complete"
#!define STR_HUD_ACHIEVEMENT_DISABLED "Achievements Disabled {0}"
#!define STR_HUD_RUN_DEATHS "Run Deaths: {0}"
#!define STR_HUD_RUN_SKIPS "Run Skips: {0}"
#!define STR_HUD_SURVIVOR "Survivor {0} "
#!define STR_HUD_GAMBLER_KING "Gambling King {0} "
#!define STR_HUD_TOTAL_TIME "Total Time: {0}"
#!define STR_HUD_SKIP_HINT "[Cheat] Use Ultimate to Skip ({0}) "
#!define STR_HUD_WELCOME_MULTI "Welcome to the 3-in-1 Map! Challenge all mini-maps to reach the end! Skip heroes after {0} deaths."
#!define STR_HUD_WELCOME_MULTI_HARD "Welcome to the 3-in-1 Map! Hero skipping is disabled on this difficulty. Good luck!"
#!define STR_HUD_WELCOME_NORMAL "Escape with all heroes! Unlocked heroes are saved for future runs. Skip heroes after {0} deaths."
#!define STR_HUD_WELCOME_NORMAL_HARD "Escape with all heroes! Hero skipping is disabled. Good luck!"
#!define STR_HUD_MAP_CLASSIC_SUFFIX "{0} Classic"
#!define STR_HUD_FOOTER_INFO "{0}Code: SVMQK | Join Discord for updates & feedback \n"
#!define STR_HUD_EVENT_GLOBAL "Global Event: {0} {1} ({2})"
#!define STR_HUD_EVENT_DESC "{0} {1}"
#!define STR_HUD_EVENT_STATS "{0}/{1}/{2} Buff/Debuff/Total"
#!define STR_HUD_RANDOM_EVENTS "[Random Events]"
#!define STR_HUD_AUTO_RESTART "Auto Restart in {0}"
#!define STR_HUD_SERVER_UPTIME "Uptime: {0}"
#!define STR_HUD_SERVER_LOAD "  Server Load: {0}"
#!define STR_HUD_VERSION "Ver"

# ------------------------------------------------
# HUD Panel Structure (4.0 New)
# ------------------------------------------------
#!define STR_HUD_PANEL_TOP "┌───────────┐"
#!define STR_HUD_PANEL_BOTTOM "└───────────┘"

# Stats Panel Content
# {0}=Deaths/Skips, {1}=Event Stats, {2}=Total Time
#!define STR_HUD_STATS_PANEL "{0}\r\n{1}\r\n{2}{3}"

# Deaths/Skips
# {0}=Deaths, {1}=Skips
#!define STR_HUD_STATS_DEATH_SKIP "Deaths/Skips \n{0}/{1}"

# Event Stats
# {0}=Buff, {1}=Debuff, {2}=Total
#!define STR_HUD_STATS_EVENT "Buff/Debuff/Total\r\n{0}/{1}/{2} "

# Random Events 4.0 Title
#!define STR_HUD_RANDOM_EVENTS_VERSION "[Random Events 5.0]"

# Event Detail Format
# {0}=Name, {1}=Time, {2}=Desc
#!define STR_HUD_EVENT_DETAIL "{0} ({1})\n{2}"

# Attribute panel
# {0}=Heartsteel stacks, {1}=Permanent movement speed bonus, {2}=Permanent damage reduction, {3}=Healing power
#!define STR_HUD_ATTR_PANEL "Heartsteel/Speed/DR/Heal%\r\n{0}/{1}/{2}/{3}%"


# ------------------------------------------------
# World Text (In-World)
# ------------------------------------------------
#!define STR_WORLD_THIRD_PERSON "      Press {0} for 3rd Person\n                    {1}"
#!define STR_WORLD_RESET_PROGRESS "Reset Progress\n                {0}"
#!define STR_WORLD_SPRINGBOARD "      Press {0} to Launch Up\n                    {1}"

# ------------------------------------------------
# Hero Specific HUD Text
# ------------------------------------------------
# D.Va
#!define STR_DVA_DISTANCE_GOAL "Distance to Goal: {0} m"

# Ana
# {0}=Skill Icon, {1}=Cooldown Seconds (30)
#!define STR_ANA_SLEEP_LIMIT_HINT "{0} Sleep Dart Limit: \n Each Bastion can only be slept once every {1}s"
# {0}=Remaining Seconds
#!define STR_ANA_SLEEP_LIMIT_BAR "Sleep Limit: {0}s Remaining "

# Zenyatta
#!define STR_ZEN_KICK_HINT "Kick ground to knockback backwards {0}\nHold Jump to levitate {1}"

# ------------------------------------------------
# Game Mechanics - Progress & Skip
# ------------------------------------------------
#!define STR_MSG_SKIP_AVAILABLE "Current Hero Skippable"
#!define STR_MSG_HOLD_RELOAD_RESET "Hold Reload to Reset"
#!define STR_MSG_RESETTING_PROGRESS "  Resetting Progress..."
#!define STR_MAP_CIRCUIT_ROYAL "Circuit Royal"
#!define STR_MSG_PLAYER_RESET_PROGRESS "  {0} reset their progress"

# ------------------------------------------------
# Menu Titles
# ------------------------------------------------
#!define STR_MENU_TITLE_DEV "Developer Mode"
#!define STR_MENU_TITLE_INGAME "In-Game Panel"
#!define STR_MENU_TITLE_DEV_PANEL "Developer Panel"
#!define STR_MENU_TITLE_WEIGHT_MANAGE "Event Weight Manager"

# ------------------------------------------------
# Menu States
# ------------------------------------------------
#!define STR_MENU_STATE_ON "ON"
#!define STR_MENU_STATE_OFF "OFF"
#!define STR_MENU_STATE_NULL "None"
#!define STR_MENU_TARGET_PLAYER "{0} ({1})"

# ------------------------------------------------
# Menu Options (Page 1)
# ------------------------------------------------
#!define STR_MENU_OPT_RESTART_EXTEND "{0}    Auto-Restart: +5 Min    \n{1}"
#!define STR_MENU_OPT_RESTART_REDUCE "{0}    Auto-Restart: -5 Min    \n{1}"
#!define STR_MENU_OPT_TITLE_PREV "{0}    Prev Title    \n{1}"
#!define STR_MENU_OPT_TITLE_NEXT "{0}    Next Title    \n{1}"
#!define STR_MENU_OPT_DIFF_INC "{0}    Increase Difficulty    \n{1}"
#!define STR_MENU_OPT_DIFF_DEC "{0}    Decrease Difficulty    \n{1}"
#!define STR_MENU_OPT_THIRD_PERSON "{0}    3rd Person View    {1}\n{2}"
#!define STR_MENU_OPT_MARK_PLAYER "{0}    Mark Player    {1}\n{2}"
#!define STR_MENU_OPT_UNMARK_BLOCK "{0}    Unmark & Temp Ban    \n{1}"
#!define STR_MENU_OPT_NEXT_PAGE "{0}    Next Page    "

# ------------------------------------------------
# Menu Options (Page 2)
# ------------------------------------------------
#!define STR_MENU_OPT_DEBUG_INFO "{0}    Debug Info    {1}\n{2}"
#!define STR_MENU_OPT_UNLOCK_ALL "{0}    Unlock All Heroes    {1}\n{2}"
#!define STR_MENU_OPT_RESTART_NOW "{0}    Restart Immediately    \n{1}"
#!define STR_MENU_OPT_UNMARK_PLAYER "{0}    Unmark Player    \n{1}"
#!define STR_MENU_OPT_TP_TO_TARGET "{0}    TP to Target    \n{1}"
#!define STR_MENU_OPT_DMG_REDUCE "{0}    Damage Reduction    {1}\n{2}"
#!define STR_MENU_OPT_INVINCIBLE "{0}    Invincible    {1}\n{2}"

# ------------------------------------------------
# Menu Options (Page 3)
# ------------------------------------------------
#!define STR_MENU_OPT_AIR_WALK "{0}    Air Walk    {1}\n{2}"
#!define STR_MENU_OPT_NOCLIP "{0}    No Clip    {1}\n{2}"
#!define STR_MENU_OPT_SELECT_INDEX "{0}    Select Point Index    {1}\n{2}"
#!define STR_MENU_OPT_TP_TO_INDEX "{0}    TP to Point    \n{1}"
#!define STR_MENU_OPT_HERO_PAGE_TITLE "Hero Select/Switch"
#!define STR_MENU_OPT_HERO_NEXT "{0}    Select Hero: {1}    \n{2}"
#!define STR_MENU_OPT_HERO_PREV "{0}    Previous Hero: {1}    \n{2}"
#!define STR_MENU_OPT_HERO_APPLY "{0}    Apply Switch (Spawn Room)    \n{1}"

# ------------------------------------------------
# Host/Dev Administration Messages
# ------------------------------------------------
# {0}=Icon
#!define STR_MSG_ADMIN_NO_TARGET "  {0}  No player available to mark"

# {0}=Icon, {1}=Player Name, {2}=Hero
#!define STR_MSG_ADMIN_MARKED "  {0}  Host Action: Marked {1} ({2})"

# {0}=Icon, {1}=Button, {2}=Player Name
#!define STR_MSG_ADMIN_HOLD_TO_KICK "  {0}  Host Action: Hold {1} to Remove {2}"

# {0}=Icon, {1}=Player Name
#!define STR_MSG_ADMIN_KICK_WARNING "  {0}  Host Action: Removing {1} soon..."

# {0}=Icon, {1}=Player Name
#!define STR_MSG_ADMIN_KICK_SUCCESS "  {0}  Host Action: Removed {1}"
#!define STR_MSG_ADMIN_BLACKLIST_SUCCESS "  {0}  {1} has been added to the temporary blacklist"

# ------------------------------------------------
# Auto Restart Countdown
# ------------------------------------------------
#!define STR_MSG_AUTO_RESTART_1MIN "Game will auto-restart in 1 minute"
