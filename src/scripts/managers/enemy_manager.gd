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
		enemy.remove_from_group("enemies")
	enemies.clear()

## Handles when an enemy dies.
func _on_enemy_death(enemy: Enemy) -> void:
	enemies.erase(enemy)
	StatsManager.add_points(enemy.points_on_kill)
	StatsManager.add_kill()

	if enemies.is_empty():
		all_enemies_defeated.emit()
