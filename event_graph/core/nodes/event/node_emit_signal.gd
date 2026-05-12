@tool
class_name EventNodeEmitSignal
extends EventNodeResource

@export var signal_name: String = ""
@export_node_path("Node") var target_path: NodePath
@export var target_group: String = ""
@export var argument: String = ""
@export var use_argument: bool = false

func _init() -> void:
	ensure_node_id()
	node_name   = "EmitSignal"
	title       = "Emit Signal"
	category    = "Action"
	description = "Emits a signal on a target node or group."

func get_trigger_inputs() -> Array[String]:
	return ["In"]

func get_trigger_outputs() -> Array[String]:
	return ["Out"]

func get_variable_inputs() -> Array[Dictionary]:
	return [
		{"name": "signal_name", "type": TYPE_STRING},
		{"name": "target_path", "type": TYPE_NODE_PATH},
		{"name": "target_group", "type": TYPE_STRING},
		{"name": "argument", "type": TYPE_STRING},
	]

func get_variable_outputs() -> Array[Dictionary]:
	return []

func _execute(_port_name: String) -> void:
	if not signal_name.is_empty() and owner_node:
		if not target_group.is_empty():
			if use_argument:
				owner_node.get_tree().call_group(target_group, "emit_signal", signal_name, argument)
			else:
				owner_node.get_tree().call_group(target_group, "emit_signal", signal_name)
		else:
			var target: Node = owner_node
			if not target_path.is_empty():
				target = owner_node.get_node_or_null(target_path)
			
			if target:
				if use_argument:
					target.emit_signal(signal_name, argument)
				else:
					target.emit_signal(signal_name)
			else:
				push_error("[EventGraph] EmitSignal: target node '%s' not found relative to owner." % target_path)
	elif not owner_node:
		push_error("[EventGraph] EmitSignal: owner_node is null.")
		
	trigger_output("Out")
