class_name GameManager
extends Node

## Signal called when the points have been updated.
signal points_changed(points: int)
## Signal called when the number of ricochets remaining has been changed.
signal ricochets_changed(ricochets_remaining: int)
## Signal called when the number of turns has changed.
signal turns_changed(turns: int, max_turns: int)

@export_category("Dependencies")
## The main bullet that the player controls.
@export var bullet: Bullet = null
## The reference to the game over panel scene.
@export var game_over_scene: PackedScene = preload("res://ui/popups/game_over_panel/game_over_panel.tscn")

@export_category("Stats")
## The number of max turns the bullet has.
@export var max_turns: int = 3
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
## The number of turns the bullet has.
var remaining_turns: int:
	set(value):
		if remaining_turns == value:
			return
		remaining_turns = value
		turns_changed.emit(value, max_turns)
## Represents all enemies in the current level.
var enemies: Array[Enemy] = []

func _ready() -> void:
	assert(bullet != null, "The main bullet must be specified in the game manager.")
	bullet.bounced_off_wall.connect(_on_bullet_bounce)
	
	ricochets_remaining = max_ricochets
	remaining_turns = max_turns
	
	call_deferred("_initialize_enemies")

func _initialize_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.died.connect(_on_enemy_death)
		enemies.append(enemy)

## The functionality for when an enemy dies within the level.
func _on_enemy_death(enemy: Enemy) -> void:
	enemies.erase(enemy)
	points += enemy.points_on_kill
	
	if enemies.size() == 0:
		_handle_game_over(true)

## The functionality to execute when the bullet has bounced off a wall.
func _on_bullet_bounce() -> void:
	if ricochets_remaining != 0:
		ricochets_remaining -= 1
		return
	
	remaining_turns -= 1
	
	if remaining_turns == 0:
		_handle_game_over(false)
		return # TODO: Game over logic.
	
	bullet.select_direction()
	ricochets_remaining = max_ricochets

func _handle_game_over(did_win: bool) -> void:
	print("Game over.")
	bullet.toggle_pause()
	
	if did_win:
		print("You won!")
	else:
		var instance: GameOverPanel = game_over_scene.instantiate()
		instance.initialize(self)
		add_child(instance)

func load_level(level: PackedScene) -> void:
	get_tree().change_scene_to_packed(level)

## Resets the state of the game manager back to default values.
func reset() -> void:
	points = 0
	ricochets_remaining = max_ricochets
	remaining_turns = max_turns
