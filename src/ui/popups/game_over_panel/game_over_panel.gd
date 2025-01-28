class_name GameOverPanel
extends Panel

func _on_new_run_button_pressed():
	GameManager.reset_run()
	# TODO: Implement animation / transition or whatever else
	queue_free()
