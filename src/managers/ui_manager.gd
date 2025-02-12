extends Node

@onready var game_root: Node2D = $"../GameRoot"
@onready var default_theme: Theme = load("res://ui/themes/default_theme.tres")

var _game_over_scene: PackedScene = load("res://ui/popups/game_over_panel/game_over_panel.tscn")
var _level_win_scene: PackedScene = load("res://ui/popups/level_win_panel/level_win_panel.tscn")
var _settings_scene: PackedScene = load("res://ui/popups/settings/settings.tscn")

var _active_popups: Dictionary = {}

const DEFAULT_Z_INDEX: int = 900

## Displays the correct UI panel when the game ends.
func show_game_over(did_win: bool) -> void:
	if did_win:
		show_ui(_level_win_scene)
		return
	
	show_ui(_game_over_scene)

## Shows the settings screen.
func show_settings_screen(previous_element_to_focus: Control = null) -> SettingsMenu:
	var instance = show_ui(_settings_scene, previous_element_to_focus) as SettingsMenu
	return instance

## Shows a given UI scene.
func show_ui(scene: PackedScene, previous_element_to_focus: Control = null) -> UserInterface:
	var user_interface: UserInterface = scene.instantiate() as UserInterface
	assert(user_interface != null, "The specified scene to show is not a UserInterface.")
	
	if _active_popups.is_empty():
		user_interface.z_index = DEFAULT_Z_INDEX
	else:
		var previous_user_interface: UserInterface = _get_last_key_in_active_elements()
		user_interface.z_index = previous_user_interface.z_index + 1
	
	_active_popups[user_interface] = previous_element_to_focus
	user_interface.close_button_pressed.connect(hide_ui)
	
	get_tree().root.add_child(user_interface)
	_focus_on_default_item(user_interface.get_default_focused_item())
	
	return user_interface

## Hides a given UI scene if it is active.
func hide_ui(user_interface: UserInterface) -> void:
	var previous_element_to_focus: Control = _active_popups[user_interface]
	
	user_interface.close_button_pressed.disconnect(hide_ui)
	_active_popups.erase(user_interface)
	user_interface.queue_free()
	
	if previous_element_to_focus:
		_focus_on_default_item(previous_element_to_focus)
		return
	
	if _active_popups.is_empty():
		return
	
	var previous_user_interface: UserInterface = _get_last_key_in_active_elements()
	_focus_on_default_item(previous_user_interface.get_default_focused_item())

func _focus_on_default_item(item_to_focus: Control) -> void:
	if not item_to_focus:
		return
	
	item_to_focus.grab_focus()

func _get_last_key_in_active_elements() -> UserInterface:
	assert(!_active_popups.is_empty(), "Can't get last key from empty dictionary.")
	return _active_popups.keys()[-1] as UserInterface
