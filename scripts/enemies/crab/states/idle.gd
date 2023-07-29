extends State

@export var animation_player: AnimationPlayer

func enter():
	animation_player.play("Idle_front")
