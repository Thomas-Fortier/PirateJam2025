extends Node

var is_using_keyboard: bool = true

func _ready():
	call_deferred("_initialize")

func _initialize() -> void:
	print("Initializing Steam input API...")
	
	var input_initialization_result: bool = Steam.inputInit()
	
	if not input_initialization_result:
		printerr("Could not initialize Steam input API. Make sure Steam is running and the SteamManager is called first.")
		return
	
	Steam.enableDeviceCallbacks()
	
	print("Done initializing Steam input API.")
	
	Steam.input_device_disconnected.connect(_on_steam_input_device_disconnected)

func _input(event: InputEvent) -> void:
	is_using_keyboard = event is InputEventKey or event is InputEventMouseMotion or event is InputEventMouseButton

func _on_steam_input_device_connected(input_handle: int) -> void:
	print("Device connected %s" % str(input_handle))

func _on_steam_input_device_disconnected(input_handle: int) -> void:
	print("Device disconnected %s" % str(input_handle))
