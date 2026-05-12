@tool
class_name EventNodeAnd2
extends EventNodeResource

@export_storage var input_count: int = 2

var _fired_inputs: Dictionary = {}

func _init() -> void:
	ensure_node_id()
	node_name   = "And"
	title       = "And"
	category    = "Logic"
	description = "Waits for all inputs to fire before firing the output."


func get_trigger_inputs() -> Array[String]:
	var inputs: Array[String] = []
	for i in range(input_count):
		inputs.append("In " + str(i + 1))
	for i in range(input_count):
		inputs.append("Cancel " + str(i + 1))
	inputs.append("Cancel All")
	return inputs

func get_trigger_outputs() -> Array[String]:
	return ["Out"]

func get_variable_inputs() -> Array[Dictionary]:
	return []

func get_variable_outputs() -> Array[Dictionary]:
	return []


func get_custom_actions() -> Array:
	return [
		{"label": "Add Input", "method": "add_input_port"},
		{"label": "Remove Input", "method": "remove_input_port"}
	]

func add_input_port() -> void:
	input_count += 1
	emit_changed()

func remove_input_port() -> void:
	if input_count > 2:
		input_count -= 1
		_fired_inputs.clear() # Clear firing state as port count changed
		emit_changed()


func _execute(port_name: String) -> void:
	if port_name == "Cancel All":
		_fired_inputs.clear()
		return
	
	if port_name.begins_with("Cancel "):
		var idx_str = port_name.replace("Cancel ", "")
		var in_name = "In " + idx_str
		if _fired_inputs.has(in_name):
			_fired_inputs.erase(in_name)
		return

	if port_name.begins_with("In "):
		_fired_inputs[port_name] = true
		
		var all_fired := true
		for i in range(input_count):
			if not _fired_inputs.has("In " + str(i + 1)):
				all_fired = false
				break
				
		if all_fired:
			_fired_inputs.clear()
			trigger_output("Out")
