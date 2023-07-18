class_name Idle
extends State

func enter():
	animation_tree["parameters/playback"].travel("idle")
