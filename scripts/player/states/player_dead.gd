extends State

@export var animation_player: AnimationPlayer

func enter():
	animation_tree["parameters/playback"].travel("Die")
	animation_tree["parameters/Die/blend_position"] = 1

