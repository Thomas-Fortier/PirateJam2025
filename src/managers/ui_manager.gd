extends Node

## Manages the creation, deletion, and handling of UI elements.
## Supports UserInterface resources for flexible UI configurations.

## The root container for all UI elements.
var _ui_container: CanvasLayer
## The currently active UI elements (key: UserInterface, value: Node).
var _active_ui_elements: Dictionary = {}

## Initializes the UI container.
func _ready():
	_ui_container = CanvasLayer.new()
	add_child(_ui_container)

## Shows a UI element based on the provided UserInterface resource.
## @param ui_resource The UserInterface resource defining the UI.
## @param properties Optional dictionary to set properties on the UI instance.
func show_ui_element(ui_resource: UserInterface, properties: Dictionary = {}) -> Node:
	if _active_ui_elements.has(ui_resource):
		return _active_ui_elements[ui_resource]  # Already active

	var ui_instance = ui_resource.scene.instantiate()
	_apply_properties(ui_instance, properties)

	_ui_container.add_child(ui_instance)
	_active_ui_elements[ui_resource] = ui_instance
	return ui_instance

## Hides and removes a UI element.
## @param ui_resource The UserInterface resource of the UI to hide.
func hide_ui_element(ui_resource: UserInterface) -> void:
	if _active_ui_elements.has(ui_resource):
		_active_ui_elements[ui_resource].queue_free()
		_active_ui_elements.erase(ui_resource)

## Toggles the visibility of a UI element.
## @param ui_resource The UserInterface resource to toggle.
## @param properties Optional properties to apply if showing.
func toggle_ui_element(ui_resource: UserInterface, properties: Dictionary = {}) -> void:
	if _active_ui_elements.has(ui_resource):
		hide_ui_element(ui_resource)
	else:
		show_ui_element(ui_resource, properties)

## Hides and removes all UI elements.
func hide_all_ui_elements() -> void:
	for ui_resource in _active_ui_elements.keys():
		_active_ui_elements[ui_resource].queue_free()
	_active_ui_elements.clear()

## Applies properties to a UI instance.
## @param instance The UI Node instance.
## @param properties A dictionary of properties to set.
func _apply_properties(instance: Node, properties: Dictionary) -> void:
	for property_name in properties.keys():
		if instance.has_method("set_%s" % property_name):
			instance.call("set_%s" % property_name, properties[property_name])
		elif instance.has_variable(property_name):
			instance.set(property_name, properties[property_name])
		else:
			push_warning("Property %s not found on %s" % [property_name, instance.name])

## Updates properties of an active UI element.
## @param ui_resource The UserInterface resource of the UI.
## @param properties A dictionary of properties to update.
func update_ui_element(ui_resource: UserInterface, properties: Dictionary) -> void:
	if _active_ui_elements.has(ui_resource):
		_apply_properties(_active_ui_elements[ui_resource], properties)
	else:
		push_warning("Attempted to update a UI element that isn't active.")

## Checks if a UI element is currently active.
## @param ui_resource The UserInterface resource to check.
## @return True if active, false otherwise.
func is_ui_element_active(ui_resource: UserInterface) -> bool:
	return _active_ui_elements.has(ui_resource)

## Retrieves the currently active UI instance.
## @param ui_resource The UserInterface resource.
## @return The active Node instance, or null if not active.
func get_active_ui_instance(ui_resource: UserInterface) -> Node:
	return _active_ui_elements.get(ui_resource, null)
