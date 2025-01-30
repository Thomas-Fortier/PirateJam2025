class_name MovingEnemy
extends Enemy

@export var speed: float = 3000
@export var movement_interval: Array[float] = [1.0, 1.5, 2.0]
var _movement_direction: Vector2
var is_idle: bool = false

func _ready() -> void:
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	move(delta)
	handle_animation()

func _on_death() -> void:
	# TODO: Implement death logic besides just de-spawning.
	queue_free()

## Make the enemy move in a random direction
func move(delta: float) -> void:
	if is_idle:
		return
	velocity = _movement_direction * speed * delta
	move_and_slide()
	if get_slide_collision_count() > 0:
		is_idle = true
		_movement_direction = Vector2.ZERO

## Function to choose random wait time and direction to move
func _on_timer_timeout() -> void:
	$Timer.wait_time = movement_interval.pick_random()
	_movement_direction = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN].pick_random()
	
	is_idle = false

func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	if is_idle:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("moving_right")
		if _movement_direction.x == -1:
			animated_sprite.flip_h = true
		elif _movement_direction.x == 1:
			animated_sprite.flip_h = false
