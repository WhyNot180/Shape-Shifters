extends Control

func _ready():
	pass 

func _on_Join_Server_pressed():
	if (1024 <= get_node("Join/Port").text.to_int()) && get_node("Join/Port").text.to_int() <= 65535:
		Lobby.port = get_node("Join/Port").text.to_int()
		Lobby.ip = get_node("Join/Server IP").text
		Lobby.username_text = get_node("Common/Username").text
		Lobby._on_Join()


func _on_Create_Server_pressed():
	if get_node("Host/Number of players").text != "" && ((1024 <= get_node("Host/Port").text.to_int()) && get_node("Host/Port").text.to_int() <= 65535):
		Lobby.port = get_node("Host/Port").text.to_int()
		Lobby.number_of_players = get_node("Host/Number of players").text.to_int()
		Lobby.username_text = get_node("Common/Username").text
		Lobby._on_Create_Server()


func _on_Back_Button_pressed():
	get_tree().change_scene("res://Scenes/Menu.tscn")
