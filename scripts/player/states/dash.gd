class_name Dash
extends State

@onready var dash_timer: Timer = $DashTimer

@onready var dash_mode: ModeState = get_node(character.mode)

func enter():
	dash_mode = get_node(character.mode + "Dash")
	dash_mode.enter()
	dash_timer.start(dash_mode.time)

func handle_physics(delta):
	dash_mode.handle_physics(delta)

func _on_dash_timer_timeout():
	dash_timer.stop()
	print(1)
