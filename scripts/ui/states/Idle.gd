extends State

@export var interact_prompt: Control
@export var dialogue_box: NinePatchRect

func enter():
	interact_prompt.hide()
	dialogue_box.hide()
