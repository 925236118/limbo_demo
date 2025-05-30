extends Area2D

@export_group("视线参数")
## 细分
@export var subdivision: int = 1
## 角度
@export var sight_degree: float = 90
## 距离
@export var sight_distance: float = 200
## 视线遮挡层
@export_custom(PROPERTY_HINT_LAYERS_2D_PHYSICS, "") var mask = 0

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

var points = [Vector2(0, 0)]

func _ready() -> void:
	update_sight()

func update_sight():
	await get_parent().ready
	points = [Vector2(0, 0)]
	var count: int = pow(2, subdivision)
	var per_ray_red = deg_to_rad(sight_degree / count)
	var start_ray_target = Vector2.from_angle(- deg_to_rad(sight_degree / 2)) * sight_distance
	for i in range(count + 1):
		var space_state = get_world_2d().direct_space_state
		var target_point = start_ray_target.rotated(i * per_ray_red)
		var query = PhysicsRayQueryParameters2D.create(Vector2(0, 0), target_point, mask)
		query.collide_with_bodies = true
		var result = space_state.intersect_ray(query)
		print(result)
		if result:
			points.append(result.position)
		else:
			points.append(target_point)
	#points.append(Vector2(0, 0))
	collision_polygon_2d.polygon = PackedVector2Array(points)

func _draw():
	#draw_polygon(points,  PackedColorArray([Color(1, 0, 0, .1)]))
	for p in points:
		draw_line(Vector2(0, 0), p, Color(0, 0, 0, 1), 2)
