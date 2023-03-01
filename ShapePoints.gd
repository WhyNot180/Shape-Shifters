extends ConvexPolygonShape2D
class_name ShapePoints

# how are global properties implemented in Godot?
# There should be a `radius` property for this script for the shape's radius.

# temporary, replace with global property
var radius: int = 10;

#Vector2 is a thing...
#class coordinate_pair:
#	# automatically calls get_x or set_x whenever x is used
#	var m_x setget set_x, get_x
#	var m_y setget set_y, get_y
#
#	func _init(x, y):
#		m_x = x
#		m_y = y
#
#	func get_x():
#		return m_x
#	func get_y():
#		return m_y
#
#	func set_x(value):
#		m_x = value
#	func set_y(value):
#		m_y = value

func _init():
	pass # plz setup constructor

# connect to difficulty change signal
func change_shape(sides: int) -> void:
	set_point_cloud(generate_points(sides))

func find_point(sides, pointID) -> Vector2:
	var x: float = cos((2 * PI * pointID) / sides) * radius
	var y: float = sin((2 * PI * pointID) / sides) * radius
	return Vector2(x, y)

func generate_points(sides: int) -> PoolVector2Array:
	var points := PoolVector2Array()
	for point in range(sides - 1):
		var coordinates := find_point(sides, point)
		points.append(coordinates)
	return points
	
func print_points() -> void:
	var point_cloud := get_points()
	for point in point_cloud:
		print("X: %.0f, Y: %.0f" % [point.x, point.y])
