#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# 路线点位的静态世界效果：位置只在创建时求值，点位会被编辑的入口不引入本文件

macro goalPointEffects():
    createEffect(getPlayers(Team.1), Effect.RING, Color.TEAM_1, endPosition, 4, EffectReeval.VISIBILITY)
    createEffect(getPlayers(Team.1), Effect.LIGHT_SHAFT, Color.TEAM_1, endPosition, 4, EffectReeval.VISIBILITY)
    createIcon(getPlayers(Team.1) if controlJumpPosition == null else [player for player in getPlayers(Team.1) if player.controlJumpIndex == evalOnce(len(controlRespawnPosition)) - 1], endPosition + vect(0, 5, 0), Icon.FLAG, IconReeval.VISIBILITY_AND_POSITION, Color.BLUE)
    if controlJumpPosition != null:
        createEffect(getPlayers(Team.1), Effect.RING, Color.YELLOW, controlJumpPosition[0], 4, EffectReeval.VISIBILITY)
        createEffect(getPlayers(Team.1), Effect.LIGHT_SHAFT, Color.YELLOW, controlJumpPosition[0], 4, EffectReeval.VISIBILITY)
        createIcon([player for player in getPlayers(Team.1) if player.controlJumpIndex == 0], controlJumpPosition[0] + vect(0, 5, 0), Icon.FLAG, IconReeval.VISIBILITY_AND_POSITION, Color.YELLOW)
        if not controlJumpPosition[1]:
            goto lbl_0
        createEffect(getPlayers(Team.1), Effect.RING, Color.GREEN, controlJumpPosition[1], 4, EffectReeval.VISIBILITY)
        createEffect(getPlayers(Team.1), Effect.LIGHT_SHAFT, Color.GREEN, controlJumpPosition[1], 4, EffectReeval.VISIBILITY)
        createIcon([player for player in getPlayers(Team.1) if player.controlJumpIndex == 1], controlJumpPosition[1] + vect(0, 5, 0), Icon.FLAG, IconReeval.VISIBILITY_AND_POSITION, Color.GREEN)
        lbl_0:

macro creditsPointEffects():
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.AQUA, creditsPosition, random.uniform(1, 2), EffectReeval.VISIBILITY)
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.SKY_BLUE, creditsPosition, random.uniform(1, 2), EffectReeval.VISIBILITY)
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.WHITE, creditsPosition, random.uniform(1, 2), EffectReeval.VISIBILITY)

macro interactionPointEffects():
    createEffect(localPlayer, Effect.RING, Color.PURPLE, thirdPersonPosition, 1.2, EffectReeval.VISIBILITY)
    createInWorldText(localPlayer, STR_WORLD_THIRD_PERSON.format(inputBindingString(Button.JUMP), iconString(Icon.ARROW_DOWN)), thirdPersonPosition + Vector.UP * 1.3, 1.2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)

    # springboard
    if springBoardPosition != null:
        createEffect(localPlayer, Effect.RING, Color.GREEN, springBoardPosition, 1.2, EffectReeval.VISIBILITY)
        createInWorldText(localPlayer, STR_WORLD_SPRINGBOARD.format(inputBindingString(Button.JUMP), iconString(Icon.ARROW_DOWN)), springBoardPosition + Vector.UP * 1.3, 1.2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
