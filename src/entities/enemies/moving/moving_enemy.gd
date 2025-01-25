class_name MovingEnemy
extends Enemy

const speed = 30
var dir: Vector2

func _ready() -> void:
	add_to_group("enemies")

func _process(delta):
	move(delta)

func _on_death() -> void:
	# TODO: Implement death logic besides just de-spawning.
	queue_free()

## Make the enemy move in a random direction
func move(delta):
	# TODO: Implement logic to prevent enemy from gaining speed if the same direction is chosen twice in a row
	velocity += dir * speed * delta
	move_and_slide()

## Function to choose random wait time and direction to move
func _on_timer_timeout():
	$Timer.wait_time = choose([1.0, 1.5, 2.0])
	dir = choose([Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN])
	print(dir)

## Helper function to randomize array
func choose(array):
	array.shuffle()
	return array.front()
