extends KinematicBody2D
class_name Player

var m_player_id: int

onready var collisionShape = get_node("CollisionPolygon2D")
onready var shape = get_node("Polygon2D")

export (int) var radius = 25 # pixels
# making this stupidly large still doesn't do all too much
export (float) var collision_safe_margin = 25.0 # pixels
export (float) var max_velocity = 400.0 # pixels/second
export (float) var player_accel = 1000.0 # pixels/second^2
export (float) var max_rot_velocity = 2.5 * (2 * PI) # radians/s clockwise-positive 
export (float) var player_rot_accel = 2 * PI # radians/s^2 clockwise-positive
# 1/sqrt(seconds) to decelerate
export (float) var player_auto_decel_scale = 4.0 # 1/sqrt(seconds)
# find out what unit this is
export (float) var player_rot_auto_decel_scale = 1.0 # unit here

var cur_sides: int = 3 # start at triangle
var cur_velocity := Vector2()
var rot_velocity := 0.0 # radians/s clockwise-positive

# clockwise-positive
enum RotDir {CCW_LEFT = -1, NONE = 0, CW_RIGHT = 1}


func _init(player_id: int = 0):
	m_player_id = player_id

# Called when the node enters the scene tree for the first time.
func _ready():
	set("collision/safe_margin", collision_safe_margin)
	change_shape(cur_sides) # create triangle
	print_points()


func _physics_process(delta):
	# add xbox controls?
	var accel_dir = Vector2()
	if Input.is_action_pressed("move_up"):
		accel_dir.y -= 1 # y starts from top of screen
	if Input.is_action_pressed("move_down"):
		accel_dir.y += 1
	if Input.is_action_pressed("move_left"):
		accel_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		accel_dir.x += 1
	var rot_accel_dir = RotDir.NONE
	if Input.is_action_pressed("rotate_left"):
		rot_accel_dir = RotDir.CCW_LEFT
	if Input.is_action_pressed("rotate_right"):
		rot_accel_dir = RotDir.CW_RIGHT
	
	var accel: Vector2
	if accel_dir.length() > 0:
		# calculate acceleration and add to velocity
		accel = accel_dir.normalized() * player_accel * delta
	else:
		# slow down if there is no accel input
		var error = Vector2.ZERO - cur_velocity
		accel = error * player_auto_decel_scale * delta
	cur_velocity += accel
	# prevent velocity from exceeding max
	cur_velocity = cur_velocity.limit_length(max_velocity)
	
	if rot_accel_dir != RotDir.NONE:
		# calculate rotational acceleration and add to velocity
		rot_velocity += rot_accel_dir * player_rot_accel * delta
		# prevent rotational velocity from exceeding max
		rot_velocity = clamp(rot_velocity, -max_rot_velocity, max_rot_velocity)
	else:
		# slow down if there is no accel input
		var error = 0.0 - rot_velocity
		rot_velocity += error * player_rot_auto_decel_scale * delta
	
	# apply velocity and rotation
# warning-ignore:return_value_discarded
	move_and_slide(cur_velocity) # do not multiply delta by velocity
	rotate(rot_velocity * delta) # do multiply delta by velocity


func _on_difficulty_change():
	# will need adjustment
	cur_sides += 1
	radius *= 1.15 # likely want to limit this to a maximum size, or keep the same size constantly
	player_accel *= 1.1 # not necessary if the shape doesn't change size
	max_velocity *= 1.1 # see above
	change_shape(cur_sides)


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
