extends State

@export var animation_player: AnimationPlayer

const END_LAG = 0.8

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
	var vec_to_player: Vector2 = get_direction_to_player()
	if abs(vec_to_player.x) > abs(vec_to_player.y):
		# Left Right
		if sign(vec_to_player.x) == 1:
			animation_player.play("Attack_right")
		else:
			animation_player.play("Attack_left")
	else:
		# Up Down
		if sign(vec_to_player.y) == 1:
			animation_player.play("Attack_down")
		else:
			animation_player.play("Attack_up")

func exit():
	animation_player.stop()

func _on_animation_end(anim_name: StringName):
	if anim_name == "Attack_down":
		animation_player.play("Idle_front")
		attack_timer.start(END_LAG)
	
func get_direction_to_player():
	for body in attack_radius.get_overlapping_bodies():
		if body.name == "player":
			return (body.global_position - character.global_position).normalized()
	return Vector2.ZERO

func _on_hit(area):
	if area.is_in_group("player_hurtbox"):
		crab_attack.effects = [
			KnockedBackEffect.new(0.05, area.global_position-self.global_position),
			StunnedEffect.new(0.25),
		]
		area.damage(crab_attack)
