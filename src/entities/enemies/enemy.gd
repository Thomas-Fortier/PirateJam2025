class_name Enemy
extends CharacterBody2D

## Represents the number of points that should be acquired when this enemy dies.
@export var points_on_kill: int = 100

# Private members
var _is_dead: bool = false

const DEATH_SOUND = preload("res://assets/sounds/enemy_killed.wav")

## Signal emitted when the enemy has died.
##
## Signal emitted when the enemy has died. This signal is being emitted
## by the child classes. Disregard any warnings about never being
## explicitly used within this class.
signal died(enemy: Enemy)

## Kills this enemy.
##
## Kills this enemy. This function is meant to be called
## externally by other scripts.
func kill() -> void:
	if _is_dead:
		return
	
	AudioManager.play_sound(DEATH_SOUND)
	died.emit(self)
	_is_dead = true
	_on_death()

## Logic to execute when this enemy dies.
##
## Logic to execute when this enemy dies. This function should be overidden
## by child scripts.
func _on_death() -> void:
	push_error("'_on_death' must be overridden by child classes.")
