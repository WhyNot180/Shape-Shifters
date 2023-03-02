extends Node2D

signal MORE_SIDES # should be sent from Stopwatch


var Ball = preload("res://Ball.tscn")
var Player = preload("res://Player.tscn")
var players: Array
var current_player_id: int = 0

# should all be handled from stopwatch
var difficulty = 15
var difficulty_modulo
var seconds_elapsed = 0
var last_recorded_time = 0
var amount_sides = 3
var missing_sides = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	_start_game() # this should be moved to a menu once complete


# rename/modify as necessary, placeholder
func _start_game():
	# create player 0
	_on_player_join()


# rename/modify as necessary, placeholder
func _on_player_join():
	# create a new player with the current ID then increment it
	players.append(Player.instance(current_player_id))
	add_child(players[current_player_id])
	# connect player signals
	connect("MORE_SIDES", players[current_player_id], "_on_difficulty_change")
	current_player_id += 1


# rename/modify as necessary, placeholder
func _on_player_leave(player_id):
	players[player_id].queue_free()


# move difficulty changes to Stopwatch
#func timer_timeout():
#	seconds_elapsed += 1
#	if(seconds_elapsed % difficulty == 0):
#		difficulty_modulo = seconds_elapsed % 3
#		match difficulty_modulo:
#			0:
#				amount_sides += 1
#			1:
#				gravity += 50
#				gravity_area.emit_signal("change_grav", gravity)
#			2:
#				if(missing_sides < amount_sides - 1):
#					missing_sides += 1
#			_:
#				print("entered default")
#		if(difficulty != 1): difficulty -= 1
#	pass

func _unhandled_input(event):
	# temporary
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			var b = Ball.instance()
			add_child(b)
			b.set_position(get_node("BallStartPos").position)
			emit_signal("MORE_SIDES")
