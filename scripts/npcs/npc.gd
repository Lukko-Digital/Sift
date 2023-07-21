extends Area2D

@export var NPC_NAME: String
@export var DIALOGUE_FILE: String

var interaction_count: Dictionary
var branch_interaction_limits: Dictionary

func _ready():
	Events.interaction_complete.connect(_on_interaction_complete)
	
	var dialogue_path = "res://assets/dialogue/%s" % DIALOGUE_FILE
	assert(FileAccess.file_exists(dialogue_path), "Dialog file at %s does not exist" % dialogue_path)
	var dialogue_json = JSON.parse_string(
		FileAccess.open(
			dialogue_path, FileAccess.READ
		).get_as_text()
	)
	for branch in dialogue_json["branches"]:
		interaction_count[branch] = 0
	
	for branch in dialogue_json["branches"]:
		branch_interaction_limits[branch] = []
		
	var dialogue_ids = []
	for id in dialogue_json.keys():
		if id == "branches":
			continue
		var split_id = id.rsplit(".")
		var branch = split_id[0]
		var limit = int(split_id[1])
		if limit not in branch_interaction_limits[branch]:
			branch_interaction_limits[branch].append(limit)

func _on_interaction_complete(npc_node, branch):
	if npc_node == self:
		interaction_count[branch] += 1
