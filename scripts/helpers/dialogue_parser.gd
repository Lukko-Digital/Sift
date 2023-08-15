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

	# Loop through lines starting on the 3rd
	for line in lines.slice(2):
		# Remove tabs
		line = line.replace("\t","")
		# Match the first 2 characters, the second should always be a space
		match line.substr(0,2):
			# Branch
			"~ ":
				branch = line.substr(2)
				dialogue_tree[branch] = {}
			# Interaction
			": ":
				interaction = line.substr(2)
				assert(
					dialogue_tree.has(branch),
					"No branch detected. Branches are denoted `~ [BRANCH_ID]`"
				)
				dialogue_tree[branch][interaction] = []
			# Response
			"- ":
				var dialogue = dialogue_tree[branch][interaction][-1]
				if not dialogue.has("responses"):
					dialogue["responses"] = {}
				
				var split_line = line.substr(2).split(" > ")
				var text = split_line[0]
				var next = split_line[1]
				
				var response_num = len(dialogue["responses"]) + 1
				
				dialogue["responses"][response_num] = {
					"text": text,
					"next": next
				}
			# Switch
			"> ":
				pass
			# Dialogue
			_:
				assert(
					dialogue_tree.has(branch),
					"No branch detected. Branches are denoted `~ [BRANCH_ID]`"
				)
				assert(
					dialogue_tree[branch].has(interaction),
					"Interaction path not detected. Interaction paths are denoted `: [MIN_INTERACRTIONS_FOR_PATH]`"
				)
				dialogue_tree[branch][interaction].append({"text": line})
	
	print(dialogue_tree)
