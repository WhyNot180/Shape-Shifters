extends Control

var continue_button


# Called when the node enters the scene tree for the first time.
func _ready():
	continue_button = get_node("VBoxContainer/Continue")


func _on_Quit_pressed():
	get_tree().quit()


func _unhandled_input(event):
	if event.is_action_pressed("pause_game"):
		get_tree().paused = !get_tree().paused
		continue_button.setvisible # this does nothing
		_on_Quit_pressed()
