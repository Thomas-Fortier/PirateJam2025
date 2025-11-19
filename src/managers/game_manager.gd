extends Node

## Signal called for when the game is over.
signal game_over(did_win: bool)
## Signal to call when the game has started
signal game_start
## Signal called when the game is paused.
signal game_paused
## Signal called when the game is resumed from a paused state.
signal game_resumed

## The configuration for the game manager.
var config: GameConfig = load("res://resources/game_config.tres") as GameConfig
@onready var game_root: Node2D = $"../GameRoot"

var GAME_SIZE: Vector2 = Vector2(640, 360)
var TITLE_SCREEN: PackedScene = load("res://ui/title_screen/tilte_screen.tscn")
var BULLET_SCENE: PackedScene = load("res://entities/bullet/bullet.tscn")
var OVERLAY_SCENE: PackedScene = load("res://ui/overlay/overlay.tscn")
var PAUSE_SCENE: PackedScene = load("res://ui/popups/pause_menu/pause_menu.tscn")
var LEVEL_LOST_SOUND = load("res://assets/sounds/level_lose_sound.tres") as Sound
var LEVEL_WON_SOUND = load("res://assets/sounds/level_win_sound.tres") as Sound
var MUSIC = load("res://assets/sounds/music.tres") as Sound

var _game_started: bool = false
var _is_paused: bool = false
var _pause_menu_instance: PauseMenu = null

func _ready() -> void:
	assert(config != null, "The config file could not be loaded.")
	EnemyManager.all_enemies_defeated.connect(_on_all_enemies_defeated)
	
	# Play music
	AudioManager.play_sound(MUSIC)
	
	# Display title screen
	UiManager.call_deferred("show_ui", TITLE_SCREEN)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and _game_started:
		if _is_paused and is_instance_valid(_pause_menu_instance):
			if _pause_menu_instance.is_sub_menu_opened:
				return
			
			_pause_menu_instance = null
			_is_paused = false
			game_resumed.emit()
			return
		
		game_paused.emit()
		_is_paused = true
		_pause_menu_instance = UiManager.show_ui(PAUSE_SCENE)

func _on_all_enemies_defeated() -> void:
	handle_game_over(true)

func resume_game() -> void:
	game_resumed.emit()
	_is_paused = false

func start_game() -> void:
	var bullet: Bullet = BULLET_SCENE.instantiate()
	game_root.add_child(bullet)
	
	_initialize_managers()
	reset_run()
	
	var overlay: Overlay = OVERLAY_SCENE.instantiate()
	overlay.set_size(GAME_SIZE)
	game_root.add_child(overlay)

func quit_game() -> void:
	BulletManager.bullet.queue_free()
	LevelManager.remove_level()
	var overlay: Overlay = $"../GameRoot/Overlay"
	overlay.queue_free()
	UiManager.show_ui(TITLE_SCREEN)
	_game_started = false

func _initialize_managers() -> void:
	BulletManager.initialize()

func handle_game_over(did_win: bool) -> void:
	game_over.emit(did_win)
	_game_started = false
	BulletManager.bullet.toggle_pause()

	if StatsManager.new_high_score:
		StatsManager.high_score = StatsManager.total_points
		StatsManager.save_data.high_score = StatsManager.high_score
		StatsManager.save_data.save()

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
	_game_started = true
