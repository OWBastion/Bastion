#!mainFile "../editorMain.opy"

# 编辑器可以改写路线点位，静态世界效果会留在旧位置；点位标记由 editor/editorPoints.opy 重建。
#!define goalPointEffects() #
#!define creditsPointEffects() #
#!define interactionPointEffects() #
#!define PROFILE_LIFEWEAVER_GRIP_ELIGIBLE(player) false
# 堡垒开火模式：开火 / 仅瞄准 / 关闭（editorFireMode 为 null 时按开火处理）
#!define BASTION_FIRE_CONDITION @Condition editorFireMode == 0
#!define BASTION_TARGETING_CONDITION @Condition editorFireMode != 2
# 事件不依赖玩家进度，所有玩家都有资格获得事件。
#!define PROFILE_EVENT_PLAYER_ELIGIBLE(player) true
