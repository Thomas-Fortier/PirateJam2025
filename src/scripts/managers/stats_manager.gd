extends Node

signal points_changed(points: int)
signal ricochets_changed(ricochets_remaining: int)
signal turns_changed(turns: int, max_turns: int)

var total_points: int = 0
var total_kills: int = 0
var total_ricochets: int = 0
var levels_completed: int = 0

var _custom_max_ricochets: int = 0

var points: int:
	set(value):
		if points == value:
			return
		points = value
		points_changed.emit(value)

var ricochets_remaining: int:
	set(value):
		if ricochets_remaining == value:
			return
		ricochets_remaining = value
		ricochets_changed.emit(value)

var remaining_turns: int:
	set(value):
		if remaining_turns == value:
			return
		remaining_turns = value
		turns_changed.emit(value, GameManager.config.max_turns)

var kills: int = 0

func _ready():
	remaining_turns = GameManager.config.max_turns
	
	if _custom_max_ricochets != 0:
		ricochets_remaining = _custom_max_ricochets
		return
	
	ricochets_remaining = GameManager.config.max_ricochets
	
	GameManager.game_over.connect(_on_game_over)

func _on_game_over(_did_win: bool) -> void:
	_custom_max_ricochets = 0

func override_max_ricochets(new_max: int) -> void:
	_custom_max_ricochets = new_max
	ricochets_remaining = new_max

func reset_level_stats() -> void:
	points = 0
	kills = 0
	remaining_turns = GameManager.config.max_turns
	
	if _custom_max_ricochets != 0:
		ricochets_remaining = _custom_max_ricochets
		return
	
	ricochets_remaining = GameManager.config.max_ricochets

func reset_all():
	reset_level_stats()
	total_points = 0
	total_kills = 0
	total_ricochets = 0
	levels_completed = 0
	_custom_max_ricochets = 0

func add_points(amount: int) -> void:
	points += amount
	total_points += amount

func add_kill() -> void:
	total_kills += 1
	kills += 1

func reset_ricochets_remaining() -> void:
	if _custom_max_ricochets != 0:
		ricochets_remaining = _custom_max_ricochets
		return
	ricochets_remaining = GameManager.config.max_ricochets

func decrement_remaining_turns() -> bool:
	remaining_turns -= 1
	return remaining_turns == 0

func add_ricochet() -> bool:
	if ricochets_remaining <= 0:
		return false
	
	total_ricochets += 1
	ricochets_remaining -= 1
	
	return true
