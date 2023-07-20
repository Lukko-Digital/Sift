extends Area2D

@export var NPC_NAME: String
@export var DIALOGUE_FILE: String

var interaction_count: Dictionary

func _ready():
	var dialogue_path = "res://assets/dialogue/%s" % DIALOGUE_FILE
	assert(FileAccess.file_exists(dialogue_path), "Dialog file at %s does not exist" % dialogue_path)
	for branch in JSON.parse_string(
		FileAccess.open(
			dialogue_path, FileAccess.READ
		).get_as_text()
	)["branches"]:
		interaction_count[branch] = 0
