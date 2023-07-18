class_name Run
extends State

#TODO: bug that we are still it run state if both A and D or W and S are pressed so we arent moving

const RUN_SPEED = 150.0
const RUN_ACCEL = 1000.0

func enter():
	animation_tree["parameters/playback"].travel("Walk")

func handle_physics(delta: float):
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	
	if abs(direction.x) > abs(direction.y):
		animation_tree["parameters/Walk/blend_position"] = Vector2(direction.x / abs(direction.x), 0)
	else:
		animation_tree["parameters/Walk/blend_position"] = Vector2(0, direction.y / abs(direction.y))
	
	character.velocity = character.velocity.move_toward(direction*RUN_SPEED, RUN_ACCEL*delta)
	character.move_and_slide()
