class_name PauseMenu
extends UserInterface

var is_sub_menu_opened: bool = false

@onready var _settings_button: Button = %SettingsButton

func _ready():
	set_size(GameManager.GAME_SIZE)

func _process(_delta: float) -> void:
	if is_sub_menu_opened:
		return
	
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("pause"):
		close_window()

func _on_resume_button_pressed() -> void:
	GameManager.resume_game()
	close_window()

func _on_settings_button_pressed():
	var instance = UiManager.show_settings_screen(_settings_button) as SettingsMenu
	instance.settings_menu_closed.connect(_on_settings_menu_closed)
	is_sub_menu_opened = true

func _on_settings_menu_closed() -> void:
	is_sub_menu_opened = false

func _on_quit_button_pressed():
	GameManager.quit_game()
	close_window()
