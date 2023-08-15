class_name DialogueParser
extends Node

static func b(dialogue_file):
	var dialogue_path = "res://assets/dialogue/%s" % dialogue_file
	assert(FileAccess.file_exists(dialogue_path), "Dialog file at %s does not exist" % dialogue_path)
	var lines = FileAccess.open(
		dialogue_path, FileAccess.READ
	).get_as_text().split('\n')

	var dialogue_dict = {
		"info": {
			"name": "",
			"image": "",
		},
		"branches": {}
	}

	# Get name and image from first two lines
	assert(
		lines[0].substr(0,6) == "name: ",
		"First line must be in the format: `name: [NAME]`"
	)
	assert(
		lines[1].substr(0,7) == "image: ",
		"Second line must be in the format: image: [IMAGE FILE PATH]`"
	)
	dialogue_dict["info"]["name"] = lines[0].substr(6)
	dialogue_dict["info"]["image"] = lines[1].substr(7)

	var dialogue_tree: Dictionary
	var branch: String
	var interaction: String
	var dialogue_idx: int = 0

	for line in lines:
		# Remove tabs
		line = line.replace("\t","")
		# Check if new branch begins
		if line.substr(0,9) == "~ branch ":
			branch = line.substr(9)
			dialogue_tree[branch] = {}
		# If there is no branch, pass
		elif not branch:
			continue
		# Get interaction number if line ends in colon
		elif line[-1] == ":":
			interaction = line.substr(0, len(line) - 1)
			dialogue_tree[branch][interaction] = []
			dialogue_idx = 0
		# Check if line is a response option
		elif line.substr(0,2) == "- ":
			pass
		# Else, assume that the line is a dialogue item
		else:
			dialogue_tree[branch][interaction] = line
	
	print(dialogue_tree)
