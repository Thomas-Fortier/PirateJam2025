class_name Hardened
extends Ability

@export var _ricochets_to_add: int = 1

func execute() -> void:
	StatsManager.override_max_ricochets(_ricochets_to_add)

func reset_usages() -> void:
	pass
