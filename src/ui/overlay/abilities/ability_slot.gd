class_name AbilitySlot
extends Control

@export var keybind: Key = KEY_1
@export var ability: Ability

@onready var _key_bind_label: Label = %KeyBind
@onready var _icon: TextureRect = %Icon

var _pause: bool = false

func _ready() -> void:
	GameManager.game_start.connect(_on_game_start)
	GameManager.game_over.connect(_on_game_over)
	_key_bind_label.text = OS.get_keycode_string(keybind)
	
	if not ability:
		return
	
	_set_properties(ability)

func _on_game_over(_did_win: bool) -> void:
	_pause = true

func _on_game_start() -> void:
	_pause = false

func _process(_delta: float) -> void:
	if Input.is_key_pressed(keybind) and ability and not _pause:
		ability.execute()

func add_ability(ability_to_add: Ability) -> void:
	ability = ability_to_add
	_set_properties(ability_to_add)

func _set_properties(ability_to_set: Ability) -> void:
	_icon.texture = ability_to_set.icon

func remove_ability() -> void:
	ability = null
	_icon.texture = null
