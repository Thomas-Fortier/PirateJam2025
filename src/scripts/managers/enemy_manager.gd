extends Node

signal all_enemies_defeated

var enemies: Array[Enemy] = []

func _ready() -> void:
	call_deferred("initialize_enemies")

func initialize_enemies() -> void:
	_clear_tracked_enemies()
	for node in get_tree().get_nodes_in_group("enemies"):
		if node is Enemy:
			if not node.died.is_connected(_on_enemy_death):
				node.died.connect(_on_enemy_death)
			enemies.append(node)

func _clear_tracked_enemies() -> void:
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.remove_from_group("enemies")
	enemies.clear()

## Handles when an enemy dies.
func _on_enemy_death(enemy: Enemy) -> void:
	enemies.erase(enemy)
	StatsManager.add_points(enemy.points_on_kill)
	StatsManager.add_kill()

	if enemies.is_empty():
		all_enemies_defeated.emit()

func _get_closest_enemy_to_node(node: Node2D) -> Enemy:
	if enemies.is_empty():
		return null  # No enemies left

	var closest_enemy: Enemy = null
	var closest_distance: float = INF

	for enemy in enemies:
		if is_instance_valid(enemy):  # Ensure enemy is still valid
			var distance = node.global_position.distance_to(enemy.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_enemy = enemy

	return closest_enemy
