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

var _skip_animation: bool = false

func _ready():
	_toggle_section_visibility(false)
	
	_levels_label.text = str(StatsManager.levels_completed)
	_points_label.text = str(StatsManager.total_points)
	_enemies_killed_label.text = str(StatsManager.total_kills)
	_ricochets_label.text = str(StatsManager.total_ricochets)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		_skip_animation = true
		_toggle_section_visibility(true)

## Logic to execute when the "New Run" button is pressed.
func _on_new_run_button_pressed():
	GameManager.reset_run()
	# TODO: Implement animation / transition or whatever else
	queue_free()

## Toggles the visibility of the sections with the cooresponding flag.
func _toggle_section_visibility(make_visible: bool) -> void:
	_levels_section.visible = make_visible
	_points_section.visible = make_visible
	_enemies_killed_section.visible = make_visible
	_ricochets_section.visible = make_visible
	_buttons_section.visible = make_visible

## Functionality to execute when the timer runs out.
func _on_timer_timeout() -> void:
	if _skip_animation:
		return
	
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
