extends RigidBody2D

export (float) var increased_gravity_scale = 10.0
export (float) var normal_gravity_scale = 1.0

func _on_network_tick_rate_timeout():
	pass

func _physics_process(delta):
	Balls.set_ball_vars(global_position, linear_velocity)

func _on_VisibilityNotifier2D_viewport_entered(_viewport):
	gravity_scale = normal_gravity_scale


func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	gravity_scale = increased_gravity_scale

func _on_Ball_body_entered(body):
	if body != null:
		if body is KinematicBody2D:
			get_tree().call_group("Players", "_enable_gravity")
			yield(get_tree().create_timer(0.03), "timeout")
			Players.get_node(body.name + "/GravityArea").emit_signal("disable_gravity")
			#Players.get_node(body.name).emit_signal("increase_hidden_sides")
			body.emit_signal("increase_hidden_sides")
