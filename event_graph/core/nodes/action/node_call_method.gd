@tool
class_name EventNodeCallMethod
extends EventNodeResource

@export var method_name: String = ""
@export_node_path("Node") var target_path: NodePath
@export var target_group: String = ""
@export var argument: String = ""
@export var use_argument: bool = false

func _init() -> void:
	ensure_node_id()
	node_name   = "CallMethod"
	title       = "Call Method"
	category    = "Action"
	description = "Calls a method on a target node or group, with an optional argument."

func get_trigger_inputs() -> Array[String]:
	return ["In"]

func get_trigger_outputs() -> Array[String]:
	return ["Out"]

func get_variable_inputs() -> Array[Dictionary]:
	return [
		{"name": "method_name", "type": TYPE_STRING},
		{"name": "target_path", "type": TYPE_STRING},
		{"name": "target_group", "type": TYPE_STRING},
		{"name": "argument", "type": TYPE_STRING},
	]

func get_variable_outputs() -> Array[Dictionary]:
	return []

func _execute(_port_name: String) -> void:
	if not method_name.is_empty():
		if owner_node:
			if not target_group.is_empty():
				if use_argument:
					owner_node.get_tree().call_group(target_group, method_name, argument)
				else:
					owner_node.get_tree().call_group(target_group, method_name)
			else:
				var target: Node = owner_node
				if not target_path.is_empty():
					target = owner_node.get_node_or_null(target_path)
				
				if target:
					if use_argument:
						target.call(method_name, argument)
					else:
						target.call(method_name)
				else:
					push_error("[EventGraph] CallMethod: target node '%s' not found relative to owner." % target_path)
		else:
			push_error("[EventGraph] CallMethod: owner_node is null.")
			
	trigger_output("Out")
