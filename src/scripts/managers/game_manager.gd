extends Node

## Signal called for when the game is over.
signal game_over(did_win: bool)

## The main bullet that the player controls.
@onready var bullet: Bullet = $"../GameRoot/Bullet"

## The number of levels completed this run.
var levels_completed: int = 0

## The configuration for the game manager.
var config: GameConfig = preload("res://scripts/managers/game_manager.tres") as GameConfig

func _ready() -> void:
	assert(config != null, "The config file could not be loaded.")
	assert(bullet != null, "The main bullet must be specified in the game manager.")

	bullet.bounced_off_wall.connect(_on_bullet_bounce)
	EnemyManager.all_enemies_defeated.connect(_on_all_enemies_defeated)

func _on_all_enemies_defeated() -> void:
	_handle_game_over(true)

## The functionality to execute when the bullet has bounced off a wall.
func _on_bullet_bounce() -> void:
	var ricochets_remaining: bool = StatsManager.add_ricochet()
	
	if ricochets_remaining:
		return
	
	if StatsManager.decrement_remaining_turns():
		_handle_game_over(false)
		return
	
	bullet.select_direction()
	StatsManager.reset_ricochets_remaining()

func _handle_game_over(did_win: bool) -> void:
	game_over.emit(did_win)
	bullet.toggle_pause()

	if did_win:
		levels_completed += 1

	UiManager.show_game_over(did_win)

func next_level() -> void:
	LevelManager.next_level(config)
	StatsManager.reset_level_stats()
	reset_bullet_and_enemies()

func reset_run() -> void:
	LevelManager.next_level(config)
	StatsManager.reset_all()
	reset_bullet_and_enemies()
	levels_completed = 0

## Resets the state of the game manager back to default values.
func reset_bullet_and_enemies() -> void:
	bullet.reset()
	EnemyManager.initialize_enemies()
