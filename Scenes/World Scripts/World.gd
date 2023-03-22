extends Node2D

onready var game_over = $GameOver
signal game_over

func _ready():
	get_node("HostIPLabel").text += " " + Network.ip_address

func _game_over():
	game_over.visible = true

func _on_Spectate_pressed():
	game_over.visible = false

func _on_BackToMenu_pressed():
	if get_tree().get_network_unique_id() == 1:
		Network.disconnect_server()
	else:
		Network.disconnect_peer()
