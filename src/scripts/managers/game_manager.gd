extends Node

## Signal called for when the game is over.
signal game_over(did_win: bool)
## Signal called when the points have been updated.
signal points_changed(points: int)
## Signal called when the number of ricochets remaining has been changed.
signal ricochets_changed(ricochets_remaining: int)
## Signal called when the number of turns has changed.
signal turns_changed(turns: int, max_turns: int)

## The main bullet that the player controls.
@onready var bullet: Bullet = $"../GameRoot/Bullet"

## The number of levels completed this run.
var levels_completed: int = 0
## The total number of ricochets.
var total_ricochets: int = 0
## The total poitns accumulated this run.
var total_points: int = 0
## The total enemies killed.
var total_enemies_killed: int = 0

## The total points that the player has.
var points: int:
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
		turns_changed.emit(value, config.max_turns)
## Represents all enemies in the current level.
var enemies: Array[Enemy] = []
## The configuration for the game manager.
var config: GameConfig = preload("res://scripts/managers/game_manager.tres") as GameConfig

func _ready() -> void:
	assert(config != null, "The config file could not be loaded.")
	assert(bullet != null, "The main bullet must be specified in the game manager.")
	
	bullet.bounced_off_wall.connect(_on_bullet_bounce)
	ricochets_remaining = config.max_ricochets
	remaining_turns = config.max_turns
	
	call_deferred("_initialize_enemies")

func _initialize_enemies() -> void:
	enemies.clear()
	for node in get_tree().get_nodes_in_group("enemies"):
		if node is Enemy:
			if node.died.is_connected(_on_enemy_death):
				continue
			node.died.connect(_on_enemy_death)
			enemies.append(node)

## The functionality for when an enemy dies within the level.
func _on_enemy_death(enemy: Enemy) -> void:
	enemies.erase(enemy)
	points += enemy.points_on_kill
	total_points += enemy.points_on_kill
	total_enemies_killed += 1
	
	if enemies.size() == 0:
		_handle_game_over(true)

## The functionality to execute when the bullet has bounced off a wall.
func _on_bullet_bounce() -> void:
	total_ricochets += 1
	
	if ricochets_remaining != 0:
		ricochets_remaining -= 1
		return
	
	remaining_turns -= 1
	
	if remaining_turns == 0:
		_handle_game_over(false)
		return # TODO: Game over logic.
	
	bullet.select_direction()
	ricochets_remaining = config.max_ricochets

func _handle_game_over(did_win: bool) -> void:
	game_over.emit(did_win)
	bullet.toggle_pause()
	
	if did_win:
		levels_completed += 1
	
	UiManager.show_game_over(did_win)

func next_level() -> void:
	LevelManager.next_level(config)
	reset()

func reset_run() -> void:
	LevelManager.next_level(config)
	reset()
	levels_completed = 0
	total_ricochets = 0
	total_enemies_killed = 0
	total_points = 0

## Resets the state of the game manager back to default values.
func reset() -> void:
	points = 0
	ricochets_remaining = config.max_ricochets
	remaining_turns = config.max_turns
	bullet.reset()
	_initialize_enemies()
