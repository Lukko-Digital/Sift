extends State

@export var animation_player: AnimationPlayer

const END_LAG = 0.8

const HORIZONTAL_ATTACK_PLACEMENT = 23.5
const VERTICAL_ATTACK_PLACEMENT = 15.5

@onready var attack_radius: Area2D = $AttackRadius
@onready var attack_timer: Timer = $AttackTimer
@onready var circle_attack_box: Area2D = $CircleAttackBox
@onready var attack_collider: CollisionShape2D

var crab_attack: Attack = Attack.new("crab slam", 1)

func _ready():
	circle_attack_box.area_entered.connect(_on_hit)
	animation_player.animation_finished.connect(_on_animation_end)

func enter():
	attack_timer.one_shot = true
	animation_player.play("Attack_front")

func exit():
	animation_player.stop()

func _on_animation_end(anim_name: StringName):
	if anim_name == "Attack_front":
		animation_player.play("Idle_front")
		attack_timer.start(END_LAG)
	
func get_direction_to_player():
	for body in attack_radius.get_overlapping_bodies():
		if body.name == "player":
			return (body.global_position - character.global_position).normalized()
	return Vector2.ZERO

func place_attack_box():
	# place attack box for directional attack
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
		crab_attack.effects = [KnockedBackEffect.new(0.05, area.global_position-self.global_position)]
		area.damage(crab_attack)
