class_name Points
extends Control

# Private members
@onready var _points_label: Label = $PointsLabel

## Initializes this script with a given GameManager.
func initialize(game_manager: GameManager) -> void:
	assert(game_manager != null, "The specified game manager cannot be null.")
	_points_label.text = str(game_manager.points)
	game_manager.points_changed.connect(_on_points_changed)

## Logic that is executed when the points have been changed.
func _on_points_changed(points: int) -> void:
	_points_label.text = str(points)
