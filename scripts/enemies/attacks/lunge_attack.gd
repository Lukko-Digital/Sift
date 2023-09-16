extends State

const LUNGE_SPEED = 200

@onready var attack_radius: Area2D = $AttackRadius
var vec_to_player: Vector2

func _ready():
	pass

func enter():
	vec_to_player = get_direction_to_player()
	
func handle_physics(delta: float):
	character.velocity = vec_to_player * LUNGE_SPEED
	character.move_and_slide()

func exit():
	pass

func get_direction_to_player():
	for body in attack_radius.get_overlapping_bodies():
		if body.name == "player":
			return (body.global_position - character.global_position).normalized()
	return Vector2.ZERO
