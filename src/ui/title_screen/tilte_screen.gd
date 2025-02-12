extends UserInterface

var CREDITS_SCENE: PackedScene = load("res://ui/credits/credits.tscn")

@onready var _play_button: Button = %PlayButton

func _ready() -> void:
	size.x = 640
	size.y = 360
	_play_button.grab_focus()

func _process(delta: float) -> void:
	var animated_sprite = %EnemyAnimation
	animated_sprite.play("idle")

func _on_play_button_pressed():
	GameManager.start_game()
	queue_free()

func _on_credits_button_pressed():
	UiManager.show_ui(CREDITS_SCENE)

func _on_settings_button_pressed():
	UiManager.show_settings_screen()
