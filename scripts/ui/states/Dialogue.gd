extends State

@export var dialogue_container: MarginContainer
@export var portrait_rect: TextureRect
@export var name_label: Label
@export var dialogue_label: Label
@export var response_button_container: VBoxContainer

@onready var response_button_scene = preload("res://scenes/ui/response_button.tscn")
@onready var text_timer: Timer = $TextTimer

# Node of current interactable
var interactable: InteractableComponent

# All data about current interaction
var dialogue_info: Dictionary
var dialogue_tree: Dictionary

# Frequently updated trackers
var branch_id: String
var branch_interaction_lvl: String
var dialogue_idx: int
var dialogue_display: Dictionary

# State control bools
var awaiting_response: bool = false
var display_in_progress: bool = false

# Text animation read-out speed
const TEXT_SPEED = 0.03

## Connect signals
func _ready():
	Events.advance_dialogue.connect(_on_advance_dialogue)
	text_timer.wait_time = TEXT_SPEED

## Recieves current interactable when dialogue entered
func recieve_args(interactable_node):
	interactable = interactable_node

## Load dialogue file and enter origin (O) branch
func enter():
	dialogue_container.show()
	despawn_buttons()
	var dialogue_path = "res://assets/dialogue/%s" % interactable.DIALOGUE_FILE
	var dialogue_json = JSON.parse_string(FileAccess.open(dialogue_path, FileAccess.READ).get_as_text())
	dialogue_info = dialogue_json["info"]
	dialogue_tree = dialogue_json["branches"]
	load_branch("O")

## Hide dialogue box and reset internal variables
func exit():
	dialogue_container.hide()
	interactable = null
	dialogue_tree = Dictionary()
	dialogue_display = Dictionary()

## Enter branch and display dialogue based on interaction level
## Args:
## 	branch_id: A character representing the id of the branch, e.g. O is the origin branch
func load_branch(next_branch_id):
	branch_id = next_branch_id
	branch_interaction_lvl = str(get_interaction_level("%s" % branch_id))
	dialogue_idx = 0
	update_dialogue_display()
	
## Get interaction level of a branch for the current NPC based on the number of past interactions
## Args:
## 	branch_id: A character representing the id of the branch, e.g. O is the origin branch
## Returns:
## 	An integer representing the interaction level of the branch. The integer will only be a number
## 		at which a new dialogue path is entered, e.g. if the branch O has different dialogue for
##		interactions number 0, 1, and 5, `get_interaction_level` will only return 0, 1, or 5
func get_interaction_level(branch_id):
	var origin_limits = interactable.branch_interaction_limits[branch_id].duplicate()
	origin_limits.reverse()
	for limit in origin_limits:
		if interactable.interaction_count[branch_id] >= limit:
			return limit

## Update ui dialogue display based on current dialogue id, also displays responses if available
## Args:
## 	dialogue_id: A string, formatted as CHAR.NUMBER.NUMBER (e.g. A.1.0) the character represents
## 		the branch id, the first number represents the interaction level to enter the path, and
## 		the second number is the index of the dialogue node in the path
func update_dialogue_display():
	dialogue_display = dialogue_tree[branch_id][str(branch_interaction_lvl)][dialogue_idx]
	
	var display_name = dialogue_info["name"] if "name" not in dialogue_display else dialogue_display["name"]
	name_label.text = display_name
	var image_file = dialogue_info["image"] if "image" not in dialogue_display else dialogue_display["image"]
	portrait_rect.texture = load("res://assets/portraits/%s" % image_file)
	
	dialogue_label.text = dialogue_display["text"]
	
	if "responses" in dialogue_display:
		handle_responses()
	await animate_display()

## Display characters one by one
func animate_display():
	dialogue_label.visible_characters = 0
	display_in_progress = true
	
	while dialogue_label.visible_characters < len(dialogue_label.text):
		dialogue_label.visible_characters += 1
		text_timer.start()
		await text_timer.timeout
	
	display_in_progress = false

## Displays responses for player to select and awaits selection
func handle_responses():
	spawn_buttons()
	awaiting_response = true

## Instantiates ResponseButtons based on available responses
func spawn_buttons():
	for response in dialogue_display["responses"].values():
		var button_instance: ResponseButton = response_button_scene.instantiate()
		button_instance.text = response["text"]
		button_instance.destination_branch = response["next"]
		button_instance.response_pressed.connect(_on_response_pressed)
		response_button_container.add_child(button_instance)
	response_button_container.get_child(0).grab_focus()

## Removes all buttons from ResponseButtonContainer
func despawn_buttons():
	for button in response_button_container.get_children():
		button.queue_free()

## Signals to NPC to log a completed interaction for the current branch
func exit_branch():
	Events.emit_signal("interaction_complete", interactable, branch_id)

## Advances dialogue when E is pressed. Does nothing if awaiting response, exits dialogue when
## EXIT flag is shown in dialogue tree
func _on_advance_dialogue():
	# display all characters if display in progress
	if display_in_progress:
		dialogue_label.visible_characters = len(dialogue_label.text)
	# do nothing if waiting for player to respond
	elif awaiting_response:
		pass
	# advance to next dialogue
	else:
		# "next" key will either signal the next branch to EXIT
		if "next" in dialogue_display:
			var next_id = dialogue_display["next"]
			# if not exiting, signal branch end and load next branch
			if next_id != "EXIT":
				exit_branch()
				load_branch(next_id)
			# exit dialogue
			else:
				Events.emit_signal("dialogue_complete")
				Events.emit_signal("alert_dialogue")
		# tick dialogue idx, display new dialogue
		else:
			dialogue_idx += 1
			update_dialogue_display()

## Handles response button being pressed
func _on_response_pressed(destination_branch):
	exit_branch()
	load_branch(destination_branch)
	despawn_buttons()
	awaiting_response = false
