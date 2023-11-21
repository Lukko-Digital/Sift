extends State

@export var RE_NAV_TIME: float
@export var SPEED: int
@export var animation_player: AnimationPlayer

@onready var state_machine: StateMachine = get_parent()
@onready var player: CharacterBody2D = find_parent("main").get_node("player")
@onready var nav_agent: NavigationAgent2D = get_node("../../NavigationAgent2D")
@onready var re_nav_timer: Timer = nav_agent.get_node("ReNavTimer")

func enter():
	re_nav_timer.timeout.connect(_on_timer_timeout)
	re_nav_timer.wait_time = RE_NAV_TIME
	re_nav_timer.start()
	find_path()
	
func handle_physics(delta: float):
	var direction = character.to_local(nav_agent.get_next_path_position()).normalized()
	character.velocity = direction * SPEED
	character.move_and_slide()
	
	handle_animation()
	state_machine.facing_direction = direction
	
func exit():
	re_nav_timer.stop()
	animation_player.stop()
	
func find_path():
	nav_agent.target_position = player.global_position
	
func handle_animation():
	if animation_player.has_animation("Run_front") and animation_player.has_animation("Run_back"):
		match Directions.direction_vertical(state_machine.facing_direction):
			Directions.Direction.DOWN: animation_player.play("Run_front")
			Directions.Direction.UP: animation_player.play("Run_back")
	
	if animation_player.has_animation("Run_down_right"):
		match Directions.direction_four_diagonal(state_machine.facing_direction):
			Directions.Direction.DOWN_RIGHT: animation_player.play("Run_down_right")
			Directions.Direction.DOWN_LEFT: animation_player.play("Run_down_left")
			Directions.Direction.UP_RIGHT: animation_player.play("Run_up_right")
			Directions.Direction.UP_LEFT: animation_player.play("Run_up_left")

func _on_timer_timeout():
	find_path()
