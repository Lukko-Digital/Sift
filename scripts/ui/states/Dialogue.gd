extends State

@export var dialogue_box: NinePatchRect
@onready var dialogue_label = dialogue_box.get_node("Dialogue")
@onready var response_buttons: VBoxContainer = dialogue_box.get_node("ResponseButtons")
@onready var response_button_scene = preload("res://scenes/ui/response_button.tscn")

var current_npc
var current_dialogue_tree: Dictionary
var current_dialogue_display: Dictionary
var awaiting_response: bool = false

## Connect signals
func _ready():
	Events.enter_dialogue.connect(_on_enter_dialogue)
	Events.advance_dialogue.connect(_on_advance_dialogue)

## Load dialogue file and enter origin (O) branch
func enter():
	dialogue_box.show()
	var dialogue_path = "res://assets/dialogue/%s" % current_npc.DIALOGUE_FILE
	current_dialogue_tree = JSON.parse_string(FileAccess.open(dialogue_path, FileAccess.READ).get_as_text())
	
	load_branch("O")

## Hide dialogue box and reset internal variables
func exit():
	dialogue_box.hide()
	current_npc = null
	current_dialogue_tree = Dictionary()
	current_dialogue_display = Dictionary()

## Enter branch and display dialogue based on interaction level
## Args:
## 	branch_id: A character representing the id of the branch, e.g. O is the origin branch
func load_branch(branch_id):
	var interaction_level = get_interaction_level("%s" % branch_id)
	update_dialogue_display("%s.%s.0" % [branch_id, interaction_level])

## Get interaction level of a branch for the current NPC based on the number of past interactions
## Args:
## 	branch_id: A character representing the id of the branch, e.g. O is the origin branch
## Returns:
## 	An integer representing the interaction level of the branch. The integer will only be a number
## 		at which a new dialogue path is entered, e.g. if the branch O has different dialogue for
##		interactions number 0, 1, and 5, `get_interaction_level` will only return 0, 1, or 5
func get_interaction_level(branch_id):
	var origin_limits = current_npc.branch_interaction_limits[branch_id].duplicate()
	origin_limits.reverse()
	for limit in origin_limits:
		if current_npc.interaction_count[branch_id] >= limit:
			return limit

## Update ui dialogue display based on current dialogue id, also displays responses if available
## Args:
## 	dialogue_id: A string, formatted as CHAR.NUMBER.NUMBER (e.g. A.1.0) the character represents
## 		the branch id, the first number represents the interaction level to enter the path, and
## 		the second number is the index of the dialogue node in the path
func update_dialogue_display(dialogue_id):
	current_dialogue_display = current_dialogue_tree[dialogue_id]
	dialogue_label.text = current_dialogue_display["text"]
	if "responses" in current_dialogue_display:
		handle_responses()

## Displays responses for player to select and awaits selection
func handle_responses():
	spawn_buttons()
	awaiting_response = true

## Instantiates ResponseButtons based on available responses
func spawn_buttons():
	for response in current_dialogue_display["responses"].values():
		var button_instance: ResponseButton = response_button_scene.instantiate()
		button_instance.text = response["text"]
		button_instance.destination_branch = response["next"]
		button_instance.response_pressed.connect(_on_response_pressed)
		response_buttons.add_child(button_instance)

## Signals to NPC to log a completed interaction for the current branch
func exit_branch():
	Events.emit_signal("interaction_complete", current_npc, current_dialogue_display["branch_end"])

## Recieves current NPC when dialogue entered
func _on_enter_dialogue(npc_node):
	current_npc = npc_node

## Advances dialogue when E is pressed. Does nothing if awaiting response, exits dialogue when
## EXIT flag is shown in dialogue tree
func _on_advance_dialogue():
	if awaiting_response:
		return
	
	if "branch_end" in current_dialogue_display:
		exit_branch()
	
	var next_dialogue_id = current_dialogue_display["next"]
	if next_dialogue_id != "EXIT":
		update_dialogue_display(next_dialogue_id)
	else:
		Events.emit_signal("dialogue_complete")
		Events.emit_signal("alert_dialogue")

## Handles response button being pressed
func _on_response_pressed(destination_branch):
	exit_branch()
	load_branch(destination_branch)
	for button in response_buttons.get_children():
		button.queue_free()
	awaiting_response = false
