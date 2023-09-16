extends State

@export var animation_player: AnimationPlayer

const LUNGE_SPEED = 200.
const LUNGE_DISTANCE = 100.
const END_LAG = 0.9

@onready var attack_radius: Area2D = $AttackRadius
@onready var attack_box: Area2D = $AttackBox
@onready var lunge_timer: Timer = $LungeTimer
@onready var end_lag_timer: Timer = $EndLag

var vec_to_player: Vector2
var lunge_attack: Attack = Attack.new("lunge", 1)

func _ready():
	attack_box.area_entered.connect(_on_hit)
	animation_player.animation_finished.connect(_on_animation_end)
	lunge_timer.timeout.connect(on_lunge_end)

func enter():
	character.velocity = Vector2()
	vec_to_player = get_direction_to_player()
	animation_player.play("Attack_windup")
	
func handle_physics(delta: float):
	character.move_and_slide()

func exit():
	pass

func _on_animation_end(anim_name: StringName):
	if anim_name == "Attack_windup":
		lunge_timer.start(LUNGE_DISTANCE / LUNGE_SPEED)
		character.velocity = vec_to_player * LUNGE_SPEED

func on_lunge_end():
	end_lag_timer.start(END_LAG)
	character.velocity = Vector2()

func _on_hit(area):
	on_lunge_end()
	if area.is_in_group("player_hurtbox"):
		lunge_attack.effects = [
			KnockedBackEffect.new(0.1, area.global_position-self.global_position),
			StunnedEffect.new(0.25),
		]
		area.damage(lunge_attack)

func get_direction_to_player():
	for body in attack_radius.get_overlapping_bodies():
		if body.name == "player":
			return (body.global_position - character.global_position).normalized()
	return Vector2.ZERO
