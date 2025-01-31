class_name TargetLock
extends Ability

var _is_initialized: bool = false
var _usages: int

const ABILITY_SOUND = preload("res://entities/bullet/abilities/target_lock/target_lock.wav")

func execute() -> void:
	if not _is_initialized:
		_usages = max_usages
		_is_initialized = true
	
	if _usages == 0:
		return
	
	var closest_enemy: Enemy = EnemyManager.get_closest_enemy_to_node(BulletManager.bullet)
	
	if closest_enemy == null:
		return
	
	var direction_to_enemy: Vector2 = (closest_enemy.global_position - BulletManager.bullet.global_position).normalized()
	BulletManager.bullet.override_direction(direction_to_enemy)
	
	AudioManager.play_sound(ABILITY_SOUND)
	
	_usages -= 1

func reset_usages() -> void:
	_usages = max_usages
