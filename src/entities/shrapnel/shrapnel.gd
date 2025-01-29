class_name Shrapnel
extends RigidBody2D

@export var damage: int = 250
@export var lifetime: float = 20.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## Enable contact reporting so that the _on_body_entered signal will trigger
	contact_monitor = true
	max_contacts_reported = 5
	
	## Connects the emitted signal to the _on_body_entered function and despawns any remaining shrapnel pieces after 20 seconds
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(lifetime).timeout
	queue_free()

## This function handles the interaction between the shrapnel and colliding enemies or walls
func _on_body_entered(body):
	## If the colliding object is an enemy, kill the enemy and despawn the shrapnel piece
	if body is Enemy:
		body.kill()
	queue_free()
