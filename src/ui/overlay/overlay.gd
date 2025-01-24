class_name Overlay
extends Control

## The game manager to reference
@export var game_manager: GameManager = null

# Private members
@onready var _points: Points = $Viewport/Stats/Points

func _ready() -> void:
	assert(game_manager != null, "The specified game manager cannot be null.")
	await get_tree().process_frame
	_points.initialize(game_manager)
