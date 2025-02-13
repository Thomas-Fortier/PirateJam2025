class_name SettingsMenu
extends UserInterface

signal settings_menu_closed

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		settings_menu_closed.emit()
		close_window()

func _on_close_button_pressed():
	settings_menu_closed.emit()
	close_window()
