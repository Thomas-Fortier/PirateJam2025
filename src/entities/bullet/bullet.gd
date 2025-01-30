class_name Bullet
extends CharacterBody2D

## Signal for when the bullet has bounced off a wall.
signal bounced_off_wall()

## The speed that the bullet travels.
@export var speed: float = 300.0
var splitter: BulletSplitter = BulletSplitter.new()

# Private members
@onready var _trajectory_line: TrajectoryLine = %TrajectoryLine
var _is_selecting_direction: bool = true
var _is_paused: bool = false

const BOUNCE_SOUND = preload("res://assets/sounds/ricochet.wav")
const SHOOT_SOUND = preload("res://assets/sounds/shoot.wav")

func _ready() -> void:
	LevelManager.level_changed.connect(_on_level_changed)
	_on_level_changed.call_deferred(LevelManager.level)

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

func _on_level_changed(next_level: Level) -> void:
	if next_level:
		position = next_level.get_spawn_point_position()

## Pauses the bullet movement and allows the user to select the direction
## that the bullet is facing.
func select_direction() -> void:
	_is_selecting_direction = true

## Resets the state of the bullet.
func reset() -> void:
	_is_paused = false
	_is_selecting_direction = true

## Pauses the bullet movement.
func toggle_pause() -> void:
	_is_paused = !_is_paused

## Bonces the bullet off of a given collision object.
func _bounce_off_wall(collision: KinematicCollision2D) -> void:
	velocity = velocity.bounce(collision.get_normal())
	rotation = velocity.angle()
	AudioManager.play_sound(BOUNCE_SOUND)
	bounced_off_wall.emit()

## Follows the cursor and resumes moving in that direction when left click is pressed.
func _follow_cursor() -> void:
	_trajectory_line.update_trajectory(global_position, rotation)
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("fire") and not _is_paused:
		_is_selecting_direction = false
		AudioManager.play_sound(SHOOT_SOUND)
		_trajectory_line.clear()

## Detects split shot and calls the split bullet function as well as plays fire sound
func _input(event: InputEvent) -> void:
	if !_is_selecting_direction and not _is_paused and event.is_action_pressed("split_shot") and splitter:
		print("Right click detected")
		AudioManager.play_sound(SHOOT_SOUND)
		splitter.split_bullet(self)
		
