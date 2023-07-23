extends State

const SPEED = 50
const RE_NAV_TIME = 0.5

#@export var player: CharacterBody2D
@onready var player: CharacterBody2D = get_node("/root/main/player")
@onready var crab: CharacterBody2D = get_node("../../")
@onready var nav_agent: NavigationAgent2D = get_node("../../NavigationAgent2D")
@onready var re_nav_timer: Timer = nav_agent.get_node("ReNavTimer")

func enter():
	re_nav_timer.timeout.connect(_on_timer_timeout)
	re_nav_timer.wait_time = RE_NAV_TIME
	re_nav_timer.start()
	find_path()
	
func handle_physics(delta: float):
#	var direction = nav_agent.get_next_path_position().normalized()
	var direction = crab.to_local(nav_agent.get_next_path_position()).normalized()
	crab.velocity = direction * SPEED
	crab.move_and_slide()
	
func exit():
	re_nav_timer.stop()
	
func find_path():
	nav_agent.target_position = player.global_position
	print(nav_agent.target_position)
#	print(player.global_position)
#	print(crab.position)
#	print(crab.to_local(nav_agent.get_next_path_position()))
	print(nav_agent.get_next_path_position())
#	print(crab.global_position.distance_to(player.global_position))
	print(nav_agent.is_navigation_finished())

func _on_timer_timeout():
	find_path()
