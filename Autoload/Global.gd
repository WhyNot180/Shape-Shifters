extends Node

func instance_node_at_location(node: Object, parent: Object, location: Vector2) -> Object:
	var node_instance = instance_node(node, parent)
	node_instance.global_position = location
	return node_instance

func instance_node(node: Object, parent: Object) -> Object:
	var node_instance = node.instance()
	parent.add_child(node_instance)
	return node_instance

func instance_client_ball(client_ball):
	var ball_instance = instance_node(client_ball, Players)
	ball_instance.global_position = Balls.puppet_ball_position
