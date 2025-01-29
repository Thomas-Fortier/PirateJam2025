extends Area2D

@export var shrapnel_scene: PackedScene
@export var shrapnel_count: int = 5
@export var explosion_radius: float = 10.0
@export var explosion_force: float = 200.0

var _random_number_generator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)

# This function calls the explode function upon colliding with the player
func _on_body_entered(body):
	if body is Bullet or body is Shrapnel:
		explode()

func explode():
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
		
		if shrapnel_instance.has_method("apply_impulse"):
			var impulse_strength = _random_number_generator.randf_range(0.8, 1.2) * explosion_force
			shrapnel_instance.apply_impulse(direction * impulse_strength)
		
		## Calls the _add_shrapnel function
		call_deferred("_add_shrapnel", shrapnel_instance)
		
	call_deferred("play_explosion_effects")

## This is a helper function to add the shrapnel pieces after the explosion
func _add_shrapnel(shrapnel_instance):
	get_parent().add_child(shrapnel_instance)

func play_explosion_effects():
	queue_free()

 
