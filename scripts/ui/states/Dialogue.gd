extends State

@export var dialogue_box: NinePatchRect

func enter():
	dialogue_box.show()
	Events.enter_dialogue.connect(_on_enter_dialogue)
	Events.advance_dialogue.connect(_on_advance_dialogue)

func exit():
	dialogue_box.hide()

func _on_enter_dialogue(npc_node):
	pass

func _on_advance_dialogue():
	pass
