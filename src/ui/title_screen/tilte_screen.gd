extends Control

var CREDITS_SCENE: PackedScene = load("res://ui/credits/credits.tscn")

func _ready() -> void:
	size.x = 640
	size.y = 360

func _process(delta: float) -> void:
	var animated_sprite = %EnemyAnimation
	animated_sprite.play("idle")

func _on_play_button_pressed():
	GameManager.start_game()
	queue_free()

func _on_credits_button_pressed():
	var credits = CREDITS_SCENE.instantiate()
	GameManager.game_root.add_child(credits)

func _on_settings_button_pressed():
	UiManager.show_settings_screen()
