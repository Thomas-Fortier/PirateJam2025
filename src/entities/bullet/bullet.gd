class_name Bullet
extends CharacterBody2D

## The speed that the bullet travels.
@export var speed: float = 300.0

func _physics_process(delta: float) -> void:
	velocity = transform.x * speed
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)

	if not collision:
		return
	
	var collider = collision.get_collider()
		
	if collider is Enemy:
		collider.kill()
	else:
		_bounce_off_wall(collision)

## Bonces the bullet off of a given collision object.
func _bounce_off_wall(collision: KinematicCollision2D) -> void:
	velocity = velocity.bounce(collision.get_normal())
	rotation = velocity.angle()
