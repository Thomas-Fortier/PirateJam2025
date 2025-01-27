extends RigidBody2D

@export var damage: int = 250

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body):
	if body is CharacterBody2D:
		body.take_damage(damage)
		queue_free()
	elif body is CollisionShape2D:
		queue_free()
