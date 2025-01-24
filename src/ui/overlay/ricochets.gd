class_name Ricochets
extends Control

# Private members
@onready var _ricochets_label: Label = $RicochetsLabel

# TODO: Isolate colors for re-usability
const CRITICAL_COLOR = Color.RED
const NORMAL_COLOR = Color.WHITE

## Initializes this script with a given GameManager.
func initialize(game_manager: GameManager) -> void:
	assert(game_manager != null, "The specified game manager cannot be null.")
	_ricochets_label.text = str(game_manager.ricochets_remaining)
	game_manager.ricochets_changed.connect(_on_ricochets_changed)

## Logic to execute when the ricochet counter has changed.
func _on_ricochets_changed(ricochets_remaining: int) -> void:
	_ricochets_label.text = str(ricochets_remaining)
	_ricochets_label.label_settings.font_color = CRITICAL_COLOR if ricochets_remaining == 0 else NORMAL_COLOR
