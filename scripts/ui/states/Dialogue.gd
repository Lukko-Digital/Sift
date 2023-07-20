extends State

@export var dialogue_box: NinePatchRect

func enter():
	dialogue_box.show()

func exit():
	dialogue_box.hide()
