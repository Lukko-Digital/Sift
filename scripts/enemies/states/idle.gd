extends State

@export var animation_player: AnimationPlayer
@onready var state_machine: StateMachine = get_parent()

func enter():
	if animation_player.has_animation("Idle_front") and animation_player.has_animation("Idle_back"):
		if state_machine.facing_direction.y > 0:
			animation_player.play("Idle_front")
		else:
			animation_player.play("Idle_back")
	
	if animation_player.has_animation("Idle_right") and animation_player.has_animation("Idle_left"):
		if state_machine.facing_direction.x > 0:
			animation_player.play("Idle_right")
		else:
			animation_player.play("Idle_left")

func exit():
	animation_player.stop()
