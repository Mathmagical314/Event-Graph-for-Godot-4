# 🌊 EventGraph for Godot 4

![Godot Engine](https://img.shields.io/badge/Godot_4.3+-478CBF?logo=godot-engine&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

**EventGraph** is a robust, resource-driven visual scripting system for Godot 4. Inspired by Unreal Engine's Blueprints and modular flow-based logic, it provides a powerful way to decouple game logic from code, making it perfect for dialogue systems, quest logic, and complex state machines.

---

## ✨ Key Features

- **Resource-Based Architecture**: Graphs are stored as `.tres` or `.res` files. This ensures your logic is data-driven, easily versionable, and cleanly separated from your UI and scene tree.
- **Trigger & Variable Separation**: Distinct port types for execution flow (Triggers) and data flow (Variables) prevent spaghetti logic and ensure strict type safety.
- **Hybrid "Pure/Stateful" Node Evaluation**: Supports recursive, pull-based variable evaluation for data-only nodes.
- **Fully Extensible API**: Creating new custom nodes is as simple as extending the `EventNodeResource` class and defining its ports and execution logic.
- **Integrated Editor**: A custom, highly polished GraphEdit-based editor that lives in your Godot bottom panel, complete with a node palette, search functionality, and dynamic properties.
- **Runtime Execution**: The `EventGraphPlayer` node allows you to execute graphs at runtime, handle Godot signals natively, and interface seamlessly with your scene tree.

## 📦 Built-In Node Types

EventGraph comes packed with a variety of nodes to handle complex logic right out of the box:
- **Action**: Nodes that perform specific tasks or side effects.
- **Data**: Pure data nodes (Strings, Integers, Booleans, Object References) with recursive evaluation.
- **Event**: Entry points that start the execution flow.
- **Flow**: Control flow nodes including **Branch**, **Sequence**, and **Reroute**.
- **Logic**: Boolean and comparative operations like **AND**, **OR**, **NOT**.
- **Utility**: Conversion and debugging nodes (e.g., Print, Type Casts).

---

## 🚀 Getting Started

### Installation

1. Copy the `addons/event_graph` folder into your Godot project's `addons/` directory.
2. Go to **Project Settings > Plugins** and enable **EventGraph**.
3. You will see a new **EventGraph** tab appear in the bottom panel of the editor.

### Basic Usage

1. **Create a Graph**: In the FileSystem dock, right-click and select **Create New Resource**, then choose `EventGraphResource`.
2. **Edit Logic**: Double-click the newly created resource to open it in the EventGraph editor. Add nodes (Right-click to open the Palette) and connect them.
3. **Run in Scene**: 
    - Add an `EventGraphPlayer` node to your scene.
    - Assign your Graph Resource to the `Graph` property.
    - Call `player.play()` from a script or enable the `Auto Play` option in the inspector.

---

## 4. Creating Custom Nodes

To add a new node, create a script inheriting from `EventNodeResource` in the appropriate directory (e.g., `addons/event_graph/core/nodes/action/`). The `EventNodeRegistry` will automatically recognize it.

### Action Node Template (Stateful/Impure)
```gdscript
@tool
extends EventNodeResource

# Required: Initialize basic node information
func _init() -> void:
    super()
    node_name = "MyCustomNode" # Unique internal name
    title = "My Custom Node"   # Display name in editor
    category = "Action"        # Category for color/grouping
    description = "Description of what this node does."

# Define input trigger ports
func get_trigger_inputs() -> Array[String]:
    return ["In"]

# Define output trigger ports
func get_trigger_outputs() -> Array[String]:
    return ["Out"]

# Define input variable ports
func get_variable_inputs() -> Array[Dictionary]:
    return [
        {"name": "Value1", "type": TYPE_FLOAT},
        {"name": "Value2", "type": TYPE_FLOAT}
    ]

# Define output variable ports
func get_variable_outputs() -> Array[Dictionary]:
    return [{"name": "Result", "type": TYPE_FLOAT}]

# Execution logic
func _execute(processor: EventGraphProcessor, port_name: String) -> void:
    # 1. Fetch input variables (already resolved by the processor)
    var val1 = get_input_value(0)
    var val2 = get_input_value(1)
    
    # 2. Process
    var result = val1 + val2
    
    # 3. Store result for output
    properties["Result"] = result
    
    # 4. Pass execution to the next node
    processor.execute_output(self, 0)
```

### Pure Data Node Template
For "Value nodes" or "Math nodes" that return results without triggers:
```gdscript
@tool
extends EventNodeResource

func _init() -> void:
    super()
    node_name = "FloatValue"
    title = "Float Value"
    category = "Data"

# Return empty for trigger ports
func get_trigger_inputs() -> Array[String]: return []
func get_trigger_outputs() -> Array[String]: return []

func get_variable_outputs() -> Array[Dictionary]:
    return [{"name": "Value", "type": TYPE_FLOAT}]

# Initialize properties so they appear in the inspector
func _ready():
    if not properties.has("Value"):
        properties["Value"] = 0.0

# Required: Inform the processor this is a pure data node
func is_pure() -> bool:
    return true

# Required: Processing when a value is requested by the processor
func evaluate(port_name: String) -> Variant:
    return properties.get("Value", 0.0)

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/your-username/event_graph/issues).

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
<p align="center"><i>Built with ❤️ for the Godot Community.</i></p>
