extends State

@export var animation_player: AnimationPlayer
@onready var state_machine: StateMachine = get_parent()

func enter():
	if animation_player.has_animation("Idle_front") and animation_player.has_animation("Idle_back"):
		match Directions.direction_vertical(state_machine.facing_direction):
			Directions.Direction.DOWN: animation_player.play("Idle_front")
			Directions.Direction.UP: animation_player.play("Idle_back")
	
	if animation_player.has_animation("Idle_right") and animation_player.has_animation("Idle_left"):
		match Directions.direction_horizontal(state_machine.facing_direction):
			Directions.Direction.RIGHT: animation_player.play("Idle_right")
			Directions.Direction.LEFT: animation_player.play("Idle_left")

func exit():
	animation_player.stop()
