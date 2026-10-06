#!mainFile "../../devMain.opy"

# Source: https://github.com/Overwatch-1-Emulator/ow1-emulator/blob/staging/src/utilities/macro_functions.opy

# Macro function for retrieving id of hero
macro heroID(h):
    getAllHeroes().index(h)

# Check if player is playing hero
macro isHero(player, hero):
    (player.getHero() == hero)

# Canonical player key/index access for save data.
macro Player.key = "{0}".format(self)
macro Player.inSaved(saved):
    self.key in saved

macro Player.savedIndex(saved):
    saved.index(self.key)

macro Player.hasPossessTarget(possess):
    possess != null and possess[0] != null and entityExists(possess[0])

macro Player.anchorPos(possess):
    possess[0].getPosition() if self.hasPossessTarget(possess) else self.getPosition()

# Macro function for converting decimal to percent
macro percent(p):
    100*(p)

# Macro function for converting negative number to number
macro negToPos(n):
    n * -1

# Macro function for converting percent to decimal 
macro unpercent(p):
    (p)/100

# Macro function for converting decimal to percent
macro roundedPercent(p):
    round(percent(p))

# Macro function for computing a percent of number
macro percentOf(p, n):
    (p)/100*(n)

macro Number.percentOf(p):
    self * (p) / 100

macro Number.scaledBy(factor):
    self * factor

macro Number.isAtMostPercentOf(p, base):
    self <= base.percentOf(p)

macro Number.isAbovePercentOf(p, base):
    self > base.percentOf(p)

macro Player.maxHealthPercent(percent):
    self.getMaxHealth().percentOf(percent)

macro Player.healthAtMostPercent(percent):
    self.getHealth().isAtMostPercentOf(percent, self.getMaxHealth())

macro Player.healthAbovePercent(percent):
    self.getHealth().isAbovePercentOf(percent, self.getMaxHealth())

macro Player.untargetable():
    self.hasStatus(Status.INVINCIBLE) or self.hasStatus(Status.UNKILLABLE) or self.hasStatus(Status.PHASED_OUT)

macro ratioPercent(value, baseValue):
    percent((value) / (baseValue))

# Convert angle in degrees to radians
macro toRadians(deg):
    (Math.PI/180)*deg

macro Array.first():
    self[0]
