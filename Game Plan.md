# Gameplay
## General
Used both in singleplayer and multiplayer
### Layout
* The player controls a shape, which they can rotate and translate.
	* This shape has a variable amount of sides, which changes based on the difficulty.
* Sides disappear off of the shape at an interval determined by the difficulty.
	* This interval decreases with higher difficulty levels.
	* There will always be the same amount of missing sides at a certain difficulty level.
	* More sides will disappear at higher difficulty levels.
* A ball bounces off of this shape.
	* It is not controlled by the player.
	* The ball is attracted to the shape's centre by gravitational force.
	* When a side disappears, the ball can pass through it.
* The shape and the ball can move anywhere on a finite game area.
	* When the player or ball exits the game area, gravity increases proportional to their distance from the game area.
	* This prevents them from exiting the game area, while being less restrictive than a hard wall.
	* **How is the size of the game area determined?**

### Scoring
* A timer begins when the game starts.
	* On easier difficulty levels, the timer progresses at a slower rate.
		* This increases difficulty more gradually.
	* On normal difficulty, the timer progresses at a normal rate.
		* The difficulty increases normally.
	* On harder difficulty levels, the timer progresses at a faster rate.
		* This increases difficulty more sharply.
* The player loses when the ball enters the centre of their shape.
	* The player's score is equal to the timer.
	* By choosing different difficulty levels, the timer progresses at a slower or faster rate, which will adjust the score according to the difficulty level.
		* Higher difficulty levels will increase the timer at a faster rate, which will mean a player on higher difficulty levels will earn more points given the same amount of actual time.

### Difficulty
* The game's difficulty is determined by the current time.
	* Difficulty increases proportionally with time.
	* It does not increase at certain points, instead, it increases smoothly as the timer increases.
* Difficulty affects:
	* The strength of gravity
	* The amount of sides the shape has
	* How often the sides disappear
	* How many sides disappear
* Easier difficulty levels:
	* **Decrease** the strength of gravity
		* This slows the ball down, allowing more reaction time
	* **Decrease** the amount of sides the shape has
		* Each side is larger, and easier to defend
		> the above sentence makes little sense, please rewrite
	* **Increase** the time interval between when sides disappear
		* The player does not have to adjust their strategy as often
	* **Decrease** the amount of sides that disappear
		* More of the player's shape can be used to deflect the ball
* Harder difficulty levels:
	* **Increase** the strength of gravity
		* This speeds up the ball, reducing reaction time
	* **Increase** the amount of sides the shape has
		* Each side is smaller, and harder to defend
		> same note as the easy version of this sentence, plz rewrite
	* **Decrease** the time interval between when sides disappear
		* The player has to adjust their strategy more often
	* **Increase** the amount of sides that disappear
		* Less of the player's shape can be used to deflect the ball
* The player chooses a difficulty level to start at:
	* See **Scoring**
	* This changes the rate the timer will increase.
		* Since higher timer values will increase difficulty, this will make the game harder to play, as higher timer levels are reached more quickly.
	* The player is compensated for the increase in difficulty, because the timer, and their score, increases more quickly in the same amount of actual time.

## Player Controls
### Rotation
* rotation should increase to a specific limit, or do we let the player increase the velocity as much as they want
	> Probably not a good idea otherwise they will fling the ball into space.

### Translation
* add out-of-bounds info here

## Physics
### Shape
* how do we handle collisions between two people in multiplayer
	> just an elastic collision?
* shape should be pulled towards the centre of the map when going out of bounds
	> should not be affected by gravity while in bounds
	> * see "Spacewar"

### Ball
* affected by rotation of shape
* affected by gravity (pulled towards centre)
	> elastic collision with shape
		> i.e. it bounces off at the same rate it hit the shape

## Singleplayer

## Multiplayer

# Ideas
- ~~more gravity on higher difficulty~~
- ~~ball, hexagon~~
- ~~ball bounce off of hexagon sides~~
- ~~gravity pulls ball *towards* hexagon~~
- ~~goal is to bounce~~
* ~~increment score by some amount on each successful bounce~~
* ~~or by time~~
> ~~it is **timed**~~
> you want to last the longest

# player
* multiplayer = more hexagons
* can bounce ball towards other players
* gravity pulls ball towards other players, see **GRAVITY WARS**
* multiplayer: you want to eliminate your oppoents

~~If ball gets too far from any hexagon, increase gravity proportional (or quadratic?) to its distance from the out of bounds tolerance~~

Distance measured from game area or hexagon? Should game area be infinite (and scroll) or finite and on screen at once, or finite (larger than screen, scroll)

spin faster = accelerate ball

multiple balls?

hexagons move around (intentional, automatic)?

How do we show a dead player?
* Show their shape transparently?
* Explode their shape?