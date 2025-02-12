class_name UserInterface
extends Control

signal close_button_pressed(user_interface: UserInterface)

@export var _default_focused_item: Control

func get_default_focused_item() -> Control:
	return _default_focused_item

func _on_close_button_pressed() -> void:
	close_button_pressed.emit(self)
