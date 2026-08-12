#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 花冈":
     @Condition (__currentMap___ == Map.HANAOKA or __currentMap___ == 2601) == true
     @Condition platformMapRevisionLoaded == false
    
     platformMapRevisionMapId = "map.hanaoka"
     platformMapRevisionVariant = null
     applyPlatformMapRevision()
     __currentMapText___ = "花冈"
     __currentMapPioneerText___ = __currentMapText___
     if not platformMapRevisionDataError:
         startForcingSpawn(Team.1, 2)
         waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
