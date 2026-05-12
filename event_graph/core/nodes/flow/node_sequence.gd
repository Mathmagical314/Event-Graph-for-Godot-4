@tool
class_name EventNodeSequence2
extends EventNodeResource

@export var output_count: int = 2
@export var reset_on_start: bool = true
@export var loop: bool = false

var _current_step: int = 0

func _init() -> void:
	ensure_node_id()
	node_name   = "Sequence"
	title       = "Sequence"
	category    = "Flow"
	description = "Fires the next output in sequence each time 'In' is triggered."


func get_trigger_inputs() -> Array[String]:
	return ["In", "Reset"]

func get_trigger_outputs() -> Array[String]:
	var outputs: Array[String] = []
	for i in range(output_count):
		outputs.append("Out " + str(i + 1))
	return outputs


func get_variable_inputs() -> Array[Dictionary]:
	return []

func get_variable_outputs() -> Array[Dictionary]:
	return [{"name": "current_step", "type": TYPE_INT}]


func get_custom_actions() -> Array:
	return [
		{"label": "Add Output", "method": "add_output_port"},
		{"label": "Remove Output", "method": "remove_output_port"}
	]

func add_output_port() -> void:
	output_count += 1
	emit_changed()

func remove_output_port() -> void:
	if output_count > 2:
		output_count -= 1
		# If the current step is now out of bounds, adjust it
		if _current_step >= output_count - 1:
			_current_step = output_count - 1
		emit_changed()


func on_flow_start() -> void:
	if reset_on_start:
		_current_step = 0
		emit_changed()

func get_variable_value(port_name: String) -> Variant:
	if port_name == "current_step":
		return _current_step
	return super.get_variable_value(port_name)


func _execute(port_name: String) -> void:
	if port_name == "Reset":
		_current_step = 0
		emit_changed()
		return
		
	if _current_step >= output_count:
		if loop:
			_current_step = 0
		else:
			# Not looping and reached the end, do nothing
			return
			
	# Fire the current step
	var out_port = "Out " + str(_current_step + 1)
	
	# Increment for next time
	_current_step += 1
	emit_changed()
	
	trigger_output(out_port)
