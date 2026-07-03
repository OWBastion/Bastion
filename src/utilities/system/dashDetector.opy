#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "System"

rule "Enable phase trigger":
    @Event eachPlayer
    @Team 1
    @Condition vishkarEventActivated == true
    @Condition eventPlayer.hasSpawned() == true
    # 只有当它是 False 时才触发，避免重复触发
    @Condition eventPlayer.phaseState == false 
    @Condition any([
        # Group 0: 技能 1
        (eventPlayer.getHero() in phaseHero[0] and eventPlayer.isUsingAbility1()),
        # Group 1: 技能 2
        (eventPlayer.getHero() in phaseHero[1] and eventPlayer.isUsingAbility2()),
        # Group 2: 右键
        (eventPlayer.getHero() in phaseHero[2] and eventPlayer.isFiringSecondaryFire()),
        # Group 3: 跳跃 (检测按住)
        (eventPlayer.getHero() in phaseHero[3] and eventPlayer.isHoldingButton(Button.JUMP)),
        # Special: 布里吉塔 (举盾+左键 = 盾击)
        (isHero(eventPlayer, Hero.BRIGITTE) and eventPlayer.isFiringSecondaryFire() and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)),
        # 近战（禅雅塔）
        (eventPlayer.getHero() in phaseHero[4] and eventPlayer.zenSnapKick)
    ]) == true
    
    eventPlayer.phaseState = true
    # 强制维持至少 0.1 秒，确保事件规则能检测到
    wait(0.096)


rule "Disable phase trigger":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.phaseState == true
    # 当所有条件都不满足时
    @Condition any([
        (eventPlayer.getHero() in phaseHero[0] and eventPlayer.isUsingAbility1()),
        (eventPlayer.getHero() in phaseHero[1] and eventPlayer.isUsingAbility2()),
        (eventPlayer.getHero() in phaseHero[2] and eventPlayer.isFiringSecondaryFire()),
        (eventPlayer.getHero() in phaseHero[3] and eventPlayer.isHoldingButton(Button.JUMP)),
        (isHero(eventPlayer, Hero.BRIGITTE) and eventPlayer.isFiringSecondaryFire() and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)),
        (eventPlayer.getHero() in phaseHero[4] and eventPlayer.zenSnapKick)
    ]) == false
    
    wait()
    eventPlayer.phaseState = false
