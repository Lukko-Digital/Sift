extends State

@export var dialogue_container: MarginContainer
@export var interact_prompt_container: MarginContainer

func enter():
	dialogue_container.hide()
	interact_prompt_container.hide()
