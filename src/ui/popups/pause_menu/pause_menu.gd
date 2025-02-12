class_name PauseMenu
extends UserInterface

var is_sub_menu_opened: bool = false
var _settings_menu_instance: SettingsMenu = null

func _ready():
	size.x = 640
	size.y = 360

func _on_resume_button_pressed() -> void:
	GameManager.resume_game()
	_on_close_button_pressed()

func _on_settings_button_pressed():
	_settings_menu_instance = UiManager.show_settings_screen()
	_settings_menu_instance.settings_menu_closed.connect(_on_settings_menu_closed)
	is_sub_menu_opened = true

func _on_quit_button_pressed():
	GameManager.quit_game()
	_on_close_button_pressed()

func _on_settings_menu_closed() -> void:
	_settings_menu_instance.settings_menu_closed.disconnect(_on_settings_menu_closed)
	_settings_menu_instance = null
	is_sub_menu_opened = false
