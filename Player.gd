extends KinematicBody2D
class_name Player

onready var collisionShape = get_node("CollisionPolygon2D")
onready var shape = get_node("Polygon2D")
onready var tween

var sides = 3 # start at triangle
# editable in 
# making this stupidly large still doesn't do all too much
export var collision_safe_margin: float = 5 # pixels
export var radius: int = 25 # pixels
export var max_velocity: float = 400 # pixels/second
export var player_accel: float = 1000 # pixels/second^2
# 1/sqrt(seconds) to decelerate
export var player_auto_decel_scale: float = 4 # 1/sqrt(seconds)

puppet var puppet_position = Vector2(0,0) setget puppet_position_set

var cur_velocity := Vector2()
var accel_dir := Vector2()

func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	tween = get_node("Tween")
	set("collision/safe_margin", collision_safe_margin)
	change_shape(sides)
	print_points()

func _process(delta):
#	var velocity = Vector2()
#	if Input.is_action_pressed("move_up"):
#		velocity.y -= 1 # y starts from top of screen
#	if Input.is_action_pressed("move_down"):
#		velocity.y += 1
#	if Input.is_action_pressed("move_left"):
#		velocity.x -= 1
#	if Input.is_action_pressed("move_right"):
#		velocity.x += 1
	#if is_network_master():
		var accel_dir = Vector2()
		if Input.is_action_pressed("move_up"):
			accel_dir.y -= 1 # y starts from top of screen
		if Input.is_action_pressed("move_down"):
			accel_dir.y += 1
		if Input.is_action_pressed("move_left"):
			accel_dir.x -= 1
		if Input.is_action_pressed("move_right"):
			accel_dir.x += 1
		# implement xbox controller version?
		
		var accel: Vector2
		# prevent diagonal accel from exceeding accel limit
		if accel_dir.length() > 0:
			accel = accel_dir.normalized() * player_accel * delta
		else: # if there is no accel input, slow down
			# want to get to zero
			var error = Vector2.ZERO - cur_velocity
			accel = error * player_auto_decel_scale * delta
		
		cur_velocity += accel
		
		cur_velocity = cur_velocity.limit_length(max_velocity)
		
		# do not multiply velocity by delta
		move_and_slide(cur_velocity)
		
		# need to provide with velocity
		# should accelerate up until a point

func _physics_process(delta):
	pass

#func _unhandled_input(event):
#	if event.is_action_pressed("move_up"):
	


func on_difficulty_change():
	# this is going to need adjustment
	sides += 1
	radius *= 1.15
	player_accel *= 1.1
	max_velocity *= 1.1
	change_shape(sides)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func change_shape(sides: int) -> void:
	var points = generate_points(sides)
	shape.polygon = points
	collisionShape.set_polygon(points)

func find_point(sides, pointID) -> Vector2:
	var x: float = cos((2 * PI * pointID) / sides) * radius
	var y: float = sin((2 * PI * pointID) / sides) * radius
	return Vector2(x, y)

func generate_points(sides: int) -> PoolVector2Array:
	var points := PoolVector2Array()
	for point in range(sides):
		var coordinates := find_point(sides, point)
		points.append(coordinates)
	return points

func print_points() -> void:
	var polygon_points = shape.polygon
	print("Polygon Points:")
	for point in polygon_points:
		print("X: %.0f, Y: %.0f" % [point.x, point.y])
	var collision_points = collisionShape.get_polygon()
	print("Collision Points:")
	for point in collision_points:
		print("X: %.0f, Y: %.0f" % [point.x, point.y])

func get_pos():
	return position

func puppet_position_set(new_value):
	puppet_position = new_value
	
	tween.interpolate_property(self, "global_position", global_position, puppet_position, 0.1)
	tween.start()

func _on_network_tick_rate_timeout():
	if is_network_master():
		rset_unreliable("puppet_position", global_position)
