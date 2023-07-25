extends State

const WIND_UP_TIME = 0.2
const ATTACK_TIME = 0.2
const END_LAG = 0.8

@onready var attack_timer: Timer = $AttackTimer
@onready var attack_boxes = $AttackBoxes
@onready var player: CharacterBody2D = get_node("/root/main/player")
@onready var crab: CharacterBody2D = get_node("../../")

var selected_attack_box: Area2D

func enter():
	selected_attack_box = get_attack_direction()
	attack_timer.one_shot = true
	attack_timer.start(WIND_UP_TIME + ATTACK_TIME + END_LAG)

func handle_physics(delta: float):
	if attack_timer.time_left > ATTACK_TIME + END_LAG:
		crab.modulate = Color(1,0,0)
	elif attack_timer.time_left > END_LAG:
		crab.modulate = Color(0,1,0)
	else:
		crab.modulate = Color(0,0,1)
		
func exit():
	crab.modulate = Color(1,1,1)

func get_attack_direction() -> Area2D:
	var vec_to_player: Vector2 = (player.global_position-crab.global_position).normalized()
	if abs(vec_to_player.x) > abs(vec_to_player.y):
		if vec_to_player.x > 0:
			return attack_boxes.get_node("RightAttackBox")
		return attack_boxes.get_node("LeftAttackBox")
	else:
		if vec_to_player.y > 0:
			return attack_boxes.get_node("DownAttackBox")
		return attack_boxes.get_node("UpAttackBox")
