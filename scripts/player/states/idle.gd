class_name Idle
extends State

const DECEL = 1000.0

func enter():
	animation_tree["parameters/playback"].travel("Idle")
	if abs(character.velocity.x) > abs(character.velocity.y):
		animation_tree["parameters/Idle/blend_position"] = Vector2(character.velocity.x / abs(character.velocity.x), 0)
	else:
		animation_tree["parameters/Idle/blend_position"] = Vector2(0, character.velocity.y / abs(character.velocity.y))

func handle_physics(delta: float):
	character.velocity = character.velocity.move_toward(Vector2.ZERO, DECEL*delta)
	character.move_and_slide()
