extends Area2D

signal change_grav(strength)
signal disable_gravity

var new_grav = 500
var grav_enable = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _change_grav(strength):
	new_grav = strength
	print("increasing gravity")

func get_grav() -> float:
	return gravity

func _physics_process(delta):
	if grav_enable:
		gravity = new_grav

remote func _disable_gravity():
	print("disabling gravity...")
	Balls.gravity_enabled = false
	if get_tree().get_network_unique_id() == 1:
		rpc("_disable_gravity")
	grav_enable = false
	gravity = 0

remote func _enable_gravity():
	print("enabling gravity...")
	if get_tree().get_network_unique_id() == 1:
		rpc("_enable_gravity")
	grav_enable = true
	Balls.gravity_enabled = true
