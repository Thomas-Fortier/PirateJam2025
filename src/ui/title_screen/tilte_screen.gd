extends Control

const CREDITS_SCENE: PackedScene = preload("res://ui/credits/credits.tscn")

func _ready() -> void:
	size.x = 640
	size.y = 360

func _on_play_button_pressed():
	GameManager.start_game()
	queue_free()

func _on_credits_button_pressed():
	var credits = CREDITS_SCENE.instantiate()
	GameManager.game_root.add_child(credits)
