class_name SettingsMenu
extends Control

signal settings_menu_opened
signal settings_menu_closed

func _ready():
	settings_menu_opened.emit()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		_on_close_button_pressed()

func _on_close_button_pressed():
	settings_menu_closed.emit()
	queue_free()
