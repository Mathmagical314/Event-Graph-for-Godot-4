@icon("res://Godot_icon.svg")
class_name EventGraphEmitter
extends EventGraph

## A utility node that sends an event to an EventGraphProcessor when triggered.
## Use this in your scene to communicate with 'Wait Event' nodes inside an EventGraph.

@export var processor: EventGraphProcessor
@export var event_name: String = ""
@export var auto_send_on_ready: bool = false

func _ready() -> void:
	if auto_send_on_ready:
		send()

## Sends the default configured event_name to the processor.
func send() -> void:
	if processor and not event_name.is_empty():
		processor.send_event(event_name)
	elif not processor:
		push_warning("[EventGraphEmitter] Processor is not set on ", name)
	elif event_name.is_empty():
		push_warning("[EventGraphEmitter] Event name is empty on ", name)

## Sends a custom event name to the processor.
func send_custom(custom_event_name: String) -> void:
	if processor and not custom_event_name.is_empty():
		processor.send_event(custom_event_name)
