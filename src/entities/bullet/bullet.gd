class_name Bullet
extends CharacterBody2D

@export var speed: float = 500.0

func _physics_process(delta: float) -> void:
	velocity = transform.x * speed
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)

	if collision:
		bounce_off_wall(collision)

func bounce_off_wall(collision: KinematicCollision2D) -> void:
	velocity = velocity.bounce(collision.get_normal())
	rotation = velocity.angle()
