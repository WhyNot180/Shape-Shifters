extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _on_singleplayer_pressed():
	#get_tree().change_scene() 

func _on_Multiplayer_pressed():
	get_tree().change_scene("res://Server Menu.tscn") 


func _on_how_to_pressed():
	get_tree().change_scene("res://howtoplay.tscn")


#func _on_controls_pressed():
	#get_tree().change_scene.add_child(options)

func _on_Quit_pressed():
	get_tree().quit()
