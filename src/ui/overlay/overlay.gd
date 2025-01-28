class_name Overlay
extends Control

# Private members
@onready var _points_label: Label = %PointsLabel
@onready var _ricochets_label: Label = %RicochetsLabel
@onready var _turns_label: Label = %TurnsLabel

const CRITICAL_COLOR = Color.RED
const NORMAL_COLOR = Color.WHITE

func _ready() -> void:
	_points_label.text = str(GameManager.points)
	GameManager.points_changed.connect(_on_points_changed)
	
	_ricochets_label.text = str(GameManager.ricochets_remaining)
	GameManager.ricochets_changed.connect(_on_ricochets_changed)
	
	_turns_label.text = _get_turns_text(GameManager.remaining_turns, GameManager.config.max_turns)
	GameManager.turns_changed.connect(_on_turns_changed)

## Logic that is executed when the points have been changed.
func _on_points_changed(points: int) -> void:
	_points_label.text = str(points)

## Logic to execute when the ricochet counter has changed.
func _on_ricochets_changed(ricochets_remaining: int) -> void:
	_ricochets_label.text = str(ricochets_remaining)
	_ricochets_label.label_settings.font_color = CRITICAL_COLOR if ricochets_remaining == 0 else NORMAL_COLOR

## Logic that is executed when the turns have been changed.
func _on_turns_changed(turns: int, max_turns: int) -> void:
	_turns_label.text = _get_turns_text(turns, max_turns)
	_turns_label.label_settings.font_color = CRITICAL_COLOR if turns <= 1 else NORMAL_COLOR

## Gets the turn count as a fraction string.
func _get_turns_text(turns: int, max_turns: int) -> String:
	return "%s / %s" % [str(turns), str(max_turns)]
