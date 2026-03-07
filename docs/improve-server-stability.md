> _The workshop provides a lot of super useful tools, but start to use too many of them at once and suddenly the server will start crashing. This tutorial will serve as a guide to improve the stability of your codes and to prevent the server from crashing._

### ==**Content**==
- [Disabling the Inspector](#disabling-the-inspector)
- [Waitless Loops](#waitless-loops)
- [Condition Ordering](#condition-ordering)
- [Player Filters](#player-filters)
- [Too Many Actions](#too-many-actions)
- [Too Many Conditions at Start Up](#too-many-conditions)
- [Sparse Condition Evaluation](#sparse-condition-evaluation)
- [De-syncing Expensive Actions](#de-syncing-expensive-actions)
- [Anti-Crash Rules](#anti-crash-rules)
- [Disabled Rules or Actions](#disabled-rules-or-actions)
- [Workshop Quirks and Pitfalls](#workshop-quirks-and-pitfalls)

<a id="disabling-the-inspector"></a>
# Disabling the Inspector
The inspector is used for debugging, and can contribute to server load, particularly when modifying arrays.

If you have finished debugging and are releasing the gamemode, it is recommended to disable the inspector using the `Disable Inspector Recording` action.

<a id="waitless-loops"></a>
# Waitless Loops

A waitless loop is any kind of loop without a `Wait` action. Depending on the duration and number of actions being executed in the loop, the server could crash.

```
For Global Variable(A, 0, 100, 1);
  Small Message(All Players(All Teams), Custom String("I'm looping!"));
End;
```
>A waitless for loop. This will loop 100 times in 1 server tick, likely crashing your server.

<p><br></p>

```
rule("Looping")
{
  conditions
	{
    Is Button Held(Event Player, Button(Interact)) == True;
  }

  actions
	{
    Small Message(All Players(All Teams), Custom String("I'm looping!"));
    Loop If Condition Is True;
  }
}
```
> A rule with a waitless loop. This will show a `Small Message` while the player is holding down the `Interact` button, and repeat it continuously via the `Loop If` action until the button is no longer held. The action will execute hundreds of times, potentially resulting in a server crash. A server crash is more likely if ran for multiple players at once.

### **Solution**

The easiest way to solve this is to add a `Wait` action to your loop. Adding a `Wait` will improve the overall server load of your mode by delaying the actions running in the loop. It does not matter where you add this wait, but it is typically added just before the end of the loop.

If it is not necessary for things to happen at the same time, batching actions can be considered:

```
< Your actions >

Global.batch++
if Global.batch == 20
  Wait(0.016)
  Global.batch == 0
end
```
> In this example, we loop over something 20 times, then wait for least amount of time possible (0.016 seconds), and then continuing the loop.

---

<a id="condition-ordering"></a>
# Condition Ordering
Conditions in a rule are not checked all at once but sequentially one by one in order. While a condition remains false, the conditions below it will not be checked.

For `Ongoing - Global` and `Ongoing - Each Player`, this condition pass happens every server tick (about 0.016s). In practice, the rule is evaluated top-to-bottom with short-circuit behavior every tick.

When multiple rules have effectively the same gates, execution order follows scan order: the rule declared earlier is processed first.

```
rule("My Rule")
{

    event
    {
        Ongoing - Each Player;
        All;
        All;
    }

    conditions
    {
        Is Button Held(Event Player, Button(Interact)) == True;
        Is Alive(Event Player) == True;
    }
}
```
> A rule that runs when the `Interact` button is held by a player and the player is alive. The first condition is checked before the second condition. The player will never be checked if they're alive until after they hold the `Interact` button.

### **Why Condition order matters**

Since condition order determines how conditions are checked, we need to be careful about what conditions we use and how we use them.

The examples provided below are super simple and the condition order will not make a noticeable difference, but with more rules improper ordering can increase server load.

```
rule("I'm alive")
{
  conditions
	{
    Is Button Held(Event Player, Button(Interact)) == True;
    Is Alive(Event Player) == True;
  }
}

rule("I'm dead")
{
  conditions
	{
    Is Button Held(Event Player, Button(Interact)) == True;
    Is Dead(Event Player) == True;
  }
}
```
> In this example, we have two rules where one fires if the `Interact` button is held and the player is alive, and one that fires if the `Interact` button is held and the player is dead. The condition for checking if the button is held is first in both rules, therefore both rules will be checked, even though only one of them can run, since the player cannot be both dead and alive.

<br>

```
Is True For Any(Global.PositionsArray, Distance Between(Current Array Element, Event Player) <= 2) == True;
Is Button Held(Event Player, Button(Interact)) == True;
```
> In this example, if the player is within range of any position within the array and is holding `Interact`, something happens. The condition for checking if the player is within range of a position is a more complex calculation. It will be constantly checking, regardless if the player is holding `Interact`. Only when the player is within range of a position will it check if the player is also holding down `Interact`.

### **Solution**
- Avoid multiple rules sharing the same conditions as the first condition.
- Avoid having conditions that involve complex calculations as the first condition in a rule.

With this in mind we would want to swap conditions around, with high-selectivity gates first.
High-selectivity means "hard to trigger", not "most computationally complex".

Optimal ordering of conditions can ensure that conditions are only checked when they need to be, reducing the server load and potential for the server to crash.  

Condition order can have a huge impact in larger modes, particularly those that utilize many rules.

```
Is Button Held(Event Player, Button(Interact)) == True;
Is True For Any(Global.PositionsArray, Distance Between(Current Array Element, Event Player) <= 2) == True;
```
> In this example, if the player is holding `Interact` and is within range of any position within the array, something happens. The condition for checking if the player is holding `Interact` is first, therefore checking the player's position is done after the player is holding down the button.

---

<a id="player-filters"></a>
# Player Filters
All player rules include a Player filter, which determines what hero or slot the rule will run for.

> A player rule in the Workshop with the Player filter set to `All`. This rule will run for all players, on all heroes, and all slots.

Using the Player filter of a player rule can be an alternative to checking for the hero via conditions. The examples below provide two similar rules: one that uses conditions, and one that uses the Player filter.

```
rule("Is Mercy")
{
  event
	{
    Ongoing - Each Player;
    All;
    All;
  }
	
  conditions
	{
    Hero Of(Event Player) == Hero(Mercy);
  }
}
```
> A player rule that checks if a player is playing as Mercy.
This rule's condition will be checked for every player, even if they are not Mercy.

<br>

```
rule("Is Mercy")
{
	event
	{
		Ongoing - Each Player;
		All;
		Mercy;
	}
}
```
> A player rule with the Player filter set to `Mercy`. This rule will run for any players on the hero Mercy, and only for those players.

By limiting the number of rules and conditions that are being reevaluated for each player, it will be easier for the server to handle large number of rules that are used for different heroes/slots.

### Notes
* When a hero or slot is selected in the Player filter, the rule will abort the moment the player swaps to a different hero or different slot.

---

<a id="too-many-actions"></a>
# Too Many Actions
The server can only handle so many actions at once (the exact number will completely depend on what you're doing). Let's say we have a gamemode, and when you press `Interact` a whole bunch of stuff starts happening. You're initializing all sorts of variables, you're teleporting all players, etc. You end up with over 20 actions in 1 rule. All these actions will try to execute in the same frame. Meaning they will essentially all try to execute before moving on to whatever is next. 

The solution here is simple; add a `Wait` action! After a certain number of actions, simply add a short wait. Anything goes, no matter how short.  

---

<a id="too-many-conditions"></a>
# Too Many Conditions at Start Up
Is your server crashing right from the start? You may have too many conditions that need to be checked at the start. When the server first starts it will need to go by every single rule and check all of their conditions. If you have 100+ rules this may start to be a problem.

In some cases this can be difficult to fix, but there's a few things you can try. 

- Defer expensive actions to a later point. If you have rules that for example create HUDs, In-World text, or simply set a variable, consider delaying them a little bit. For example only initiate them when the player has actually spawned. Or simply add a start `Wait`.
- Make sure expensive conditions that don't need to be checked yet don't get checked yet. Chances are you have some expensive conditions (with complex calculations or checking large arrays) that don't need to be checked the very second the server starts. Hide them behind other conditions that are definitely not true at start up so these more expensive condition don't need to be checked. Refer back to <a href="#condition-order">Condition Order</a> for more info. You could use conditions such as `Total Time Elapsed` or `Number Of Living Players` to defer these rules to when they are actually needed.
- Merge multiple rules in to 1. You might be able to get away with merging rules with similar conditions in to 1, and using `If Else` statements in the actions instead. These `If Else` actions are more expensive, but if all you need is more headroom at start up, this could be an option.
- Avoid putting all conditions in the same event type (Ongoing - Each Player, Ongoing - Global ...). A healthy mix of events is generally easier for the server to handle.

---

<a id="sparse-condition-evaluation"></a>
# Sparse Condition Evaluation
Sometimes, you might find yourself working with a complex and costly condition that evaluates for each player, but is also crucial to gameplay and cannot be easily discarded. This is particularly evident in the popular _lava parkour_ modes. In these modes, the game needs to calculate the distance between each of the 8-12 players and dozens of lava zone vectors all at the same time.

The conventional way to handle this would be the following:
```
rule("Player Entered Lava Zone")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Is True For Any(Global.lavaZones, Distance Between(Event Player, Current Array Element) < 5) == True;
	}

	actions
	{
		Kill(Event Player, Null);
	}
}
```
> This rule assumes that all lava zones have a radius of 5 meters. While this isn't accurate for the actual modes, the condition has been simplified for easier understanding.

By doing it this way, the game must constantly reevaluate this condition for multiple players, as the `Distance Between` value is continuously compared to an array of positions while the players move. This constant reevaluation will lead to crashes when more than a few players join the game.

### **Solution**
What we can do, instead, is **force the game to only run those checks when we want** instead of in every game logic tick (0.016 seconds). This can be achieved by moving the conditions to an `If`. This is what it would look like for the lava zones example:
```
rule("Player Entered Lava Zone (Optimized)")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
    }

	actions
	{
		Wait(0.2, Ignore Condition);
		If(Is True For Any(Global.lavaZones, Distance Between(Event Player, Current Array Element) < 5));
			Kill(Event Player, Null);
		End;
		Loop;
	}
}
```
> This rule will check for lava zone collisions 5 times per second instead of the previous 62.5. In other words, once every 0.2 seconds instead of once every 0.016 seconds while players move.

This trick is also a great way to help with the <a href="#too-many-conditions">Too Many Conditions at Startup</a> issue since it gets rid of all conditions in the rule. Unfortunately, this method will not be of use when your rule absolutely requires more precision and decreasing the evaluation interval is not enough.

Important default policy: keep continuous-rule gates in the `conditions` block whenever possible. Moving checks into `actions` (`If` + `Wait`) is an exception strategy, not the default pattern.

Use action-side checks mainly when:
- you must manually control evaluation frequency for non-frame-critical logic
- multiple expensive sub-checks share one upper gate and can be scheduled together

---

<a id="de-syncing-expensive-actions"></a>
# De-syncing Expensive Actions
Say you have a `Ongoing - Each Player` rule that sets up a large number of variables, creates new effects and several hud texts. A rule like this might be perfectly fine for the server to handle one its own, but not when attempting to run it several times on the same server tick (which is often the case at startup). 
A quick peak from 100 to 255 server load can be worse than a consistent 200 server load, and by de-syncing expensive actions we can reduce such peaks.
One way to de-sync actions at startup is to use a wait that is inconsistent between players.
```
	actions
	{
		Wait(Slot Of(Event Player) * 0.016, Ignore Condition);
	}
```
There are a number of ways to make sure expensive actions dont all line up on the same server tick, such as using variables to check if certain actions are currently running, or by combining several rules and adding waits inbetween actions. But in the end it all comes down to making good use of the `Wait` action.

---

<a id="anti-crash-rules"></a>
# Anti-Crash Rules
A way to reduce the chance of crash is to use anti-crash rules. It works by setting slow motion if the server load goes past a certain threshold ; slow motion lowers the tick rate, letting the server with more time to do the calculations.

```
rule("Anti-Crash")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Server Load > 230;
	}

	actions
	{
		Wait(1, Abort When False);
		Small Message(Evaluate Once(True), Custom String("Anti crash system activated"));
		Set Slow Motion(10);
		Wait Until(Server Load < 200, 99999);
		Set Slow Motion(100);
	}
}
```

Although this is not a silver bullet (as your players might not like playing at 10% speed), it is very useful to prevent crashes due to spikes in load (eg if too many players use your custom ability at the same time).


for a more refined version, try using this formula instead.

```
variables
{
	global:
		26: svrloadmin
		27: svrslowamount
}

rule("anticrash on")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Server Load >= Global.svrloadmin;
	}

	actions
	{
		Set Slow Motion(100 - (Global.svrslowamount * Server Load - Global.svrloadmin) / 105);
	}
}

rule("anticrash off")
{
	event
	{
		Ongoing - Global;
	}

	conditions
	{
		Server Load < Global.svrloadmin;
	}

	actions
	{
		Set Slow Motion(100);
	}
}

rule("leave these in your (setup) rule")
{
	event
	{
		Ongoing - Global;
	}

	actions
	{
		"Serverload required to activate anti-crash rules"
		Global.svrloadmin = 150;
		"The precent to slow the server down"
		Global.svrslowamount = 15;
	}
}
```
To modify this, simply change, "global.svrloadmin" and "global.svrslowamount". as mentioned above, the serverloadmin, is the amount required for the rule to start. which is scaled off of 0 to 255, while svrslowamount, is the precent you wish it to slow down. so in this example its 15%. 

the reason this is better, is its more dynamic, as well as subtle. since the original equation allows for 10x serverload. which is not too likely to be needed for most gamemodes. however, with the current example, you get a effective 17% more overhead in preformance at a subtle 0-15% slowdown.


---

<a id="disabled-rules-or-actions"></a>
# Disabled Rules or Actions
Disabled rules, actions, or conditions do not affect performance. Nor do completely empty rules.

For these code examples we will use the `@for` format of the Workshop.codes editor to quickly create many rules.

Having too many conditions will instantly crash the server on start up, no matter how simple the condition is.
```
@for (1 through 500) {
	rule("Rule Name")
	{	
		conditions
		{
			Global.a == 1;
		}
	}
}
```
How many conditions the server can handle on startup before crashing is going to depend on how advanced they are, as well as what type of event triggers the condition. Combining `Global` and `Each Player` events allow for more conditions to be used before the server crashes. This is likely caused by players loading in later than the Global Events, causing a de-sync between condition checks.
```
@for (1 through 400) {
    rule("Rule Name")
		{ 
			event
			{
				Ongoing - Each Player;
				All;
				All;
			}
			
			conditions
			{
				Global.a == 1;
			}
    }
}

@for (1 through 400) {
    rule("Rule Name")
		{ 
			event
			{
				Ongoing - Global;
			}
		
			conditions
			{
				Global.a == 1;
			}
    }
}
```
Disabling the rule _or_ the condition means they are not processed at all and they will no longer affect performance as a result.
```
@for (1 through 5000) {
  disabled rule("Rule Name")
	{	
		conditions
		{
			Global.a == 1;
		}
	}
}

@for (1 through 5000) {
  rule("Rule Name")
	{	
		conditions
		{
			disabled Global.a == 1;
		}
	}
}
```
Similarly, empty rules have no impact on performance and act the same as if they were disabled. They do still show up in the inspector unlike the disabled rules.
```
@for (1 through 5000) {
	rule("Rule Name")
	{	
		conditions
		{
		}
	}
}
```

---

<a id="workshop-quirks-and-pitfalls"></a>
# Workshop Quirks and Pitfalls
**Avoid using large arrays in conditions.**
when _any_ value within an array changes, _every_ condition in any rule containing that variable is checked.
For example, if you set `Event Player.upgrades[73]` to = 1, the conditions will also need to be checked in rules with `Event Player.upgrades[0]`, `Event Player.upgrades[1]` and so on. This can potentially trigger a lot of unnessecary condition checks.

**Avoid using too many/expensive Player Dealt/Took Damage events**
Certain abilities and weapons trigger significantly more damage events than others (attacks with a lot of damage instances such as SMGs, dots and beams). If possible, add a short wait at the end of the rule to prevent them from triggering too often. Just keep in mind that each rule can only run one at the time, so if you add a wait to a `Player Dealt Damage` rule, and that player damages several players on the same server tick, the rule will only apply to one target (there is only one attacker who can trigger the rule). If you swap the event to `Player Took Damage`, the rule can now trigger once per target (several victims, each one triggering their own respective rule). Because of this behavior you will need to be careful with how you use your waits, or you might prevent your rules from running when you want them to.

For AOE-triggered chains, treat this as a hard constraint: actions before `Wait` may affect multiple targets in the same tick, while actions after `Wait` can lose multi-target context and often continue on only one target. In testing, this tends to be the first-hit target, but this is an observed tendency, not a guaranteed engine contract.

Apply the same caution model to similar trigger families (for example healing/knockback-triggered logic) when event context is expected to represent multiple targets.

Preferred mitigations (in order):
1. Place all multi-target-consistency actions before `Wait`.
2. Switch to a per-victim event path when possible (for example `Player Took Damage`).
3. Cache target collections explicitly and iterate with bounded loops plus throttling waits.

**Using the built in array-actions**
To a programmer coming to the workshop it might not make a lot of sense, but iterating over an array with `For Global Variable` can be a lot more expensive than doing the exact same thing with actions like `Mapped Array` / `Filtered Array` / `Sorted Array`. Working with arrays in general is pretty expensive in the workshop, especially multidimensional arrays. Using the built in array actions can be a good way to reduce server load when performing a lot of calculations on arrays.

**"My mode is crashing today but worked fine yesterday??"**
Server stability changes from day to day, and server load is generally higher in the evening than it is in the morning/night. It is also not uncommon to see more crashes on patch days, not because the patch is unstable, but because of the increase in player numbers. The best thing you can do is to improve the general performance of your mode so that it remains stable even when the servers are struggling.

**Server load peaks every few seconds**
This is a problem that has long been discussed within the workshop community. The cause is most likely the snapshots that are sent to the server containing data for the replay system, kill cam, play of the game. After the game has been running for 1h 30min, the replay system and kill cams will turn off, and the periodic server load peaks will disappear along with it. Unfortunately there is no other known way to turn off or avoid this system. The best you can do is to reduce its impact by not having too many bots/players, texts and effects.

**"Heroes are randomly disappearing from the hero select screen"**
This is something that has been happening since the launch of OW2 to modes that are dangerously close to breaking the limits of what the workshop can handle. Working to improve the performance of your mode and reducing server load should fix the issue.

**Testing your changes in the Practice range**
Unknown to many, the practice range runs on a different tick rate than the remaining maps. Instead of the usual 62.5 ticks/s the practice range runs at a third of that, ~20.8333 ticks/s.
Unless you plan to build your mode around the practice range, it is generally better to test your changes on any other map.
