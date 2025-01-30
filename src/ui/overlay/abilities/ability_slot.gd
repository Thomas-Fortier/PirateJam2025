class_name AbilitySlot
extends Control

@export var keybind: Key = KEY_1
@export var ability: Ability

@onready var _key_bind_label: Label = %KeyBind
@onready var _icon: TextureRect = %Icon

func _ready() -> void:
	_key_bind_label.text = OS.get_keycode_string(keybind)
	
	if not ability:
		return
	
	_icon.texture = ability.icon

func _process(_delta: float) -> void:
	if Input.is_key_pressed(keybind) and ability:
		ability.execute()

func _remove_ability() -> void:
	ability = null
	_icon.texture = null
