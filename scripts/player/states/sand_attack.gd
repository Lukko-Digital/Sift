class_name SandAttack
extends State

@onready var timer: Timer = get_node("../Timer")
@onready var sand_attack_scene = preload("res://scenes/sand_attack.tscn")

const START_LAG = 0.1

var time = 0.4
var direction: Vector2

func enter():
	timer.start(time)
	
	animation_tree["parameters/playback"].travel("SandAttack")
	
	direction = get_global_mouse_position() - character.global_position
	
	if abs(direction.x) > abs(direction.y):
		animation_tree["parameters/SandAttack/blend_position"] = Vector2(direction.x / abs(direction.x), 0)
	else:
		animation_tree["parameters/SandAttack/blend_position"] = Vector2(0, direction.y / abs(direction.y))
	
	var instance = sand_attack_scene.instantiate()
	add_child(instance)
	
func handle_physics(delta):
	if time - timer.time_left > START_LAG:
		print(1)
		character.velocity = direction.normalized() * character.RUN_SPEED / 2
	
	character.move_and_slide()
