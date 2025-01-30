extends Control

func _ready() -> void:
	size.x = 640
	size.y = 360

func _on_play_button_pressed():
	GameManager.start_game()
	queue_free()
