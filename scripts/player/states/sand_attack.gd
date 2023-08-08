class_name SandAttack
extends State

@onready var timer: Timer = get_node("../Timer")
@onready var sand_attack_scene = preload("res://scenes/sand_attack.tscn")

const START_LAG = 0.05
const END_LAG = 0.2

var time = 0.35
var direction: Vector2

func enter():
	timer.start(time)
	
	animation_tree["parameters/playback"].travel("SandAttack")
	
	direction = (get_global_mouse_position() - character.global_position).normalized()
	var anim_name: String
	
	if abs(direction.x) > abs(direction.y):
		animation_tree["parameters/SandAttack/blend_position"] = Vector2(direction.x / abs(direction.x), 0)
		if direction.x > 0:
			anim_name = "right"
		else:
			anim_name = "left"
	else:
		animation_tree["parameters/SandAttack/blend_position"] = Vector2(0, direction.y / abs(direction.y))
		if direction.y > 0:
			anim_name = "down"
		else:
			anim_name = "up"
			
	direction = animation_tree["parameters/SandAttack/blend_position"]
	
	var instance = sand_attack_scene.instantiate()
	instance.start(global_position + Vector2(0, -12) - direction * 20, anim_name)
	get_tree().root.add_child(instance)
	Global.camera.shake(0.1, 1)
	
func handle_physics(delta):
	if time - timer.time_left > START_LAG and timer.time_left > END_LAG:
		character.velocity = -animation_tree["parameters/SandAttack/blend_position"] * character.RUN_SPEED
	elif timer.time_left < END_LAG - 0.05:
		var direction = Vector2(
			Input.get_axis("left", "right"), Input.get_axis("up", "down")
		).normalized()
		character.velocity = character.velocity.move_toward(direction*character.RUN_SPEED * 0.5, character.RUN_ACCEL*delta)
#	else:
#		character.velocity = Vector2.ZERO
	
	character.move_and_slide()
	
func exit():
	animation_tree["parameters/Idle/blend_position"] = animation_tree["parameters/SandAttack/blend_position"]
