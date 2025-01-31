extends Node

## This manager handles switching levels and resetting runs.

signal level_changed(new_level: Level)

## The root of the game.
@onready var game_root: Node2D = $"../GameRoot"
var level: Level = null
var _level_index: int = -1 # TODO: Stinky

## Handles switching to a new level.
func switch_to_level(next_level_to_load: PackedScene) -> void:
	if level:
		level.queue_free()
	var instance = next_level_to_load.instantiate()
	level = instance
	game_root.add_child(instance)
	level_changed.emit(instance)

func are_there_levels_remaining() -> bool:
	return _level_index != GameManager.config.levels.size() - 1

## Loads a new random level from the config.
func next_level(config: GameConfig) -> void:
	if _level_index != config.levels.size() - 1:
		_level_index += 1
	var level_to_load: PackedScene = config.levels[_level_index]
	switch_to_level(level_to_load)

func first_level(config: GameConfig) -> void:
	_level_index = -1
	next_level(config)

func remove_level() -> void:
	level.queue_free()
	level = null

## Resets the current level.
func reset() -> void:
	GameManager.reset()
