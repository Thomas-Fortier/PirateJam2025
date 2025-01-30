class_name BulletRicochet
extends CharacterBody2D

@export var speed: float = 300.0
@export var bounces: int = 3

var _is_paused: bool = false

signal bounced_off_wall()
const BOUNCE_SOUND = preload("res://assets/sounds/ricochet.wav")

func _ready() -> void:
	var game_manager = get_node("/root/GameManager")
	if game_manager:
		game_manager.game_over.connect(_on_game_over)
	var level_change = get_node("/root/LevelManager")
	if level_change:
		level_change.level_changed.connect(_on_level_changed)

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	if _is_paused:
		return
	velocity = Vector2.RIGHT.rotated(rotation) * speed
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
	AudioManager.play_sound(BOUNCE_SOUND)
	bounced_off_wall.emit()
	bounces -= 1
	
func _on_level_changed(_next_level: Level) -> void:
	queue_free()
	
func _on_game_over(_did_win: bool) -> void:
	_is_paused = true
