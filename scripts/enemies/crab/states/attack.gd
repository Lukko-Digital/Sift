extends State

@export var animation_player: AnimationPlayer

const WIND_UP_TIME = 0.2
@onready var ATTACK_TIME = animation_player.get_animation("Attack_front").length
const END_LAG = 0.8

@onready var attack_timer: Timer = $AttackTimer
@onready var attack_boxes = $AttackBoxes
@onready var player: CharacterBody2D = get_node("/root/main/player")

var selected_attack_box: Area2D

var crab_attack: Attack = Attack.new("crab slam", 1)

func enter():
	selected_attack_box = get_attack_direction()
	selected_attack_box.get_child(0).disabled = false
	attack_timer.one_shot = true
	attack_timer.start(WIND_UP_TIME + ATTACK_TIME + END_LAG)

func handle_physics(delta: float):
	if attack_timer.time_left > ATTACK_TIME + END_LAG:
		# windup
		character.modulate = Color(1,0,0)
	elif attack_timer.time_left > END_LAG:
		# attack
		animation_player.play("Attack_front")
		character.modulate = Color(0,1,0)
		for area in selected_attack_box.get_overlapping_areas():
			if area.name == "HurtboxComponent":
				area.damage(crab_attack)
				selected_attack_box.get_child(0).disabled = true
	else:
		# end lag
		character.modulate = Color(0,0,1)
		
func exit():
	character.modulate = Color(1,1,1)

func get_attack_direction() -> Area2D:
	var vec_to_player: Vector2 = (player.global_position-character.global_position).normalized()
	if abs(vec_to_player.x) > abs(vec_to_player.y):
		if vec_to_player.x > 0:
			return attack_boxes.get_node("RightAttackBox")
		return attack_boxes.get_node("LeftAttackBox")
	else:
		if vec_to_player.y > 0:
			return attack_boxes.get_node("DownAttackBox")
		return attack_boxes.get_node("UpAttackBox")
