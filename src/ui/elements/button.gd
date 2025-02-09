extends Button

@export var _hover_sound: Sound

@onready var _focus_elements: Control = %FocusElements

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
	AudioManager.play_sound(_hover_sound)

func _on_focus_exited():
	_focus_elements.visible = false
