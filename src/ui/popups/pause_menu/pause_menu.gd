class_name PauseMenu
extends UserInterface

func _ready():
	size.x = 640
	size.y = 360

func _on_resume_button_pressed() -> void:
	GameManager.resume_game()
	close_window()

func _on_settings_button_pressed():
	UiManager.show_settings_screen()

func _on_quit_button_pressed():
	GameManager.quit_game()
	close_window()
