extends State

@export var dialogue_box: NinePatchRect
@onready var dialogue_label = dialogue_box.get_node("Dialogue")

var current_npc
var current_dialogue_tree: Dictionary
var current_dialogue_display: Dictionary

func _ready():
	Events.enter_dialogue.connect(_on_enter_dialogue)
	Events.advance_dialogue.connect(_on_advance_dialogue)

func enter():
	dialogue_box.show()
	var dialogue_path = "res://assets/dialogue/%s" % current_npc.DIALOGUE_FILE
	current_dialogue_tree = JSON.parse_string(FileAccess.open(dialogue_path, FileAccess.READ).get_as_text())
	
	var origin_limits = current_npc.branch_interaction_limits["O"].duplicate()
	origin_limits.reverse()
	var interaction_level
	for limit in origin_limits:
		if current_npc.interaction_count["O"] >= limit:
			interaction_level = limit
			break
			
	current_dialogue_display = current_dialogue_tree["O.%s.0" % interaction_level]
	dialogue_label.text = current_dialogue_display["text"]

func exit():
	dialogue_box.hide()
	current_npc = null
	current_dialogue_tree = Dictionary()
	current_dialogue_display = Dictionary()

func _on_enter_dialogue(npc_node):
	current_npc = npc_node

func _on_advance_dialogue():
	if "branch_end" in current_dialogue_display:
		Events.emit_signal("interaction_complete", current_npc, current_dialogue_display["branch_end"])
	
	var next_dialogue_id = current_dialogue_display["next"]
	if next_dialogue_id != "EXIT":
		current_dialogue_display = current_dialogue_tree[next_dialogue_id]
		dialogue_label.text = current_dialogue_display["text"]
	else:
		Events.emit_signal("dialogue_complete")
		Events.emit_signal("alert_dialogue")
