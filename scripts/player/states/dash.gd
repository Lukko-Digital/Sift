class_name Dash
extends State



@export var shore_checker: RayCast2D

func enter():
	dash_mode = get_node(character.mode + "Dash")
	
	
	

	
	
func exit():
	dash_mode.exit()

func handle_physics(delta):
	dash_mode.handle_physics(delta)



