extends Node

## Signal called for when the game is over.
signal game_over(did_win: bool)

## The configuration for the game manager.
var config: GameConfig = preload("res://scripts/managers/game_manager.tres") as GameConfig

func _ready() -> void:
	assert(config != null, "The config file could not be loaded.")
	EnemyManager.all_enemies_defeated.connect(_on_all_enemies_defeated)

func _on_all_enemies_defeated() -> void:
	handle_game_over(true)

func handle_game_over(did_win: bool) -> void:
	game_over.emit(did_win)
	BulletManager.bullet.toggle_pause()

	if did_win:
		StatsManager.levels_completed += 1

	UiManager.show_game_over(did_win)

func next_level() -> void:
	LevelManager.next_level(config)
	StatsManager.reset_level_stats()
	reset_bullet_and_enemies()

func reset_run() -> void:
	LevelManager.next_level(config)
	StatsManager.reset_all()
	reset_bullet_and_enemies()

## Resets the state of the game manager back to default values.
func reset_bullet_and_enemies() -> void:
	BulletManager.bullet.reset()
	EnemyManager.initialize_enemies.call_deferred()
