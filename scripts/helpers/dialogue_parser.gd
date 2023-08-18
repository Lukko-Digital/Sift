class_name DialogueParser
extends Node

static func parse(dialogue_file):
	var dialogue_path = "res://assets/dialogue/%s" % dialogue_file
	assert(FileAccess.file_exists(dialogue_path), "Dialog file at %s does not exist" % dialogue_path)
	var lines = FileAccess.open(
		dialogue_path, FileAccess.READ
	).get_as_text().split('\n')

	var dialogue_info: Dictionary

	# Get name and image from first two lines
	assert(
		lines[0].substr(0,6) == "name: ",
		"First line must be in the format: `name: [NAME]`"
	)
	assert(
		lines[1].substr(0,7) == "image: ",
		"Second line must be in the format: image: [IMAGE FILE PATH]`"
	)
	dialogue_info["name"] = lines[0].substr(6)
	dialogue_info["image"] = lines[1].substr(7)

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
				var res = branch_line(dialogue_tree, line)
				dialogue_tree = res[0]
				branch = res[1]
			# Interaction
			": ":
				var res = interaction_line(dialogue_tree, branch, line)
				dialogue_tree = res[0]
				interaction = res[1]
			# Response
			"- ":
				dialogue_tree = response_line(dialogue_tree, branch, interaction, line)
			# Switch
			"> ":
				dialogue_tree = switch_line(dialogue_tree, branch, interaction, line)
			# Dialogue
			_:
				dialogue_tree = dialogue_line(dialogue_tree, branch, interaction, line)
	
	print(JSON.stringify(dialogue_tree, "\t"))
	return {"info": dialogue_info, "tree": dialogue_tree}

static func branch_line(dialogue_tree, line):
	var branch = line.substr(2)
	dialogue_tree[branch] = {}
	return [dialogue_tree, branch]

static func interaction_line(dialogue_tree, branch, line):
	var interaction = line.substr(2)
	assert(
		dialogue_tree.has(branch),
		"No branch detected. Branches are denoted `~ [BRANCH_ID]`"
	)
	dialogue_tree[branch][interaction] = []
	return [dialogue_tree, interaction]

static func response_line(dialogue_tree, branch, interaction, line):
	assert(" > " in line, "No next branch detected. Next branch is denoted [DIALOGUE_TEXT] > [BRANCH_ID]")
	
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
	return dialogue_tree

static func switch_line(dialogue_tree, branch, interaction, line):
	dialogue_tree[branch][interaction][-1]["next"] = line.substr(2)
	return dialogue_tree

static func dialogue_line(dialogue_tree, branch, interaction, line):
	assert(
		dialogue_tree.has(branch),
		"No branch detected. Branches are denoted `~ [BRANCH_ID]`"
	)
	assert(
		dialogue_tree[branch].has(interaction),
		"Interaction path not detected. Interaction paths are denoted `: [MIN_INTERACRTIONS_FOR_PATH]`"
	)
	dialogue_tree[branch][interaction].append({"text": line})
	return dialogue_tree
