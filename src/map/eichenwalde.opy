#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - eichenwalde":
    @Condition (__currentMap___ == Map.EICHENWALDE or __currentMap___ == 565) == true
    
    masteryRunCode = ""