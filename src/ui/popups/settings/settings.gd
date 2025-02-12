class_name SettingsMenu
extends UserInterface

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		close_window()
