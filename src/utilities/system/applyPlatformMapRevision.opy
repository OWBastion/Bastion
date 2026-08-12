#!mainFile "../../main.opy"

#!optimizeStrict

subroutine failPlatformMapRevisionData
subroutine applyPlatformMapRevisionSpatialConfig
subroutine applyPlatformMapRevision
subroutine applyPlatformMapRevisionStage

def failPlatformMapRevisionData():
    @Name "Fail platform map revision data"

    platformMapRevisionDataError = true
    bastionPosition = []
    getPlayers(Team.1).disableRespawn()
    bigMessage(getAllPlayers(), STR_HUD_MAP_REVISION_DATA_INVALID.format(platformMapRevisionMapId))

def applyPlatformMapRevisionSpatialConfig():
    @Name "Apply platform spatial config"

    bastionPosition = platformMapRevisionSpatialConfig[PLATFORM_MAP_REVISION_SPATIAL_FIELD_BASTION_POSITIONS]
    resetPosition = platformMapRevisionSpatialConfig[PLATFORM_MAP_REVISION_SPATIAL_FIELD_RESET_POSITION]
    endPosition = platformMapRevisionSpatialConfig[PLATFORM_MAP_REVISION_SPATIAL_FIELD_END_POSITION]
    thirdPersonPosition = platformMapRevisionSpatialConfig[PLATFORM_MAP_REVISION_SPATIAL_FIELD_THIRD_PERSON_POSITION]
    creditsPosition = platformMapRevisionSpatialConfig[PLATFORM_MAP_REVISION_SPATIAL_FIELD_CREDITS_POSITION]

    if platformMapRevisionSpatialConfig[PLATFORM_MAP_REVISION_SPATIAL_FIELD_CONTROL] == null:
        controlCenterPosition = null
        controlJumpPosition = null
        controlRespawnPosition = null
        controlRespawnAxis = null
        controlRespawnAxisThreshold = null
    else:
        controlCenterPosition = platformMapRevisionSpatialConfig[PLATFORM_MAP_REVISION_SPATIAL_FIELD_CONTROL][PLATFORM_MAP_REVISION_CONTROL_FIELD_CENTER_POSITIONS]
        controlJumpPosition = platformMapRevisionSpatialConfig[PLATFORM_MAP_REVISION_SPATIAL_FIELD_CONTROL][PLATFORM_MAP_REVISION_CONTROL_FIELD_JUMP_POSITIONS]
        controlRespawnPosition = platformMapRevisionSpatialConfig[PLATFORM_MAP_REVISION_SPATIAL_FIELD_CONTROL][PLATFORM_MAP_REVISION_CONTROL_FIELD_RESPAWN_POSITIONS]
        controlRespawnAxis = null if platformMapRevisionSpatialConfig[PLATFORM_MAP_REVISION_SPATIAL_FIELD_CONTROL][PLATFORM_MAP_REVISION_CONTROL_FIELD_RESPAWN_AXIS] == null else 0 if platformMapRevisionSpatialConfig[PLATFORM_MAP_REVISION_SPATIAL_FIELD_CONTROL][PLATFORM_MAP_REVISION_CONTROL_FIELD_RESPAWN_AXIS] == "x" else 1 if platformMapRevisionSpatialConfig[PLATFORM_MAP_REVISION_SPATIAL_FIELD_CONTROL][PLATFORM_MAP_REVISION_CONTROL_FIELD_RESPAWN_AXIS] == "y" else 2
        controlRespawnAxisThreshold = platformMapRevisionSpatialConfig[PLATFORM_MAP_REVISION_SPATIAL_FIELD_CONTROL][PLATFORM_MAP_REVISION_CONTROL_FIELD_RESPAWN_AXIS_THRESHOLD]

    portalPosition = platformMapRevisionSpatialConfig[PLATFORM_MAP_REVISION_SPATIAL_FIELD_PORTAL_POSITIONS] if len(platformMapRevisionSpatialConfig[PLATFORM_MAP_REVISION_SPATIAL_FIELD_PORTAL_POSITIONS]) > 0 else null
    springBoardPosition = platformMapRevisionSpatialConfig[PLATFORM_MAP_REVISION_SPATIAL_FIELD_SPRINGBOARD_POSITIONS][0] if len(platformMapRevisionSpatialConfig[PLATFORM_MAP_REVISION_SPATIAL_FIELD_SPRINGBOARD_POSITIONS]) > 0 else null

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
        failPlatformMapRevisionData()
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
            failPlatformMapRevisionData()
            return
        platformMapRevision = platformMapRevisionSelectableCandidates[0]

    platformMapRevisionId = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_GAMEPLAY_REVISION_ID]
    platformMapRevisionChallengeRefs = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_CHALLENGE_REFS]
    __currentMapText___ = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_MAP_NAME]
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format(platformMapRevision[PLATFORM_MAP_REVISION_FIELD_MAP_NAME])
    if platformMapRevisionVariant == "classic":
        __currentMapText___ = __currentMapClassicText___
    __currentMapPioneerText___ = __currentMapText___
    mapTitlePlayersByKey = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_TITLE_HOLDERS]
    platformMapRevisionSpatialConfig = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG]
    applyPlatformMapRevisionSpatialConfig()

def applyPlatformMapRevisionStage():
    @Name "Apply platform map revision stage"

    if platformMapRevisionDataError:
        return
    platformMapRevisionStageCandidates = platformMapRevision[PLATFORM_MAP_REVISION_FIELD_SPATIAL_CONFIG][PLATFORM_MAP_REVISION_SPATIAL_FIELD_ALTERNATE_STAGES].filter(lambda stage:
        len(getPlayersInRadius(
            stage[PLATFORM_MAP_REVISION_ALTERNATE_STAGE_FIELD_SETUP_DETECTION][PLATFORM_MAP_REVISION_STAGE_SETUP_DETECTION_FIELD_POSITION],
            stage[PLATFORM_MAP_REVISION_ALTERNATE_STAGE_FIELD_SETUP_DETECTION][PLATFORM_MAP_REVISION_STAGE_SETUP_DETECTION_FIELD_RADIUS],
            Team.1
        )) != 0
    )
    if len(platformMapRevisionStageCandidates) == 0:
        return
    if len(platformMapRevisionStageCandidates) != 1:
        failPlatformMapRevisionData()
        return
    platformMapRevisionSpatialConfig = platformMapRevisionStageCandidates[0][PLATFORM_MAP_REVISION_ALTERNATE_STAGE_FIELD_SPATIAL_CONFIG]
    applyPlatformMapRevisionSpatialConfig()
