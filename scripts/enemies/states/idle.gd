extends State

@export var animation_player: AnimationPlayer
@onready var state_machine: StateMachine = get_parent()

func enter():
	if animation_player.has_animation("Idle_front") and animation_player.has_animation("Idle_back"):
		match Directions.direction_vertical(state_machine.facing_direction):
			Directions.Direction.DOWN: animation_player.play("Idle_front")
			Directions.Direction.UP: animation_player.play("Idle_back")
	
	if animation_player.has_animation("Idle_down_right"):
		match Directions.direction_four_diagonal(state_machine.facing_direction):
			Directions.Direction.DOWN_RIGHT: animation_player.play("Idle_down_right")
			Directions.Direction.DOWN_LEFT: animation_player.play("Idle_down_left")
			Directions.Direction.UP_RIGHT: animation_player.play("Idle_up_right")
			Directions.Direction.UP_LEFT: animation_player.play("Idle_up_left")

func exit():
	animation_player.stop()
