extends UserInterface

func _ready() -> void:
	size.x = 640
	size.y = 360

func _on_replay_button_pressed():
	GameManager.reset_run()
	_on_close_button_pressed()

func _on_quit_button_pressed():
	GameManager.quit_game()
	_on_close_button_pressed()
