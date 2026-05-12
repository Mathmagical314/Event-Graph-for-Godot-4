@tool
class_name EventNodeChance
extends EventNodeResource

## A flow control node that randomly fires one of its outputs based on probability weights.
## Weights are relative: if you have two outputs with weights 1.0 and 3.0,
## the first has a 25% chance and the second has a 75% chance.

var output_count: int = 2

func _init() -> void:
	super()
	node_name   = "Chance"
	title       = "Chance"
	category    = "Flow"
	description = "Randomly fires one of its outputs based on weight."
	
	# Initial default state
	if properties.is_empty():
		properties = {
			"Weight 1": 1.0,
			"Weight 2": 1.0
		}


func get_trigger_inputs() -> Array[String]:
	return ["In"]


func get_trigger_outputs() -> Array[String]:
	var outputs: Array[String] = []
	for i in range(output_count):
		outputs.append("Out " + str(i + 1))
	return outputs


func get_custom_actions() -> Array:
	return [
		{"label": "Add Output", "method": "add_output_port"},
		{"label": "Remove Output", "method": "remove_output_port"}
	]


func add_output_port() -> void:
	output_count += 1
	properties["Weight " + str(output_count)] = 1.0
	emit_changed()


## Custom action to remove the last weighted output port.
func remove_output_port() -> void:
	if output_count > 1:
		properties.erase("Weight " + str(output_count))
		output_count -= 1
		emit_changed()


func _execute(_port_name: String) -> void:
	var weights: Array[float] = []
	var total_weight: float = 0.0
	
	# Collect weights and calculate sum
	for i in range(output_count):
		var w = float(properties.get("Weight " + str(i + 1), 1.0))
		weights.append(w)
		total_weight += w
	
	if total_weight <= 0.0:
		# If no weight is assigned, do nothing to avoid division by zero or infinite loop
		return
		
	# Weighted random selection
	var roll = randf() * total_weight
	var current_sum = 0.0
	for i in range(output_count):
		current_sum += weights[i]
		if roll <= current_sum:
			trigger_output("Out " + str(i + 1))
			return
