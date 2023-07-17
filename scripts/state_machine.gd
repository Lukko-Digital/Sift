class_name StateMachine
extends Node

signal transitioned(state_name)

@export var initial_state := NodePath()

@onready var state: State = get_node(initial_state)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state.enter()
	
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _physics_process(delta: float) -> void:
	state.handle_physics(delta)

func transition_to(target_state_name: String) -> void:
#	saftey check
	if not has_node(target_state_name):
		return
		
	state.exit()
	state = get_node(target_state_name)
	state.enter()
	emit_signal("transitioned", state.name)
