class_name Bullet
extends CharacterBody2D

## Signal for when the bullet has bounced off a wall.
signal bounced_off_wall()

@export_category("Sounds")
@export var _shoot_sound: Sound
@export var _ricochet_sound: Sound

@export_category("Stats")
## The speed that the bullet travels.
@export var speed: float = 300.0
var splitter: BulletSplitter = BulletSplitter.new()

# Private members
@onready var _trajectory_line: TrajectoryLine = %TrajectoryLine
var _is_selecting_direction: bool = true
var _is_paused: bool = false
var _overriden_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	LevelManager.level_changed.connect(_on_level_changed)
	_on_level_changed.call_deferred(LevelManager.level)
	
	GameManager.game_paused.connect(_on_game_paused)
	GameManager.game_resumed.connect(_on_game_resumed)

func _physics_process(delta: float) -> void:
	if _is_paused:
		return
	
	if _is_selecting_direction:
		_follow_cursor()
		return
	
	if _overriden_direction != Vector2.ZERO:
		velocity = _overriden_direction.normalized() * speed
		rotation = velocity.angle()
	else:
		velocity = Vector2.RIGHT.rotated(rotation) * speed
	
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)

	if not collision:
		return
	
	var collider = collision.get_collider()
		
	if collider is Enemy:
		collider.kill()
	else:
		_overriden_direction = Vector2.ZERO
		_bounce_off_wall(collision)

func _on_game_paused() -> void:
	_is_paused = true

func _on_game_resumed() -> void:
	_is_paused = false

func _on_level_changed(next_level: Level) -> void:
	_overriden_direction = Vector2.ZERO
	if next_level:
		position = next_level.get_spawn_point_position()

## Pauses the bullet movement and allows the user to select the direction
## that the bullet is facing.
func select_direction() -> void:
	_overriden_direction = Vector2.ZERO
	_is_selecting_direction = true

## Resets the state of the bullet.
func reset() -> void:
	_is_paused = false
	_is_selecting_direction = true

## Pauses the bullet movement.
func toggle_pause() -> void:
	_is_paused = !_is_paused

func override_direction(direction: Vector2) -> void:
	if _is_selecting_direction or _is_paused:
		return
	_overriden_direction = direction.normalized() * speed

## Bonces the bullet off of a given collision object.
func _bounce_off_wall(collision: KinematicCollision2D) -> void:
	velocity = velocity.bounce(collision.get_normal())
	rotation = velocity.angle()
	AudioManager.play_sound(_ricochet_sound)
	bounced_off_wall.emit()

## Follows the cursor and resumes moving in that direction when left click is pressed.
func _follow_cursor() -> void:
	_trajectory_line.update_trajectory(global_position, rotation)
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("fire") and not _is_paused:
		_is_selecting_direction = false
		AudioManager.play_sound(_shoot_sound)
		_trajectory_line.clear()
