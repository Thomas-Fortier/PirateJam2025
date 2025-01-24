class_name GameManager
extends Node

## Signal called when the points have been updated.
signal points_changed(points: int)

## Represents all enemies in the current level.
var enemies: Array[Enemy] = []
## The total points that the player has.
var points: int:
	set(value):
		points = value
		points_changed.emit(value)

func _ready() -> void:
	for node: Node in get_tree().root.get_child(0).get_children():
		if node is not Enemy:
			continue
		
		var enemy: Enemy = node as Enemy
		enemy.died.connect(_on_enemy_death)
		enemies.append(enemy)

## The functionality for when an enemy dies within the level.
func _on_enemy_death(enemy: Enemy) -> void:
	enemies.erase(enemy)
	points += enemy.points_on_kill
