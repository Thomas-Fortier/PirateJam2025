extends Node

func _ready():
	_initialize()

func _initialize() -> void:
	var initialize_response: Dictionary = Steam.steamInitEx( true, 1853750 )
	
	if initialize_response["status"] != 0:
		printerr("An error occured when attempting to initialize with steam: '%s'." % initialize_response["verbal"])
		return
	
	print("Initialized with Steam successfully.")
