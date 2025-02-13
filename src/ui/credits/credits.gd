extends UserInterface

func _ready() -> void:
	size.x = 640
	size.y = 360

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		close_window()
