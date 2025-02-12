extends UserInterface

func _ready() -> void:
	size.x = 640
	size.y = 360

func _on_close_button_pressed():
	super()
