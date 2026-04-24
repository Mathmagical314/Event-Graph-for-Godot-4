# EventGraph for Godot 4

![EventGraph Header](https://raw.githubusercontent.com/your-username/event_graph/main/icon.svg) <!-- Placeholder for icon -->

**EventGraph** is a robust, resource-driven visual scripting system for Godot 4. Inspired by Unreal Engine's Blueprints and modular flow-based logic, it provides a powerful way to decouple game logic from code, making it perfect for dialogue systems, quest logic, and complex state machines.

## ✨ Key Features

- **Resource-Based Architecture**: Graphs are stored as `.treres` or `.res` files. This ensures your logic is data-driven, easily versionable, and separate from your UI.
- **Trigger & Variable Separation**: Distinct port types for execution flow (Triggers) and data flow (Variables) prevent spaghetti logic and ensure type safety.
- **Fully Extensible**: Creating new nodes is as simple as extending the `EventNodeResource` class and defining its ports and execution logic.
- **Integrated Editor**: A custom GraphEdit-based editor that lives in your Godot bottom panel, complete with a node palette and search functionality.
- **Runtime Execution**: The `EventGraphPlayer` node allows you to execute graphs at runtime, handle signals, and interface with your scene tree.

## 🚀 Getting Started

### Installation

1. Copy the `addons/event_graph` folder into your Godot project's `addons/` directory.
2. Go to **Project Settings > Plugins** and enable **EventGraph**.
3. You will see a new **EventGraph** tab in the bottom panel.

### Basic Usage

1. **Create a Graph**: In the FileSystem dock, right-click and create a new `EventGraphResource`.
2. **Edit Logic**: Double-click the resource to open it in the EventGraph editor. Add nodes (Right-click or use the Palette) and connect them.
3. **Run in Scene**: 
    - Add an `EventGraphPlayer` node to your scene.
    - Assign your Graph Resource to the `Graph` property.
    - Call `player.play()` from a script or use the `Auto Play` option.

## 🛠 Extending EventGraph

To create a custom node, create a new script extending `EventNodeResource`:

```gdscript
extends EventNodeResource
class_name EventNodeMyCustomLogic

func _init() -> void:
    node_name = "My Custom Node"
    category = "Logic"
    
    # Add an input trigger
    add_input_trigger("In")
    # Add an output trigger
    add_output_trigger("Out")
    # Add a data input
    add_input_variable("Message", TYPE_STRING, "Hello!")

func _execute(processor: EventGraphProcessor, input_trigger_index: int) -> void:
    var msg = get_input_value(0)
    print("Executing: ", msg)
    
    # Continue flow
    processor.execute_output(self, 0)
```

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
*Built with ❤️ for the Godot Community.*
