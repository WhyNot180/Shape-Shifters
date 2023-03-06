# Gameplay
## General
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
	* The player's shape cannot exit the game area.
	* When the ball exits the game area, gravity increases proportional to its distance from the game area. This means that the ball can exit the game area, but will quickly be pulled back.
	* The game area is restricted to the size of the player's screen.

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
	* **Increase** the time interval between when sides disappear
		* The player does not have to adjust their strategy as often
	* **Decrease** the amount of sides that disappear
		* More of the player's shape can be used to deflect the ball
* Harder difficulty levels:
	* **Increase** the strength of gravity
		* This speeds up the ball, reducing reaction time
	* **Increase** the amount of sides the shape has
		* Each side is smaller, and harder to defend
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
* The player can control how fast their shape is spinning.
	* The player can accelerate in a clockwise or counterclockwise direction, until they reach a maximum velocity.
	* This prevents the ball from being sent far away from the player.

### Translation
* The player can move up, down, left, or right.
	* The player cannot move past the boundary of the game area.

## Multiplayer
### Layout
* Multiplayer is played on the same game area.
* Each player is assigned a unique number starting at 1.
* Each player is assigned a seperate shape.
	* The player's unique number is shown in the centre of the shape, in text that contrasts that background of the game area.
	> For example, white text if the background is black.
* Each player's shape is a different colour.
	* The player's number is shown to distinguish different players for colour-blind people.
* The ball is attracted to each player's shape, with the strength depending on its distance from the centre of each shape.
	* The ball behaves similarly to an asteroid in a solar system.
	* can bounce ball towards other players
	* gravity pulls ball towards other players, see **GRAVITY WARS**

### Scoring
* The timer is still visible, but players are not assigned a score.
* The game ends when one player is still alive. This player wins the game.
* When a ball enters the centre of a player's shape, their shape and number are no longer shown on the game area.
	* The player has lost the game.
	> Indicate the player has died.

### Player Controls
* Each player plays on a seperate device.
* Each player controls a seperate shape, using the same controls as singleplayer.

## Physics
### Shape
* How are collisions handled between two shapes in multiplayer?
	> Elastic collisions?
* Player shapes are never affected by gravity.
~~* shape should be pulled towards the centre of the map when going out of bounds~~
	> ~~Should not be affected by gravity while in bounds~~
	> ~~* see "Spacewar"~~

### Ball
* Balls are pulled towards the centre of the game area when they are not affected by a player.
* When balls are close to a player, they will be attracted to the player's centre.
	* When the ball collides with the player, it will stop being attracted to the player.
	* The ball will resume being attracted to the player once it collides with another player.
* When a ball collides with a player's shape, it will experience an elastic collision and bounce off of the player.
	* The player's rotational velocity will be applied to the ball, causing it to bounce off of the player at a higher velocity.
