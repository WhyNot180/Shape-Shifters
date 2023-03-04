extends Node2D

signal MORE_SIDES # should be sent from Stopwatch

var Ball = load("res://Ball.tscn")

# should all be handled from stopwatch
var difficulty = 15
var difficulty_modulo
var seconds_elapsed = 0
var last_recorded_time = 0
var amount_sides = 3
var missing_sides = 1

var gravity = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
