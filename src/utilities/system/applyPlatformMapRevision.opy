#!mainFile "../../main.opy"

#!optimizeStrict

subroutine applyPlatformMapRevision

def applyPlatformMapRevision():
    @Name "Apply platform map revision"

    if platformMapRevisionLoaded:
        return
    platformMapRevisionLoaded = true

    if platformMapRevisionMapId == null:
        return

    platformMapRevisionCandidates = PLATFORM_MAP_REVISION_DATA.filter(lambda revision:
        revision[PLATFORM_MAP_REVISION_FIELD_MAP_ID] == platformMapRevisionMapId and
        revision[PLATFORM_MAP_REVISION_FIELD_ENABLED] == true and
        revision[PLATFORM_MAP_REVISION_FIELD_LIFECYCLE] in ["default", "selectable"]
    )
    platformMapRevisionDefaults = platformMapRevisionCandidates.filter(lambda revision:
        revision[PLATFORM_MAP_REVISION_FIELD_LIFECYCLE] == "default" and
        revision[PLATFORM_MAP_REVISION_FIELD_IS_DEFAULT] == true and
        revision[PLATFORM_MAP_REVISION_FIELD_IS_SELECTABLE] == false
    )

    if len(platformMapRevisionDefaults) != 1:
        platformMapRevisionDataError = true
        bastionPosition = []
        getPlayers(Team.1).disableRespawn()
        bigMessage(getAllPlayers(), STR_HUD_MAP_REVISION_DATA_INVALID.format(platformMapRevisionMapId))
        return

    platformMapRevision = platformMapRevisionDefaults[0]
    platformMapRevisionSelectableCandidates = platformMapRevisionCandidates.filter(lambda revision:
        revision[PLATFORM_MAP_REVISION_FIELD_LIFECYCLE] == "selectable" and
        revision[PLATFORM_MAP_REVISION_FIELD_IS_DEFAULT] == false and
        revision[PLATFORM_MAP_REVISION_FIELD_IS_SELECTABLE] == true
    )
    if platformMapRevisionVariant != null:
        platformMapRevisionSelectableCandidates = platformMapRevisionSelectableCandidates.filter(lambda revision:
            revision[PLATFORM_MAP_REVISION_FIELD_MAP_VARIANT] == platformMapRevisionVariant
        )
        if len(platformMapRevisionSelectableCandidates) != 1:
            platformMapRevisionDataError = true
            bastionPosition = []
            getPlayers(Team.1).disableRespawn()
            bigMessage(getAllPlayers(), STR_HUD_MAP_REVISION_DATA_INVALID.format(platformMapRevisionMapId))
            return
        platformMapRevision = platformMapRevisionSelectableCandidates[0]

    platformMapRevisionId = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_GAMEPLAY_REVISION_ID]
    platformMapRevisionChallengeRefs = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_CHALLENGE_REFS]
    __currentMapText___ = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_MAP_NAME]
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format(platformMapRevision[PLATFORM_MAP_REVISION_FIELD_MAP_NAME])
    if platformMapRevisionVariant == "classic":
        __currentMapText___ = __currentMapClassicText___
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG][PLATFORM_MAP_REVISION_SPATIAL_FIELD_BASTION_POSITIONS]
    resetPosition = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG][PLATFORM_MAP_REVISION_SPATIAL_FIELD_RESET_POSITION]
    endPosition = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG][PLATFORM_MAP_REVISION_SPATIAL_FIELD_END_POSITION]
    thirdPersonPosition = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG][PLATFORM_MAP_REVISION_SPATIAL_FIELD_THIRD_PERSON_POSITION]
    creditsPosition = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG][PLATFORM_MAP_REVISION_SPATIAL_FIELD_CREDITS_POSITION]
    mapTitlePlayersByKey = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_TITLE_HOLDERS]

    if platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG][PLATFORM_MAP_REVISION_SPATIAL_FIELD_CONTROL] == null:
        controlCenterPosition = null
        controlJumpPosition = null
        controlRespawnPosition = null
        controlRespawnAxis = null
        controlRespawnAxisThreshold = null
    else:
        controlCenterPosition = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG][PLATFORM_MAP_REVISION_SPATIAL_FIELD_CONTROL][PLATFORM_MAP_REVISION_CONTROL_FIELD_CENTER_POSITIONS]
        controlJumpPosition = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG][PLATFORM_MAP_REVISION_SPATIAL_FIELD_CONTROL][PLATFORM_MAP_REVISION_CONTROL_FIELD_JUMP_POSITIONS]
        controlRespawnPosition = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG][PLATFORM_MAP_REVISION_SPATIAL_FIELD_CONTROL][PLATFORM_MAP_REVISION_CONTROL_FIELD_RESPAWN_POSITIONS]
        controlRespawnAxis = null if platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG][PLATFORM_MAP_REVISION_SPATIAL_FIELD_CONTROL][PLATFORM_MAP_REVISION_CONTROL_FIELD_RESPAWN_AXIS] == null else 0 if platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG][PLATFORM_MAP_REVISION_SPATIAL_FIELD_CONTROL][PLATFORM_MAP_REVISION_CONTROL_FIELD_RESPAWN_AXIS] == "x" else 1 if platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG][PLATFORM_MAP_REVISION_SPATIAL_FIELD_CONTROL][PLATFORM_MAP_REVISION_CONTROL_FIELD_RESPAWN_AXIS] == "y" else 2
        controlRespawnAxisThreshold = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG][PLATFORM_MAP_REVISION_SPATIAL_FIELD_CONTROL][PLATFORM_MAP_REVISION_CONTROL_FIELD_RESPAWN_AXIS_THRESHOLD]

    portalPosition = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG][PLATFORM_MAP_REVISION_SPATIAL_FIELD_PORTAL_POSITIONS] if len(platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG][PLATFORM_MAP_REVISION_SPATIAL_FIELD_PORTAL_POSITIONS]) > 0 else null
    springBoardPosition = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG][PLATFORM_MAP_REVISION_SPATIAL_FIELD_SPRINGBOARD_POSITIONS][0] if len(platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG][PLATFORM_MAP_REVISION_SPATIAL_FIELD_SPRINGBOARD_POSITIONS]) > 0 else null
