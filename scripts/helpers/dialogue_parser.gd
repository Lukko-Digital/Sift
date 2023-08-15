class_name DialogueParser
extends Node

static func b(dialogue_file):
	var dialogue_path = "res://assets/dialogue/%s" % dialogue_file
	assert(FileAccess.file_exists(dialogue_path), "Dialog file at %s does not exist" % dialogue_path)
	var raw = FileAccess.open(
		dialogue_path, FileAccess.READ
	).get_as_text()
	var lines = raw.split('\n')
	print(lines)
