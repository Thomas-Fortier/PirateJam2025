class_name SettingsMenu
extends UserInterface

signal settings_menu_closed

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		settings_menu_closed.emit()
		close_window()
