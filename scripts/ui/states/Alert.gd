extends State

@export var interact_prompt_container: MarginContainer

func enter():
	interact_prompt_container.show()
	
func exit():
	interact_prompt_container.hide()
