extends Node

signal ability_added(ability: Ability)

var _all_abilities: Array[Ability] = []
var _current_abilities: Array[Ability] = []

const ABILITY_SELECT = preload("res://ui/popups/ability_select/ability_select.tscn")

func _ready():
	_all_abilities = GameManager.config.abilities

func show_ability_select() -> void:
	var ability_select = ABILITY_SELECT.instantiate()
	GameManager.game_root.add_child(ability_select)

func add_ability(ability: Ability) -> void:
	_current_abilities.append(ability)
	ability_added.emit(ability)

func get_random_ability() -> Ability:
	var filtered_abilities = _all_abilities.duplicate()
	
	for ability in _current_abilities:
		filtered_abilities.erase(ability)
	
	if filtered_abilities.size() == 0:
		return null
	
	return filtered_abilities.pick_random()

func clear_ability_usages() -> void:
	for ability in _current_abilities:
		ability.reset_usages()

func has_no_more_space_for_abilities():
	return _current_abilities.size() == 5

func reset() -> void:
	_current_abilities.clear()
