class_name Bomb
extends Area2D

@export var shrapnel_scene: PackedScene
@export var shrapnel_count: int = 5
@export var explosion_radius: float = 10.0
@export var explosion_force: float = 200.0

var EXPLOSION_SOUND = load("res://assets/sounds/mixkit-arcade-game-explosion-2759.wav")
var _random_number_generator = RandomNumberGenerator.new()
var _ignore_collision: bool = false
var exploded: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)

# This function calls the explode function upon colliding with the player
func _on_body_entered(body):
	if exploded or _ignore_collision:
		return
	if body is Bullet or body is Shrapnel or body is BulletRicochet:
		exploded = true
		handle_animation()
		explode()

func explode(ignore_collision: bool = false):
	_ignore_collision = ignore_collision
	
	## Spawn shrapnel pieces
	for i in range(shrapnel_count):
		var shrapnel_instance = shrapnel_scene.instantiate()
		
		## Calculate angle for circular spawning of pieces
		var angle = i * (PI * 2 / shrapnel_count) + _random_number_generator.randf_range(-0.1, 0.1)
		var direction = Vector2(cos(angle), sin(angle)).normalized()
		var position_offset = direction * explosion_radius
		
		## Rotate pieces to match outward direction
		shrapnel_instance.rotation = angle
		
		## Make pieces spawn near the explosion
		shrapnel_instance.position = position + position_offset
		
		if shrapnel_instance.has_method("set_linear_velocity"):
			var constant_speed = 300.0
			shrapnel_instance.set_linear_velocity(direction * constant_speed)
		
		## Calls the _add_shrapnel function
		call_deferred("_add_shrapnel", shrapnel_instance)
		
	play_explosion_effects()

## This is a helper function to add the shrapnel pieces after the explosion
func _add_shrapnel(shrapnel_instance):
	get_parent().add_child(shrapnel_instance)

func play_explosion_effects():
	if exploded:
		AudioManager.play_sound(EXPLOSION_SOUND)

func handle_animation() -> void:
	var animated_sprite = $AnimatedSprite2D
	animated_sprite.play("explode")
	animated_sprite.set_frame(0)

func _on_animation_finished():
	queue_free()
