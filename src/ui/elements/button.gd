extends Button

@onready var _focus_elements: Control = %FocusElements

const HOVER_SOUND = preload("res://assets/sounds/button_hover.wav")

func _ready():
	_focus_elements.visible = false

func _on_mouse_entered():
	_handle_focused()

func _on_mouse_exited():
	_focus_elements.visible = false

func _on_focus_entered():
	_handle_focused()

func _handle_focused() -> void:
	_focus_elements.visible = true
	AudioManager.play_sound(HOVER_SOUND)

func _on_focus_exited():
	_focus_elements.visible = false
