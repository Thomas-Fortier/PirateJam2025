extends UserInterface

var CREDITS_SCENE: PackedScene = load("res://ui/credits/credits.tscn")

@onready var _play_button: Button = %PlayButton
@onready var _settings_button: Button = %SettingsButton
@onready var _credits_button: Button = %CreditsButton

func _ready() -> void:
	size.x = 640
	size.y = 360
	_play_button.grab_focus()

func _process(delta: float) -> void:
	var animated_sprite = %EnemyAnimation
	animated_sprite.play("idle")

func _on_play_button_pressed():
	GameManager.start_game()
	close_window()

func _on_credits_button_pressed():
	UiManager.show_ui(CREDITS_SCENE, true, _credits_button)

func _on_settings_button_pressed():
	UiManager.show_settings_screen(_settings_button)

func _on_quit_button_pressed():
	# TODO: Call save method and other logic. Should be extracted into GameManager.
	get_tree().quit()
