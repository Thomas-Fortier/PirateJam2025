class_name Turns
extends Control

# Private members
@onready var _turns_label: Label = $TurnsLabel

# TODO: Isolate colors for re-usability
const CRITICAL_COLOR = Color.RED
const NORMAL_COLOR = Color.WHITE

## Initializes this script with a given GameManager.
func initialize(game_manager: GameManager) -> void:
	assert(game_manager != null, "The specified game manager cannot be null.")
	_turns_label.text = _get_turns_text(game_manager.remaining_turns, game_manager.max_turns)
	game_manager.turns_changed.connect(_on_turns_changed)

## Logic that is executed when the turns have been changed.
func _on_turns_changed(turns: int, max_turns: int) -> void:
	_turns_label.text = _get_turns_text(turns, max_turns)
	_turns_label.label_settings.font_color = CRITICAL_COLOR if turns <= 1 else NORMAL_COLOR

func _get_turns_text(turns: int, max_turns: int) -> String:
	return "%s / %s" % [str(turns), str(max_turns)]
