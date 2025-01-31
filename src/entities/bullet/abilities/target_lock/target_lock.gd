class_name TargetLock
extends Ability

var _is_initialized: bool = false
var _usages: int

func execute() -> void:
	if not _is_initialized:
		_usages = max_usages
		_is_initialized = true
	
	if _usages == 0:
		return
	
	
