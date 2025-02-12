extends Node

@onready var game_root: Node2D = $"../GameRoot"
@onready var default_theme: Theme = load("res://ui/themes/default_theme.tres")

var _game_over_scene: PackedScene = load("res://ui/popups/game_over_panel/game_over_panel.tscn")
var _level_win_scene: PackedScene = load("res://ui/popups/level_win_panel/level_win_panel.tscn")
var _settings_scene: PackedScene = load("res://ui/popups/settings/settings.tscn")
var _active_popups: Array[Control] = []

const MAX_Z_INDEX: int = 999

## Displays the correct UI panel when the game ends.
func show_game_over(did_win: bool) -> void:
	var instance = _level_win_scene.instantiate() if did_win else _game_over_scene.instantiate()
	get_tree().root.add_child(instance)

func show_settings_screen() -> SettingsMenu:
	var instance = _settings_scene.instantiate() as SettingsMenu
	get_tree().root.add_child(instance)
	return instance

func show_popup(popup: PackedScene) -> void:
	var instance: Control = popup.instantiate() as Control
	
	if _active_popups.is_empty():
		instance.z_index = MAX_Z_INDEX
	else:
		var previous_popup: Control = _active_popups.back() as Control
		instance.z_index = previous_popup.z_index + 1
	
	_active_popups.append(instance)
	get_tree().root.add_child(instance)
