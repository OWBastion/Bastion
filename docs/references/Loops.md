# Table Of Contents

<ol>
	<li><a href="#what-are-loops">What are loops?</li>
	<li><a href="#rule-loops">Rule Loops</li>
	<li><a href="#while-loops">While Loops</li>
	<li><a href="#for-loops">For-loops</li>
</ol>


# What are loops? <span id="what-are-loops"></span>

Loops are a great way to repeat a bit of code over and over again, with slight adjustments each time. They are useful when you have to do something at regular time intervals, have a specific part in a rule that should repeat as long as a condition is true, or want to execute a set of actions for each element in an array.

# Rule Loops <span id="rule-loops"></span>

Rule loops are the simplest type of loop available - they simply reexecute a rule when the action is run. The actions that cause a rule to loop are:

* [Loop](/wiki/articles/loop)
* [Loop If](/wiki/articles/loop+if)
* [Loop If Condition Is True](/wiki/articles/loop+if+condition+is+true)
* [Loop If Condition Is False](/wiki/articles/loop+if+condition+is+false)

Here's an example. Let's say that you want to heal the player in bursts of 20 every 0.2 seconds for a total of 100 healing per second when they hold Interact. To do that, you can do a rule like this:

```
rule("Heal the player when they hold Interact")
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
	}

	actions
	{
		Heal(Event Player, Null, 20);
		Wait(0.200, Ignore Condition);
		Loop If Condition Is True;
	}
}
```

Note the [Wait](/wiki/articles/wait) action. Here, the Wait action specifies how fast the rule will repeat. The lower the number in the Wait action, the faster the rule will repeat, down to a minimum of 0.016 seconds per execution. If you don't have a Wait action, it's the same as running the code an infinite amount of times in one frame, which crashes the server. To avoid this, always add a Wait action to rule loops.

# While Loops <span id="while-loops"></span>

While loops are not used as often as the other types of loops, but they are still a useful kind of loop to know. Instead of repeating a rule according to some condition, While loops will repeat an action or series of actions. The actions you need to know for this section are:

* [While](/wiki/articles/while)
* [End](/wiki/articles/end)

Another example: let's say you have a custom ability that functions similarly to Soldier:76's sprint, in that it has no cooldown and can be used for as long as the player wants. Let's say that this ability will spawn a large red ring effect when it begins, then creates a lot of ring effects under the player while it's active, and another large red ring effect when it ends. To do that, we can use this rule:

```
rule("Ring effect ability")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Is Button Held(Event Player, Button(Ability 1)) == True;
	}

	actions
	{
		Play Effect(All Players(All Teams), Ring Explosion, Color(Red), Position Of(Event Player), 10);
		While(Is Button Held(Event Player, Button(Ability 1)));
			Play Effect(All Players(All Teams), Ring Explosion, Color(White), Position Of(Event Player), 3);
			Wait(0.016, Ignore Condition);
		End;
		Play Effect(All Players(All Teams), Ring Explosion, Color(Red), Position Of(Event Player), 10);
	}
}
```

A couple things to note about this script. First, the [End](/wiki/articles/end) action terminates the While loop. If you copy this rule into the Workshop Editor, you will see that the actions between the While and End actions are indented slightly. This marks that they are in the loop.

Let's run through what this action does when the player presses and releases Ability 1:

1. The player starts holding Ability 1.
2. The rule executes.
3. A large red ring effect is played at the Event Player's position.
4. The rule enters the While loop.
5. A smaller white ring effect is placed under the Event Player every 0.016 seconds.
6. Step 5 repeats as long as the player holds Ability 1.
7. The player releases Ability 1.
8. The While loop terminates.
9. Another large red ring effect is played at the Event Player's position.

It's important to note that just like the rule loop, this also requires a Wait action to set the speed of the execution and to not crash the server with an infinite amount of actions.

# For-loops <span id="for-loops"></span>

For-loops are a bit confusing to understand, since the name is a bit misleading. A for-loop takes a variable, a set of actions and some other values, and does the following things:

1. Sets the variable to the Range Start.
2. Executes the actions in the for-loop.
3. Modifies the variable by the Step.
4. Checks if the variable is greater than or equal to the Range Stop.
5. If it's greater than or equal to the Range Stop, ends the for-loop.
6. If it's less than the Range Stop, goes to step 2 and continues the loop.

For this section, you'll need to know the following actions:

* [For Global Variable](/wiki/articles/for+global+variable)
* [For Player Variable](/wiki/articles/for+player+variable)

This may all be a bit confusing, so here's an example. Let's say that you have another ability, which blasts all nearby enemies away from you. You cannot use just one [Apply Impulse](/wiki/articles/apply+impulse) action for this, since each player will need to be launched in a different direction. You would have to create a rule like this:

```
variables
{
	player:
		0: index
		1: playersInRadius
}

rule("Blast nearby enemies away from the player")
{
	event
	{
		Ongoing - Each Player;
		All;
		All;
	}

	conditions
	{
		Is Button Held(Event Player, Button(Jump)) == True;
	}

	actions
	{
		Event Player.playersInRadius = Players Within Radius(Event Player, 8, Opposite Team Of(Team Of(Event Player)), Surfaces);
		For Player Variable(Event Player, index, 0, Count Of(Event Player.playersInRadius), 1);
			Apply Impulse(Event Player.playersInRadius[Event Player.index], Direction Towards(Event Player,
				Event Player.playersInRadius[Event Player.index]), 15, To World, Cancel Contrary Motion);
		End;
	}
}
```

Let's explain step-by-step what this rule does. Let's assume that there are three enemies near the player - Player1, Player2 and Player3.

1. The player variable `playersInRadius` is set to the array of all enemies within 8 meters who are in line of sight to the Event Player (\[Player1, Player2, Player3\]). 
2. The for-loop starts. In this case, the player variable will be `index` (it's a common practice to call variables used in loops either `i` or `index`), the range start is 0, the range stop is 3 (since there are 3 enemies nearby), and the step is 1.
3. `index` is set to 0.
4. The first impulse executes. If you're confused by the bracket and dot notation, that's `Value In Array(Player Variable(Event Player, playersInRadius), Player Variable(Event Player, index))`. Basically, it takes the `index`th value in the `playersInRadius` variable, and since arrays start counting from 0, it takes Player1. It then knocks that player away from the Event Player.
6. The variable `index` is incremented by 1.
7. The game checks if the loop should end. Currently, `index` is 1, which is less than 3, so it continues.
8. The second impulse executes. This time, it takes element 1 in the array, which is Player2 (remember, arrays start counting from 0, so Player1 is the number 0 element in the array), and knocks them away from the Event Player.
9. The variable `index` is once again incremented by 1.
10. The game sees that `index` (now 2) is still less than 3, so it continues the loop.
11. The third impulse executes. This time, it takes element 2 in the array, which is Player3, and knocks them away from the Event Player.
12. The variable `index` is incremented by 1.
13. The game notices that `index` (now 3) is equal to 3, and terminates the loop.

Success! We have knocked all nearby enemies away from the Event Player. To recap, the for-loop takes a variable, sets it to Range Start, and repeatedly executes a set of actions, incrementing the variable by Step each time, until it reaches the Range Stop. You might have also noticed that there's no Wait action in this rule - this is because the loop only executes a couple of times, and there's no fear of it running an infinite amount of times in a single frame.