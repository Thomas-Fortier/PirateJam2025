class_name StationaryEnemy
extends Enemy

func _on_death() -> void:
	# TODO: Implement death logic besides just de-spawning.
	queue_free()
