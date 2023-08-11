class_name StateMachine
extends Node2D

signal transitioned(state_name)

@export var initial_state := NodePath()

@onready var state: State = get_node(initial_state)

func _ready() -> void:
	state.enter()
	
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _physics_process(delta: float) -> void:
	state.handle_physics(delta)

func transition_to(target_state_name: String, args = null) -> void:
#	saftey check
	if not has_node(target_state_name):
		return
	if state == get_node(target_state_name):
		return

	state.exit()
	state = get_node(target_state_name)
	state.recieve_args(args)
	state.enter()
	emit_signal("transitioned", state.name)
