#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine setPlayerTitle

def setPlayerTitle():
    @Name "set player title"
    
    # 1. 基础称号 (从通用数据库获取)
    eventPlayer.playerTitles = playerTitleRelation[playerTitleSetIndex[eventPlayer.playerTitleRelationIndex]]

    # 2. 查找并合并地图称号
    if platformMapRevisionId != null:
        if platformMapRevisionVariant == null:
            if eventPlayer.key in mapTitlePlayersByKey[MapTITLEKey.PIONEER]:
                eventPlayer.playerTitles.append(TITLE.PIONEER)

            if eventPlayer.key in mapTitlePlayersByKey[MapTITLEKey.CONQUEROR]:
                eventPlayer.playerTitles.append(TITLE.CONQUEROR)

            if eventPlayer.key in mapTitlePlayersByKey[MapTITLEKey.DOMINATOR]:
                eventPlayer.playerTitles.append(TITLE.DOMINATOR)
        elif platformMapRevisionVariant == "classic" and eventPlayer.key in mapTitlePlayersByKey[MapTITLEKey.CLASSIC]:
            eventPlayer.playerTitles.append(TITLE.CLASSIC)
    else:
        if classicMapVariant == CLASSIC_MAP_VARIANT_OFF:
            if f"{eventPlayer.playerTitleRelationIndex}" in mapTitlePlayersByKey[MapTITLEKey.PIONEER]:
                eventPlayer.playerTitles.append(TITLE.PIONEER)

            if f"{eventPlayer.playerTitleRelationIndex}" in mapTitlePlayersByKey[MapTITLEKey.CONQUEROR]:
                eventPlayer.playerTitles.append(TITLE.CONQUEROR)

            if f"{eventPlayer.playerTitleRelationIndex}" in mapTitlePlayersByKey[MapTITLEKey.DOMINATOR]:
                eventPlayer.playerTitles.append(TITLE.DOMINATOR)

        if __currentMapClassicText___ != null and f"{eventPlayer.playerTitleRelationIndex}" in mapTitlePlayersByKey[MapTITLEKey.CLASSIC]:
            eventPlayer.playerTitles.append(TITLE.CLASSIC)

    if eventPlayer.playerTitleIndex == null:
        eventPlayer.playerTitleIndex = len(eventPlayer.playerTitles) - 1
