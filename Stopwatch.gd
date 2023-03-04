extends Timer
class_name Stopwatch

export var easy_time_scale = 0.5
export var normal_time_scale = 1
export var hard_time_scale = 2

# should all be handled from stopwatch
export var difficulty = 15
var difficulty_modulo
export var amount_sides = 3
export var missing_sides = 1

export var gravity = 500

export var elapsed_time = 0 # seconds
var time_scale = normal_time_scale

onready var id = get_tree().get_network_unique_id()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	start()

func _player_connected(id):
	if id != get_tree().get_network_unique_id():
		rpc_id(id, "change_sides", get_tree().call_group("Players", "get_sides"))
		rpc_id(id, "change_sides", get_tree().call_group("Players", "get_grav"))

func _Stopwatch_timeout():
	if id == 1:
		elapsed_time += 1
		if(elapsed_time % difficulty == 0):
			difficulty_modulo = elapsed_time % 3
			match difficulty_modulo:
				0:
					amount_sides += 1
					rpc("change_sides", amount_sides)
				1:
					gravity += 50
					rpc("change_gravity", gravity)
				2:
					if(missing_sides < amount_sides - 1):
						missing_sides += 1
				_:
					print("entered default")
			if(difficulty != 1): difficulty -= 1

func get_floored_seconds() -> int:
	return floor(elapsed_time) as int

func get_raw_seconds() -> float:
	return elapsed_time

# setup signals in world
func set_easy_difficulty():
	time_scale = easy_time_scale

func set_normal_difficulty():
	time_scale = normal_time_scale

func set_hard_difficulty():
	time_scale = hard_time_scale

remotesync func change_sides(sides):
	get_tree().call_group("Players", "_on_difficulty_change", sides)

remotesync func change_gravity(strength):
	print("rpc grav")
	get_tree().call_group("Players", "_change_grav", strength)
