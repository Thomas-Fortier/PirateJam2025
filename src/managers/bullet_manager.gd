extends Node

var bullet: Bullet = null

func initialize() -> void:
	bullet = $"../GameRoot/Bullet"
	if bullet:
		bullet.bounced_off_wall.connect(_on_bullet_bounce)

func _on_bullet_bounce():
	var ricochets_remaining: bool = StatsManager.add_ricochet()
	
	if ricochets_remaining:
		return
	
	if StatsManager.decrement_remaining_turns():
		GameManager.handle_game_over(false)
		return
	
	BulletManager.bullet.select_direction()
	StatsManager.reset_ricochets_remaining()
