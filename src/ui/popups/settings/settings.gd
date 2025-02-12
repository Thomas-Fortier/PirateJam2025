class_name SettingsMenu
extends UserInterface

signal settings_menu_opened
signal settings_menu_closed

func _ready():
	settings_menu_opened.emit()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		close_window()
