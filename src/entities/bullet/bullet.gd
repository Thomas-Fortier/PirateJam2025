class_name Bullet
extends CharacterBody2D

## Signal for when the bullet has bounced off a wall.
signal bounced_off_wall()

## The speed that the bullet travels.
@export var speed: float = 300.0

# Private members
var _is_selecting_direction: bool = true
var _is_paused: bool = false

func _physics_process(delta: float) -> void:
	if _is_paused:
		return
	
	if _is_selecting_direction:
		_follow_cursor()
		return
	
	velocity = Vector2.RIGHT.rotated(rotation) * speed
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)

	if not collision:
		return
	
	var collider = collision.get_collider()
		
	if collider is Enemy:
		collider.kill()
	else:
		_bounce_off_wall(collision)

## Pauses the bullet movement and allows the user to select the direction
## that the bullet is facing.
func select_direction() -> void:
	_is_selecting_direction = true

## Pauses the bullet movement.
func toggle_pause() -> void:
	_is_paused = !_is_paused

## Bonces the bullet off of a given collision object.
func _bounce_off_wall(collision: KinematicCollision2D) -> void:
	velocity = velocity.bounce(collision.get_normal())
	rotation = velocity.angle()
	bounced_off_wall.emit()

## Follows the cursor and resumes moving in that direction when left click is pressed.
func _follow_cursor() -> void:
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("fire"):
		_is_selecting_direction = false
