class_name StationaryEnemy
extends Enemy

func _ready() -> void:
	add_to_group("enemies")

func _physics_process(_delta: float) -> void:
	var animated_sprite = $AnimatedSprite2D
	animated_sprite.play("idle")

func _on_death() -> void:
	# TODO: Implement death logic besides just de-spawning.
	queue_free()
