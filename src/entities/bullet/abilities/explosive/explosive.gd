class_name Explosive
extends Ability

var _is_initialized: bool = false
var _usages: int

var BOMB_SCENE: PackedScene = load("res://entities/bomb/bomb.tscn")

func execute() -> void:
	if not _is_initialized:
		_usages = max_usages
		_is_initialized = true
	
	if _usages == 0:
		return
	
	var bomb: Bomb = BOMB_SCENE.instantiate()
	bomb.position = BulletManager.bullet.position
	GameManager.game_root.add_child(bomb)
	bomb.explode()
	
	_usages -= 1

func reset_usages() -> void:
	_usages = max_usages
