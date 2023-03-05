extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


<<<<<<< HEAD:LineEdit.gd
func _on_player_count_text_entered(new_text):
	pass # Replace with function body.
=======
func _unhandled_input(event):
	if event.is_action_pressed("pause_game"):
		if get_tree().get_network_unique_id() == 1:
			Network.disconnect_server()
		else:
			Network.disconnect_peer()
>>>>>>> Networking:Scenes/World Scripts/Pause.gd
