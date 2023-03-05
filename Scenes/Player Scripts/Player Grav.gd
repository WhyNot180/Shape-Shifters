extends Area2D

signal change_grav(strength)

var new_grav = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _change_grav(strength):
	new_grav = strength
	print("increasing gravity")

func get_grav() -> float:
	return gravity

func _physics_process(delta):
	gravity = new_grav
