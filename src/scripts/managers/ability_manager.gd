extends Node

## List of all abilities.
var _abilities: Array[Ability] = []

func _ready():
	_abilities = GameManager.config.abilities

func get_random_ability() -> Ability:
	return _abilities.pick_random()
