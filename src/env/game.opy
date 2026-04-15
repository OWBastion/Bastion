#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

globalvar savedIndex 17
globalvar savedHero 18
globalvar savedDeaths 19
globalvar savedIsWinner 20
globalvar savedSkipCount 21
globalvar savedJoinTime 22
globalvar savedWinnerTime 49
globalvar savedA36TGrenadeAlive 54
globalvar difficulty
globalvar difficultyText

rule "Initialize global variables":
    dlcVishkarEvent = createWorkshopSettingBool(STR_SETTING_CAT_DLC, STR_SETTING_DLC_VISHKAR, true, 5)

    rebootTime = createWorkshopSettingFloat(STR_SETTING_CAT_GAME, STR_SETTING_REBOOT_TIME, 3.5, 1, 4) * 3600

    debugMode = createWorkshopSettingBool(STR_SETTING_CAT_GAME, STR_SETTING_DEBUG, true if DEBUG else false, 5)

    hashTag = false if evalOnce(debugMode) else true
    bastionBotTargetPrefer = createWorkshopSettingEnum(
        STR_SETTING_CAT_GAME, 
        STR_SETTING_BASTION_TARGET, 
        0, 
        STR_ENUM_TARGET_OPTIONS,  # 在这里显式构造数组
        2
    )

    difficulty = createWorkshopSettingEnum(STR_SETTING_CAT_GAME, STR_SETTING_DIFFICULTY, 1, STR_ENUM_DIFFICULTY_OPTIONS, 1)

    dmgReduction = createWorkshopSettingBool(STR_SETTING_CAT_GAME, STR_SETTING_ULT_CHARGE, true, 4)

    bastionBotSeconFire = createWorkshopSettingBool(STR_SETTING_CAT_GAME, STR_SETTING_BASTION_GRENADE, false, 3)

    classicMapVariant = createWorkshopSettingEnum(
        STR_SETTING_CAT_GAME,
        STR_SETTING_CLASSIC_MAP_VARIANT,
        CLASSIC_MAP_VARIANT_OFF,
        STR_ENUM_CLASSIC_MAP_VARIANT_OPTIONS,
        6
    )

    turnSpeedMultiplier = 4 + difficulty if difficulty < 4 else 12 * 0.8
    maxDeath = 5 * difficulty
    savedIndex = []
    savedHero = []
    savedDeaths = []
    savedIsWinner = []
    savedSkipCount = []
    savedJoinTime = []
    devList = ["他又", "别感冒"]
    devPlayer = []
    obstrucVis = []
    mapTitlePlayersByKey = []

rule "Update devPlayer from devList":
    @Event playerJoined
    @Team 1
    @Condition "{0}".format(eventPlayer) in devList == true
    @Condition "{0}".format(eventPlayer) in devPlayer == false

    devPlayer.append(eventPlayer)


rule "Update targetPlayer when player left":
    @Event playerLeft
    @Team 1
    
    wait(getAverageServerLoad() / 100 * 0.032)
    targetPlayerIndex = 0
    targetPlayer = sorted(getPlayers(Team.1), lambda player: player.joinTime)[0]
    if eventPlayer.hudTextId != null:
        destroyHudText(eventPlayer.hudTextId)

rule "initialize color array":
    rgbList = [vect(255, 0, 0), vect(255, 165, 0), vect(255, 255, 0), vect(0, 255, 0), vect(0, 0, 255), vect(75, 0, 130), vect(238, 130, 238)]
    wait(getAverageServerLoad() / 100 * 0.032)
    breathRed = [vect(238, 75, 43), vect(233, 116, 81), vect(210, 43, 43), vect(220, 20, 60), vect(255, 36, 0), vect(255, 50, 50), vect(255, 0, 0)]
    breathPurple = [vect(161, 73, 197), vect(93, 63, 211), vect(218, 112, 214), vect(112, 41, 99), vect(191, 64, 191), vect(204, 204, 255), vect(128, 0, 128)]
    breathBlue = [vect(85, 178, 204), vect(120, 200, 225), vect(160, 220, 240), vect(25, 80, 120), vect(45, 125, 165), vect(200, 235, 245), vect(230, 245, 250)]
    breathOrange = [vect(250, 121, 0), vect(255, 140, 0), vect(255, 220, 180), vect(255, 160, 50), vect(255, 200, 150), vect(255, 180, 100), vect(230, 105, 0)]
    breathGold = [vect(255, 215, 0), vect(238, 201, 0), vect(255, 223, 70), vect(255, 239, 128), vect(218, 165, 32), vect(250, 250, 210), vect(184, 134, 11)]
    heroColor = [vect(124, 62, 82), vect(214, 145, 65), vect(236, 233, 189), vect(185, 179, 137), vect(191, 115, 110), vect(148, 161, 165), vect(60, 126, 204), vect(160, 169, 186), vect(157, 105, 166), vect(124, 143, 122), vect(45, 187, 209), vect(236, 229, 128), vect(149, 239, 66), vect(179, 139, 80), vect(173, 90, 95), vect(236, 190, 82), vect(231, 130, 184), vect(109, 121, 149), vect(132, 201, 81), vect(237, 147, 199), vect(9, 171, 235), vect(118, 93, 189), vect(131, 83, 76), vect(110, 137, 177), vect(69, 139, 66), vect(139, 98, 94), vect(151, 113, 228), vect(219, 147, 66), vect(198, 28, 65), vect(105, 105, 104), vect(154, 202, 243), vect(85, 178, 204), vect(212, 135, 143), vect(142, 181, 215), vect(148, 160, 165), vect(157, 140, 208), vect(224, 182, 198), vect(220, 132, 125), vect(183, 168, 142), vect(121, 97, 78), vect(173, 143, 203), vect(114, 31, 163), vect(54, 127, 221), vect(238, 75, 43), vect(93, 63, 211), vect(196, 30, 58)]

rule "initialize phase hero arrays":
    @Condition vishkarEventActivated == true
    
    # 技能 1
    phaseHero[0] = [Hero.DVA, Hero.REINHARDT, Hero.WINSTON, Hero.MAUGA, Hero.HAZARD, Hero.DOOMFIST, Hero.ASHE, Hero.PHARAH, Hero.ECHO, Hero.CASSIDY, Hero.SOLDIER, Hero.REAPER, Hero.SOJOURN, Hero.VENTURE, Hero.GENJI, Hero.TRACER, Hero.MOIRA, Hero.MERCY, Hero.KIRIKO, Hero.ILLARI, Hero.JUNO, Hero.WUYANG, Hero.FREJA, Hero.ANRAN, Hero.JETPACK_CAT, Hero.EMRE, Hero.MIZUKI, Hero.WIDOWMAKER, Hero.SIERRA]

    # 技能 2
    phaseHero[1] = [Hero.ORISA, Hero.SOMBRA, Hero.TRACER, Hero.FREJA, Hero.REAPER]

    # 辅助攻击
    phaseHero[2] = [Hero.DOOMFIST, Hero.TRACER, Hero.JETPACK_CAT]

    # 跳跃
    phaseHero[3] = [Hero.HANZO]

    # 近战
    phaseHero[4] = [Hero.ZENYATTA]

rule "initialize hero list":
    #make default hero list, which includes all 36 heroes available in Season 2
    heroList = [Hero.SOMBRA, Hero.REAPER, Hero.MOIRA, Hero.KIRIKO, Hero.SIGMA, Hero.WUYANG, Hero.MIZUKI, Hero.EMRE, Hero.GENJI, Hero.ORISA, Hero.WINSTON, Hero.DVA, Hero.TRACER, Hero.WIDOWMAKER, Hero.DOMINA, Hero.SOJOURN, Hero.BAPTISTE, Hero.SYMMETRA, Hero.MEI, Hero.ECHO, Hero.BRIGITTE, Hero.SOLDIER, Hero.JUNO, Hero.WRECKING_BALL, Hero.CASSIDY, Hero.ZARYA, Hero.LUCIO, Hero.PHARAH, Hero.JETPACK_CAT, Hero.MERCY, Hero.REINHARDT, Hero.HANZO, Hero.DOOMFIST, Hero.ROADHOG, Hero.JUNKER_QUEEN, Hero.ASHE, Hero.TORBJORN, Hero.ANA, Hero.ZENYATTA, Hero.JUNKRAT, Hero.BASTION]
    #remove all heroes that are not for some reason in Overwatch's list of all the heroes (at the time of making this, Mei is an example because she was removed to be patched)
    heroList.remove(heroList.filter(lambda player: not player in getAllHeroes()))
    #add any heroes that for some reason are on Overwatch's list but not the game's (eg if I don't update the mode after a hero release). they are added as the second hero in the list
    if getAllHeroes().any(lambda i: not i in heroList):
        missingHeroes = getAllHeroes().filter(lambda i: not i in heroList)
        for I in range(len(missingHeroes)):
            heroList = sorted(heroList.concat(missingHeroes[I]), lambda i, idx: idx if i != missingHeroes[I] else 0.5)
            wait()
    #move Bastion to the end of the hero list, and keep the rest of the list how it is
    heroList = sorted(heroList, lambda player, i: i + (len(heroList) * (player == Hero.BASTION)))
