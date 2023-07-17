extends CharacterBody2D


const RUN_SPEED = 300.0
const RUN_ACCEL = 2000.0


func _physics_process(delta):
	handle_movement(delta)

func handle_movement(delta):
	handle_run(delta)
	move_and_slide()
	
func handle_run(delta):
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	velocity = velocity.move_toward(direction*RUN_SPEED, RUN_ACCEL*delta)
