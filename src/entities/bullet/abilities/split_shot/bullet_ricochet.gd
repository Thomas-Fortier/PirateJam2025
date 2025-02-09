class_name BulletRicochet
extends CharacterBody2D

@export_category("Sounds")
@export var _ricochet_sound: Sound

@export_category("Stats")
@export var speed: float = 300.0
@export var bounces: int = 3

var _is_paused: bool = false

signal bounced_off_wall()

## Connecting to the global scripts to receive signals when the game is paused or level is changed
func _ready() -> void:
	var game_manager = get_node("/root/GameManager")
	if game_manager:
		game_manager.game_over.connect(_on_game_over)

# Bouncing logic for the ricochets, despawns once it has bounced three times
func _physics_process(delta: float) -> void:
	if _is_paused:
		return
	velocity = Vector2.RIGHT.rotated(rotation) * speed
	handle_animation()
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)

	if not collision:
		return
	
	var collider = collision.get_collider()
		
	if collider is Enemy:
		collider.kill()
	else:
		if bounces == 0:
			queue_free()
		_bounce_off_wall(collision)

func _bounce_off_wall(collision: KinematicCollision2D) -> void:
	velocity = velocity.bounce(collision.get_normal())
	rotation = velocity.angle()
	AudioManager.play_sound(_ricochet_sound)
	bounced_off_wall.emit()
	bounces -= 1

# Deletes the ricochet on game over
func _on_game_over(_did_win: bool) -> void:
	_is_paused = true
	queue_free()
	
func handle_animation() -> void:
	var animated_sprite = $AnimatedSprite2D
	animated_sprite.play("flying")
