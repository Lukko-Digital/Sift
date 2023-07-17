extends State

const RUN_SPEED = 300.0
const RUN_ACCEL = 2000.0

func handle_physics(delta: float):
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	root.velocity = root.velocity.move_toward(direction*RUN_SPEED, RUN_ACCEL*delta)
	root.move_and_slide()
