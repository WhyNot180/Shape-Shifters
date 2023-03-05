extends Node

const DEFAULT_PORT = 1024
const MAX_CLIENTS = 3

var server = null
var client = null

var ip_address = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168.") or ip.begins_with("10.") or ip.begins_with("172.16") and not ip.ends_with(".1"):
			ip_address = ip
	
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connection_failed", self, "_connection_failed")

func create_server(max_clients: int):
	server = NetworkedMultiplayerENet.new()
	server.create_server(DEFAULT_PORT, max_clients)
	get_tree().set_network_peer(server)

func join_server():
	print("joining...")
	client = NetworkedMultiplayerENet.new()
	client.create_client(ip_address, DEFAULT_PORT)
	print(client.get_connection_status())
	get_tree().set_network_peer(client)

func disconnect_server():
	rpc("disconnect_peer")
	get_tree().network_peer = null
	Lobby._server_disconnected()

remote func disconnect_peer():
	get_tree().network_peer = null
	Lobby._server_disconnected()

func _connected_to_server():
	print("connected successfully")

func _server_disconnected():
	print("disconnected from the server")

func _connection_failed():
	print("failed")
