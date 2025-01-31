class_name AbilityPanel
extends Control

signal ability_chosen()

var _assigned_ability: Ability

@onready var _title: Label = %Title
@onready var _icon: TextureRect = %Icon
@onready var _description: Label = %Description

func assign_ability(ability: Ability) -> void:
	_assigned_ability = ability
	_title.text = ability.name
	_description.text = ability.description
	_icon.texture = ability.icon

func _on_choose_button_pressed():
	AbilityManager.add_ability(_assigned_ability)
	ability_chosen.emit()
