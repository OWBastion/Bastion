# 核心信息
#!define STR_MODE_NAME "Bastion Escape 3"
#!define STR_MODE_CODE "Code [SVMQK]"

# 描述文本 - 标题与状态
#!define STR_DESC_EVENT_STATUS "Random Events 5.0: Greedy Ones is Live"
#!define STR_DESC_GAMEPLAY_TAG "!!!Escape with All Heroes!!!"

# 描述文本 - 元数据
#!define STR_DESC_LAST_UPDATE_PREFIX "Last Updated: "
# 英文版通常不放QQ群，可以改为Discord或者仅保留网站，这里做直译备用
#!define STR_DESC_CONTACT_INFO "Discord: 445152554" 
#!define STR_DESC_ORIGINAL_CREDIT "Based on [OW2 BASTION ESCAPE]"

#!define STR_LICENSE_TITLE "Notice: This code is released under Apache-2.0 with additional non-commercial restrictions"
#!define STR_LICENSE_PERMIT "You may modify and republish this mode for non-commercial use, provided you credit the original author and preserve the original mode code or source reference in the description."

# Settings Categories
#!define STR_SETTING_CAT_GAME "1. Game"

# Setting Names
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
#!define STR_OPT_CLASSIC_MAP_VARIANT_2 "Paris"
#!define STR_OPT_CLASSIC_MAP_VARIANT_3 "Hanamura"
#!define STR_ENUM_CLASSIC_MAP_VARIANT_OPTIONS ["Off", "Circuit Royal", "Paris", "Hanamura"]

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
#!define STR_EVT_BUFF_1_DESC "Movement speed increased by {0}%."
#!define STR_EVT_BUFF_2_TITLE "Ironclad Defense"
#!define STR_EVT_BUFF_2_DESC "Gain {0} + {1}% max HP as temporary armor and {2}% damage reduction."
#!define STR_EVT_BUFF_4_TITLE "Fountain of Life"
#!define STR_EVT_BUFF_4_DESC "Gain {0}% max HP as overhealth.\nRecover {1}% max HP per second."
#!define STR_EVT_BUFF_5_TITLE "Fan Attack"
#!define STR_EVT_BUFF_5_DESC "While targeted by Bastions, gain {0} + {1}% max HP as overhealth and {2}% bonus movement speed."
#!define STR_EVT_BUFF_6_TITLE "Power Walk"
#!define STR_EVT_BUFF_6_DESC "Continuous movement grants {0}% stackable movement speed."
#!define STR_EVT_BUFF_7_TITLE "Flesh Regeneration"
#!define STR_EVT_BUFF_7_DESC "Gain overhealth equal to {0} + {1}% max HP.\nAutomatically refreshes every {2}s."
#!define STR_EVT_BUFF_8_TITLE "Heartsteel"
#!define STR_EVT_BUFF_8_DESC "Gain {0} stacks on death.\nEach stack permanently grants {1}% max HP."
#!define STR_EVT_BUFF_9_TITLE "Death Delay"
#!define STR_EVT_BUFF_9_DESC "Fatal damage is delayed until the event ends."
#!define STR_EVT_BUFF_11_TITLE "Konami Code"
#!define STR_EVT_BUFF_11_DESC "Respawn at your death location when you die."
#!define STR_EVT_BUFF_12_TITLE "Vishkar Photon Shield"
#!define STR_EVT_BUFF_12_DESC "All players gain a recoverable shield\nequal to {0}% of your max HP.\nThe shield lasts until death or event end."
#!define STR_EVT_BUFF_13_TITLE "Rally to Me"
#!define STR_EVT_BUFF_13_DESC "You and nearby allies gain {1}s invulnerability every {0}s."
#!define STR_EVT_BUFF_14_TITLE "Will to Win"
#!define STR_EVT_BUFF_14_DESC "Triggers below {0}% HP.\nGain {1}s invulnerability and cleanse debuffs."
#!define STR_EVT_BUFF_15_TITLE "Mission: Marathon"
#!define STR_EVT_BUFF_15_DESC "Move continuously for {0}s to permanently gain {1}% speed."
#!define STR_EVT_BUFF_16_TITLE "Heartsteel Pro"
#!define STR_EVT_BUFF_16_DESC "Gain {0} Heartsteel stacks.\nTemporarily increases max HP based on stacks.\nValue = Heartsteel stacks x {1}."
#!define STR_EVT_BUFF_18_TITLE "Q to Win"
#!define STR_EVT_BUFF_18_DESC "Continuous movement charges Ultimate.\nDuring Ultimate, gain {0}% damage reduction."
# ------------------------------------------------
# Debuff Events
# ------------------------------------------------
#!define STR_EVT_DEBUFF_0_TITLE "Gravity Anomaly"
#!define STR_EVT_DEBUFF_0_DESC "Jump height reduced by {0}%."
#!define STR_EVT_DEBUFF_1_TITLE "EMP"
#!define STR_EVT_DEBUFF_1_DESC "Hacked. Abilities disabled."
#!define STR_EVT_DEBUFF_2_TITLE "Sacrifice"
#!define STR_EVT_DEBUFF_2_DESC "When teammates use abilities,\nyou lose {0}% max HP."
#!define STR_EVT_DEBUFF_3_TITLE "Vulnerable"
#!define STR_EVT_DEBUFF_3_DESC "All damage taken is increased by {0}%."
#!define STR_EVT_DEBUFF_4_TITLE "Speed Limit 40"
#!define STR_EVT_DEBUFF_4_DESC "While moving, lose {0} + {1}% max HP per second."
#!define STR_EVT_DEBUFF_5_TITLE "Gravitational Pull"
#!define STR_EVT_DEBUFF_5_DESC "Constantly pulled toward the nearest Bastion.\nMovement speed reduced by {0}%."
#!define STR_EVT_DEBUFF_6_TITLE "Osteoporosis"
#!define STR_EVT_DEBUFF_6_DESC "Movement speed decreases over time, up to {0}%."
#!define STR_EVT_DEBUFF_7_TITLE "EMP ProMax"
#!define STR_EVT_DEBUFF_7_DESC "Hacked.\nSpreads to allies within {0}m."
#!define STR_EVT_DEBUFF_8_TITLE "Energy Leak"
#!define STR_EVT_DEBUFF_8_DESC "Using abilities costs {0}% HP."
#!define STR_EVT_DEBUFF_9_TITLE "Shared Pain"
#!define STR_EVT_DEBUFF_9_DESC "{0}% of damage taken is shared with allies within {1}m."
#!define STR_EVT_DEBUFF_10_TITLE "Carnival Feast"
#!define STR_EVT_DEBUFF_10_DESC "If you die during the Feast,\nBastion enters Berserk for {0}s."
#!define STR_EVT_DEBUFF_11_TITLE "Return to Earth"
#!define STR_EVT_DEBUFF_11_DESC "After {0}s, nearby allies are knocked down for {1}s."
#!define STR_EVT_DEBUFF_13_TITLE "Halved"
#!define STR_EVT_DEBUFF_13_DESC "Lose {1}% HP every {0}s.\nDie instantly when HP drops below {2}%."
#!define STR_EVT_DEBUFF_14_TITLE "Self-Sacrifice"
#!define STR_EVT_DEBUFF_14_DESC "Heartsteel stacks are lost based on player count.\nEach player loses {0} stacks, split across other players."
# ------------------------------------------------
# Mech Events
# ------------------------------------------------
#!define STR_EVT_MECH_0_TITLE "Extreme Challenge"
#!define STR_EVT_MECH_0_DESC "Gain {0}% damage reduction.\nHP is locked at {1}%.\nHealing is disabled."
#!define STR_EVT_MECH_1_TITLE "Gambler"
#!define STR_EVT_MECH_1_DESC "Hold {0} to trigger.\n{1}% chance to permanently lose/gain {2} Heartsteel stacks."
#!define STR_EVT_MECH_2_TITLE "Mini Form"
#!define STR_EVT_MECH_2_DESC "Size reduced by {0}%, max HP reduced by {1}%.\nGain {2}% movement speed."
#!define STR_EVT_MECH_3_TITLE "Sneaky Beaky"
#!define STR_EVT_MECH_3_DESC "Become invisible while crouching. While moving, lose {0}% max health per second and gain {1}% movement speed."
#!define STR_EVT_MECH_4_TITLE "Brake Failure"
#!define STR_EVT_MECH_4_DESC "Move forward uncontrollably.\nMovement speed gradually increases to {0}%."
#!define STR_EVT_MECH_5_TITLE "Fart Power"
#!define STR_EVT_MECH_5_DESC "Hold {0} to fly forward.\nGain {1}% damage reduction while flying."
#!define STR_EVT_MECH_6_TITLE "Gambler: Speedrun"
#!define STR_EVT_MECH_6_DESC "Hold {0} to spend {1} Heartsteel stacks.\n{2}% chance to permanently gain/lose {3}% movement speed.\n{4}% chance to permanently gain/lose {5}% movement speed."
# ------------------------------------------------
# Random Pack 4: Buffs
# ------------------------------------------------
#!define STR_EVT_BUFF_19_TITLE "Phase Rush"
#!define STR_EVT_BUFF_19_DESC "Movement abilities gain {0}% + {1}% per trigger this match movement speed."
#!define STR_EVT_BUFF_20_TITLE "Bodyguard"
#!define STR_EVT_BUFF_20_DESC "Movement abilities grant temp armor to nearby allies."
#!define STR_EVT_BUFF_21_TITLE "Mission: Martyr"
#!define STR_EVT_BUFF_21_DESC "Die to {0} different Bastions. Reward: 5% Permanent DR."
#!define STR_EVT_BUFF_24_TITLE "F5"
#!define STR_EVT_BUFF_24_DESC "Reset all ability cooldowns every {0}s."
#!define STR_EVT_BUFF_25_TITLE "Healing Pylon ProMax"
#!define STR_EVT_BUFF_25_DESC "Ignore distance and heal the whole team for {0} + {1}% max HP per second."
#!define STR_EVT_BUFF_29_TITLE "Magic Master"
#!define STR_EVT_BUFF_29_DESC "Become invisible while using emotes.\nGain {0}% bonus movement speed."
#!define STR_EVT_BUFF_30_TITLE "Divine Reinforcement"
#!define STR_EVT_BUFF_30_DESC "Hold {0} to teleport to the ally with the lowest HP ratio.\nRestore {1} + {2}% max HP to them. Cooldown: {3}s."
#!define STR_EVT_BUFF_31_TITLE "Temper Heart"
#!define STR_EVT_BUFF_31_DESC "Pass the finish line with {0} heroes during the duration.\nHeartsteel stacks x {1}.\nMax HP per stack permanently raised from {2}% to {3}%"
#!define STR_EVT_BUFF_32_TITLE "Battlefield Medic"
#!define STR_EVT_BUFF_32_DESC "Heal {0} + {1} x player count HP.\nReward: permanently gain {2}% healing power."

# ------------------------------------------------
# Random Pack 4: Debuffs
# ------------------------------------------------
#!define STR_EVT_DEBUFF_15_TITLE "Social Distancing"
#!define STR_EVT_DEBUFF_15_DESC "Taking damage increases when closer to allies."
#!define STR_EVT_DEBUFF_20_TITLE "Moon Rocket"
#!define STR_EVT_DEBUFF_20_DESC "Randomly launches you skyward\nand scrambles your flight direction."

# ------------------------------------------------
# Random Pack 5: Debuffs
# ------------------------------------------------
#!define STR_EVT_DEBUFF_21_TITLE "Adlersbrunn's Wraith"
#!define STR_EVT_DEBUFF_21_DESC "Gain {0} curses immediately.\nEach curse reduces healing power by {1}%.\nHold {2}: pay {3}% max HP to remove 1 curse.\nOn end, lose {1}% permanent healing power per remaining curse."
#!define STR_EVT_DEBUFF_22_TITLE "Wayward Navigation"
#!define STR_EVT_DEBUFF_22_DESC "Every {0}s, launch yourself at high speed in a random direction."
#!define STR_EVT_DEBUFF_23_TITLE "Overweight Backpack"
#!define STR_EVT_DEBUFF_23_DESC "For every {0} max HP, damage taken increases by {1}%."
# ------------------------------------------------
# Random Pack 4: Mechanics
# ------------------------------------------------
#!define STR_EVT_MECH_7_TITLE "Cheat: Check Cards"
#!define STR_EVT_MECH_7_DESC "Hold {0} to permanently lose {1} Heartsteel stacks (about {2}% max HP).\nYour next event is guaranteed to be a Buff."
#!define STR_EVT_MECH_8_TITLE "Gambler: Short Term"
#!define STR_EVT_MECH_8_DESC "Hold {0} to lock {1} Debuffs.\n{2}% chance to gain {3} Heartsteel stacks."
#!define STR_EVT_MECH_10_TITLE "Cheat: Skip"
#!define STR_EVT_MECH_10_DESC "Hold {0}: Skip current hero (Doesn't count for challenge)."
#!define STR_EVT_MECH_11_TITLE "Matryoshka"
#!define STR_EVT_MECH_11_DESC "Respawn after {0}s on death.\nEach respawn shrinks size by {1}% and increases speed by {2}%."
#!define STR_EVT_MECH_12_TITLE "Gambler: Long Term"
#!define STR_EVT_MECH_12_DESC "Hold {0} to lock {1} Debuffs.\n{2}% chance to gain {3} Heartsteel stacks."
#!define STR_EVT_MECH_13_TITLE "Valkyrie's Descent"
#!define STR_EVT_MECH_13_DESC "Max HP increased by {0}%, and healing is disabled.\nTaking damage charges Ultimate.\nDuring Ultimate, recover up to {1}% HP."
#!define STR_EVT_MECH_14_TITLE "Trinity"
#!define STR_EVT_MECH_14_DESC "100 HP -> {0}% damage reduction. 1% damage reduction -> {1}% movement speed.\nGain 1 Heartsteel stack every {2}s."
#!define STR_EVT_MECH_15_TITLE "Gambler: Dice Maniac"
#!define STR_EVT_MECH_15_DESC "Hold {1} to roll a die.\nBased on the result, permanently lose/gain: Heartsteel / movement speed / damage reduction / healing power."
#!define STR_EVT_MECH_16_TITLE "Gambler: Heart of Steel"
#!define STR_EVT_MECH_16_DESC "Hold {0} to settle.\n{1}% chance to multiply Heartsteel stacks by {2}; {3}% chance to lose {4}% stacks (rounded up)."
#!define STR_EVT_MECH_17_TITLE "Gambler: All-in Art"
#!define STR_EVT_MECH_17_DESC "Press {0} to bet {1}% of your Heartsteel stacks.\n{2}% chance to gain bet x {3} stacks."
#!define STR_EVT_MECH_18_TITLE "Vampire"
#!define STR_EVT_MECH_18_DESC "Drain all allies for {0} + {1}% max HP per second.\nEach allied kill grants +{2}% permanent healing dealt."
#!define STR_EVT_MECH_19_TITLE "Thief"
#!define STR_EVT_MECH_19_DESC "Hold {0} to randomly steal one ally's future Buff event.\nYour next event is guaranteed to be a Buff.\nThe target loses one future Buff event."
#!define STR_EVT_MECH_20_TITLE "Gambler: Helpful Soul"
#!define STR_EVT_MECH_20_DESC "Hold {0} to settle.\n{1}% chance to restore all allies for {2}% max HP.\n{3}% chance to set all players' HP to 1."
#!define STR_EVT_MECH_22_TITLE "Cheat: Backroom Deal"
#!define STR_EVT_MECH_22_DESC "Hold {0} to permanently lose {1} Heartsteel stacks (about {2}% max HP).\nYour next event is guaranteed to be a Mech."
#!define STR_EVT_MECH_23_TITLE "Mirror Inversion"
#!define STR_EVT_MECH_23_DESC "Hold {0} to permanently invert your current permanent stats: damage reduction / movement speed / healing power / Heartsteel."
#!define STR_EVT_MECH_24_TITLE "Gambler: Winner Takes All"
#!define STR_EVT_MECH_24_DESC "Hold {0} to spend {1}% of your Heartsteel stacks.\n{2}% chance to empty the jackpot and claim all Heartsteel inside."


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
#!define STR_HUD_MAP_REVISION_DATA_INVALID "Map revision data is unavailable: {0}. Map initialization stopped."
#!define STR_HUD_FOOTER_INFO "Top 500 Group: 445152554 | Join the group to upvote your favorite events \n"
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
# {0}=Deaths/Skips, {1}=Event Stats, {2}=Player Attributes, {3}=Total Time, {4}=Completion Code
#!define STR_HUD_STATS_PANEL "{0}\r\n{1}\r\n{2}{3}{4}"

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
#!define STR_MAP_PARIS "Paris"
#!define STR_MSG_PLAYER_RESET_PROGRESS "  {0} reset their progress"

# ------------------------------------------------
# Menu Titles
# ------------------------------------------------
#!define STR_MENU_TITLE_DEV "Developer Mode"
#!define STR_MENU_TITLE_INGAME "In-Game Panel ({0}+{1})"
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
