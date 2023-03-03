extends RigidBody2D


export (float) var increased_gravity_scale = 10.0
export (float) var normal_gravity_scale = 1.0

func _on_network_tick_rate_timeout():
	Balls.set_ball_vars(global_position, linear_velocity)

func _on_VisibilityNotifier2D_viewport_entered(_viewport):
	gravity_scale = normal_gravity_scale


func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	gravity_scale = increased_gravity_scale
