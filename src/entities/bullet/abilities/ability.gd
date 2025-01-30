class_name Ability
extends Resource

@export var icon: Texture
@export var max_usages: int = 1

func execute() -> void:
	printerr("The method 'execute' inside of ability must be overidden by child classes.")
 
