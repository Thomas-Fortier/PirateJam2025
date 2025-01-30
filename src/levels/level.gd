class_name Level
extends Node2D

@onready var spawn_point: Node2D = %SpawnPoint

func _ready() -> void:
	assert(spawn_point != null, "No spawn point for level was specified.")

func get_spawn_point_position() -> Vector2:
	if not spawn_point:
		printerr("No spawn point for level was specified. Defualting position to 0,0.")
		return Vector2.ZERO
	return spawn_point.global_position
