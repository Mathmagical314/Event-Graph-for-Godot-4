@tool
class_name EventNodeInstantiate
extends EventNodeResource

@export_file() var scene_path: String = ""
@export_node_path("Node") var parent_node: NodePath
@export var position: Vector2 = Vector2.ZERO

func _init() -> void:
	ensure_node_id()
	node_name   = "Instantiate"
	title       = "Instantiate Scene"
	category    = "Action"
	description = "Instantiates a PackedScene and adds it to the specified parent."

func get_trigger_inputs() -> Array[String]:
	return ["In"]

func get_trigger_outputs() -> Array[String]:
	return ["Out"]

func get_variable_inputs() -> Array[Dictionary]:
	return [
		{"name": "scene_path", "type": TYPE_STRING},
		{"name": "parent_node", "type": TYPE_NODE_PATH},
		{"name": "position", "type": TYPE_VECTOR2},
	]

func get_variable_outputs() -> Array[Dictionary]:
	return [{"name": "instance", "type": TYPE_OBJECT}]

func _execute(_port_name: String) -> void:
	if owner_node and not scene_path.is_empty():
		var scene: PackedScene = load(scene_path)
		if scene:
			var instance = scene.instantiate()
			var parent: Node = owner_node
			
			if not parent_node.is_empty():
				parent = owner_node.get_node_or_null(parent_node)
			
			if parent:
				parent.add_child(instance)
				if instance is Node2D:
					instance.global_position = position
				elif instance is Node3D:
					instance.global_position = Vector3(position.x, position.y, 0) # Fallback if someone uses 3D but supplies Vector2
				
				properties["instance"] = instance
			else:
				push_error("[EventGraph] Instantiate: Parent node '%s' not found." % parent_node)
		else:
			push_error("[EventGraph] Instantiate: Failed to load scene at '%s'." % scene_path)
			
	trigger_output("Out")
