class_name ModeState
extends State

var time: float
var animation: String
@onready var parent_state: State = get_parent()

func _ready():
	character = parent_state.character
	animation_tree = parent_state.animation_tree
