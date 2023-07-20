extends State

@export var dialogue_box: NinePatchRect

var current_npc

func _ready():
	Events.enter_dialogue.connect(_on_enter_dialogue)
	Events.advance_dialogue.connect(_on_advance_dialogue)

func enter():
	dialogue_box.show()

func exit():
	dialogue_box.hide()

func _on_enter_dialogue(npc_node):
	current_npc = npc_node

func _on_advance_dialogue():
	pass
