extends State

@export var animation_player: AnimationPlayer
@onready var state_machine: StateMachine = get_parent()

func enter():
	if state_machine.facing_direction.y > 0:
		animation_player.play("Idle_front")
	else:
		animation_player.play("Idle_back")

func exit():
	animation_player.stop()
