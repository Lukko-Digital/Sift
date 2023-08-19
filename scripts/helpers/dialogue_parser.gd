## Functions for parsing .idmu files (Ian Dialogue MarkUp)
class_name DialogueParser
extends Node

# idmu format constants
const NAME_TAG = "name: "
const IMAGE_TAG = "image: "
const BRANCH_CHAR = "~ "
const PATH_CHAR = ": "
const RESPONSE_CHAR = "- "
const SWITCH_CHAR = "> "

## Load idmu file, throws an error if file doesn't exist
## Args:
## 	dialogue_file: A string representing the .imdu file name, must be in the res://assets/dialogue/
## Returns: A PackedStringArray, representing each line of the .imdu as a new element
static func load_idmu(dialogue_file):
	var dialogue_path = "res://assets/dialogue/%s" % dialogue_file
	assert(FileAccess.file_exists(dialogue_path), "Dialog file at %s does not exist" % dialogue_path)
	return FileAccess.open(
		dialogue_path, FileAccess.READ
	).get_as_text().split('\n')

## Parse the name and image from the first two lines of the idmu
## Args:
## 	dialogue_file: A string representing the .imdu file name, must be in the res://assets/dialogue/
## Returns: A dictionary with the name of the interactable stored under "name" and the image for
## 	the interactable sotred under "image"
static func parse_dialogue_info(dialogue_file):
	var lines = load_idmu(dialogue_file)
	
	var dialogue_info: Dictionary
	# Get name and image from first two lines
	assert(
		lines[0].substr(0, len(NAME_TAG)) == NAME_TAG,
		"First line must be in the format: `%s [NAME]`" % NAME_TAG
	)
	assert(
		lines[1].substr(0, len(IMAGE_TAG)) == IMAGE_TAG,
		"Second line must be in the format: `%s [IMAGE FILE PATH]`" % IMAGE_TAG
	)
	dialogue_info["name"] = lines[0].substr(6)
	dialogue_info["image"] = lines[1].substr(7)
	
	return dialogue_info

## Parse the dialogue tree of the idmu line by line
## Args:
##	dialogue_file: A string representing the .imdu file name, must be in the res://assets/dialogue/
## Returns: A dictionary representing the dialogue tree, structured as:
##	dialogue tree: A dict of branches
##	branch: A dict of paths
##	path: A list of dialogue line dicts
## dialogue line dict: A dictionary with the line stored under "text" and optional "response" and
##	"next" keys
static func parse_dialogue_tree(dialogue_file):
	var lines = load_idmu(dialogue_file)
	
	var dialogue_tree: Dictionary
	var branch: String
	var path: String

	# Loop through lines starting on the 3rd
	for line in lines.slice(2):
		# Remove tabs
		line = line.replace("\t","")
		# Match the first 2 characters, the second should always be a space
		match line.substr(0,2):
			# Branch
			BRANCH_CHAR:
				var res = branch_line(dialogue_tree, line)
				dialogue_tree = res[0]
				branch = res[1]
			# path
			PATH_CHAR:
				var res = path_line(dialogue_tree, branch, line)
				dialogue_tree = res[0]
				path = res[1]
			# Response
			RESPONSE_CHAR:
				dialogue_tree = response_line(dialogue_tree, branch, path, line)
			# Switch
			SWITCH_CHAR:
				dialogue_tree = switch_line(dialogue_tree, branch, path, line)
			# Dialogue
			_:
				dialogue_tree = dialogue_line(dialogue_tree, branch, path, line)
	return dialogue_tree

## Parse a line tagged with the branch character
## Args:
##	 dialogue_tree: A dictionary representing the working dialogue tree
##	 line: A string representing the current line
## Returns: A list, with the first element being the dialogue tree with the branch added,
##	 and the second item being a string representing the current branch
static func branch_line(dialogue_tree, line):
	var branch = line.substr(2)
	dialogue_tree[branch] = {}
	return [dialogue_tree, branch]

## Parse a line tagged with the path character
## Args:
##	 dialogue_tree: A dictionary representing the working dialogue tree
##	 line: A string representing the current line
##	 branch: A string representing the current branch
## Returns: A list, with the first element being the dialogue tree with the path added,
##	 and the second item being a string representing the current path
static func path_line(dialogue_tree, branch, line):
	var path = line.substr(2)
	assert(
		dialogue_tree.has(branch),
		"No branch detected. Branches are denoted `~ [BRANCH_ID]`"
	)
	dialogue_tree[branch][path] = []
	return [dialogue_tree, path]

## Parse a line tagged with the response character
## Args:
##	 dialogue_tree: A dictionary representing the working dialogue tree
##	 line: A string representing the current line
##	 branch: A string representing the current branch
##	 path: A string representing the current path
## Returns: The dialogue tree with the response added to the last dialogue line under "responses"
static func response_line(dialogue_tree, branch, path, line):
	assert(" > " in line, "No next branch detected. Next branch is denoted [DIALOGUE_TEXT] > [BRANCH_ID]")
	
	var dialogue = dialogue_tree[branch][path][-1]
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

## Parse a line tagged with the switch character
## Args:
##	 dialogue_tree: A dictionary representing the working dialogue tree
##	 line: A string representing the current line
##	 branch: A string representing the current branch
##	 path: A string representing the current path
## Returns: The dialogue tree with the branch to switch to added to the last dialogue line under "next"
static func switch_line(dialogue_tree, branch, path, line):
	dialogue_tree[branch][path][-1]["next"] = line.substr(2)
	return dialogue_tree

## Parse a dialogue line
## Args:
##	 dialogue_tree: A dictionary representing the working dialogue tree
##	 line: A string representing the current line
##	 branch: A string representing the current branch
##	 path: A string representing the current path
## Returns: The dialogue tree with the dialogue line added to the respective path
static func dialogue_line(dialogue_tree, branch, path, line):
	assert(
		dialogue_tree.has(branch),
		"No branch detected. Branches are denoted `~ [BRANCH_ID]`"
	)
	assert(
		dialogue_tree[branch].has(path),
		"Path not detected. Paths are denoted `: [PATH_ENTRACE_CONDITIONS]`"
	)
	dialogue_tree[branch][path].append({"text": line})
	return dialogue_tree
