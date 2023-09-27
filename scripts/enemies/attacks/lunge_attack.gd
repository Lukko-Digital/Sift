extends State

@export var animation_player: AnimationPlayer

const LUNGE_SPEED = 400.

@onready var attack_radius: Area2D = $AttackRadius
@onready var attack_box: Area2D = $AttackBox
@onready var attack_collider: CollisionShape2D = $AttackBox/CollisionShape2D

var vec_to_player: Vector2
var attack_dir: Directions.Direction
var lunge_attack: Attack = Attack.new("lunge", 1)

func _ready():
	attack_box.area_entered.connect(_on_hit)
	animation_player.animation_finished.connect(_on_animation_end)

func enter():
	character.velocity = Vector2()
	vec_to_player = get_direction_to_player()
	attack_dir = Directions.direction_four_diagonal(vec_to_player)
	match attack_dir:
		Directions.Direction.DOWN_RIGHT: animation_player.play("Attack_windup_down_right")
		Directions.Direction.DOWN_LEFT: animation_player.play("Attack_windup_down_left")
		Directions.Direction.UP_RIGHT: animation_player.play("Attack_windup_up_right")
		Directions.Direction.UP_LEFT: animation_player.play("Attack_windup_up_left")
	
func handle_physics(delta: float):
	character.move_and_slide()

func exit():
	pass

func _on_animation_end(anim_name: StringName):
	match anim_name:
		"Attack_windup_down_right", "Attack_windup_down_left", "Attack_windup_up_right", "Attack_windup_up_left":
			match attack_dir:
				Directions.Direction.DOWN_RIGHT: animation_player.play("Attack_down_right")
				Directions.Direction.DOWN_LEFT: animation_player.play("Attack_down_left")
				Directions.Direction.UP_RIGHT: animation_player.play("Attack_up_right")
				Directions.Direction.UP_LEFT: animation_player.play("Attack_up_left")
			character.velocity = vec_to_player * LUNGE_SPEED
		"Attack_down_right", "Attack_down_left", "Attack_up_right", "Attack_up_left":
			on_lunge_end()

func on_lunge_end():
	attack_collider.set_deferred("disabled", true)
	character.velocity = Vector2()
	match attack_dir:
		Directions.Direction.DOWN_RIGHT: animation_player.play("Getup_down_right")
		Directions.Direction.DOWN_LEFT: animation_player.play("Getup_down_left")
		Directions.Direction.UP_RIGHT: animation_player.play("Getup_up_right")
		Directions.Direction.UP_LEFT: animation_player.play("Getup_up_left")

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
