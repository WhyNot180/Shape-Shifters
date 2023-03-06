# Twisted-Pong

## Objective of the game

The game is a multiplayer game where the last man standing wins. The players are represented as 2-D shapes that can be rotated and moved around the play area. There is a ball that is gravitationally attracted to the players, as well as the center of the play area. When the ball bounces off a player, the player will have a certain number of sides go missing and their gravity field will be disabled until another player is hit. If the ball reaches the inside of a player, then the player will disappear and be out of the game, afterwhich they may choose to exit or continue to spectate. The game will slowly become more difficult over time as the gravity increases and the total amount of sides increase.

## The Game Engine

The game was created using the [Godot engine](https://godotengine.org/). The scripting code was created using it's [GDScript language](https://docs.godotengine.org/en/3.5/tutorials/scripting/gdscript/gdscript_basics.html), which is similar in syntax with python and javascript. It also supports other languages, such as C# and C++, but we've opted for using GDScript due to time constraints and its simplicity.

The game engine was chosen due to its relative ease of use and UI editing capabilities.

## 