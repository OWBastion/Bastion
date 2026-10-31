#!mainFile "../main.opy"

#!optimizeStrict

subroutine refreshCompatibleEventPool

#!define EVENT_GROUP_PHASE_TRIGGER [EventId.PHASE_SURGE, EventId.BODYGUARD]
#!define EVENT_GROUP_ULT_SUSTAIN [EventId.ULT_MOMENTUM, EventId.VALKYRIE_DESCENT]

# 大招没有可持续状态的英雄；暂定名单，补全英雄大招数据前人工维护。
#!define ULT_NO_SUSTAIN_HEROES [Hero.HANZO, Hero.LIFEWEAVER, Hero.JUNKRAT, Hero.BASTION, Hero.CASSIDY, Hero.PHARAH, Hero.REAPER, Hero.TRACER]

macro Player.supportsPhaseTrigger():
    any([
        self.getHero() in phaseHero[0],
        self.getHero() in phaseHero[1],
        self.getHero() in phaseHero[2],
        self.getHero() in phaseHero[3],
        isHero(self, Hero.BRIGITTE),
        self.getHero() in phaseHero[4]
    ])

# 当前英雄不兼容的全部事件组；新增结构兼容组只在此追加一项。
macro Player.incompatibleEventIds():
    (EVENT_GROUP_PHASE_TRIGGER if self.supportsPhaseTrigger() == false else []).concat(
        EVENT_GROUP_ULT_SUSTAIN if self.getHero() in ULT_NO_SUSTAIN_HEROES else []
    )

def refreshCompatibleEventPool():
    @Name "[VishkarEvent]: refresh player compatible event pool"

    waitUntil(all([eventPlayer.joinTime != null, vishkarEventActivated == true, phaseHero[0] != null, eventCatalogId != null]), 125)
    if all([eventPlayer.joinTime != null, vishkarEventActivated == true, phaseHero[0] != null, eventCatalogId != null]) == false:
        return
    eventPlayer.eventCompatibleBasePool = eventCatalogId
    eventPlayer.eventCompatibleBasePool.remove(eventPlayer.incompatibleEventIds())
    waitLoadBrief()


rule "initialize player compatible event pool":
    @Event playerJoined
    @Team 1

    refreshCompatibleEventPool()
