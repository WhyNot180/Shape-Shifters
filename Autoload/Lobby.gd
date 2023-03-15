extends Control

var player = load("res://Scenes/Player.tscn")
var ball = load("res://Scenes/Ball.tscn")
var client_ball = load("res://Scenes/Client Ball.tscn")

var username_text
var port
var number_of_players
var ip

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _player_connected(id):
	if id != get_tree().get_network_unique_id():
		print("Player " + str(id) + " has connected")
		instance_player(id)

func _player_disconnected(id):
	print("Player " + str(id) + " has disconnected")
	
	if Players.has_node(str(id)):
		Players.get_node(str(id)).username_instance.queue_free()
		Players.get_node(str(id)).queue_free()

func _connected_to_server():
	get_tree().change_scene("res://Scenes/World.tscn")
	instance_player(get_tree().get_network_unique_id())
	yield(get_tree().create_timer(0.1), "timeout")
	instance_server_ball()

func _server_disconnected():
	var children = Players.get_children()
	for n in children:
		Players.remove_child(n)
		n.queue_free()
	get_tree().change_scene("res://Scenes/Server Menu.tscn")

func _on_Join():
	if ip != "" and ip.is_valid_ip_address():
		Network.ip_address = ip
		Network.port = port
		Network.join_server()

func instance_player(id):
	var player_instance = Global.instance_node_at_location(player, Players, Vector2(rand_range(10, 1910), rand_range(300, 1070)))
	player_instance.name = str(id)
	player_instance.set_network_master(id)
	if username_text != "":
		player_instance.username = username_text
	else:
		player_instance.username = str(id)

func instance_server_ball():
	var ball_instance = Global.instance_node_at_location(ball, Players, Vector2(rand_range(10, 1910), rand_range(10, 200)))
	ball_instance.name = "ball"
	ball_instance.set_network_master(1)
	print("set master")

func instance_client_ball(client_ball):
	var ball_instance = Global.instance_node_at_location(client_ball, Players, Vector2(rand_range(10, 1910), rand_range(10, 200)))
	ball_instance.global_position = Balls.puppet_ball_position

func _on_Create_Server():
	Network.max_clients = number_of_players
	Network.port = port
	Network.create_server()
	print(str(Network.ip_address))
	get_tree().change_scene("res://Scenes/World.tscn")
	instance_player(get_tree().get_network_unique_id())
	instance_server_ball()
