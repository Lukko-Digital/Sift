extends State

@export var animation_player: AnimationPlayer

const LUNGE_SPEED = 300.

@onready var attack_radius: Area2D = $AttackRadius
@onready var attack_box: Area2D = $AttackBox
@onready var attack_collider: CollisionShape2D = $AttackBox/CollisionShape2D

var driller_attack: Attack = Attack.new("drill attack", 1)
var player: CharacterBody2D

func _ready():
	attack_box.area_entered.connect(_on_hit)
	animation_player.animation_finished.connect(_on_animation_end)

func enter():
	find_player()
	character.velocity = Vector2()
	match Directions.direction_four_diagonal(direction_to_player()):
		Directions.Direction.DOWN_RIGHT: animation_player.play("Attack_windup_down_right")
		Directions.Direction.DOWN_LEFT: animation_player.play("Attack_windup_down_left")
		Directions.Direction.UP_RIGHT: animation_player.play("Attack_windup_up_right")
		Directions.Direction.UP_LEFT: animation_player.play("Attack_windup_up_left")
	
func handle_physics(delta: float):
	if animation_player.current_animation in [
		"Attack_down_right", "Attack_down_left", "Attack_up_right", "Attack_up_left"
	]:
		character.move_and_slide()

func exit():
	pass

func _on_animation_end(anim_name: StringName):
	match anim_name:
		"Attack_windup_down_right", "Attack_windup_down_left", "Attack_windup_up_right", "Attack_windup_up_left":
			match Directions.direction_four_diagonal(direction_to_player()):
				Directions.Direction.DOWN_RIGHT: animation_player.play("Attack_down_right")
				Directions.Direction.DOWN_LEFT: animation_player.play("Attack_down_left")
				Directions.Direction.UP_RIGHT: animation_player.play("Attack_up_right")
				Directions.Direction.UP_LEFT: animation_player.play("Attack_up_left")
			character.velocity = direction_to_player() * LUNGE_SPEED
		"Attack_down_right", "Attack_down_left", "Attack_up_right", "Attack_up_left":
			on_lunge_end(anim_name)

func on_lunge_end(anim_name: StringName):
	attack_collider.set_deferred("disabled", true)
	character.velocity = Vector2()
	match anim_name:
		"Attack_down_right": animation_player.play("Getup_down_right")
		"Attack_down_left": animation_player.play("Getup_down_left")
		"Attack_up_right": animation_player.play("Getup_up_right")
		"Attack_up_left": animation_player.play("Getup_up_left")

func _on_hit(area):
	on_lunge_end(animation_player.current_animation)
	if area.is_in_group("player_hurtbox"):
		driller_attack.effects = [
			KnockedBackEffect.new(0.1, area.global_position-self.global_position),
			StunnedEffect.new(0.25),
		]
		area.damage(driller_attack)

func find_player():
	for body in attack_radius.get_overlapping_bodies():
		if body.name == "player":
			player = body

func direction_to_player():
	return(player.global_position - character.global_position).normalized()
