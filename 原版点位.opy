settings
{
	main
	{
		Description: "<FGc236ccFF>Ramattra + Shambali Monastery added!\n<FGFFFFFFFF>Work together to sneak past the Bastion prison guards and reach the end of the map to escape as every hero, each time a little harder.\nBastion Escape 2/Prison Escape/CCTV, but fixed for OW2.\n\nCredits included in spawn room.\nVersion 1.2.1 (Jan 14th, 2023)"
		Mode Name: "<FGed6516FF>OW2 Bastion Escape"
	}

	lobby
	{
		Allow Players Who Are In Queue: Yes
		Map Rotation: After A Game
		Match Voice Chat: Enabled
		Max Spectators: 12
		Max Team 1 Players: 10
		Max Team 2 Players: 0
		Return To Lobby: Never
	}

	modes
	{
		Skirmish
		{
			enabled maps
			{
				Blizzard World 0
				Dorado 0
				Eichenwalde 0
				Havana 0
				Hollywood 0
				Horizon Lunar Colony 0
				Junkertown 0
				King's Row 0
				Numbani 0
				Paraíso 0
				Paris 0
				Rialto 0
				Route 66 0
				Shambali Monastery 0
				Temple of Anubis 0
				Volskaya Industries 0
				Watchpoint: Gibraltar 0
			}
		}

		General
		{
			Enemy Health Bars: Off
			Game Mode Start: Manual
			Health Pack Respawn Time Scalar: 20%
			Hero Limit: Off
			Respawn Time Scalar: 20%
		}
	}

	heroes
	{
		Team 1
		{
			Ability Cooldown Time: 30%

			Bastion
			{
				Health: 150%
			}
		}

		Team 2
		{
			Ability Cooldown Time: 0%
			Damage Received: 10%
			Health: 500%

			Bastion
			{
				Health: 500%
				No Ammunition Requirement: On
			}
		}

		General
		{
			No Ammunition Requirement: On
			Ultimate Generation - Combat: 0%
			Ultimate Generation - Passive: 0%

			Ana
			{
				Sleep Dart Cooldown Time: 67%
			}

			Ashe
			{
				Coach Gun Cooldown Time: 40%
				Dynamite Cooldown Time: 50%
			}

			Baptiste
			{
				Healing Received: 50%
				Health: 25%
				Immortality Field Cooldown Time: 20%
				Projectile Gravity: 0%
				Projectile Speed: 500%
			}

			Brigitte
			{
				Barrier Shield Recharge Rate: 500%
				Shield Bash Cooldown Time: 120%
			}

			Cassidy
			{
				Combat Roll Cooldown Time: 50%
			}

			D.Va
			{
				Boosters Cooldown Time: 125%
			}

			Doomfist
			{
				Power Block Cooldown Time: 50%
				Rocket Punch Cooldown Time: 80%
				Seismic Slam Cooldown Time: 80%
			}

			Echo
			{
				Flight Cooldown Time: 33%
			}

			Genji
			{
				Deflect Cooldown Time: 75%
			}

			Hanzo
			{
				Lunge Cooldown Time: 60%
				Sonic Arrow Cooldown Time: 0%
			}

			Mei
			{
				Ice Wall Cooldown Time: 67%
			}

			Mercy
			{
				Guardian Angel Cooldown Time: 67%
			}

			Moira
			{
				Biotic Orb Max Healing Scalar: 500%
				Fade Cooldown Time: 50%
			}

			Orisa
			{
				Fortify Cooldown Time: 50%
				Javelin Spin Cooldown Time: 70%
			}

			Reinhardt
			{
				Charge Cooldown Time: 75%
			}

			Roadhog
			{
				Take a Breather Cooldown Time: 50%
			}

			Sigma
			{
				Accretion Cooldown Time: 50%
				Experimental Barrier Cooldown Time: 50%
				Kinetic Grasp Cooldown Time: 75%
			}

			Sombra
			{
				Translocator Cooldown Time: 0%
			}

			Symmetra
			{
				Sentry Turret: Off
				Teleporter Cooldown Time: 50%
			}

			Torbjörn
			{
				Deploy Turret: Off
				Overload Cooldown Time: 20%
				Overload Duration Scalar: 40%
				Weapons Enabled: Forge Hammer Only
			}

			Tracer
			{
				Blink Cooldown Time: 50%
				Recall Cooldown Time: 50%
			}

			Winston
			{
				Barrier Projector Cooldown Time: 83%
				Jump Pack Cooldown Time: 80%
			}

			Wrecking Ball
			{
				Roll Always Active: On
			}

			Zarya
			{
				Jump Vertical Speed: 140%
				Particle Barrier Cooldown Time: 60%
				Particle Cannon Secondary Knockback Scalar: 200%
			}

			Zenyatta
			{
				Healing Dealt: 200%
				Health: 150%
				Orb of Discord: Off
			}
		}
	}

	extensions
	{
		Spawn More Dummy Bots
	}
}

variables
{
	global:
		0: bastionPosition
		1: heroRingPosition
		2: resetPosition
		3: creditsPosition
		4: endPosition
		5: heroList
		6: missingHeroes
		7: maxDeath
		8: I
		9: kills
		10: bastionBotTargetPrefer
		11: difficulty
		12: scoreboardArray
		13: firstPlace
		14: secondPlace
		15: thirdPlace
		16: textIDs
		17: savedIndex
		18: savedHero
		19: savedDeaths
		20: savedIsWinner
		21: savedSkipCount
		22: devList
		23: __currentMap__
		127: antiCrashActivated

	player:
		0: heroNumber
		1: progressionDeathCount
		2: skipCount
		3: isWinner
		4: invis
		5: anaSleepLimit
		6: temp
		7: attacker
		8: I
		9: target
		10: aimPosition
		11: turnSpeed
		12: tempAimPosition
		13: nearestTargetOutOfLoS
		14: dvaStart
		15: healID
		16: isInPosition
		17: rainbowOff
		18: runDeathCount
}

subroutines
{
	0: savePlayerData
	1: progressHero
}

rule("OverPy Map Detection")
{
	event
	{
		Ongoing - Global;
	}

	actions
	{
		If(Array Contains(Array(Map(Ayutthaya), Map(Black Forest), Map(Black Forest), Map(Blizzard World), Map(Blizzard World), Map(Busan),
			Map(Busan), Map(Busan), Map(Castillo), Map(Château Guillard), Map(Château Guillard), Map(Circuit royal), Map(Colosseo), Map(
			Dorado), Map(Ecopoint: Antarctica), Map(Ecopoint: Antarctica), Map(Eichenwalde), Map(Eichenwalde), Map(Esperança), Map(
			Hanamura), Map(Hanamura), Map(Havana), Map(Hollywood), Map(Hollywood), Map(Horizon Lunar Colony), Map(Ilios), Map(Ilios), Map(
			Ilios), Map(Ilios), Map(Junkenstein's Revenge), Map(Junkertown), Map(Kanezaka), Map(King's Row), Map(King's Row), Map(
			Lijiang Control Center), Map(Lijiang Control Center), Map(Lijiang Garden), Map(Lijiang Garden), Map(Lijiang Night Market), Map(
			Lijiang Night Market), Map(Lijiang Tower), Map(Lijiang Tower), Map(Malevento), Map(Midtown), Map(Necropolis), Map(Nepal), Map(
			Nepal), Map(Nepal), Map(Nepal), Map(Nepal), Map(New Queen Street), Map(Numbani), Map(Oasis), Map(Oasis), Map(Oasis), Map(
			Oasis), Map(Paraíso), Map(Paris), Map(Petra), Map(Practice Range), Map(Rialto), Map(Route 66), Map(Temple of Anubis), Map(
			Volskaya Industries), Map(Watchpoint: Gibraltar), Map(Workshop Chamber), Map(Workshop Expanse), Map(Workshop Expanse), Map(
			Workshop Green Screen), Map(Workshop Island), Map(Workshop Island), Map(Shambali Monastery)), Current Map));
			Global.__currentMap__ = Current Map;
			Abort;
		End;
		Global.__currentMap__ = Ray Cast Hit Position(Vector(500, 100, 500), Vector(-500, -100, -500), Null, Null, False);
		If(Global.__currentMap__ == Vector(0, 0, 0) || Global.__currentMap__ == Vector(-500, -100, -500));
			Global.__currentMap__ = Ray Cast Hit Position(Vector(30, 5, 0), Vector(-30, -10, -10), Null, Null, False);
			If(Global.__currentMap__ == Vector(-30, -10, -10));
				Global.__currentMap__ = Ray Cast Hit Position(Vector(200, 20, 100), Vector(100, -100, -100), Null, Null, False);
				If(Global.__currentMap__ == Vector(100, -100, -100));
					Global.__currentMap__ = Ray Cast Hit Position(Vector(300, 20, -100), Vector(300, -100, 100), Null, Null, False);
					If(Global.__currentMap__ == Vector(300, -100, 100));
						Global.__currentMap__ = Ray Cast Hit Position(Vector(50, 100, -150), Vector(-50, -100, -160), Null, Null, False);
						If(Global.__currentMap__ == Vector(-50, -100, -160));
							Global.__currentMap__ = Ray Cast Hit Position(Vector(0, 300, 340), Vector(0, -100, -300), Null, Null, False);
							If(Global.__currentMap__ == Vector(0, -100, -300));
								Global.__currentMap__ = Ray Cast Hit Position(Vector(140, 10, -240), Vector(200, -10, -300), Null, Null, False);
								If(Global.__currentMap__ == Vector(200, -10, -300));
									Global.__currentMap__ = Ray Cast Hit Position(Vector(-180, 30, 60), Vector(-180, -50, -60), Null, Null, False);
								End;
							End;
						End;
					End;
				End;
			End;
		End;
		Global.__currentMap__ = 100 * Round To Integer(Y Component Of(Global.__currentMap__), Up) + 10 * Round To Integer(X Component Of(
			Global.__currentMap__), To Nearest) + Round To Integer(Z Component Of(Global.__currentMap__), Down);
		If(Global.__currentMap__ == 10121);
			Global.__currentMap__ = Ray Cast Hit Position(Vector(-60, 20, -60), Vector(60, -10, 60), Null, Null, False);
			If(Global.__currentMap__ == Vector(60, -10, 60));
				Global.__currentMap__ = Ray Cast Hit Position(Vector(-180, -70, 60), Vector(-180, -100, -60), Null, Null, False);
			End;
			Global.__currentMap__ = 100 * Round To Integer(Y Component Of(Global.__currentMap__), Up) + 10 * Round To Integer(X Component Of(
				Global.__currentMap__), To Nearest) + Round To Integer(Z Component Of(Global.__currentMap__), Down);
		End;
	}
}

rule("Initialize global variables")
{
	event
	{
		Ongoing - Global;
	}

	actions
	{
		Global.maxDeath = 5;
		Global.bastionBotTargetPrefer = Workshop Setting Combo(Custom String("Game"), Custom String("Bastion Bot Target Prefer System"), 0,
			Array(Custom String("Dynamic"), Custom String("Nearest"), Custom String("Lowest Health")), 0);
		Global.difficulty = Workshop Setting Combo(Custom String("Game"), Custom String("Difficulty"), 1, Array(Custom String("Easy"),
			Custom String("Normal"), Custom String("Hard"), Custom String("Expert"), Custom String("Legendary")), 0);
		Global.savedIndex = Empty Array;
		Global.savedHero = Empty Array;
		Global.savedDeaths = Empty Array;
		Global.savedIsWinner = Empty Array;
		Global.savedSkipCount = Empty Array;
		Global.devList = Array(Custom String("EfeDursun125"), Custom String("WOBBLYOW"), Custom String("NOTBANANA"), Custom String(
			"REYDI"), Custom String("DATZENYAT"), Custom String("PirateBoot"), Custom String("BearWhoLived"));
	}
}

rule("save player data if the player has pa﻿ssed round 2")
{
	event
	{
		Subroutine;
		savePlayerData;
	}

	actions
	{
		Wait(Server Load / 100 * 0.500, Ignore Condition);
		If(Event Player.heroNumber > 2);
			"We're saving data as a string, because although we can't hold entity id's, we can hold entity names as string."
			If(!Array Contains(Global.savedIndex, Custom String("{0}", Event Player)));
				Modify Global Variable(savedIndex, Append To Array, Custom String("{0}", Event Player));
			End;
			Wait(Server Load / 100 * 0.500, Ignore Condition);
			Global.savedHero[Index Of Array Value(Global.savedIndex, Custom String("{0}", Event Player))] = Event Player.heroNumber;
			Wait(Server Load / 100 * 0.500, Ignore Condition);
			Global.savedDeaths[Index Of Array Value(Global.savedIndex, Custom String("{0}", Event Player))] = Event Player.runDeathCount;
			Wait(Server Load / 100 * 0.500, Ignore Condition);
			Global.savedIsWinner[Index Of Array Value(Global.savedIndex, Custom String("{0}", Event Player))] = Event Player.isWinner;
			Wait(Server Load / 100 * 0.500, Ignore Condition);
			Global.savedSkipCount[Index Of Array Value(Global.savedIndex, Custom String("{0}", Event Player))] = Event Player.skipCount;
			Small Message(Event Player, Custom String("your hero data is saved"));
			Wait(2, Ignore Condition);
			Small Message(Event Player, Custom String("if the match restarts, everyone's data will be lost!"));
		End;
	}
}

rule("add 1 to heroNumber, switch player to the newly unlocked hero, and set hero availability to that hero and all preceding")
{
	event
	{
		Subroutine;
		progressHero;
	}

	actions
	{
		Event Player.heroNumber += 1;
		Small Message(All Players(All Teams), Custom String("{0} unlocked {1}", Event Player, Hero Icon String(
			Global.heroList[Event Player.heroNumber])));
		Play Effect(Event Player, Buff Explosion Sound, Color(White), Position Of(Event Player), 200);
		Event Player.progressionDeathCount = 0;
		Wait(0.032, Ignore Condition);
		Start Forcing Player To Be Hero(Event Player, Global.heroList[Event Player.heroNumber]);
		Wait Until(Hero Of(Event Player) == Global.heroList[Event Player.heroNumber], 0.500);
		Stop Forcing Player To Be Hero(Event Player);
		Wait(Server Load / 100 * 0.500, Ignore Condition);
		Set Player Allowed Heroes(Event Player, Array Slice(Global.heroList, 0, Event Player.heroNumber + 1));
		Wait(Server Load / 100 * 0.500, Ignore Condition);
		Preload Hero(Event Player, Array(Global.heroList[Event Player.heroNumber + 1], Global.heroList[Event Player.heroNumber + 1]));
		Wait(Server Load / 100 * 0.500, Ignore Condition);
		Wait(3, Ignore Condition);
		Call Subroutine(savePlayerData);
		Wait(0.100, Ignore Condition);
	}
}

rule("map - b﻿lizzworld")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		(Global.__currentMap__ == Map(Blizzard World) || Global.__currentMap__ == 1228) == True;
	}

	actions
	{
		Global.bastionPosition[0] = Vector(-121.979, 0.148, 110.507);
		Global.bastionPosition[1] = Vector(-93.733, -1.047, 110.100);
		Global.bastionPosition[2] = Vector(-66.733, 7.079, 110.571);
		Global.bastionPosition[3] = Vector(-0.165, 7.421, 89.178);
		Global.bastionPosition[4] = Vector(3.082, 3.900, 43.609);
		Global.bastionPosition[5] = Vector(3.049, -4.850, 16.685);
		Global.endPosition = Vector(2.772, -6.500, -6.900);
		Global.heroRingPosition = Vector(-149.170, 0.830, 100.850);
		Global.resetPosition = Vector(-150.250, 0.830, 104.510);
		Global.creditsPosition = Vector(-170.800, 3.650, 96.450);
		Start Forcing Spawn Room(Team 1, 2);
	}
}

rule("map - dorado")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Global.__currentMap__ == Map(Dorado);
	}

	actions
	{
		Global.bastionPosition = Vector(170.288, 19.100, 45.051);
		Modify Global Variable(bastionPosition, Append To Array, Vector(118.262, 18.250, 1.209));
		Modify Global Variable(bastionPosition, Append To Array, Vector(78.973, 17.480, -6.843));
		Modify Global Variable(bastionPosition, Append To Array, Vector(34.074, 11.080, -17.958));
		Modify Global Variable(bastionPosition, Append To Array, Vector(26.361, 10.650, 20.115));
		Modify Global Variable(bastionPosition, Append To Array, Vector(126.713, 16.300, 17.517));
		Global.endPosition = Vector(16.012, Empty Array, 5.874);
		Global.heroRingPosition = Vector(182.470, 7.040, 42.270);
		Global.resetPosition = Vector(183.300, 7.040, 37.960);
		Global.creditsPosition = Vector(197.720, 10.010, 44.630);
		Start Forcing Spawn Room(Team 1, 1);
	}
}

rule("map - eichenwalde")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		(Global.__currentMap__ == Map(Eichenwalde) || Global.__currentMap__ == 565) == True;
	}

	actions
	{
		Global.bastionPosition[0] = Vector(123.333, 8.971, -27.303);
		Global.bastionPosition[1] = Vector(89.318, 21.095, -62.697);
		Global.bastionPosition[2] = Vector(37.930, 12.620, -79.920);
		Global.bastionPosition[3] = Vector(23.799, 7.417, -53.839);
		Global.bastionPosition[4] = Vector(-4.858, 6.957, -31.559);
		Global.bastionPosition[5] = Vector(25.587, 6.300, -14.531);
		Global.endPosition = Vector(-10.354, -2.149, -12.399);
		Global.heroRingPosition = Vector(131.335, 10.720, 1.098);
		Global.resetPosition = Vector(128.060, 10.720, 1.840);
		Global.creditsPosition = Vector(132.820, 13.720, 9.040);
		Start Forcing Spawn Room(Team 1, 2);
	}
}

rule("map - havana")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Global.__currentMap__ == Map(Havana);
	}

	actions
	{
		Global.bastionPosition[0] = Vector(117.332, 14.433, -58.091);
		Global.bastionPosition[1] = Vector(140.438, 6.413, -16.667);
		Global.bastionPosition[2] = Vector(31.288, 18.900, -75.331);
		Global.bastionPosition[3] = Vector(-32.514, 7.150, -79.487);
		Global.bastionPosition[4] = Vector(14.787, 7.300, -47.470);
		Global.bastionPosition[5] = Vector(-71.110, 5.846, -72.362);
		Global.endPosition = Vector(-71.203, 2, -50.678);
		Global.heroRingPosition = Vector(158.256, 11, -47.739);
		Global.resetPosition = Vector(158.300, 11, -44.350);
		Global.creditsPosition = Vector(193.450, 13.250, -46.490);
		Start Forcing Spawn Room(Team 1, 2);
	}
}

rule("map - hollywood")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Global.__currentMap__ == Map(Hollywood);
	}

	actions
	{
		Global.bastionPosition[0] = Vector(-26.166, 7.503, -134.609);
		Global.bastionPosition[1] = Vector(-2.241, 12.161, -112.505);
		Global.bastionPosition[2] = Vector(11.552, 6.303, -69.943);
		Global.bastionPosition[3] = Vector(-7.480, 7.441, -43.441);
		Global.bastionPosition[4] = Vector(-20.714, 8.050, 9.977);
		Global.bastionPosition[5] = Vector(4.864, 7.147, 38.401);
		Global.endPosition = Vector(-12.002, -1.307, 69.489);
		Global.heroRingPosition = Vector(-27.291, 3.920, -156.654);
		Global.resetPosition = Vector(-23.640, 3.920, -157.440);
		Global.creditsPosition = Vector(-31.650, 8.960, -175.050);
		Start Forcing Spawn Room(Team 1, 2);
	}
}

rule("map - horizon lunar colony")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Global.__currentMap__ == Map(Horizon Lunar Colony);
	}

	actions
	{
		Global.bastionPosition[0] = Vector(-15.287, 6, -127.244);
		Global.bastionPosition[1] = Vector(16.250, 11.860, -106.756);
		Global.bastionPosition[2] = Vector(64.269, 16, -74.726);
		Global.bastionPosition[3] = Vector(33.705, 7.590, -41.578);
		Global.bastionPosition[4] = Vector(19.496, 9, -1.439);
		Global.bastionPosition[5] = Vector(66.687, 8.520, -37.241);
		Global.endPosition = Vector(34.476, 12, -23.518);
		Global.heroRingPosition = Vector(-41.390, 5, -159.030);
		Global.resetPosition = Vector(-45.620, 5, -156.870);
		Global.creditsPosition = Vector(-55.870, 7.680, -171.970);
		Start Forcing Spawn Room(Team 1, 0);
	}
}

rule("map - junkerto﻿wn")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Global.__currentMap__ == Map(Junkertown);
	}

	actions
	{
		Global.bastionPosition = Vector(-96.235, 13.672, -136.725);
		Modify Global Variable(bastionPosition, Append To Array, Vector(-72.634, 6.669, -145.321));
		Modify Global Variable(bastionPosition, Append To Array, Vector(-27.431, 13.480, -100.155));
		Modify Global Variable(bastionPosition, Append To Array, Vector(-32.236, 12.976, -29.143));
		Modify Global Variable(bastionPosition, Append To Array, Vector(-2.080, 11.366, -61.807));
		Modify Global Variable(bastionPosition, Append To Array, Vector(30.116, 13.407, -59.880));
		Global.endPosition = Vector(30.248, 5.515, -81.733);
		Global.heroRingPosition = Vector(-88.030, 11.220, -88);
		Global.resetPosition = Vector(-103.910, 11.690, -86.600);
		Global.creditsPosition = Vector(-92.710, 14.040, -73.790);
		Start Forcing Spawn Room(Team 1, 2);
	}
}

rule("map - king's row")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		(Global.__currentMap__ == Map(King's Row) || Global.__currentMap__ == 742) == True;
	}

	actions
	{
		Global.bastionPosition = Vector(-143.900, 7.130, 10.150);
		Modify Global Variable(bastionPosition, Append To Array, Vector(-120.990, 1.070, -12.080));
		Modify Global Variable(bastionPosition, Append To Array, Vector(-91.380, 1.140, -27.900));
		Modify Global Variable(bastionPosition, Append To Array, Vector(-55.460, -0.200, -29.830));
		Modify Global Variable(bastionPosition, Append To Array, Vector(5.980, 6.110, -30.350));
		Modify Global Variable(bastionPosition, Append To Array, Vector(-21.560, 2.580, -8.160));
		Global.endPosition = Vector(-1.900, 5, -0.290);
		Global.heroRingPosition = Vector(-176.048, -0.070, 36.540);
		Global.resetPosition = Vector(-175.230, -0.070, 43.030);
		Global.creditsPosition = Vector(-185.560, 2.930, 38.320);
		Start Forcing Spawn Room(Team 1, 1);
	}
}

rule("map - numbani")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Global.__currentMap__ == Map(Numbani);
	}

	actions
	{
		Global.bastionPosition[0] = Vector(179.102, 4.250, 13.115);
		Global.bastionPosition[1] = Vector(154.224, -4.180, 13.616);
		Global.bastionPosition[2] = Vector(118.815, 4.250, 3.556);
		Global.bastionPosition[3] = Vector(78.459, 6.250, -11.527);
		Global.bastionPosition[4] = Vector(-49.872, 11.283, -43.701);
		Global.bastionPosition[5] = Vector(7.964, 1.270, -6.488);
		Global.endPosition = Vector(6.984, -1, 5.778);
		Global.heroRingPosition = Vector(245.030, 0.200, 24.420);
		Global.resetPosition = Vector(245.030, 0.200, 20.420);
		Global.creditsPosition = Vector(254.540, 3.200, 22.870);
		Start Forcing Spawn Room(Team 1, 1);
	}
}

rule("map - paraiso")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Global.__currentMap__ == Map(Paraíso);
	}

	actions
	{
		Global.bastionPosition = Empty Array;
		Modify Global Variable(bastionPosition, Append To Array, Vector(-47.030, 6.860, -141.730));
		Modify Global Variable(bastionPosition, Append To Array, Vector(5.220, 12, -122));
		Modify Global Variable(bastionPosition, Append To Array, Vector(10.140, 3.900, -57.320));
		Modify Global Variable(bastionPosition, Append To Array, Vector(-23.510, 10.110, -48.500));
		Modify Global Variable(bastionPosition, Append To Array, Vector(11.420, 5.100, -24.260));
		Modify Global Variable(bastionPosition, Append To Array, Vector(-6.880, 0.500, 26.090));
		Global.endPosition = Vector(-30.920, 3.300, 21.460);
		Global.heroRingPosition = Vector(-78.250, 6.330, -167.960);
		Global.resetPosition = Vector(-78.300, 5.030, -170.800);
		Global.creditsPosition = Vector(-70.200, 7.750, -183.140);
		Start Forcing Spawn Room(Team 1, 2);
	}
}

rule("map - paris")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Global.__currentMap__ == Map(Paris);
	}

	actions
	{
		Global.bastionPosition = Vector(-95.984, 13.454, -83.535);
		Modify Global Variable(bastionPosition, Append To Array, Vector(-72.132, 11.976, -44.042));
		Modify Global Variable(bastionPosition, Append To Array, Vector(-41.725, 13.990, -2.920));
		Modify Global Variable(bastionPosition, Append To Array, Vector(20, 10.030, -38.500));
		Modify Global Variable(bastionPosition, Append To Array, Vector(-14.721, 14.250, -35.219));
		Modify Global Variable(bastionPosition, Append To Array, Vector(0.211, 10.174, -60.874));
		Global.endPosition = Vector(9.563, 8.329, -59.980);
		Global.heroRingPosition = Vector(-109.263, 15.300, -111.151);
		Global.resetPosition = Vector(-115.030, 15.970, -122.820);
		Global.creditsPosition = Vector(-119.740, 19, -132.450);
		Start Forcing Spawn Room(Team 1, 1);
	}
}

rule("map - rialto")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Global.__currentMap__ == Map(Rialto);
	}

	actions
	{
		Global.bastionPosition[0] = Vector(-64.421, 5.040, -125.927);
		Global.bastionPosition[1] = Vector(-16.976, 1.660, -38.459);
		Global.bastionPosition[2] = Vector(-36.002, 4.750, -77.344);
		Global.bastionPosition[3] = Vector(59.058, 0.070, -8.103);
		Global.bastionPosition[4] = Vector(54.797, 1.740, -59.938);
		Global.bastionPosition[5] = Vector(87.874, -0.370, 0.268);
		Global.endPosition = Vector(98.662, -1.500, -21.009);
		Global.heroRingPosition = Vector(-54.920, 3.750, -158.320);
		Global.resetPosition = Vector(-59.050, 3.750, -158.410);
		Global.creditsPosition = Vector(-57.060, 5.250, -181.510);
		Start Forcing Spawn Room(Team 1, 2);
	}
}

rule("map - route 66")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Global.__currentMap__ == Map(Route 66);
	}

	actions
	{
		Global.bastionPosition[0] = Vector(-95.624, 12.660, -5.541);
		Global.bastionPosition[1] = Vector(-38.680, 12.750, -22.136);
		Global.bastionPosition[2] = Vector(-15.784, 8.540, -12.685);
		Global.bastionPosition[3] = Vector(36.467, 2.140, -4.003);
		Global.bastionPosition[4] = Vector(48.707, 10.110, 25.063);
		Global.bastionPosition[5] = Vector(26.871, 7.010, 2.468);
		Global.endPosition = Vector(47.956, 5.200, 47.318);
		Global.heroRingPosition = Vector(-115.228, 5.799, -49.590);
		Global.resetPosition = Vector(-115.010, 4.500, -46.010);
		Global.creditsPosition = Vector(-113.270, 7.500, -63.140);
		Start Forcing Spawn Room(Team 1, 1);
	}
}

rule("map - shambali monastery")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Global.__currentMap__ == Map(Shambali Monastery);
	}

	actions
	{
		Global.bastionPosition = Empty Array;
		Modify Global Variable(bastionPosition, Append To Array, Vector(-37.100, 28.400, 192.320));
		Modify Global Variable(bastionPosition, Append To Array, Vector(-13.270, 25.500, 146.040));
		Modify Global Variable(bastionPosition, Append To Array, Vector(-57.820, 29, 122.100));
		Modify Global Variable(bastionPosition, Append To Array, Vector(-18.190, 23.250, 88.510));
		Modify Global Variable(bastionPosition, Append To Array, Vector(11.100, 15.500, 40.100));
		Modify Global Variable(bastionPosition, Append To Array, Vector(-16.060, 6.180, 12));
		Global.endPosition = Vector(5.450, 9, 17.500);
		Global.heroRingPosition = Vector(-7.690, 31.070, 226.970);
		Global.resetPosition = Vector(-1.970, 31.070, 221.850);
		Global.creditsPosition = Vector(1.750, 35, 232.500);
		Start Forcing Spawn Room(Team 1, 2);
	}
}

rule("map - temple of anubis")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Global.__currentMap__ == Map(Temple of Anubis);
	}

	actions
	{
		Global.bastionPosition = Vector(-17.188, 11.237, 105.646);
		Modify Global Variable(bastionPosition, Append To Array, Vector(-12.218, 10.667, 52.835));
		Modify Global Variable(bastionPosition, Append To Array, Vector(-58.847, 6.810, 41.419));
		Modify Global Variable(bastionPosition, Append To Array, Vector(-8.454, 1.153, 29.868));
		Modify Global Variable(bastionPosition, Append To Array, Vector(8.482, 4.898, 10.299));
		Modify Global Variable(bastionPosition, Append To Array, Vector(-23.218, 2.706, -26.863));
		Global.endPosition = Vector(-0.866, -3.781, -10.919);
		Global.heroRingPosition = Vector(-7.969, 4.701, 137.390);
		Global.resetPosition = Vector(-17.160, 4.460, 137.760);
		Global.creditsPosition = Vector(-11.300, 7.350, 149.110);
		Start Forcing Spawn Room(Team 1, 1);
	}
}

rule("map - volskaya industries")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Global.__currentMap__ == Map(Volskaya Industries);
	}

	actions
	{
		Global.bastionPosition[0] = Vector(-87.972, 2.020, 38.919);
		Global.bastionPosition[1] = Vector(-67.835, 10.390, 49.479);
		Global.bastionPosition[2] = Vector(-63.809, -0.410, 77.730);
		Global.bastionPosition[3] = Vector(-11.250, 1.270, 76.356);
		Global.bastionPosition[4] = Vector(-16.279, 2.200, 41.017);
		Global.bastionPosition[5] = Vector(-6.364, 8.240, 35.514);
		Global.endPosition = Vector(-11.477, -6, 19.868);
		Global.heroRingPosition = Vector(-113.051, -1.980, 31.996);
		Global.resetPosition = Vector(-115.180, -1.980, 35.240);
		Global.creditsPosition = Vector(-128.250, 0.500, 24.750);
		Start Forcing Spawn Room(Team 1, 0);
	}
}

rule("map - watchpoint gibraltar")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Global.__currentMap__ == Map(Watchpoint: Gibraltar);
	}

	actions
	{
		Global.bastionPosition[0] = Vector(70.099, 9, 26.803);
		Global.bastionPosition[1] = Vector(81.759, 6, 3.200);
		Global.bastionPosition[2] = Vector(64.465, 9.690, -32.138);
		Global.bastionPosition[3] = Vector(32.373, 3, -50.866);
		Global.bastionPosition[4] = Vector(31.113, 7.300, -89.871);
		Global.bastionPosition[5] = Vector(41.383, 4, -124.788);
		Global.endPosition = Vector(46.558, 1, -146.808);
		Global.heroRingPosition = Vector(80.213, -9.980, 46.632);
		Global.resetPosition = Vector(75.310, -9.050, 38.500);
		Global.creditsPosition = Vector(95.090, -6, 54.500);
		Start Forcing Spawn Room(Team 1, 2);
	}
}

rule("bastion init position, unkillable status, and damage dealt scaling with difficulty setting")
{
	event
	{
		Ongoing - Each Player;
		Team 2;
		Bastion;
	}

	conditions
	{
		Is Alive(Event Player) == True;
		Has Spawned(Event Player) == True;
	}

	actions
	{
		Wait(0.250, Ignore Condition);
		Set Damage Dealt(Event Player, 100 + 50 * Global.difficulty);
		Teleport(Event Player, Global.bastionPosition[Slot Of(Event Player)]);
		If(!Has Status(Event Player, Unkillable));
			Set Status(Event Player, Null, Unkillable, 99999);
	}
}

rule("set hero list")
{
	event
	{
		Ongoing - Global;
	}

	actions
	{
		"make default hero list, which includes all 36 heroes available in Season 2"
		Global.heroList = Array(Hero(Sombra), Hero(Reaper), Hero(Moira), Hero(Kiriko), Hero(Sigma), Hero(Genji), Hero(Orisa), Hero(
			Symmetra), Hero(Winston), Hero(D.Va), Hero(Tracer), Hero(Widowmaker), Hero(Sojourn), Hero(Baptiste), Hero(Mei), Hero(Echo),
			Hero(Brigitte), Hero(Soldier: 76), Hero(Wrecking Ball), Hero(Cassidy), Hero(Zarya), Hero(Lúcio), Hero(Junkrat), Hero(Pharah),
			Hero(Mercy), Hero(Reinhardt), Hero(Hanzo), Hero(Doomfist), Hero(Roadhog), Hero(Junker Queen), Hero(Ashe), Hero(Torbjörn), Hero(
			Ana), Hero(Zenyatta), Hero(Bastion));
		"remove all heroes that are not for some reason in Overwatch's list of all the heroes (at the time of making this, Mei is an example because she was removed to be patched)"
		Modify Global Variable(heroList, Remove From Array By Value, Filtered Array(Global.heroList, !Array Contains(All Heroes,
			Current Array Element)));
		"add any heroes that for some reason are on Overwatch's list but not the game's (eg if I don't update the mode after a hero release). they are added as the second hero in the list"
		If(Is True For Any(All Heroes, !Array Contains(Global.heroList, Current Array Element)));
			Global.missingHeroes = Filtered Array(All Heroes, !Array Contains(Global.heroList, Current Array Element));
			For Global Variable(I, 0, Count Of(Global.missingHeroes), 1);
				Global.heroList = Sorted Array(Append To Array(Global.heroList, Global.missingHeroes[Global.I]),
					Current Array Element != Global.missingHeroes[Global.I] ? Current Array Index : 0.500);
				Wait(0.016, Ignore Condition);
			End;
		End;
		"move Bastion to the end of the hero list, and keep the rest of the list how it is"
		Global.heroList = Sorted Array(Global.heroList, Current Array Index + Count Of(Global.heroList) * (Current Array Element == Hero(
			Bastion)));
	}
}

rule("infinite match time")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Is In Setup == False;
	}

	actions
	{
		Disable Inspector Recording;
		Disable Built-In Game Mode Completion;
		Disable Built-In Game Mode Announcer;
		Disable Built-In Game Mode Music;
		Disable Built-In Game Mode Scoring;
		Wait(1, Ignore Condition);
		Pause Match Time;
		Set Slow Motion(90);
	}
}

rule("if someone starts the game mode, restart the match")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Current Game Mode != Game Mode(Skirmish);
		(Is In Setup || Is Assembling Heroes || Is Game In Progress) == True;
	}

	actions
	{
		Disable Built-In Game Mode Announcer;
		Wait(0.016, Ignore Condition);
		Destroy All Dummy Bots;
		Destroy All Effects;
		Destroy All HUD Text;
		Destroy All Icons;
		Destroy All In-World Text;
		Destroy All Progress Bar HUD Text;
		Wait(0.016, Ignore Condition);
		Disable Messages(All Players(Team 1));
		Disable Game Mode HUD(All Players(Team 1));
		Disable Game Mode In-World UI(All Players(Team 1));
		Disable Built-In Game Mode Respawning(All Players(Team 1));
		Unpause Match Time;
		While(!Is Game In Progress);
			Set Match Time(0);
			Wait(0.016, Ignore Condition);
		End;
		Create Icon(All Players(Team 1), Vector(0, 101, -0.250), Warning, Color, Custom Color(220 + Sine From Radians(
			Total Time Elapsed * 3.141) * 35, 0, 0, 255), False);
		Create In-World Text(All Players(Team 1), Custom String(
			"host started the game mode.\nthis breaks bastion escape.\n\n                      Restarting..."), Vector(0, 101, 0), 3,
			Do Not Clip, Color, Custom Color(220 + Sine From Radians(Total Time Elapsed * 3.141) * 35, 0, 0, 255), Visible Always);
		For Global Variable(I, 0, 5, 1);
			Create Effect(All Players(Team 1), Orb, Color(Black), Vector(0, 100 + 0.500 * (Global.I + 1) / 5, 0), 2 + 2 * (Global.I + 5),
				None);
			Create Effect(All Players(Team 1), Sphere, Color(Black), Vector(0, 100, 0), 2 + 2 * (Global.I + 5), None);
			Create Effect(All Players(Team 1), Bad Aura, Color(Black), Vector(0, 100 + 3 * (Global.I + 1) / 5, 0), 2 + 2 * (Global.I + 5),
				None);
			Wait(0.016, Ignore Condition);
		End;
		Start Forcing Player To Be Hero(All Players(Team 1), Hero(Sombra));
		Wait(0.016, Ignore Condition);
		Kill(All Players(Team 1), Host Player);
		Disable Hero HUD(All Players(Team 1));
		Start Camera(All Players(Team 1), Vector(0, 100, 0), Vector(0, 101, 0.010), 0);
		Wait(5, Ignore Condition);
		Enable Built-In Game Mode Music;
		Declare Team Victory(Team 2);
		Destroy All In-World Text;
		Destroy All Icons;
		Wait(2, Ignore Condition);
		Wait Until(Total Time Elapsed > 30, 30);
		Restart Match;
	}
}

rule("create bastion bots")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Number Of Players(Team 2) < Count Of(Global.bastionPosition);
	}

	actions
	{
		Destroy All Dummy Bots;
		While(Number Of Players(Team 2) < Count Of(Global.bastionPosition));
			Create Dummy Bot(Hero(Bastion), Team 2, -1, Random Value In Array(Spawn Points(Team 2)), Vector(0, 0, 0));
			Wait(0.250, Ignore Condition);
		End;
		If(Global.kills == 0);
			Global.kills = Array(0, 0, 0, 0, 0, 0);
		End;
		Wait(2, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("bastions are numbered and list their kills (by changing their names when they spawn)")
{
	event
	{
		Player Joined Match;
		Team 2;
		All;
	}

	actions
	{
		Start Forcing Dummy Bot Name(Event Player, Custom String("BASTION {0} | KILLS: {1}", Slot Of(Event Player) + 1,
			Global.kills[Slot Of(Event Player)]));
	}
}

rule("damage modifier: players can't hurt bastions")
{
	event
	{
		Ongoing - Global;
	}

	actions
	{
		Start Damage Modification(All Players(Team 2), All Players(Team 1), 0.010, Receivers and Damagers);
	}
}

rule("anti crash")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Global.antiCrashActivated == False;
		Server Load > 230;
	}

	actions
	{
		Wait(1, Abort When False);
		Small Message(All Players(All Teams), Custom String("Anti crash system activated"));
		Set Slow Motion(20);
		Global.antiCrashActivated = True;
	}
}

rule("disable anti crash")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Global.antiCrashActivated != False;
		Server Load < 200;
	}

	actions
	{
		Set Slow Motion(90);
		Global.antiCrashActivated = False;
	}
}

rule("disable gamemode hud and player collision for all players")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		Has Spawned(Event Player) == True;
	}

	actions
	{
		Disable Game Mode HUD(Event Player);
		Disable Game Mode In-World UI(Event Player);
		Disable Movement Collision With Players(Event Player);
	}
}

rule("enemy bastions must stay in configuration: assault (AKA machine gun/sentry/alternate form)")
{
	event
	{
		Ongoing - Each Player;
		Team 2;
		Bastion;
	}

	conditions
	{
		Is In Alternate Form(Event Player) == False;
		Total Time Elapsed > 10;
	}

	actions
	{
		"this cancels bastion's \"standing up\" animation so he can sit back down faster"
		Cancel Primary Action(Event Player);
		Set Ability Cooldown(Event Player, Button(Ability 1), 0);
		Press Button(Event Player, Button(Ability 1));
		Wait(0.032, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("bastions periodically refresh their configuration when there are enemies nearby but out of sight")
{
	event
	{
		Ongoing - Each Player;
		Team 2;
		Bastion;
	}

	conditions
	{
		Total Time Elapsed > 10;
		Event Player.target == False;
		First Of(Players Within Radius(Position Of(Event Player), 80, Team 1, Off)) != False;
	}

	actions
	{
		Wait(Random Real(0.200, 1), Abort When False);
		Press Button(Event Player, Button(Ability 1));
		Wait(Random Real(1, 3), Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("bastion constantly searches for targets in line of sight")
{
	event
	{
		Ongoing - Each Player;
		Team 2;
		Bastion;
	}

	conditions
	{
		First Of(Players Within Radius(Eye Position(Event Player), 50, Team 1, Off)) != False;
	}

	actions
	{
		Event Player.temp = Filtered Array(All Living Players(Team 1), Is In Line of Sight(Eye Position(Event Player), Eye Position(
			Current Array Element), Barriers Do Not Block LOS) || Is In Line of Sight(Eye Position(Event Player), Position Of(
			Current Array Element), Barriers Do Not Block LOS));
		Wait(0.016, Ignore Condition);
		If(!Event Player.temp);
			Event Player.target = Null;
			Skip(8);
		End;
		Modify Player Variable(Event Player, temp, Remove From Array By Value, Filtered Array(Event Player.temp, !Has Spawned(
			Current Array Element) || Current Array Element.isWinner || Has Status(Current Array Element, Phased Out) || (Hero Of(
			Current Array Element) == Hero(Sombra) && Is Using Ability 1(Current Array Element))));
		Wait(0.016, Ignore Condition);
		If(Count Of(Event Player.temp) > 1);
			Event Player.temp = Sorted Array(Event Player.temp, Global.bastionBotTargetPrefer == 0 ? Health(Current Array Element)
				* Distance Between(Event Player, Current Array Element) : (Global.bastionBotTargetPrefer == 1 ? Distance Between(Event Player,
				Current Array Element) : Health(Current Array Element)));
			Wait(0.016, Ignore Condition);
		End;
		Event Player.target = First Of(Event Player.temp);
		Wait(Random Real(0.256, 0.512), Ignore Condition);
		Loop If Condition Is True;
		Event Player.target = Null;
	}
}

rule("bastion fires if he has a target")
{
	event
	{
		Ongoing - Each Player;
		Team 2;
		Bastion;
	}

	conditions
	{
		Evaluate Once(Is Dummy Bot(Event Player)) != False;
		Is Alive(Event Player) == True;
		Is Firing Primary(Event Player) == False;
		Event Player.target != False;
	}

	actions
	{
		Start Holding Button(Event Player, Button(Primary Fire));
		Wait(0.500, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("bastion stops firing when there aren't targets")
{
	event
	{
		Ongoing - Each Player;
		Team 2;
		Bastion;
	}

	conditions
	{
		Evaluate Once(Is Dummy Bot(Event Player)) != False;
		Event Player.target == False;
		Is Alive(Event Player) == True;
	}

	actions
	{
		Stop Holding Button(Event Player, Button(Primary Fire));
		Wait(1, Abort When False);
		Loop If(Is Firing Primary(Event Player));
	}
}

rule("bastion aims at whichever part of his target is most exposed")
{
	event
	{
		Ongoing - Each Player;
		Team 2;
		Bastion;
	}

	conditions
	{
		Evaluate Once(Is Dummy Bot(Event Player)) != False;
		Is Alive(Event Player) == True;
		Event Player.target != Null;
	}

	actions
	{
		Event Player.tempAimPosition = (Position Of(Event Player.target) + Eye Position(Event Player.target)) / 2;
		If(Is In Line of Sight(Eye Position(Event Player), Event Player.tempAimPosition, Barriers Do Not Block LOS));
			Event Player.aimPosition = Event Player.tempAimPosition;
		Else If(Is In Line of Sight(Eye Position(Event Player), Eye Position(Event Player.target), Barriers Do Not Block LOS));
			Event Player.aimPosition = Eye Position(Event Player.target);
		Else;
			Event Player.aimPosition = Position Of(Event Player.target);
		End;
		Wait(0.064, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("bastion places his crosshair near the closest potential target if he doesn't currently have one")
{
	event
	{
		Ongoing - Each Player;
		Team 2;
		Bastion;
	}

	conditions
	{
		Evaluate Once(Is Dummy Bot(Event Player)) != False;
		Is Alive(Event Player) == True;
		Event Player.target == False;
	}

	actions
	{
		Wait(Server Load / 100, Abort When False);
		Event Player.nearestTargetOutOfLoS = First Of(Sorted Array(Filtered Array(All Living Players(Team 1), Has Spawned(
			Current Array Element) && !Event Player.isWinner && !(Hero Of(Current Array Element) == Hero(Sombra) && Is Using Ability 1(
			Current Array Element))), Distance Between(Eye Position(Event Player), Eye Position(Current Array Element))));
		Skip If(Event Player.nearestTargetOutOfLoS == Null, 1);
		Event Player.aimPosition = Eye Position(Event Player.nearestTargetOutOfLoS) + Vector(Random Real(-1, 1), Random Real(-1, 1),
			Random Real(-1, 1));
		Wait(Random Real(1, 4), Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("determine bastion's aim speed, to improve smooth tracking")
{
	event
	{
		Ongoing - Each Player;
		Team 2;
		Bastion;
	}

	conditions
	{
		Evaluate Once(Is Dummy Bot(Event Player)) != False;
		Is Alive(Event Player) == True;
		Event Player.target != False;
	}

	actions
	{
		Event Player.turnSpeed = Angle Between Vectors(Facing Direction Of(Event Player), Direction Towards(Eye Position(Event Player),
			Eye Position(Event Player.target))) * 6;
		Event Player.turnSpeed += Speed Of(Event Player.target) * 6;
		Wait(Server Load Average / 1000, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("increase bastion's aim speed to prep for flicking to a target entering range")
{
	event
	{
		Ongoing - Each Player;
		Team 2;
		Bastion;
	}

	conditions
	{
		Evaluate Once(Is Dummy Bot(Event Player)) != False;
		Is Alive(Event Player) == True;
		Event Player.target == False;
		Angle Between Vectors(Facing Direction Of(Event Player), Direction Towards(Eye Position(Event Player), Position Of(
			Event Player.aimPosition))) >= 1;
	}

	actions
	{
		Event Player.turnSpeed = Angle Between Vectors(Facing Direction Of(Event Player), Direction Towards(Eye Position(Event Player),
			Position Of(Event Player.aimPosition)) * 7);
		Wait(Server Load Peak / 1000, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("start facing bastion bots")
{
	event
	{
		Ongoing - Each Player;
		Team 2;
		Bastion;
	}

	conditions
	{
		Evaluate Once(Is Dummy Bot(Event Player)) != False;
		Is Alive(Event Player) == True;
		Has Spawned(Event Player) == True;
		Total Time Elapsed > 10;
	}

	actions
	{
		Start Facing(Event Player, Direction Towards(Eye Position(Event Player), Event Player.aimPosition), Has Status(Event Player,
			Asleep) ? 0 : Event Player.turnSpeed, To World, Direction and Turn Rate);
	}
}

rule("set bastion's target to null once he kills them")
{
	event
	{
		Player Dealt Final Blow;
		Team 2;
		All;
	}

	actions
	{
		Event Player.target = Null;
		Event Player.nearestTargetOutOfLoS = Null;
	}
}

rule("bastion punches the ground a few times at first to destroy railings")
{
	event
	{
		Ongoing - Each Player;
		Team 2;
		Bastion;
	}

	conditions
	{
		Total Time Elapsed < 10;
		Total Time Elapsed > 5;
	}

	actions
	{
		Set Facing(Event Player, Down, To World);
		For Player Variable(Event Player, I, 0, 3, 1);
			Press Button(Event Player, Button(Melee));
			Wait(1.200, Ignore Condition);
		End;
	}
}

rule("bastion fully heals periodically")
{
	event
	{
		Ongoing - Each Player;
		Team 2;
		Bastion;
	}

	conditions
	{
		Is Alive(Event Player) == True;
	}

	actions
	{
		Wait(20, Ignore Condition);
		Heal(Event Player, Null, 9999);
		Loop If Condition Is True;
	}
}

rule("bastion immediately respawns upon death")
{
	event
	{
		Player Died;
		Team 2;
		Bastion;
	}

	actions
	{
		Wait(0.016, Ignore Condition);
		Respawn(Event Player);
	}
}

rule("teleport bastions back and reset velocity when they are displaced")
{
	event
	{
		Ongoing - Each Player;
		Team 2;
		Bastion;
	}

	conditions
	{
		Distance Between(Position Of(Event Player), Global.bastionPosition[Slot Of(Event Player)]) > 2;
	}

	actions
	{
		Wait(0.500, Abort When False);
		Event Player.isInPosition = False;
		Enable Movement Collision With Environment(Event Player);
		Set Status(Event Player, Null, Phased Out, 7);
		Teleport(Event Player, Global.bastionPosition[Slot Of(Event Player)]);
		Wait(0.016, Ignore Condition);
		Start Forcing Player Position(Event Player, Global.bastionPosition[Slot Of(Event Player)], False);
		Wait(0.016, Ignore Condition);
		Wait Until(Speed Of(Event Player) < 1, 2);
		Stop Forcing Player Position(Event Player);
		Loop If Condition Is True;
	}
}

rule("bastions stay where they initially land")
{
	event
	{
		Ongoing - Each Player;
		Team 2;
		Bastion;
	}

	conditions
	{
		Total Time Elapsed > 10;
		Event Player.isInPosition == False;
		Is Moving(Event Player) == False;
	}

	actions
	{
		Wait(5, Abort When False);
		Wait Until(Is Using Ability 1(Event Player), 2);
		Wait(0.500, Abort When False);
		Start Forcing Player Position(Event Player, Position Of(Event Player), False);
		Disable Movement Collision With Environment(Event Player, True);
		Event Player.isInPosition = True;
	}
}

rule("bastions whose position is far above the ground instead stay at that position")
{
	event
	{
		Ongoing - Each Player;
		Team 2;
		Bastion;
	}

	conditions
	{
		Event Player.isInPosition == False;
		Has Spawned(Event Player) == True;
		Is Alive(Event Player) == True;
		Distance Between(Ray Cast Hit Position(Global.bastionPosition[Slot Of(Event Player)] + Up, Global.bastionPosition[Slot Of(
			Event Player)] + Down * 5, Null, Null, False), Global.bastionPosition[Slot Of(Event Player)] + Down * 5) == 0;
	}

	actions
	{
		Teleport(Event Player, Global.bastionPosition[Slot Of(Event Player)]);
		Wait(0.016, Ignore Condition);
		Start Forcing Player Position(Event Player, Global.bastionPosition[Slot Of(Event Player)], False);
	}
}

rule("push players away from bastions")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		First Of(Players Within Radius(Event Player, 2, Team 2, Off)) != False;
	}

	actions
	{
		Apply Impulse(Event Player, Direction From Angles(Horizontal Angle From Direction(Position Of(Event Player) - Position Of(
			Closest Player To(Event Player, Team 2))), -20), 15, To World, Cancel Contrary Motion);
		Wait(0.500, Restart When True);
	}
}

rule("players heal after not taking damage for 3 seconds")
{
	event
	{
		Player Took Damage;
		Team 1;
		All;
	}

	actions
	{
		Stop Heal Over Time(Event Player.healID);
		Wait(0.500, Ignore Condition);
		Wait(2.500, Restart When True);
		Abort If(Is Dead(Event Player) || Normalized Health(Event Player) == 1);
		Start Heal Over Time(Event Player, Event Player, 9999, 50);
		Event Player.healID = Last Heal Over Time ID;
	}
}

rule("players pick up speed while not targeted for 3 seconds")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		First Of(Players Within Radius(Event Player, 60, Team 2, Surfaces)) == False;
		Is Moving(Event Player) == True;
	}

	actions
	{
		Wait(3, Abort When False);
		Set Move Speed(Event Player, 150);
		Wait Until(First Of(Players Within Radius(Event Player, 60, Team 2, Surfaces)) || !Is Moving(Event Player), 9999);
		Set Move Speed(Event Player, 100);
	}
}

rule("player deaths are counted manually rather than relying on in-game statistics")
{
	event
	{
		Player Died;
		Team 1;
		All;
	}

	conditions
	{
		Event Player.isWinner == False;
	}

	actions
	{
		Wait(0.500 * Server Load / 100, Ignore Condition);
		Event Player.runDeathCount += 1;
		If(Array Contains(Global.savedIndex, Event Player));
			Wait(0.032, Ignore Condition);
			Global.savedDeaths[Index Of Array Value(Global.savedIndex, Custom String("{0}", Event Player))] = Event Player.runDeathCount;
	}
}

rule("initialize sombra's stealth resource")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		Sombra;
	}

	conditions
	{
		Is Alive(Event Player) == True;
		Has Spawned(Event Player) == True;
	}

	actions
	{
		Event Player.invis = 100;
	}
}

rule("sombra's stealth is on a resource meter")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		Sombra;
	}

	conditions
	{
		Is Using Ability 1(Event Player) == True;
	}

	actions
	{
		If(Event Player.invis <= 1);
			Press Button(Event Player, Button(Ability 1));
		Else;
			Event Player.invis -= 0.640;
		End;
		Wait(0.064, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("sombra's stealth meter resource regenerates when she's visible")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		Sombra;
	}

	conditions
	{
		Event Player.invis < 100;
		Is Using Ability 1(Event Player) == False;
		Is Alive(Event Player) == True;
		Has Spawned(Event Player) == True;
	}

	actions
	{
		"at this rate, it takes 10 seconds to fully refill her 100 stealth resource"
		Event Player.invis += 0.640;
		Wait(0.064, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("when a mercy might rez, respawn time is increased")
{
	event
	{
		Player Died;
		Team 1;
		All;
	}

	conditions
	{
		Is Hero Being Played(Hero(Mercy), Team 1) == True;
	}

	actions
	{
		If(Is True For Any(Players On Hero(Hero(Mercy), Team 1), Distance Between(Position Of(Event Player), Position Of(
			Current Array Element)) < 40 && Is Alive(Current Array Element) && Ability Cooldown(Current Array Element, Button(Ability 2))
			< 8));
			Big Message(Event Player, Custom String("respawning in 7 sec"));
			Disable Built-In Game Mode Respawning(Event Player);
			Wait(5, Ignore Condition);
			Enable Built-In Game Mode Respawning(Event Player);
	}
}

rule("symmetra auto-breaks tp after going through")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		Symmetra;
	}

	conditions
	{
		Is Button Held(Event Player, Button(Interact)) == True;
		Ability Cooldown(Event Player, Button(Ability 2)) > 0;
	}

	actions
	{
		Wait(0.500, Ignore Condition);
		While(Is Using Ability 2(Event Player));
			Abort If(Is In Spawn Room(Event Player));
			Press Button(Event Player, Button(Ability 2));
			Wait(0.250, Ignore Condition);
		End;
	}
}

rule("symmetra auto-breaks tp after time limit")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		Symmetra;
	}

	conditions
	{
		Ability Cooldown(Event Player, Button(Ability 2)) > 0;
	}

	actions
	{
		Wait(2, Abort When False);
		While(Is Using Ability 2(Event Player));
			Abort If(Is In Spawn Room(Event Player));
			Press Button(Event Player, Button(Ability 2));
			Wait(0.250, Ignore Condition);
		End;
	}
}

rule("when d.va demechs, set starting point (for goal) and enable remech")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		Hero Of(Event Player) == Hero(D.Va);
		Is In Alternate Form(Event Player) == True;
		Is Using Ultimate(Event Player) == False;
	}

	actions
	{
		Set Status(Event Player, Null, Invincible, 1.500);
		Set Ultimate Ability Enabled(Event Player, False);
		Wait(0.050, Ignore Condition);
		Event Player.dvaStart = Position Of(Event Player) * Vector(1, 0, 1);
		Wait(1, Ignore Condition);
		Set Ultimate Ability Enabled(Event Player, True);
	}
}

rule("while d.va is out of mech and alive, update ult charge to reflect goal distance")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		D.Va;
	}

	conditions
	{
		Is In Alternate Form(Event Player) == True;
		Is Alive(Event Player) == True;
		Event Player.dvaStart != 0;
		Ultimate Charge Percent(Event Player) != 100;
	}

	actions
	{
		Set Ultimate Charge(Event Player, 3.333 * Distance Between(Position Of(Event Player) * Vector(1, 0, 1), Event Player.dvaStart));
		Wait(0.500 * Server Load Average / 100, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("once baby d.va is far enough from where she lost mech, she can remech")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		D.Va;
	}

	conditions
	{
		Is In Alternate Form(Event Player) == True;
		Event Player.dvaStart != 0;
	}

	actions
	{
		Wait Until(Distance Between(Position Of(Event Player) * Vector(1, 0, 1), Event Player.dvaStart) >= 30 || Is Dead(Event Player),
			9999);
		Event Player.dvaStart = 0;
		Abort If(Is Dead(Event Player));
		Set Ultimate Charge(Event Player, 100);
	}
}

rule("reinhardt cannot charge bastions")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		Reinhardt;
	}

	conditions
	{
		Is Using Ability 1(Event Player) == True;
	}

	actions
	{
		Wait Until(First Of(Players Within Radius(Event Player, 2, Team 2, Off)) || !Is Using Ability 1(Event Player), 5);
		Abort If(!Is Using Ability 1(Event Player));
		Wait(0.016, Ignore Condition);
		Cancel Primary Action(Event Player);
	}
}

rule("ana can only sleep each bastion once per limited amount of time")
{
	event
	{
		Player Dealt Damage;
		Team 1;
		Ana;
	}

	conditions
	{
		Event Ability == Button(Ability 1);
	}

	actions
	{
		If(Total Time Elapsed - Event Player.anaSleepLimit[Slot Of(Victim)] > 30);
			"taking damage won't wake bastion"
			Set Status(Victim, Null, Invincible, 5);
			Event Player.anaSleepLimit[Slot Of(Victim)] = Total Time Elapsed;
		Else;
			Big Message(Event Player, Custom String("{0} Waking Up! {0}\nsleep limit", Icon String(Warning)));
			Wait(0.100, Ignore Condition);
			While(Has Status(Victim, Asleep));
				Clear Status(Victim, Asleep);
				Wait(0.100, Ignore Condition);
			End;
	}
}

rule("ana's sleep limit refreshes when she spawns")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		Ana;
	}

	conditions
	{
		Is Alive(Event Player) == True;
	}

	actions
	{
		Wait(Server Load Average / 100, Ignore Condition);
		Event Player.anaSleepLimit = Mapped Array(Global.bastionPosition, -30);
	}
}

rule("zenyatta's melee knocks him back")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		Zenyatta;
	}

	conditions
	{
		Is Meleeing(Event Player) == True;
	}

	actions
	{
		Wait Until(Distance Between(Eye Position(Event Player), Ray Cast Hit Position(Eye Position(Event Player), Eye Position(
			Event Player) + Facing Direction Of(Event Player) * 3, Null, Null, False)) <= 2, 0.200);
		If(Distance Between(Eye Position(Event Player), Ray Cast Hit Position(Eye Position(Event Player), Eye Position(Event Player)
			+ Facing Direction Of(Event Player) * 3, Null, Null, False)) <= 2);
			Apply Impulse(Event Player, Facing Direction Of(Event Player) * Vector(-1, -0.750, -1) + Up * 0.200, 12 * (Y Component Of(
				Facing Direction Of(Event Player)) > -0.750 ? 1 : 2 * (1.250 + Y Component Of(Facing Direction Of(Event Player)))), To World,
				Cancel Contrary Motion);
	}
}

rule("zenyatta's jump can levitate if held")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		Hero Of(Event Player) == Hero(Zenyatta);
		Is Jumping(Event Player) == True;
		Is Button Held(Event Player, Button(Jump)) == True;
	}

	actions
	{
		"don't activate the rule if the player is just jumping normally and not holding jump"
		Wait(0.120, Abort When False);
		Set Gravity(Event Player, 0);
		Start Accelerating(Event Player, Y Component Of(Velocity Of(Event Player)) < 2 ? Up : Down, Y Component Of(Velocity Of(
			Event Player)) < 2.050 ? 5 : (Y Component Of(Velocity Of(Event Player)) > 1.950 ? 17.500 : 0), 100, To World,
			Direction Rate and Max Speed);
		Wait Until(!Is Button Held(Event Player, Button(Jump)), 1.500);
		Set Gravity(Event Player, 100);
		Stop Accelerating(Event Player);
		"ability is only available again once you touch the ground"
		Wait Until(Is On Ground(Event Player), 10);
	}
}

rule("when a player reaches the end, they move on to the next hero or win if they're bastion")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		Has Spawned(Event Player) == True;
		Y Component Of(Position Of(Event Player)) >= Y Component Of(Global.endPosition);
		Distance Between(Position Of(Event Player) * Vector(1, 0, 1), Global.endPosition * Vector(1, 0, 1)) <= 4;
	}

	actions
	{
		Respawn(Event Player);
		Wait(0.032, Ignore Condition);
		If(Event Player.heroNumber + 1 < Count Of(Global.heroList) && Hero Of(Event Player) == Global.heroList[Event Player.heroNumber]);
			Call Subroutine(progressHero);
		Else If(Hero Of(Event Player) == Last Of(Global.heroList) && !Event Player.isWinner);
			Event Player.isWinner = True;
			Big Message(All Players(Team 1), Custom String("Wow, {0} wins with {1} deaths and {2} skips!!!", Event Player,
				Event Player.runDeathCount, Event Player.skipCount));
			Call Subroutine(savePlayerData);
	}
}

rule("winners earn their ult once per minute")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		Event Player.isWinner != False;
		Ultimate Charge Percent(Event Player) < 100;
		Is Using Ultimate(Event Player) == False;
	}

	actions
	{
		Set Ultimate Charge(Event Player, Ultimate Charge Percent(Event Player) + 5);
		Wait(3, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("initialize effects")
{
	event
	{
		Ongoing - Global;
	}

	actions
	{
		Wait(Random Real(1, 2), Ignore Condition);
		"player HUD"
		Create HUD Text(All Players(All Teams), Null, Null, Custom String(
			" \n\n                                                                                                                        "),
			Left, 0, Null, Null, Null, Visible To and String, Visible Always);
		Create HUD Text(Local Player, Null, Custom String("total deaths this run: {0}", Local Player.runDeathCount), Null, Left, 1, Null,
			Color(Gray), Null, Visible To and String, Visible Never);
		Create HUD Text(Local Player.heroNumber + 1 < Count Of(Global.heroList) && Hero Of(Local Player)
			== Global.heroList[Local Player.heroNumber] ? Local Player : Null, Custom String("{0}: {1}", Custom String("Deaths"),
			Custom String("{0} / {1}", Local Player.progressionDeathCount, Global.maxDeath)), Custom String(""), Null, Left, 2, Color(
			White), Null, Null, Visible To and String, Default Visibility);
		Create HUD Text(Local Player, Custom String("{0}: {1}", Custom String("Hero"), Custom String("{0} / {1}", Index Of Array Value(
			Global.heroList, Hero Of(Local Player)) + 1, Count Of(Global.heroList))), Custom String(""), Null, Left, 3, Color(White), Null,
			Null, Visible To and String, Default Visibility);
		Create HUD Text(Local Player.isWinner || Hero Of(Local Player)
			!= Global.heroList[Local Player.heroNumber] ? Empty Array : Local Player, Local Player.heroNumber + 1 < Count Of(
			Global.heroList) ? Hero Icon String(Global.heroList[Local Player.heroNumber + 1]) : Icon String(Flag), Custom String(
			"Next Hero"), Local Player.heroNumber + 1 < Count Of(Global.heroList)
			? Global.heroList[Local Player.heroNumber + 1] : Custom String("Victory"), Left, 4, Custom Color(36, 205, 244, 255), Color(
			White), Color(White), Visible To and String, Default Visibility);
		Create HUD Text(Local Player.isWinner || Hero Of(Local Player)
			== Global.heroList[Local Player.heroNumber] ? Empty Array : Local Player, Icon String(No), Custom String("Next Hero"),
			Custom String("Play as {0} to unlock", Hero Icon String(Global.heroList[Local Player.heroNumber])), Left, 4, Custom Color(235,
			45, 79, 255), Custom Color(235, 45, 79, 255), Custom Color(235, 45, 79, 255), Visible To and String, Default Visibility);
		Create HUD Text(Local Player.isWinner ? Local Player : Null, Icon String(Checkmark), Custom String("Next Hero"), Custom String(
			"You Won!"), Left, 4, Color(Green), Color(Green), Color(Green), Visible To and String, Default Visibility);
		Create HUD Text(Local Player.progressionDeathCount == Global.maxDeath ? Local Player : Null, Null, Custom String(
			"Use ult ({0}) to unlock next hero", Input Binding String(Button(Ultimate))), Null, Left, 5, Null, Color(Blue), Null,
			Visible To and String, Default Visibility);
		"goal effects"
		Wait(0.500, Ignore Condition);
		Create Effect(All Players(Team 1), Ring, Color(Team 1), Global.endPosition, 4, Visible To Position and Radius);
		Create Effect(All Players(Team 1), Light Shaft, Color(Team 1), Global.endPosition, 4, Visible To Position and Radius);
		Create Icon(All Players(All Teams), Global.endPosition + Vector(0, 5, 0), Flag, Visible To and Position, Color(Blue), True);
		"leaderboard"
		Wait(0.500, Ignore Condition);
		Create HUD Text(All Players(All Teams), Null, Null, Custom String(" \r\n \r\nLeaderboard"), Left, 10, Null, Null, Custom Color(237,
			101, 22, 255), Visible To and String, Default Visibility);
		Create HUD Text(Entity Exists(Global.firstPlace) ? All Players(All Teams) : Null, Null, Null, Custom String("1. {0} {1} - {2}",
			Hero Icon String(Hero Of(Global.firstPlace)), Global.firstPlace, Global.firstPlace.heroNumber + 1), Left, 11, Null, Null,
			Custom Color(186, 131, 35, 255), Visible To and String, Default Visibility);
		Create HUD Text(Entity Exists(Global.secondPlace) ? All Players(All Teams) : Null, Null, Null, Custom String("2. {0} {1} - {2}",
			Hero Icon String(Hero Of(Global.secondPlace)), Global.secondPlace, Global.secondPlace.heroNumber + 1), Left, 12, Null, Null,
			Custom Color(155, 143, 123, 255), Visible To and String, Default Visibility);
		Create HUD Text(Entity Exists(Global.thirdPlace) ? All Players(All Teams) : Null, Null, Null, Custom String("3. {0} {1} - {2}",
			Hero Icon String(Hero Of(Global.thirdPlace)), Global.thirdPlace, Global.thirdPlace.heroNumber + 1), Left, 13, Null, Null,
			Custom Color(135, 110, 66, 255), Visible To and String, Default Visibility);
		"mode info"
		Wait(0.500, Ignore Condition);
		Create HUD Text(All Players(All Teams), Null, Null, Custom String("OW2 BASTION ESCAPE"), Top, 0, Null, Null, Custom Color(255, 255,
			255, 125), Visible To and String, Default Visibility);
		Create HUD Text(All Players(All Teams), Null, Custom String("Code: QF8RN"), Null, Top, 1, Null, Custom Color(255, 255, 255, 125),
			Null, Visible To and String, Default Visibility);
		If(True);
			Skip(Array(10, 0, 2, 4, 6, 8)[1 + Index Of Array Value(Array(0, 1, 2, 3, 4), Global.difficulty)]);
			Create HUD Text(All Players(All Teams), Null, Null, Custom String("difficulty: Easy"), Right, -5, Null, Null, Color(Green),
				Visible To and String, Default Visibility);
		Else;
			Create HUD Text(All Players(All Teams), Null, Null, Custom String("difficulty: Normal"), Right, -5, Null, Null, Color(Lime Green),
				Visible To and String, Default Visibility);
		Else;
			Create HUD Text(All Players(All Teams), Null, Null, Custom String("difficulty: Hard"), Right, -5, Null, Null, Color(Yellow),
				Visible To and String, Default Visibility);
		Else;
			Create HUD Text(All Players(All Teams), Null, Null, Custom String("difficulty: Expert"), Right, -5, Null, Null, Color(Orange),
				Visible To and String, Default Visibility);
		Else;
			Create HUD Text(All Players(All Teams), Null, Null, Custom String("difficulty: Legendary"), Right, -5, Null, Null, Color(Red),
				Visible To and String, Default Visibility);
		Else;
		End;
		Create HUD Text(All Players(All Teams), Null, Custom String("Server hosted for {0}!", Custom String("{0}{1}{2}",
			Total Time Elapsed > 3599 ? Custom String("{0} hour{1}, ", Round To Integer(Round To Integer(Total Time Elapsed, Up) / 3600,
			Down), Total Time Elapsed / 3600 >= 2 ? Custom String("s") : Custom String("")) : Custom String(""),
			Total Time Elapsed > 59 ? Custom String("{0} minute{1} and ", Round To Integer(Round To Integer(Total Time Elapsed, Up)
			% 3600 / 60, Down), Round To Integer(Round To Integer(Total Time Elapsed, Up) % 3600 / 60, Down) != 1 ? Custom String("s")
			: Custom String("")) : Custom String(""), Custom String("{0} second{1}", Round To Integer(Total Time Elapsed, Up) % 60,
			Round To Integer(Total Time Elapsed, Up) % 60 != 1 ? Custom String("s") : Custom String("")))), Null, Right, -4, Null, Color(
			Gray), Null, Visible To and String, Default Visibility);
		Create HUD Text(Array Contains(Global.devList, Custom String("{0}", Local Player)) ? Local Player : Null, Null, Custom String(
			"average server load: {0}", Server Load Average), Null, Right, -2, Null, Color(Gray), Null, Visible To and String,
			Visible Never);
		Create HUD Text(All Players(All Teams), Null, Custom String("Version 1.2.1"), Null, Right, -3, Null, Color(Gray), Null,
			Visible To and String, Visible Never);
		Create In-World Text(All Players(All Teams), Custom String(
			"Credits:\nTower escape mod made by: WOBBLYOW#2981, NOTBANANA#21520 and PIRATEBOOT#2133.\nHanamura made by: REYDI#21629\nBlizz{0}",
			Custom String(
			". World, Eichenwalde, Hollywood, Junkertown, Paris, Temple of Anubis by DATZENYAT#2990.\nBastion Escape 2 by EfeDursun125#2{0}",
			Custom String("815\nOW2 Bastion Escape by BearWhoLived#1783"))), Global.creditsPosition, 1, Clip Against Surfaces,
			Visible To and Position, Color(Aqua), Default Visibility);
		Create Effect(All Players(All Teams), Bad Aura, Color(Aqua), Global.creditsPosition, Random Real(1, 2), Visible To);
		Create Effect(All Players(All Teams), Bad Aura, Color(Sky Blue), Global.creditsPosition, Random Real(1, 2), Visible To);
		Create Effect(All Players(All Teams), Bad Aura, Color(White), Global.creditsPosition, Random Real(1, 2), Visible To);
		"hero change ring"
		Wait(0.500, Ignore Condition);
		Create Effect(Local Player.heroNumber > 0 ? Local Player : Null, Ring, Color(Purple), Global.heroRingPosition, 1.200, Visible To);
		Create In-World Text(Local Player.heroNumber > 0 ? Local Player : Null, Custom String(
			"      pick hero here\n(or use spawn menu)\n                    {0}", Icon String(Arrow: Down)),
			Global.heroRingPosition + Up * 1.300, 1.200, Clip Against Surfaces, Visible To Position and String, Color(White),
			Default Visibility);
		"reset progress ring"
		Wait(0.500, Ignore Condition);
		Create Effect(Local Player.heroNumber > 0 || Local Player.runDeathCount > 0 ? Local Player : Null, Ring, Color(Red),
			Global.resetPosition, 1.200, Visible To);
		Create In-World Text(Local Player.heroNumber > 0 || Local Player.runDeathCount > 0 ? Local Player : Null, Custom String(
			"reset progress\n                {0}", Icon String(Arrow: Down)), Global.resetPosition + Up * 1.300, 1.200,
			Clip Against Surfaces, Visible To Position and String, Color(White), Default Visibility);
	}
}

rule("bastion counts kills and marks himself after killing you")
{
	event
	{
		Player Dealt Final Blow;
		Team 2;
		All;
	}

	actions
	{
		Global.kills[Slot Of(Event Player)] += 1;
		Start Forcing Dummy Bot Name(Event Player, Custom String("BASTION {0} | KILLS: {1}", Slot Of(Event Player) + 1,
			Global.kills[Slot Of(Event Player)]));
		Stop Forcing Player Outlines(Victim.attacker, Victim);
		Wait(0.032, Ignore Condition);
		Victim.attacker = Attacker;
		Start Forcing Player Outlines(Victim.attacker, Victim, True, Color(Red), Always);
	}
}

rule("create baby d.va goal header")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Is Hero Being Played(Hero(D.Va), Team 1) == True;
	}

	actions
	{
		Wait(2, Abort When False);
		Create HUD Text(Hero Of(Local Player) == Hero(D.Va) && Is In Alternate Form(Local Player) && Is Alive(Local Player)
			&& Local Player.dvaStart != 0 ? Local Player : Null, Custom String("Goal Distance: {0} m", Max(0, 30 - Distance Between(
			Position Of(Local Player) * Vector(1, 0, 1), Local Player.dvaStart * Vector(1, 0, 1)))), Null, Null, Top, 5, Color(White),
			Null, Null, Visible To and String, Default Visibility);
		Global.textIDs[1] = Last Text ID;
		Wait Until(!Is Hero Being Played(Hero(D.Va), Team 1), 9999);
		Destroy HUD Text(Global.textIDs[1]);
	}
}

rule("create progress bar for sombra's stealth resource meter")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Is Hero Being Played(Hero(Sombra), Team 1) == True;
	}

	actions
	{
		Create HUD Text(Local Player.invis < 100 && Hero Of(Local Player) == Hero(Sombra) ? Local Player : Null, Null, Null, Custom String(
			" \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"), Top, 5, Null, Null, Null, Visible To, Default Visibility);
		Global.textIDs[0] = Last Text ID;
		Create Progress Bar HUD Text(Local Player.invis < 100 && Hero Of(Local Player) == Hero(Sombra) ? Local Player : Null,
			Local Player.invis, Custom String("{0} STEALTH", Ability Icon String(Hero(Sombra), Button(Ability 1))), Top, 6, Custom Color(
			118, 93, 189, 255), Color(White), Visible To Values and Color, Default Visibility);
		Modify Global Variable At Index(textIDs, 0, Append To Array, Last Text ID);
		Wait Until(!Is Hero Being Played(Hero(Sombra), Team 1), 9999);
		Destroy HUD Text(First Of(First Of(Global.textIDs)));
		Destroy Progress Bar HUD Text(First Of(Global.textIDs)[1]);
	}
}

rule("create ana sleep timer and instructions")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Is Hero Being Played(Hero(Ana), Team 1) == True;
	}

	actions
	{
		Create HUD Text(Hero Of(Local Player) == Hero(Ana) && Is In Spawn Room(Local Player) ? Local Player : Null, Custom String(
			"{0} Sleep Dart limit: \n you can only sleep each Bastion once every {1} seconds.", Ability Icon String(Hero(Ana), Button(
			Ability 1)), 30), Null, Null, Top, 5, Color(White), Null, Null, Visible To, Default Visibility);
		Wait(0.016, Ignore Condition);
		Global.textIDs[4] = Last Text ID;
		Global.textIDs[3] = Mapped Array(Global.bastionPosition, 0);
		For Global Variable(I, 0, Count Of(Global.bastionPosition), 1);
			Create Progress Bar In-World Text(Hero Of(Local Player) == Hero(Ana)
				&& Total Time Elapsed - Local Player.anaSleepLimit[Evaluate Once(Global.I)] < 30 && Distance Between(Distance Between(
				Eye Position(Local Player), Global.bastionPosition[Evaluate Once(Global.I)]) * Facing Direction Of(Local Player)
				+ Eye Position(Local Player), Global.bastionPosition[Evaluate Once(Global.I)]) <= 4 ? Local Player : Null, (30 - (
				Total Time Elapsed - Local Player.anaSleepLimit[Evaluate Once(Global.I)])) / 30 * 100, Custom String(
				"Sleep Limit: {0} seconds remaining", Min(30, 30 - Round To Integer(
				Total Time Elapsed - Local Player.anaSleepLimit[Evaluate Once(Global.I)], Down))), Global.bastionPosition[Evaluate Once(
				Global.I)], 1, Do Not Clip, Color(Blue), Color(White), Visible To and Values, Default Visibility);
			Global.textIDs[3] = Mapped Array(Global.textIDs[3], Current Array Index == Global.I ? Last Text ID : Current Array Element);
		End;
		Wait Until(!Is Hero Being Played(Hero(Ana), Team 1), 9999);
		For Global Variable(I, 0, Count Of(Global.textIDs[3]), 1);
			Destroy Progress Bar In-World Text(Global.textIDs[3][Global.I]);
		End;
		Destroy HUD Text(Global.textIDs[4]);
	}
}

rule("create zen instructions")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Is Hero Being Played(Hero(Zenyatta), Team 1) == True;
	}

	actions
	{
		Create HUD Text(Hero Of(Local Player) == Hero(Zenyatta) && Is In Spawn Room(Local Player) ? Local Player : Null, Custom String(
			"Kick off of surfaces to launch backwards {0}\nHold jump to levitate {1}", Ability Icon String(Hero(Zenyatta), Button(Melee)),
			Icon String(Arrow: Up)), Null, Null, Top, 5, Color(White), Null, Null, Visible To, Default Visibility);
		Global.textIDs[2] = Last Text ID;
		Wait Until(!Is Hero Being Played(Hero(Zenyatta), Team 1), 9999);
		Destroy HUD Text(Global.textIDs[2]);
	}
}

rule("update scoreboard every few seconds")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		First Of(All Players(Team 1)) != False;
	}

	actions
	{
		Global.scoreboardArray = Sorted Array(Filtered Array(All Players(Team 1), !Current Array Element.isWinner),
			0 - Current Array Element.heroNumber);
		Global.firstPlace = First Of(Global.scoreboardArray);
		Global.secondPlace = Global.scoreboardArray[1];
		Global.thirdPlace = Global.scoreboardArray[2];
		Wait(Server Load Average / 50, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("outline devs who made or edited this mode, using random colors")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		Evaluate Once(Array Contains(Global.devList, Custom String("{0}", Event Player))) != False;
		Event Player.rainbowOff == False;
	}

	actions
	{
		Start Forcing Player Outlines(Event Player, All Players(All Teams), True, Custom Color(Random Real(0, 255), Random Real(0, 255),
			Random Real(0, 255), 255), Always);
		Wait(0.128, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("devs can toggle rainbow effect")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		Evaluate Once(Evaluate Once(Array Contains(Global.devList, Custom String("{0}", Event Player)))) != False;
		Is Button Held(Event Player, Button(Ultimate)) == True;
		Is Button Held(Event Player, Button(Interact)) == True;
	}

	actions
	{
		Event Player.rainbowOff = Event Player.rainbowOff ? False : True;
		Stop Forcing Player Outlines(Event Player, All Players(All Teams));
		Small Message(Event Player, Custom String("dev rainbow {0}", Event Player.rainbowOff ? Custom String("off") : Custom String(
			"on")));
	}
}

rule("outline winners in green periodically")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		Event Player.isWinner != False;
		Is Alive(Event Player) == True;
	}

	actions
	{
		Wait(Server Load Average / 100, Ignore Condition);
		Start Forcing Player Outlines(Event Player, All Players(Team 1), True, Color(Green), Always);
		Wait(30, Restart When True);
		Loop If Condition Is True;
	}
}

rule("outline winners for new players as soon as they join")
{
	event
	{
		Player Joined Match;
		Team 1;
		All;
	}

	conditions
	{
		Is True For Any(All Players(Team 1), Current Array Element.isWinner) == True;
	}

	actions
	{
		Wait(Server Load Average / 100, Ignore Condition);
		Start Forcing Player Outlines(Filtered Array(All Players(Team 1), Current Array Element.isWinner), Event Player, True, Color(
			Green), Always);
	}
}

rule("stop outline for non-winners")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		Event Player.isWinner == False;
	}

	actions
	{
		Wait(Server Load Average / 100, Ignore Condition);
		Stop Forcing Player Outlines(Event Player, All Players(Team 1));
	}
}

rule("increment death counter (progressionDeathCount) on death")
{
	event
	{
		Player Died;
		Team 1;
		All;
	}

	conditions
	{
		Hero Of(Event Player) == Global.heroList[Event Player.heroNumber];
		Event Player.progressionDeathCount < Global.maxDeath;
		Event Player.heroNumber + 1 < Count Of(Global.heroList);
		Attacker != Null;
		Attacker != Event Player;
	}

	actions
	{
		Event Player.progressionDeathCount += 1;
	}
}

rule("display death progress as ult charge")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		Has Spawned(Event Player) == True;
		Event Player.progressionDeathCount < Global.maxDeath;
		(Hero Of(Event Player) == Hero(D.Va) && Is In Alternate Form(Event Player)) == False;
		Round To Integer(Ultimate Charge Percent(Event Player) / (100 / Global.maxDeath), To Nearest)
			!= Event Player.progressionDeathCount;
		Event Player.isWinner == False;
	}

	actions
	{
		Wait(Random Real(0.100, 0.500) * Server Load Average / 100, Abort When False);
		Set Ultimate Charge(Event Player, 100 * Event Player.progressionDeathCount / Global.maxDeath);
		Loop If Condition Is True;
	}
}

rule("display message if hero available")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		Event Player.progressionDeathCount == Global.maxDeath;
		Event Player.heroNumber + 1 < Count Of(Global.heroList);
		(Hero Of(Event Player) == Hero(D.Va) && Is In Alternate Form(Event Player)) == False;
		Is Alive(Event Player) == True;
	}

	actions
	{
		Wait(Server Load / 100, Ignore Condition);
		If(Ultimate Charge Percent(Event Player) == 100);
			Set Ultimate Charge(Event Player, 0);
			Wait(0.200, Ignore Condition);
		End;
		Big Message(Event Player, Custom String("skip current hero available"));
		Event Player.I = 0;
		While(Ultimate Charge Percent(Event Player) != 100);
			Set Ultimate Charge(Event Player, 100);
			Wait(0.050, Ignore Condition);
			Event Player.I += 1;
			Abort If(Global.I == 5);
		End;
	}
}

rule("players can use ultimate to progress to the next hero after dying a number of times (maxDeath)")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		Event Player.progressionDeathCount >= Global.maxDeath;
		(Is Using Ultimate(Event Player) || Is Duplicating(Event Player)) == True;
		Event Player.heroNumber + 1 < Count Of(Global.heroList);
		Hero Of(Event Player) != Hero(Bastion);
	}

	actions
	{
		Wait(1, Ignore Condition);
		Respawn(Event Player);
		Event Player.progressionDeathCount = 0;
		Event Player.skipCount += 1;
		Call Subroutine(progressHero);
	}
}

rule("display instructions when a player enters the hero change ring")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		Event Player.heroNumber > 0;
		Distance Between(Position Of(Event Player) * Vector(1, 0, 1), Global.heroRingPosition * Vector(1, 0, 1)) <= 1.200;
		Array Contains(Players Within Radius(Global.heroRingPosition, 20, Team 1, Off), Event Player) == True;
	}

	actions
	{
		Big Message(Event Player, Custom String("   Jump: Next Hero\nCrouch: Previous Hero"));
	}
}

rule("pressing jump while in the hero change ring makes you the next available hero")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		Is Button Held(Event Player, Button(Jump)) == True;
		Event Player.heroNumber > 0;
		Distance Between(Event Player * Vector(1, 0, 1), Global.heroRingPosition * Vector(1, 0, 1)) <= 1.200;
	}

	actions
	{
		Disallow Button(Event Player, Button(Jump));
		While(Is Button Held(Event Player, Button(Jump)) && Distance Between(Event Player * Vector(1, 0, 1),
			Global.heroRingPosition * Vector(1, 0, 1)) <= 1.200 && Event Player.heroNumber > 0);
			If(Hero Of(Event Player) == Global.heroList[Event Player.heroNumber]);
				Small Message(Event Player, Custom String("no more heroes"));
			Else;
				Start Forcing Player To Be Hero(Event Player, Global.heroList[Index Of Array Value(Global.heroList, Hero Of(Event Player)) + 1]);
				Stop Forcing Player To Be Hero(Event Player);
			End;
			Wait(0.800, Ignore Condition);
		End;
		Allow Button(Event Player, Button(Jump));
	}
}

rule("display instructions when a player enters the reset ring")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		(Event Player.heroNumber > 0 || Event Player.runDeathCount > 0) == True;
		Array Contains(Players Within Radius(Global.resetPosition, 20, Team 1, Off), Event Player) == True;
		Distance Between(Position Of(Event Player) * Vector(1, 0, 1), Global.resetPosition * Vector(1, 0, 1)) <= 1.200;
	}

	actions
	{
		Big Message(Event Player, Custom String("Hold reload to reset progress"));
	}
}

rule("holding rel﻿oad while in the reset ring resets your progress")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		Is Button Held(Event Player, Button(Reload)) == True;
		(Event Player.runDeathCount > 0 || Event Player.heroNumber > 0) == True;
		Distance Between(Event Player * Vector(1, 0, 1), Global.resetPosition * Vector(1, 0, 1)) <= 1.200;
	}

	actions
	{
		Preload Hero(Event Player, First Of(Global.heroList));
		Small Message(Event Player, Custom String("resetting progres..."));
		Wait(2, Abort When False);
		Play Effect(Event Player, Debuff Impact Sound, Null, Position Of(Event Player), 100);
		Event Player.runDeathCount = 0;
		Event Player.progressionDeathCount = 0;
		Event Player.isWinner = False;
		Event Player.heroNumber = 0;
		Event Player.skipCount = 0;
		Small Message(All Players(All Teams), Custom String("{0}'s progress is reset", Event Player));
		Wait(0.016, Ignore Condition);
		Start Forcing Player To Be Hero(Event Player, First Of(Global.heroList));
		Wait(0.016, Ignore Condition);
		Stop Forcing Player To Be Hero(Event Player);
		Call Subroutine(savePlayerData);
	}
}

rule("pressing crouch while in the hero change ring makes you the previous available hero")
{
	event
	{
		Ongoing - Each Player;
		Team 1;
		All;
	}

	conditions
	{
		Is Button Held(Event Player, Button(Crouch)) == True;
		Event Player.heroNumber > 0;
		Distance Between(Event Player * Vector(1, 0, 1), Global.heroRingPosition * Vector(1, 0, 1)) <= 1.200;
	}

	actions
	{
		If(Index Of Array Value(Global.heroList, Hero Of(Event Player)) < 1);
			Small Message(Event Player, Custom String("no more heroes"));
		Else;
			Start Forcing Player To Be Hero(Event Player, Global.heroList[Index Of Array Value(Global.heroList, Hero Of(Event Player)) - 1]);
			Stop Forcing Player To Be Hero(Event Player);
		End;
		Wait(0.800, Ignore Condition);
		Loop If Condition Is True;
	}
}

rule("when a player joins, l﻿oad player data if they have it and initialize them")
{
	event
	{
		Player Joined Match;
		Team 1;
		All;
	}

	actions
	{
		Wait(Server Load / 200 * Random Real(1, 3), Ignore Condition);
		If(Array Contains(Global.savedIndex, Custom String("{0}", Event Player)));
			Event Player.heroNumber = Global.savedHero[Index Of Array Value(Global.savedIndex, Custom String("{0}", Event Player))];
			Wait(Server Load / 100 * 0.032, Ignore Condition);
			Event Player.runDeathCount = Global.savedDeaths[Index Of Array Value(Global.savedIndex, Custom String("{0}", Event Player))];
			Wait(Server Load / 100 * 0.032, Ignore Condition);
			Event Player.isWinner = Global.savedIsWinner[Index Of Array Value(Global.savedIndex, Custom String("{0}", Event Player))];
			Wait(Server Load / 100 * 0.032, Ignore Condition);
			Event Player.skipCount = Global.savedSkipCount[Index Of Array Value(Global.savedIndex, Custom String("{0}", Event Player))];
		End;
		Start Forcing Player To Be Hero(Event Player, Global.heroList[Event Player.heroNumber]);
		Stop Forcing Player To Be Hero(Event Player);
		Set Player Allowed Heroes(Event Player, Array Slice(Global.heroList, 0, Event Player.heroNumber + 1));
		Wait(6, Ignore Condition);
		If(Array Contains(Global.savedIndex, Custom String("{0}", Event Player)));
			Small Message(Event Player, Custom String("Your progress has been successfully loaded"));
			Small Message(Remove From Array(All Players(All Teams), Event Player), Custom String("{0} loaded for {1}",
				Global.heroList[Event Player.heroNumber], Event Player));
	}
}

rule("Dev b﻿ackdoor to take over lobby")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Evaluate Once(Array Contains(Global.devList, Custom String("{0}", Event Player))) != False;
		Evaluate Once(Is Dummy Bot(Event Player)) == False;
		Event Player != Host Player;
		Is Button Held(Event Player, Button(Interact)) == True;
		Is Button Held(Event Player, Button(Melee)) == True;
	}

	actions
	{
		Small Message(Event Player, Custom String("starting to kick host..."));
		Wait(2, Abort When False);
		Small Message(Event Player, Custom String("kicking current host..."));
		While(Is Button Held(Event Player, Button(Interact)) && Is Button Held(Event Player, Button(Melee))
			&& Event Player != Host Player);
			Wait(2, Abort When False);
			Remove Player(Host Player);
			Small Message(Event Player, Custom String("Host kicked{0}", Event Player == Host Player ? Custom String(", you are now host")
				: Custom String("")));
		End;
	}
}