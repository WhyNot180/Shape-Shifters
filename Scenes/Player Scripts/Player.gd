extends KinematicBody2D
class_name Player

# should we keep the other point generating functions to generate a CollisionShape2D for the scoring system?
# yes
# also add the CollisionShape2d to the player, it will silence the warning too


signal MORE_SIDES

signal increase_hidden_sides()

var max_missing_sides = 1

onready var gravity_area = get_node("GravityArea")
onready var tween

var m_player_id: int
var line_segments: Array
var random = RandomNumberGenerator.new()

export (Color) var color = Color.lightblue
export (int) var m_radius = 25 # pixels
export (int) var outline_width = 10 # pixels
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

puppet var puppet_player_position = Vector2(0, 0) setget puppet_player_position_set
puppet var puppet_player_velocity = Vector2(0, 0)
puppet var puppet_player_rotation = 0
puppet var puppet_rot_velocity = 0.0

# this becomes a bad idea once _change_sides() is called with a different number
var cur_sides: int = 3 # start at triangle
var cur_velocity := Vector2()
var rot_velocity := 0.0 # radians/s clockwise-positive

# clockwise-positive
enum RotDir {CCW_LEFT = -1, NONE = 0, CW_RIGHT = 1}


class LineSegment:
	var line_2d: Line2D
	var collision_shape_2d: CollisionShape2D


	func _init():
		# setup collision_shape_2d/line_2d stuff here (e.g. colour)
		line_2d = Line2D.new()
		collision_shape_2d = CollisionShape2D.new()


	func hide():
		line_2d.visible = false
		collision_shape_2d.disabled = true


	func set_position(point_set: PoolVector2Array):
		assert(point_set.size() == 2)
		line_2d.points = point_set
		var shape = SegmentShape2D.new()
		shape.a = point_set[0]
		shape.b = point_set[1]
		collision_shape_2d.shape = shape

	func setup(color: Color, outline_width: float):
		line_2d.default_color = color
		line_2d.width = outline_width


	func show():
		line_2d.visible = true
		collision_shape_2d.disabled = false


func _init(player_id: int = 0):
	m_player_id = player_id

# Called when the node enters the scene tree for the first time.
func _ready():
	tween = get_node("Tween")
	set("collision/safe_margin", collision_safe_margin)
	get_node("InnerBoundary").get_node("VisibleShape").color = color.lightened(0.5)
	_change_shape(cur_sides) # create triangle


func _physics_process(delta):
	# add xbox controls?
	if is_network_master():
		var accel_dir := Vector2()
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
	else:
		rotation = lerp_angle(rotation, puppet_player_rotation, delta * 8)
		if not tween.is_active():
			move_and_slide(puppet_player_velocity)

func _on_body_entered(body: Node):
	if body is RigidBody2D:
		rpc("_on_player_died")

func _on_difficulty_change(sides):
	cur_sides = sides
	print("changing shape")
	_change_shape(cur_sides)

remotesync func _on_player_died():
	hide()
	yield(get_tree().create_timer(1), "timeout")
	queue_free() # delete this player
	# do whatever necessary to show the player died here

func get_sides() -> int:
	return cur_sides

func _apply_points(sides: int, point_sets: Array, polygon_points: PoolVector2Array):
	assert(sides == point_sets.size())
	var id := 0
	# reassign existing points if they exist
	while id < line_segments.size():
		line_segments[id].set_position(point_sets[id])
		id += 1
	# create new points if needed
	while id < point_sets.size():
		line_segments.append(LineSegment.new())
		line_segments[-1].setup(color, outline_width)
		line_segments[-1].set_position(point_sets[id])
		add_child(line_segments[-1].line_2d)
		add_child(line_segments[-1].collision_shape_2d)
		id += 1
	# assign points to inner boundary polygon
	get_node("InnerBoundary").get_node("CollisionShape").polygon = polygon_points
	get_node("InnerBoundary").get_node("VisibleShape").polygon = polygon_points


puppet func _change_hidden_sides(hidden_sides: int, network_sides: Array):
	if get_tree().get_network_unique_id() == 1:
		# should never be less than 2 visible sides (or player orientation is difficult to determine)
		assert(line_segments.size() - hidden_sides >= 2)
		for line_segment in line_segments:
			line_segment.show()
		var possible_hidden_sides = range(0, line_segments.size() - 1)
		var side_ids = []
		for _i in range(hidden_sides):
			# same thing but shorter
			# line_segments[possible_hidden_sides.pop_at(random.randi_range(0, possible_hidden_sides.size() - 1))].hide()
			# choose random element from possible_hidden_sides
			var id: int = random.randi_range(0, possible_hidden_sides.size() - 1)
			# find the side id
			var hidden_side_id: int = possible_hidden_sides[id]
			# delete the id so it cannot be hidden more than once
			possible_hidden_sides.pop_at(id)
			# hide the segment
			side_ids.append(hidden_side_id)
			line_segments[hidden_side_id].hide()
		rpc("client_change_hidden_sides", side_ids)

remote func client_change_hidden_sides(network_sides: Array):
	for line_segment in line_segments:
		line_segment.show()
	
	for _i in network_sides:
		var id: int = _i
		# hide the segment
		line_segments[id].hide()

func _increase_missing_sides():
	if line_segments.size() - (max_missing_sides + 1) >= 2:
		max_missing_sides += 1
	_change_hidden_sides(max_missing_sides, [])

func _change_shape(sides: int):
	var point_sets = _generate_line_points(sides)
	var polygon_points = _generate_polygon_points(sides)
	_apply_points(sides, point_sets, polygon_points)
	_print_line_points(point_sets)
	_print_polygon_points(polygon_points)


func _find_point(sides, pointID, radius) -> Vector2:
	var x: float = cos((2 * PI * pointID) / sides) * radius
	var y: float = sin((2 * PI * pointID) / sides) * radius
	return Vector2(x, y)

func _generate_line_points(sides: int) -> Array:
	var point_sets := Array()
	var point_id := 0
	for _set_id in range(sides):
		var set := PoolVector2Array()
		set.append(_find_point(sides, point_id, m_radius)) # first point
		point_id += 1
		set.append(_find_point(sides, point_id, m_radius)) # second point
		# do not need to increment since point is shared with next line
		point_sets.append(set)
	return point_sets

func _generate_polygon_points(sides: int) -> PoolVector2Array:
	var points := PoolVector2Array()
	for point in range(sides):
		# shrink polygon so that it does not overlap the area occupied by the lines
		var coordinates := _find_point(sides, point, m_radius - outline_width / 2)
		points.append(coordinates)
	return points

func get_pos():
	return position


func _print_line_points(point_sets: Array):
	# point_sets is an Array<PoolVector2Array>[sides]
	# PoolVector2Array is an Array<Vector2>[2]
	# Total: Array<Array<Vector2>[2]>[sides]
	print("Line Points:")
	for point_set in point_sets:
		print("Point Set:")
		for point in point_set: # put s in stead of none
			print("X: %.0f, Y: %.0f" % [point.x, point.y])


func _print_polygon_points(polygon_points: PoolVector2Array):
	print("Polygon Points:")
	for point in polygon_points:
		print("X: %.0f, Y: %.0f" % [point.x, point.y])

func puppet_player_position_set(new_value):
	puppet_player_position = new_value
	
	tween.interpolate_property(self, "global_position", global_position, puppet_player_position, 0.1)
	tween.start()

func _on_network_tick_rate_timeout():
	if is_network_master():
		rset_unreliable("puppet_player_position", global_position)
		rset_unreliable("puppet_player_velocity", cur_velocity)
		rset_unreliable("puppet_player_rotation", rotation)
