extends Node

@export var ricochet_bullet_scene: PackedScene 
@export var split_angle: float = 15.0

func split_bullet(original_bullet: CharacterBody2D):
	if not ricochet_bullet_scene:
		print("Error Ricochet bullet scene not assigned!")
		return
		
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
