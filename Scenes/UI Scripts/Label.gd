extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
class_name Stopwatch

export var easy_time_scale = 0.5
export var normal_time_scale = 1
export var hard_time_scale = 2

var elapsed_time = 0.0 # seconds
var time_scale = normal_time_scale

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed_time += (delta * time_scale)

func get_floored_seconds() -> int:
	return floor(elapsed_time) as int

func get_raw_seconds() -> float:
	return elapsed_time

# setup signals in main
func set_easy_difficulty():
	time_scale = easy_time_scale

func set_normal_difficulty():
	time_scale = normal_time_scale

func set_hard_difficulty():
	time_scale = hard_time_scale
