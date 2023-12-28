class_name SandAttack
extends State

@onready var timer: Timer = $Timer
@onready var sand_attack_scene = preload("res://scenes/player/sand_attack.tscn")
@onready var continuation_timer: Timer = $ContinuationTimer
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var instance_timer: Timer = $InstanceTimer

@export var attack_lengths = [0.5]
@export var initial_movement_delays = [0.001]
@export var startups = [0.001]
@export var end_lags = [0.35]

const END_SPEED_COEFF = 0.5

const COOLDOWN = 0.001
const MULTI_ATTCK_TIMING = 0.001

var direction: Vector2

var multi_attack = 0
var num_attacks = 1

func enter():
	timer.start(attack_lengths[multi_attack])
	instance_timer.start(startups[multi_attack])
	continuation_timer.stop()
	
	direction = (get_global_mouse_position() - character.global_position).normalized()
#	if multi_attack == 0:
#		direction = (get_global_mouse_position() - character.global_position).normalized()
#	else:
#		var angle = direction.angle_to(get_global_mouse_position() - character.global_position)
#		angle = sign(angle) * min(abs(angle), PI/4)
#		direction = direction.rotated(angle)
	
#	var anim_name: String
	
	if abs(direction.x) > abs(direction.y):
		animation_tree["parameters/SandAttack/blend_position"] = Vector2(direction.x / abs(direction.x), 0)
#		if direction.x > 0:
#			anim_name = "right"
#		else:
#			anim_name = "left"
	else:
		animation_tree["parameters/SandAttack/blend_position"] = Vector2(0, direction.y / abs(direction.y))
#		if direction.y > 0:
#			anim_name = "down"
#		else:
#			anim_name = "up"
			
#	direction = animation_tree["parameters/SandAttack/blend_position"]
	
func handle_physics(delta):
	if attack_lengths[multi_attack] - timer.time_left < initial_movement_delays[multi_attack]:
		pass
	elif timer.time_left < end_lags[multi_attack]:
		var walk_direction = Vector2(
			Input.get_axis("left", "right"), Input.get_axis("up", "down")
		).normalized()
		character.velocity = character.velocity.move_toward((walk_direction * END_SPEED_COEFF) * character.RUN_SPEED , character.RUN_ACCEL * delta)
	else:
		character.velocity = direction * character.RUN_SPEED
	
#	else:
#		character.velocity = Vector2.ZERO
	
	character.move_and_slide()
	
func exit():
	animation_tree["parameters/Idle/blend_position"] = animation_tree["parameters/SandAttack/blend_position"]
	continuation_timer.start(MULTI_ATTCK_TIMING)
	multi_attack += 1
	
	if multi_attack == num_attacks:
		multi_attack = 0
		cooldown_timer.start(COOLDOWN)

func _on_continuation_timer_timeout():
	multi_attack = 0

func _on_cooldown_timer_timeout():
	cooldown_timer.stop()

func _on_instance_timer_timeout():
	animation_tree["parameters/playback"].travel("SandAttack")
	
	var instance = sand_attack_scene.instantiate()
	instance.start(character.position + Vector2(0, -12), direction, multi_attack)
	character.get_parent().add_child(instance)
	Global.camera.shake(0.1, 2)
	
	instance_timer.stop()
