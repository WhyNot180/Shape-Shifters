extends Node2D

var player_following = null
var text = "" setget text_set

onready var label = $Label

func _physics_process(delta):
	if player_following != null && player_following.visible:
		global_position = player_following.global_position

func text_set(new_text):
	text = new_text
	get_node("Label").text = text
