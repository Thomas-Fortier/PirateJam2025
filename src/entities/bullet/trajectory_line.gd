class_name TrajectoryLine
extends Node2D

@export var _collision_mask: int = 1 << 2
@export var _max_bounces: int = 1
@export var _max_distance: float = 500.0

@onready var _line: Line2D = $Line2D  # Reference to Line2D node

var _bullet_direction: Vector2 = Vector2.ZERO

func _ready():
	_line.clear_points()

func update_trajectory(bullet_position: Vector2, bullet_rotation: float):
	var direction = Vector2.RIGHT.rotated(bullet_rotation)
	var bullet_tip_offset = direction * 8.0
	var start_position = bullet_position + bullet_tip_offset  

	_bullet_direction = direction.normalized()
	_calculate_bounces(start_position)

func clear() -> void:
	_line.clear_points()

func _calculate_bounces(start_position: Vector2):
	clear()
	_line.add_point(to_local(start_position))

	var current_position = start_position
	var direction = _bullet_direction
	var space_state = get_world_2d().direct_space_state

	for i in range(_max_bounces + 1):
		var query = PhysicsRayQueryParameters2D.create(
			current_position, current_position + direction * _max_distance
		)
		
		query.collision_mask = _collision_mask
		
		var result = space_state.intersect_ray(query)

		if result:
			var collision_point = result.position
			var normal = result.normal
			
			_line.add_point(to_local(collision_point))
			direction = direction.bounce(normal)
			current_position = collision_point + direction * 2.0
		else:
			_line.add_point(to_local(current_position + direction * _max_distance))
			break
