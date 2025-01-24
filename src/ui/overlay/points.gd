class_name Points
extends Control

# Private members
@onready var _points_label: Label = $PointsLabel

func initialize(game_manager: GameManager) -> void:
	assert(game_manager != null, "The specified game manager cannot be null.")
	game_manager.points_changed.connect(_on_points_changed)

func _on_points_changed(points: int) -> void:
	_points_label.text = str(points)
