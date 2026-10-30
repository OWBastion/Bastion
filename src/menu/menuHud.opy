#!mainFile "../main.opy"

#!optimizeStrict
#!rulePrefix "Menu"

# 菜单 HUD 版本（A/B 测试后只保留一个，其余删除），由入口文件中 menuHud.opy 之后的 include 选择：
#   hudSingle.opy    单个 hudText（标题 + 正文），全局创建一次，常驻
#   hudPair.opy      hudHeader + hudSubheader 两个文本，全局创建一次，常驻
#   hudPerPlayer.opy 两个文本，打开时创建、关闭时销毁（每名玩家各自一份）

# 位于左列游戏 HUD（排序 2–7）之下
#!define MENU_HUD_SORT_TITLE 8
#!define MENU_HUD_SORT_BODY 9

#!define MENU_TITLE(viewer) MENU_MAIN_TITLE(viewer) if viewer.menu == MENU_PAGE_MAIN else (MENU_HERO_TITLE(viewer) if viewer.menu == MENU_PAGE_HERO else (MENU_DEV_ADMIN_TITLE(viewer) if viewer.menu == MENU_PAGE_DEV_ADMIN else (MENU_DEV_MOVEMENT_TITLE(viewer) if viewer.menu == MENU_PAGE_DEV_MOVEMENT else MENU_DEV_WEIGHTS_TITLE(viewer))))
#!define MENU_BODY(viewer) MENU_MAIN_BODY(viewer) if viewer.menu == MENU_PAGE_MAIN else (MENU_HERO_BODY(viewer) if viewer.menu == MENU_PAGE_HERO else (MENU_DEV_ADMIN_BODY(viewer) if viewer.menu == MENU_PAGE_DEV_ADMIN else (MENU_DEV_MOVEMENT_BODY(viewer) if viewer.menu == MENU_PAGE_DEV_MOVEMENT else MENU_DEV_WEIGHTS_BODY(viewer))))
