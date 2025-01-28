extends Area2D

@export var shrapnel_scene: PackedScene
@export var shrapnel_count: int = 5
@export var explosion_radius: float = 10.0
@export var explosion_force: float = 100.0

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is CharacterBody2D:
		explode()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func explode():
	## Spawn shrapnel pieces
	for i in range(shrapnel_count):
		var shrapnel_instance = shrapnel_scene.instantiate()
		
		## Calculate angle for circular spawning of pieces
		var angle = i * (PI * 2 / shrapnel_count) + rng.randf_range(-0.1, 0.1)
		var direction = Vector2(cos(angle), sin(angle)).normalized()
		var position_offset = direction * explosion_radius
		
		## Rotate pieces to match outward direction
		shrapnel_instance.rotation = angle
		
		## Make pieces spawn near the explosion
		shrapnel_instance.position = position + position_offset
		
		if shrapnel_instance.has_method("apply_impulse"):
			var impulse_strength = rng.randf_range(0.8, 1.2) * explosion_force
			shrapnel_instance.apply_impulse(direction * impulse_strength)
		
		get_parent().add_child(shrapnel_instance)
		
	call_deferred("_destroy_barrel")
		
	play_explosion_effects()
		

func _destroy_barrel():
	queue_free()

func play_explosion_effects():
	pass
	
 
