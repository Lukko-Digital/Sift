extends State

@export var animation_player: AnimationPlayer

const END_LAG = 0.8

const HORIZONTAL_ATTACK_PLACEMENT = 23.5
const VERTICAL_ATTACK_PLACEMENT = 15.5

@onready var attack_radius: Area2D = $AttackRadius
@onready var attack_timer: Timer = $AttackTimer
@onready var attack_box: Area2D = $AttackBox
@onready var attack_collider: CollisionShape2D

var crab_attack: Attack = Attack.new("crab slam", 1)

func _ready():
	attack_box.area_entered.connect(_on_hit)
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

func _on_hit(area):
	if area.is_in_group("player_hurtbox"):
		crab_attack.effects = [
			KnockedBackEffect.new(0.05, area.global_position-self.global_position),
			StunnedEffect.new(0.25),
		]
		area.damage(crab_attack)
