class_name AbilitySelect
extends UserInterface

@onready var _panel_1: AbilityPanel = %AbilityPanel1
@onready var _panel_2: AbilityPanel = %AbilityPanel2
@onready var _panel_3: AbilityPanel = %AbilityPanel3
@onready var _abilities: HBoxContainer = %Abilities
@onready var _subtitle: Label = %Subtitle
@onready var _no_more_space_label: Label = %NoMoreSpaceLabel
@onready var _no_more_abilities_label: Label = %NoMoreAbilitiesLabel
@onready var _or_label: Label = %OrLabel

var _ability_pool: Array[Ability] = []

func _ready():
	size.x = 640
	size.y = 360
	
	if AbilityManager.has_no_more_space_for_abilities():
		_abilities.visible = false
		_subtitle.visible = false
		_or_label.visible = false
		_no_more_space_label.visible = true
		return
	
	_no_more_space_label.visible = false
	
	if not _get_random_ability_for_panel(_panel_1) or not _get_random_ability_for_panel(_panel_2) or not _get_random_ability_for_panel(_panel_3):
		_abilities.visible = false
		_subtitle.visible = false
		_or_label.visible = false
		_no_more_abilities_label.visible = true
		return

func _get_random_ability_for_panel(panel: AbilityPanel) -> bool:
	var random_ability = AbilityManager.get_random_ability()
	
	if not random_ability:
		return false
	
	# TODO: THIS IS ABSOLUTE GARBAGE
	while not AbilityManager.is_ability_pool_less_than(3) and _ability_pool.has(random_ability):
		random_ability = AbilityManager.get_random_ability()
	
	_ability_pool.append(random_ability)
	panel.assign_ability(random_ability)
	panel.ability_chosen.connect(_on_ability_chosen)
	return true

func _on_ability_chosen() -> void:
	_continue()

func _on_skip_button_pressed():
	_continue()

func _continue() -> void:
	GameManager.next_level()
	_on_close_button_pressed()
