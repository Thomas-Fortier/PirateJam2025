class_name GameOverPanel
extends Panel

@onready var _levels_section: Control = %Levels
@onready var _points_section: Control = %Points
@onready var _enemies_killed_section: Control = %EnemiesKilled
@onready var _ricochets_section: Control = %Ricochets
@onready var _buttons_section: Control = %Buttons

@onready var _levels_label: Label = %LevelsCompletedLabel
@onready var _points_label: Label = %PointsLabel
@onready var _enemies_killed_label: Label = %EnemiesKilledLabel
@onready var _ricochets_label: Label = %RicochetsLabel

func _ready():
	_levels_section.visible = false
	_points_section.visible = false
	_enemies_killed_section.visible = false
	_ricochets_section.visible = false
	_buttons_section.visible = false
	
	_levels_label.text = str(GameManager.levels_completed)
	_points_label.text = str(GameManager.total_points)
	_enemies_killed_label.text = str(GameManager.total_enemies_killed)
	_ricochets_label.text = str(GameManager.total_ricochets)

## Logic to execute when the "New Run" button is pressed.
func _on_new_run_button_pressed():
	GameManager.reset_run()
	# TODO: Implement animation / transition or whatever else
	queue_free()

## Functionality to execute when the timer runs out.
func _on_timer_timeout():
	if not _levels_section.visible:
		_levels_section.visible = true
	elif not _points_section.visible:
		_points_section.visible = true
	elif not _enemies_killed_section.visible:
		_enemies_killed_section.visible = true
	elif not _ricochets_section.visible:
		_ricochets_section.visible = true
	elif not _buttons_section.visible:
		_buttons_section.visible = true
