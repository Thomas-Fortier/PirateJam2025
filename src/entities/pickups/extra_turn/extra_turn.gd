extends Pickup

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is Bullet:
		AudioManager.play_sound(_pickup_sound)
		StatsManager.remaining_turns += 1
		queue_free()
