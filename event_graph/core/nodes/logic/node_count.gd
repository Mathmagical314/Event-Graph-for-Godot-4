@tool
class_name EventNodeCount2
extends EventNodeResource

@export var limit: int = 3
@export var reset_on_start: bool = true

@export_storage var _current_count: int = 0

func _init() -> void:
	ensure_node_id()
	node_name   = "Count"
	title       = "Count"
	category    = "Logic"
	description = "Limits execution to a set number of times. Output stops firing when the limit is reached."


func get_trigger_inputs() -> Array[String]:
	return ["In", "Reset"]

func get_trigger_outputs() -> Array[String]:
	return ["Out", "Finished"]

func get_variable_inputs() -> Array[Dictionary]:
	return []

func get_variable_outputs() -> Array[Dictionary]:
	return [{"name": "count", "type": TYPE_INT}]


func on_flow_start() -> void:
	if reset_on_start:
		_current_count = 0
		emit_changed()


func get_variable_value(port_name: String) -> Variant:
	if port_name == "count":
		return _current_count
	return super.get_variable_value(port_name)


func _execute(port_name: String) -> void:
	if port_name == "Reset":
		_current_count = 0
		emit_changed()
		return
		
	if _current_count < limit:
		_current_count += 1
		emit_changed()
		trigger_output("Out")
	else:
		trigger_output("Finished")
