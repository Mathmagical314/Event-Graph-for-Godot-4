@tool
class_name EventNodeWaitEvent
extends EventNodeResource

@export_storage var _is_waiting: bool = false

@export_storage var output_count: int = 1

func _init() -> void:
	ensure_node_id()
	node_name   = "WaitEvent"
	title       = "Wait Event"
	category    = "Flow"
	description = "Waits for a specific string event from the processor. Once 'In' fires, it remains receptive."
	
	if properties.is_empty():
		properties = {
			"Event 1": "my_event",
		}


func get_trigger_inputs() -> Array[String]:
	return ["In", "StopWaiting"]


func get_trigger_outputs() -> Array[String]:
	var outputs: Array[String] = []
	for i in range(output_count):
		outputs.append("Out " + str(i + 1))
	return outputs


func get_custom_actions() -> Array:
	return [
		{"label": "Add Event", "method": "add_output_port"},
		{"label": "Remove Event", "method": "remove_output_port"}
	]


func add_output_port() -> void:
	output_count += 1
	properties["Event " + str(output_count)] = "event_" + str(output_count)
	emit_changed()


func remove_output_port() -> void:
	if output_count > 1:
		properties.erase("Event " + str(output_count))
		output_count -= 1
		emit_changed()


func on_flow_start() -> void:
	_is_waiting = false
	if processor and not processor.graph_event_received.is_connected(_on_graph_event):
		processor.graph_event_received.connect(_on_graph_event)


func _execute(port_name: String) -> void:
	if port_name == "In":
		_is_waiting = true
	elif port_name == "StopWaiting":
		_is_waiting = false


func _on_graph_event(event_name: String) -> void:
	if not _is_waiting:
		return
		
	for i in range(output_count):
		var target_ev = properties.get("Event " + str(i + 1), "")
		if target_ev == event_name:
			trigger_output("Out " + str(i + 1))
