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
	var vec_to_player: Vector2 = (player.global_position-crab.global_position).normalized()
	if abs(vec_to_player.x) > abs(vec_to_player.y):
		if vec_to_player.x > 0:
			selected_attack_box = attack_boxes.get_node("RightAttackBox")
		else:
			selected_attack_box = attack_boxes.get_node("LeftAttackBox")
	else:
		if vec_to_player.y > 0:
			selected_attack_box = attack_boxes.get_node("DownAttackBox")
		else:
			selected_attack_box = attack_boxes.get_node("UpAttackBox")
