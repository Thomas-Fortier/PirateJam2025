class_name LevelWinPanel
extends UserInterface

@export_category("Sounds")
@export var _appear_sound: Sound

@onready var _points_section: Control = %Points
@onready var _enemies_killed_section: Control = %EnemiesKilled
@onready var _ricochets_section: Control = %Ricochets
@onready var _buttons_section: Control = %Buttons

@onready var _points_label: Label = %PointsLabel
@onready var _enemies_killed_label: Label = %EnemiesKilledLabel
@onready var _ricochets_label: Label = %RicochetsLabel

var _skip_animation: bool = false

var GAME_COMPLETE_SCENE: PackedScene = load("res://ui/game_complete/game_complete.tscn")

func _ready():
	_toggle_section_visibility(false)
	
	_points_label.text = str(StatsManager.points)
	_enemies_killed_label.text = str(StatsManager.kills)
	_ricochets_label.text = str(StatsManager.total_ricochets)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		_skip_animation = true
		_toggle_section_visibility(true)

## Logic to execute when the continue button is pressed.
func _on_next_level_button_pressed():
	if LevelManager.are_there_levels_remaining():
		AbilityManager.show_ability_select()
	else:
		UiManager.show_ui(GAME_COMPLETE_SCENE)
	
	_on_close_button_pressed()

## Toggles the visibility of the sections with the cooresponding flag.
func _toggle_section_visibility(make_visible: bool) -> void:
	_points_section.visible = make_visible
	_enemies_killed_section.visible = make_visible
	_ricochets_section.visible = make_visible
	_buttons_section.visible = make_visible

## Functionality to execute when the timer runs out.
func _on_timer_timeout() -> void:
	if _skip_animation:
		return
	
	if not _points_section.visible:
		_points_section.visible = true
	elif not _enemies_killed_section.visible:
		_enemies_killed_section.visible = true
	elif not _ricochets_section.visible:
		_ricochets_section.visible = true
	elif not _buttons_section.visible:
		_buttons_section.visible = true
	else:
		_skip_animation = true
		return
	
	AudioManager.play_sound(_appear_sound)

func _on_quit_button_pressed():
	GameManager.quit_game()
	_on_close_button_pressed()
