extends CollisionPolygon2D
class_name CollisionShapePoints

# editable in editor
export var radius: int = 10;

func _ready():
#	change_shape(6)
	print_points()

func _init():
	change_shape(3)

# connect to difficulty change signal
func change_shape(sides: int) -> void:
	set_polygon(generate_points(sides))

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
	var point_cloud := get_polygon()
	for point in point_cloud:
		print("X: %.0f, Y: %.0f" % [point.x, point.y])
