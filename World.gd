extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Ball = load("res://Ball.tscn")

var difficulty = 15

var difficulty_modulo

var seconds_elapsed = 0
var last_recorded_time = 0

var amount_sides = 3

var missing_sides = 1

var gravity = 500

var gravity_area

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_area = get_node("Gravity")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
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
	
	


func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			var b = Ball.instance()
			add_child(b)
			b.set_position(event.position)
		#if event.button_index == BUTTON_RIGHT:
			
	if event is InputEventMouseMotion:
		gravity_area.set_position(event.position)
