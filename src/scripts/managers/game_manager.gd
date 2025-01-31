extends Node

## Signal called for when the game is over.
signal game_over(did_win: bool)
## Signal to call when the game has started
signal game_start

## The configuration for the game manager.
var config: GameConfig = preload("res://scripts/managers/game_manager.tres") as GameConfig
@onready var game_root: Node2D = $"../GameRoot"

const TITLE_SCREEN: PackedScene = preload("res://ui/title_screen/tilte_screen.tscn")
const BULLET_SCENE: PackedScene = preload("res://entities/bullet/bullet.tscn")
const OVERLAY_SCENE: PackedScene = preload("res://ui/overlay/overlay.tscn")
const LEVEL_LOST_SOUND = preload("res://assets/sounds/level_lose.wav")
const LEVEL_WON_SOUND = preload("res://assets/sounds/level_win.wav")

func _ready() -> void:
	assert(config != null, "The config file could not be loaded.")
	EnemyManager.all_enemies_defeated.connect(_on_all_enemies_defeated)

func _on_all_enemies_defeated() -> void:
	handle_game_over(true)

func start_game() -> void:
	var bullet: Bullet = BULLET_SCENE.instantiate()
	game_root.add_child(bullet)
	
	_initialize_managers()
	reset_run()
	
	var overlay: Overlay = OVERLAY_SCENE.instantiate()
	overlay.size.x = 640
	overlay.size.y = 360
	game_root.add_child(overlay)

func quit_game() -> void:
	BulletManager.bullet.queue_free()
	LevelManager.remove_level()
	var overlay: Overlay = $"../GameRoot/Overlay"
	overlay.queue_free()
	var title_screen = TITLE_SCREEN.instantiate()
	game_root.add_child(title_screen)

func _initialize_managers() -> void:
	BulletManager.initialize()

func handle_game_over(did_win: bool) -> void:
	game_over.emit(did_win)
	BulletManager.bullet.toggle_pause()

	if did_win:
		StatsManager.levels_completed += 1
		AudioManager.play_sound(LEVEL_WON_SOUND)
	else:
		AudioManager.play_sound(LEVEL_LOST_SOUND)

	await get_tree().create_timer(3.0).timeout # TODO: Parameterize

	UiManager.show_game_over(did_win)

func next_level() -> void:
	LevelManager.next_level(config)
	StatsManager.reset_level_stats()
	reset_bullet_and_enemies_and_ability_usages()

func reset_run() -> void:
	LevelManager.first_level(config)
	StatsManager.reset_all()
	AbilityManager.reset()
	reset_bullet_and_enemies_and_ability_usages()

## Resets the state of the game manager back to default values.
func reset_bullet_and_enemies_and_ability_usages() -> void:
	AbilityManager.clear_ability_usages()
	BulletManager.bullet.reset()
	EnemyManager.initialize_enemies.call_deferred()
	game_start.emit()
