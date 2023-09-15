class_name KnockedUp
extends State

@export var animation_player: AnimationPlayer
@onready var state_machine: StateMachine = get_parent()

func enter():
	animation_player.play("knocked_up")

func exit():
	animation_player.stop()

