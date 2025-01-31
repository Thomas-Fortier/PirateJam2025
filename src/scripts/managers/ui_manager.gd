extends Node

@onready var game_root: Node2D = $"../GameRoot"
@onready var default_theme: Theme = preload("res://ui/themes/default_theme.tres")

var _game_over_scene: PackedScene = preload("res://ui/popups/game_over_panel/game_over_panel.tscn")
var _level_win_scene: PackedScene = preload("res://ui/popups/level_win_panel/level_win_panel.tscn")

## Displays the correct UI panel when the game ends.
func show_game_over(did_win: bool) -> void:
	var instance = _level_win_scene.instantiate() if did_win else _game_over_scene.instantiate()
	get_tree().root.add_child(instance)
