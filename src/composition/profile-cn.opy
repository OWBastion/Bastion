#!include "../env/title-vars.opy"
#!include "../title/title-cn.opy"
#!define PROFILE_EVENT_PLAYER_ELIGIBLE(player) any([player.playerTitles[0][1] == vect(149, 239, 66) and player.heroNumber >= 1, player.heroNumber > 2])
#!define PROFILE_LIFEWEAVER_GRIP_ELIGIBLE(player) (player.isWinner or player.playerTitleRelationIndex != null)
#!define PROFILE_DEV_MENU_OPTIONS(next) STR_MENU_OPT_TITLE_PREV.format(inputBindingString(Button.ULTIMATE), STR_MENU_OPT_TITLE_NEXT.format(inputBindingString(Button.ABILITY_2), next))
#!define PROFILE_HOST_MENU_OPTIONS(next) STR_MENU_OPT_TITLE_NEXT.format(inputBindingString(Button.ABILITY_2), next)
#!define PROFILE_PLAYER_MENU_OPTIONS(next) STR_MENU_OPT_TITLE_NEXT.format(inputBindingString(Button.ABILITY_2), next)
#!define PROFILE_RESET_ACHIEVEMENT_STATE() eventPlayer.tempUnlockId = null
#!define PROFILE_RESET_ACHIEVEMENT_LIST() eventPlayer.earnedAchievements = []
