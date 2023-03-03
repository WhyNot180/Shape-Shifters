extends RigidBody2D

func _on_network_tick_rate_timeout():
	Balls.set_ball_vars(global_position, linear_velocity)
