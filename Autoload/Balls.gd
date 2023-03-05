extends Node

var tween

var Client_Ball

puppet var puppet_ball_position = Vector2(0, 0) setget puppet_ball_position_set
puppet var puppet_ball_velocity = Vector2(0, 0)

func set_ball_vars(pos: Vector2, vel: Vector2):
	rset_unreliable("puppet_ball_position", pos)
	rset_unreliable("puppet_ball_velocity", vel)

func puppet_ball_position_set(new_value):
	puppet_ball_position = new_value
	Client_Ball = Players.get_node("Client Ball")
	if Client_Ball != null:
		tween.interpolate_property(Client_Ball, "global_position", Client_Ball.global_position, puppet_ball_position, 0.01)
		tween.start()
