extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal change_grav(strength)

var new_grav = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _change_grav(strength):
	new_grav = strength
	print("increasing gravity")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	gravity = new_grav
