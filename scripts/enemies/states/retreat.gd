extends State

@export var SPEED: int
@export var animation_player: AnimationPlayer

const RETREAT_DIST = 70

signal retreat_finished

@onready var state_machine: StateMachine = get_parent()
@onready var player: CharacterBody2D = find_parent("main").get_node("player")
@onready var nav_agent: NavigationAgent2D = get_node("../../NavigationAgent2D")

func _ready():
	nav_agent.navigation_finished.connect(_retreat_finished)

func enter():
	find_path()
	
func handle_physics(delta: float):
	handle_animation()
	var direction = character.to_local(nav_agent.get_next_path_position()).normalized()
	character.velocity = direction * SPEED
	character.move_and_slide()
	state_machine.facing_direction = direction
	
func exit():
	animation_player.stop()
	
func find_path():
	var vec_to_player = (player.global_position - character.global_position).normalized()
	nav_agent.target_position = character.global_position + vec_to_player.rotated(PI) * RETREAT_DIST

func handle_animation():
	match Directions.direction_four_diagonal(state_machine.facing_direction):
		Directions.Direction.DOWN_RIGHT: animation_player.play("Run_down_right")
		Directions.Direction.DOWN_LEFT: animation_player.play("Run_down_left")
		Directions.Direction.UP_RIGHT: animation_player.play("Run_up_right")
		Directions.Direction.UP_LEFT: animation_player.play("Run_up_left")

func _retreat_finished():
	emit_signal("retreat_finished")
