@tool
class_name EventNodeGate
extends EventNodeResource

@export var is_open: bool = true

func _init() -> void:
	super()
	node_name = "Gate"
	title = "Gate"
	category = "Flow"
	description = "Passes execution only if open. Can be opened, closed, or toggled."

func get_trigger_inputs() -> Array[String]:
	return ["In", "Open", "Close", "Toggle"]

func get_trigger_outputs() -> Array[String]:
	return ["Out"]

func get_variable_inputs() -> Array[Dictionary]:
	return []

func get_variable_outputs() -> Array[Dictionary]:
	return [{"name": "is_open", "type": TYPE_BOOL}]

func _execute(port_name: String) -> void:
	match port_name:
		"Open":
			is_open = true
			emit_changed()
		"Close":
			is_open = false
			emit_changed()
		"Toggle":
			is_open = not is_open
			emit_changed()
		"In":
			if is_open:
				trigger_output("Out")
