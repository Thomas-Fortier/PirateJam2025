extends Area2D

@export var shrapnel_scene: PackedScene
@export var shrapnel_count: int = 10
@export var explosion_radius: float = 200.0
@export var explosion_force: float = 300.0

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is CharacterBody2D:
		explode()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func explode():
	## Spawn shrapnel pieces
	for i in range(shrapnel_count):
		var shrapnel_instance = shrapnel_scene.instantiate()
		var direction = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()
		var position_offset = direction * rng.randf_range(0, explosion_radius)
		
		## Make pieces spawn near the explosion
		shrapnel_instance.position = position + position_offset
		
		if shrapnel_instance.has_method("apply_impulse"):
			shrapnel_instance.apply_impulse(direction * rng.randf_range(0.5, 1.0) * explosion_force)
		
		get_parent().add_child(shrapnel_instance)
		
	play_explosion_effects()
		
	queue_free()

func play_explosion_effects():
	pass
	
 
