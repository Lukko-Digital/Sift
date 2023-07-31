extends State

@export var animation_player: AnimationPlayer

const WIND_UP_TIME = 0.2
@onready var ATTACK_TIME = animation_player.get_animation("Attack_front").length
const END_LAG = 0.8

const HORIZONTAL_ATTACK_PLACEMENT = 23.5
const VERTICAL_ATTACK_PLACEMENT = 15.5

@onready var attack_radius: Area2D = $AttackRadius
@onready var attack_timer: Timer = $AttackTimer
@onready var attack_box: Area2D = $AttackBox
@onready var attack_collider: CollisionShape2D = $AttackBox/CollisionShape2D

var crab_attack: Attack = Attack.new("crab slam", 1)

func _ready():
	attack_box.area_entered.connect(_on_hit)

func enter():
	place_attack_box()
	attack_timer.one_shot = true
	attack_timer.start(WIND_UP_TIME + ATTACK_TIME + END_LAG)

func handle_physics(delta: float):
	if attack_timer.time_left > ATTACK_TIME + END_LAG:
		# windup
		pass
	elif attack_timer.time_left > END_LAG:
		# attack
		animation_player.play("Attack_front")
	else:
		# end lag
		pass
		
func exit():
	animation_player.stop()
	
func get_direction_to_player():
	for body in attack_radius.get_overlapping_bodies():
		if body.name == "player":
			return (body.global_position - character.global_position).normalized()
	return Vector2.ZERO

func place_attack_box():
	var vec_to_player: Vector2 = get_direction_to_player()
	var pos: Vector2
	if abs(vec_to_player.x) > abs(vec_to_player.y):
		# Left Right
		pos = Vector2(sign(vec_to_player.x)*HORIZONTAL_ATTACK_PLACEMENT, 0)
	else:
		# Up Down
		pos = Vector2(0, sign(vec_to_player.y)*VERTICAL_ATTACK_PLACEMENT)
	attack_collider.position = pos

func _on_hit(area):
	if area.is_in_group("player_hurtbox"):
		area.damage(crab_attack)
