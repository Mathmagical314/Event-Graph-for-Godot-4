@tool
class_name EventNodePlayAnimation
extends EventNodeResource

@export_node_path("AnimationPlayer") var target_path: NodePath
@export var animation_name: String = ""
@export var speed: float = 1.0
@export var blend: float = -1.0
@export var from_end: bool = false

func _init() -> void:
	ensure_node_id()
	node_name   = "PlayAnimation"
	title       = "Play Animation"
	category    = "Action"
	description = "Plays an animation on a target AnimationPlayer."

func get_trigger_inputs() -> Array[String]:
	return ["In"]

func get_trigger_outputs() -> Array[String]:
	return ["Out"]

func get_variable_inputs() -> Array[Dictionary]:
	return [
		{"name": "target_path", "type": TYPE_NODE_PATH},
		{"name": "animation_name", "type": TYPE_STRING},
		{"name": "speed", "type": TYPE_FLOAT},
	]

func get_variable_outputs() -> Array[Dictionary]:
	return []

func _execute(_port_name: String) -> void:
	if owner_node and not target_path.is_empty():
		var target: Node = owner_node.get_node_or_null(target_path)
		if target and target is AnimationPlayer:
			if not animation_name.is_empty():
				target.play(animation_name, blend, float(speed), from_end)
			else:
				push_error("[EventGraph] PlayAnimation: animation_name is empty.")
		else:
			push_error("[EventGraph] PlayAnimation: target node '%s' is not an AnimationPlayer or not found." % target_path)
	elif not owner_node:
		push_error("[EventGraph] PlayAnimation: owner_node is null.")
		
	trigger_output("Out")
