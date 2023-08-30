extends Node2D

var direction: Vector2
var mode: String
@onready var animation_tree: AnimationTree = $AnimationTree

func start(direction: Vector2, mode: String, start_position: Vector2):
	position = start_position
	self.direction = direction
	self.mode = mode
	
	if abs(direction.x) > abs(direction.y):
		animation_tree["parameters/" + mode + "/blend_position"] = Vector2(direction.x / abs(direction.x), 0)
	else:
		animation_tree["parameters/" + mode + "/blend_position"] = Vector2(0, direction.y / abs(direction.y))
		
	animation_tree["parameters/playback"].start(mode)
	
	visible = true

func _on_animation_tree_animation_finished(anim_name):
	queue_free()
