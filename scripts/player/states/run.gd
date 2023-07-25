class_name Run
extends State

#TODO: bug that we are still it run state if both A and D or W and S are pressed so we arent moving

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
	
	character.velocity = character.velocity.move_toward(direction*character.RUN_SPEED, character.RUN_ACCEL*delta)
	character.move_and_slide()

func exit():
	animation_tree["parameters/Idle/blend_position"] = animation_tree["parameters/Walk/blend_position"]
