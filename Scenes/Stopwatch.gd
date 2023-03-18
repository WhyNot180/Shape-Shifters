extends Timer
class_name Stopwatch

# should all be handled from stopwatch
export var difficulty = 15
var difficulty_modulo
export var amount_sides = 3
export var missing_sides = 1

export var gravity = 500

export var elapsed_time = 0 # seconds

onready var id = get_tree().get_network_unique_id()

# Called when the node enters the scene tree for the first time.
func _ready():
	start()

func _Stopwatch_timeout():
	if id == 1:
		elapsed_time += 1
		if(elapsed_time % difficulty == 0):
			difficulty_modulo = elapsed_time % 2
			match difficulty_modulo:
				0:
					amount_sides += 1
					rpc("change_sides", amount_sides)
				1:
					gravity += 50
					rpc("change_gravity", gravity)
				_:
					print("entered default")
			if(difficulty != 1): difficulty -= 1
			$Shape_change.play()

remotesync func change_sides(sides):
	get_tree().call_group("Players", "_on_difficulty_change", sides)

remotesync func change_gravity(strength):
	print("rpc grav")
	get_tree().call_group("Players", "_change_grav", strength)
