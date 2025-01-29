extends Node

## This manager handles switching levels and resetting runs.

signal level_changed(new_level: Node2D)

## The root of the game.
@onready var game_root: Node2D = $"../GameRoot"
@onready var level: Node2D = $"../GameRoot/Level"

## Handles switching to a new level.
func switch_to_level(next_level_to_load: PackedScene) -> void:
	level.queue_free()
	var instance = next_level_to_load.instantiate()
	level = instance
	game_root.add_child(instance)
	level_changed.emit(instance)

## Loads a new random level from the config.
func next_level(config: GameConfig) -> void:
	var level_to_load: PackedScene = config.levels.pick_random()
	switch_to_level(level_to_load)

## Resets the current level.
func reset() -> void:
	GameManager.reset()
