class_name MovingEnemy
extends Enemy

@export var speed: float = 3000
@export var movement_interval: Array[float] = [1.0, 1.5, 2.0]
var _movement_direction: Vector2

func _ready() -> void:
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	move(delta)

func _on_death() -> void:
	# TODO: Implement death logic besides just de-spawning.
	queue_free()

## Make the enemy move in a random direction
func move(delta: float) -> void:
	velocity = _movement_direction * speed * delta
	move_and_slide()

## Function to choose random wait time and direction to move
func _on_timer_timeout() -> void:
	$Timer.wait_time = movement_interval.pick_random()
	_movement_direction = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN].pick_random()
