extends Node2D

signal MORE_SIDES

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Ball = load("res://Ball.tscn")
#var Player = load("res://Player.tscn")

var difficulty = 15

var difficulty_modulo

var seconds_elapsed = 0
var last_recorded_time = 0

var amount_sides = 3

var missing_sides = 1

var gravity = 500

var gravity_areas = []

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_areas.append(get_node("Gravity"))
	gravity_areas.append(rpc())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().is_network_server():
		rpc_unreliable("update_position", ball_position, gravity_positions)

puppetsync func update_position(ball_position, gravity_positions):
	b.set_position(ball_position)
	for i in gravity_position:
		gravity_areas[i].set_position(gravity_position[i])

func timer_timeout():
	seconds_elapsed += 1
	if(seconds_elapsed % difficulty == 0):
		difficulty_modulo = seconds_elapsed % 3
		match difficulty_modulo:
			0:
				amount_sides += 1
			1:
				gravity += 50
				gravity_area.emit_signal("change_grav", gravity)
			2:
				if(missing_sides < amount_sides - 1):
					missing_sides += 1
			_:
				print("entered default")
		if(difficulty != 1): difficulty -= 1

# temporary
func _process(delta):
	gravity_area.set_position(get_node("Player").position)
	# should make gravity a child of Player (put in the player scene)

func _unhandled_input(event):
	# temporary
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			var b = Ball.instance()
			add_child(b)
			b.set_position(event.position)
			emit_signal("MORE_SIDES")

func _on_Gravity_change_grav(strength):
	pass # Replace with function body.
