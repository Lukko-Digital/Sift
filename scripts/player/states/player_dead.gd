extends State

@export var animation_player: AnimationPlayer

func enter():
	animation_tree.active = false
	animation_player.play("die_left")
