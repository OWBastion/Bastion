#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "map - 花村":
    @Condition (__currentMap___ == Map.HANAMURA or __currentMap___ == 1848 or __currentMap___ == Map.HANAMURA_WINTER) == true
    
    #Made by 他又 芋泥玛奇朵
    if classicMapVariant == CLASSIC_MAP_VARIANT_HANAMURA:
        bastionPosition = [
            vect(-15.46, 9.68, -89.3),
            vect(1.87, 5, -41.04),
            vect(-6.95, 8.01, -10.86),
            vect(27, 0, -7.87),
            vect(34.66, 6, 16.47),
            vect(63.63, 6, -11.98)
        ]
        endPosition = vect(72.38, -1.96, -0.16)
    else:
        bastionPosition = vect(-20.75, 9.21, -78.14)
        bastionPosition.append(vect(11.87, 7.21, -47.22))
        bastionPosition.append(vect(28.31, 10.47, 6.6))
        bastionPosition.append(vect(-6.95, 8.01, -10.86))
        bastionPosition.append(vect(49.13, 14.56, 17.96))
        bastionPosition.append(vect(52.2, -1, -0.58))
        bastionPosition.append(vect(15.61, 11.98, 17.47))
        bastionPosition.append(vect(46.87, -0.16, -15.6))
        bastionPosition.append(vect(60.13, -1.04, -15.61))
        endPosition = vect(51.7, -1.87, 25.91)
    thirdPersonPosition = vect(-33.2, 1, -115.04)
    resetPosition = vect(-46.98, 1, -101.54)
    creditsPosition = vect(-48.1, 2.5, -116.08)
    __currentMapText___ = "花村"
    if classicMapVariant == CLASSIC_MAP_VARIANT_HANAMURA:
        __currentMapText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("花村")
    __currentMapPioneerText___ = __currentMapText___

    mapTitlePlayersByKey = [
        DATA_HANAMURA[0].split("-"),
        DATA_HANAMURA[1].split("-"),
        DATA_HANAMURA[2].split("-")
    ]
