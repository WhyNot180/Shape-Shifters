extends KinematicBody2D

var tween

var velocity

func _ready():
	Balls.tween = get_node("Tween")
	Balls.Client_Ball = get_node("Client Ball")

func _physics_process(delta):
	var colliding = test_move(Transform2D(Vector2(global_position.x, 0), Vector2(0, global_position.y), Vector2(0, 0)), Vector2(0,0))
	if not Balls.tween.is_active():
		var collision = move_and_collide(Balls.puppet_ball_velocity * delta)
		if collision:
			print("collision")
			Balls.puppet_ball_velocity = Balls.puppet_ball_velocity.bounce(collision.get_normal())
	elif Balls.tween.is_active() and colliding:
		print("collision")
		var collision = move_and_collide(velocity * delta)
		velocity = velocity.bounce(collision.get_normal())
		move_and_collide(velocity * delta)
	else:
		velocity = Balls.puppet_ball_velocity
