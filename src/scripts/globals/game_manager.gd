class_name GameManager
extends Node

## Signal called when the points have been updated.
signal points_changed(points: int)
## Signal called when the number of ricochets remaining has been changed.
signal ricochets_changed(ricochets_remaining: int)

@export_category("Dependencies")
## The main bullet that the player controls.
@export var bullet: Bullet = null

@export_category("Stats")
## The number of max ricochets the bullet has.
@export var max_ricochets: int = 6
## The total points that the player has.
@export var points: int:
	set(value):
		if points == value:
			return
		points = value
		points_changed.emit(value)

## The number of ricochets remaining that the player has.
var ricochets_remaining: int:
	set(value):
		if ricochets_remaining == value:
			return
		ricochets_remaining = value
		ricochets_changed.emit(value)
## Represents all enemies in the current level.
var enemies: Array[Enemy] = []

func _ready() -> void:
	assert(bullet != null, "The main bullet must be specified in the game manager.")
	bullet.bounced_off_wall.connect(_on_bullet_bounce)
	
	ricochets_remaining = max_ricochets
	
	call_deferred("_initialize_enemies")

func _initialize_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.died.connect(_on_enemy_death)
		enemies.append(enemy)

## The functionality for when an enemy dies within the level.
func _on_enemy_death(enemy: Enemy) -> void:
	enemies.erase(enemy)
	points += enemy.points_on_kill

## The functionality to execute when the bullet has bounced off a wall.
func _on_bullet_bounce() -> void:
	if ricochets_remaining != 0:
		ricochets_remaining -= 1
		return
		
	bullet.select_direction()
	ricochets_remaining = max_ricochets
