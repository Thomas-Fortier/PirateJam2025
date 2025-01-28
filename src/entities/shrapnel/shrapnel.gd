extends RigidBody2D

@export var damage: int = 250
@export var lifetime: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 5
	
	call_deferred("connect", "body_entered", _on_body_entered)
	await get_tree().create_timer(lifetime).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body):
	print("Collided with:", body)
	if body is CharacterBody2D:
		if body.has_method("kill"):
			body.kill()
		queue_free()
	elif body is StaticBody2D or body is TileMapLayer:
		queue_free()
