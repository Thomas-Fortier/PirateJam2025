class_name Ability
extends Resource

@export var name: String = "Unknown"
@export var description: String = "No description."
@export var icon: CanvasTexture
@export var max_usages: int = 1
@export var ability_sound: AudioStream

func execute() -> void:
	printerr("The method 'execute' inside of ability must be overidden by child classes.")

func reset_usages() -> void:
	printerr("The method 'reset_usages' inside of ability must be overidden by child classes.")
