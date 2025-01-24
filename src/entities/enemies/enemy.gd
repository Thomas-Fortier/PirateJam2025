class_name Enemy
extends CharacterBody2D

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
	died.emit(self)
	_on_death()

## Logic to execute when this enemy dies.
##
## Logic to execute when this enemy dies. This function should be overidden
## by child scripts.
func _on_death() -> void:
	push_error("'_on_death' must be overridden by child classes.")
