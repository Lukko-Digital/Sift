extends State

@export var interact_prompt: Control

func enter():
	interact_prompt.show()
	
func exit():
	interact_prompt.hide()
