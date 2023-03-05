extends Node2D


var Ball = preload("res://Ball.tscn")
var Player = preload("res://Player.tscn")
var players: Array
var current_player_id: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	_start_game() # this should be moved to a menu once complete


# rename/modify as necessary, placeholder
func _start_game():
	# create player 0
	_on_player_join()
	get_node("TimerController").set_normal_difficulty()
	get_node("TimerController")._on_game_start()
	# select stopwatch difficulty here


# rename/modify as necessary, placeholder
func _on_player_join():
	# create a new player with the current ID then increment it
	players.append(Player.instance(current_player_id))
	add_child(players[current_player_id])
	# connect player signals
# warning-ignore:return_value_discarded
	get_node("TimerController").connect("gravity_change", players[current_player_id], "_change_gravity")
# warning-ignore:return_value_discarded
	get_node("TimerController").connect("side_amount_change", players[current_player_id], "_change_sides")
# warning-ignore:return_value_discarded
	get_node("TimerController").connect("hidden_side_amount_change", players[current_player_id], "_change_hidden_sides")
	current_player_id += 1


# rename/modify as necessary, placeholder
func _on_player_leave(player_id):
	players[player_id].queue_free()


func _unhandled_input(event):
	# temporary
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			var b = Ball.instance()
			add_child(b)
			b.add_to_group("Balls")
			b.set_position(get_node("BallStartPos").position)
			emit_signal("MORE_SIDES")
		#if event.button_index == BUTTON_RIGHT:
		#	#missing_sides += 1
		#	emit_signal("CHANGE_HIDDEN_SIDES", missing_sides)
