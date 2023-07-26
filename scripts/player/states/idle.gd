class_name Idle
extends State

const DECEL = 1000.0

func enter():
	animation_tree["parameters/playback"].travel("Idle")

func handle_physics(delta: float):
	character.velocity = character.velocity.move_toward(Vector2.ZERO, DECEL*delta)
	character.move_and_slide()
