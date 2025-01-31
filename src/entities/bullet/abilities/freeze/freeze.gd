class_name Freeze
extends Ability

var _is_initialized: bool = false
var _usages: int

func execute() -> void:
	if not _is_initialized:
		_usages = max_usages
		_is_initialized = true
	
	if _usages == 0:
		return
	
	BulletManager.bullet.select_direction()
	AudioManager.play_sound(ability_sound)
	
	_usages -= 1

func reset_usages() -> void:
	_usages = max_usages
