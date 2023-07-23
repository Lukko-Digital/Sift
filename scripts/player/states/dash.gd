class_name Dash
extends State

@onready var dash_timer: Timer = get_node("../Timer")

@onready var dash_mode: ModeState = get_node(character.mode + "Dash")
@export var shore_checker: RayCast2D

func enter():
	if (shore_checker.get_collision_point() - shore_checker.global_position).length() < 1:
		dash_mode = get_node("WaterDash")
	else:
		dash_mode = get_node(character.mode + "Dash")
	
	if character.velocity.length() < 0.1:
		character.velocity = animation_tree["parameters/Idle/blend_position"]
	
	dash_mode.enter()
	dash_timer.start(dash_mode.time)

func handle_physics(delta):
	dash_mode.handle_physics(delta)

func _on_dash_timer_timeout():
	dash_timer.stop()
