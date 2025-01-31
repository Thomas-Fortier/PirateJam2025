class_name BulletSplitter
extends Ability

var ricochet_bullet_scene: PackedScene = preload("res://entities/bullet/abilities/split_shot/bullet_ricochet.tscn")
var split_angle: float = 15.0

var _is_initialized: bool = false
var _usages: int

const SHOOT_SOUND = preload("res://assets/sounds/shoot.wav")

# Spawns two ricochets next to the bullet at slightly different angles
func execute() -> void:
	if not ricochet_bullet_scene:
		printerr("Scene not instantiated")
		return
	
	if not _is_initialized:
		_usages = max_usages
		_is_initialized = true
	
	if _usages == 0:
		return
	
	var original_bullet = BulletManager.bullet
	var bullet_position = original_bullet.global_position
	var bullet_rotation = original_bullet.rotation
	var bullet_velocity = original_bullet.velocity
	
	## Spawn two ricochet bullets
	for angle_offset in [-split_angle, split_angle]:
		var new_bullet = ricochet_bullet_scene.instantiate() as CharacterBody2D
		new_bullet.global_position = bullet_position
		new_bullet.rotation = bullet_rotation + deg_to_rad(angle_offset)
		new_bullet.velocity = bullet_velocity.rotated(deg_to_rad(angle_offset))
		
		original_bullet.get_parent().add_child(new_bullet)
	
	AudioManager.play_sound(SHOOT_SOUND)
	
	_usages -= 1

func reset_usages() -> void:
	_usages = max_usages
