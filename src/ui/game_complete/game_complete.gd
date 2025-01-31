extends Control

func _on_replay_button_pressed():
	GameManager.reset_run()
	queue_free()

func _on_quit_button_pressed():
	GameManager.quit_game()
	queue_free()
