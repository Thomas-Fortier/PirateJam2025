extends Control

@onready var _slot_1: AbilitySlot = %AbilitySlot1
@onready var _slot_2: AbilitySlot = %AbilitySlot2
@onready var _slot_3: AbilitySlot = %AbilitySlot3
@onready var _slot_4: AbilitySlot = %AbilitySlot4
@onready var _slot_5: AbilitySlot = %AbilitySlot5

func _ready():
	AbilityManager.ability_added.connect(_on_ability_added)

func _on_ability_added(ability: Ability) -> void:
	if not _slot_1.ability:
		_slot_1.add_ability(ability)
	elif not _slot_2.ability:
		_slot_2.add_ability(ability)
	elif not _slot_3.ability:
		_slot_3.add_ability(ability)
	elif not _slot_4.ability:
		_slot_4.add_ability(ability)
	elif not _slot_5.ability:
		_slot_5.add_ability(ability)
	else:
		print("Cannot add any more abilities.")
