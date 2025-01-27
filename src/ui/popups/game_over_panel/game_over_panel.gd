class_name GameOverPanel
extends Panel

var _game_manager: GameManager = null

func initialize(game_manager: GameManager) -> void:
	assert(game_manager != null, "The given game manager cannot be null.")
	_game_manager = game_manager

func _on_new_run_button_pressed():
	var level_to_load: PackedScene = preload("res://levels/playground_tom.tscn")
	_game_manager.load_level(level_to_load)
	# TODO: Implement animation / transition or whatever else
	queue_free()
