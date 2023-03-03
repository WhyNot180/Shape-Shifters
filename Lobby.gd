extends Control

var player = load("res://Player.tscn")
var ball = load("res://Ball.tscn")
var client_ball = load("res://Client Ball.tscn")

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
		Players.get_node(str(id)).queue_free()

func _connected_to_server():
	yield(get_tree().create_timer(0.1), "timeout")
	instance_player(get_tree().get_network_unique_id())
	instance_client_ball()

func _server_disconnected():
	Players.queue_free()
	get_tree().change_scene("res://Server Menu.tscn")

func _on_2_player_pressed():
	Network.create_server(2)
	print(str(Network.ip_address))
	get_tree().change_scene("res://World.tscn")
	instance_player(get_tree().get_network_unique_id())
	instance_server_ball(1)

func _on_3_player_pressed():
	Network.create_server(3)
	print(str(Network.ip_address))
	get_tree().change_scene("res://World.tscn")
	instance_player(get_tree().get_network_unique_id())
	instance_server_ball(1)

func _on_Join(ip: String):
	if ip != "" and ip.is_valid_ip_address():
		Network.ip_address = ip
		Network.join_server()
		get_tree().change_scene("res://World.tscn")

func instance_player(id):
	var player_instance = Global.instance_node_at_location(player, Players, Vector2(rand_range(10, 990), rand_range(10, 990)))
	player_instance.name = str(id)
	player_instance.set_network_master(id)

func instance_server_ball(id):
	var ball_instance = Global.instance_node_at_location(ball, Players, Vector2(rand_range(10, 990), rand_range(10, 990)))
	ball_instance.name = "ball"

func instance_client_ball():
	var ball_instance = Global.instance_node(client_ball, Players)
	ball_instance.name = "ball"
