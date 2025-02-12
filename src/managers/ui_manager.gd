extends Node

@onready var game_root: Node2D = $"../GameRoot"
@onready var default_theme: Theme = load("res://ui/themes/default_theme.tres")

var _game_over_scene: PackedScene = load("res://ui/popups/game_over_panel/game_over_panel.tscn")
var _level_win_scene: PackedScene = load("res://ui/popups/level_win_panel/level_win_panel.tscn")
var _settings_scene: PackedScene = load("res://ui/popups/settings/settings.tscn")
var _active_popups: Array[UserInterface] = []

const DEFAULT_Z_INDEX: int = 900

## Displays the correct UI panel when the game ends.
func show_game_over(did_win: bool) -> void:
	if did_win:
		show_ui(_level_win_scene)
		return
	
	show_ui(_game_over_scene)

## Shows the settings screen.
func show_settings_screen() -> SettingsMenu:
	var instance = show_ui(_settings_scene) as SettingsMenu
	return instance

## Shows a given UI scene.
func show_ui(scene: PackedScene) -> UserInterface:
	var user_interface: UserInterface = scene.instantiate() as UserInterface
	assert(user_interface != null, "The specified scene to show is not a UserInterface.")
	
	if _active_popups.is_empty():
		user_interface.z_index = DEFAULT_Z_INDEX
	else:
		var previous_user_interface: UserInterface = _active_popups.back() as UserInterface
		user_interface.z_index = previous_user_interface.z_index + 1
	
	_active_popups.append(user_interface)
	user_interface.close_button_pressed.connect(_on_ui_close_button_pressed)
	
	get_tree().root.add_child(user_interface)
	user_interface.get_default_focused_item().grab_focus()
	
	return user_interface

## Hides a given UI scene if it is active.
func hide_ui(user_interface: UserInterface) -> void:
	pass

func _on_ui_close_button_pressed(user_interface: UserInterface) -> void:
	user_interface.close_button_pressed.disconnect(_on_ui_close_button_pressed)
	_active_popups.erase(user_interface)
	user_interface.queue_free()
