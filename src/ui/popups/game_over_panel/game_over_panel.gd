class_name GameOverPanel
extends Panel

func _on_new_run_button_pressed():
	var level_to_load: PackedScene = preload("res://levels/playground_tom.tscn")
	GameManager.load_level(level_to_load)
	# TODO: Implement animation / transition or whatever else
	queue_free()
