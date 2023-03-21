extends Control

onready var loading_arrow = $Loading_arrow
onready var loading_text = $Loading_text
var rotation = 0
signal failed_to_connect

func _ready():
	pass

func _process(delta):
	rotation += 0.1
	if rotation > PI * 2:
		rotation = 0
	loading_arrow.set_rotation(rotation)

func _connection_failed():
	loading_arrow.visible = false
	loading_text.text = "Connection failed"
	loading_text.visible = true

func _on_Join_Server_pressed():
	if (1024 <= get_node("Join Menu/Join/Port").text.to_int()) && get_node("Join Menu/Join/Port").text.to_int() <= 65535:
		loading_arrow.visible = true
		loading_text.text = "Loading..."
		loading_text.visible = true
		Lobby.port = get_node("Join/Port").text.to_int()
		Lobby.ip = get_node("Join/Server IP").text
		Lobby.username_text = get_node("Common/Username").text
		Lobby._on_Join()


func _on_Create_Server_pressed():
	if get_node("Host Menu/Host/Number of players").text != "" && ((1024 <= get_node("Host Menu/Host/Port").text.to_int()) && get_node("Host Menu/Host/Port").text.to_int() <= 65535):
		Lobby.port = get_node("Host Menu/Host/Port").text.to_int()
		Lobby.number_of_players = get_node("Host Menu/Host/Number of players").text.to_int()
		Lobby.username_text = get_node("Common/Username").text
		Lobby._on_Create_Server()


func _on_Back_Button_pressed():
	get_tree().change_scene("res://Scenes/Menu.tscn")
