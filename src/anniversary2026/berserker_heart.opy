#!mainFile "../anniversary2026.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "BerserkerHeart"

## 狂暴之心：周年模式堡垒全程狂暴
## 复用盛宴狂暴状态机（hasNano / berserkerTime）；nano.opy 每 60 秒自清一次、
## 狂欢盛宴计时器持续衰减 berserkerTime，本闩锁在条件侧侦测掉态后补回。
#!define BERSERKER_HEART_DURATION 9999

rule "Latch berserk on Bastion bots":
    @Condition false in getPlayersOnHero(Hero.BASTION, Team.1).hasNano

    getPlayersOnHero(Hero.BASTION, Team.1).hasNano = true
    berserkerTime = BERSERKER_HEART_DURATION
