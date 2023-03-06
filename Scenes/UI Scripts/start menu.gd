extends Control

func _ready():
	pass

func _on_Multiplayer_pressed():
	get_tree().change_scene("res://Scenes/Server Menu.tscn") 


func _on_how_to_pressed():
	get_tree().change_scene("res://Scenes/howtoplay.tscn")


#func _on_controls_pressed():
	#get_tree().change_scene.add_child(options)

func _on_Quit_pressed():
	get_tree().quit()
