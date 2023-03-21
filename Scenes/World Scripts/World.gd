extends Node2D


func _ready():
	get_node("HostIPLabel").text += " " + Network.ip_address
