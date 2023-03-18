extends RigidBody2D

export (float) var increased_gravity_scale = 10.0
export (float) var normal_gravity_scale = 1.0

onready var tween = $Tween

puppet var puppet_ball_position = Vector2(0, 0) setget puppet_ball_position_set
puppet var puppet_ball_velocity = Vector2(0, 0)

func _on_network_tick_rate_timeout():
	if is_network_master():
		rset_unreliable("puppet_ball_position", global_position)
		rset_unreliable("puppet_ball_velocity", linear_velocity)

func _ready():
	yield(get_tree().create_timer(0.03), "timeout")
	if not is_network_master():
		print("is master")
		set_mode(3)
		set_use_custom_integrator(true)
	else:
		print("is not master")
		set_mode(0)
		set_use_custom_integrator(false)

func _integrate_forces(state):
	if not tween.is_active():
		state.add_central_force(puppet_ball_velocity)
	if state.get_contact_count() > 0:
		puppet_ball_velocity.bounce(state.get_contact_local_normal(0))
		state.apply_central_impulse(-puppet_ball_velocity*1.5)

func _on_Ball_body_entered(body):
	#if is_network_master():
	if body != null:
		if body is KinematicBody2D:
			get_tree().call_group("Players", "_enable_gravity")
			yield(get_tree().create_timer(0.03), "timeout")
			Players.get_node(body.name + "/GravityArea").emit_signal("disable_gravity")
			#Players.get_node(body.name).emit_signal("increase_hidden_sides")
			body.emit_signal("increase_hidden_sides")

func puppet_ball_position_set(new_value):
	puppet_ball_position = new_value
	
	tween.interpolate_property(self, "global_position", global_position, puppet_ball_position, 0.1)
	tween.start()
