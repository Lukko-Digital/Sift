extends State

@onready var dash_speed: float = character.RUN_SPEED * 3
@onready var dash_end_speed: float = character.RUN_SPEED * 0.25

@onready var dash_timer: Timer = $DashTimer

var time = 0.5

var direction: Vector2

func enter():
	direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	if direction.is_zero_approx():
		direction = animation_tree["parameters/Idle/blend_position"]
		
	character.velocity = direction * character.RUN_SPEED
	
	animation_tree["parameters/playback"].travel("SandDash")
	
	if abs(character.velocity.x) > abs(character.velocity.y):
		animation_tree["parameters/SandDash/blend_position"] = Vector2(character.velocity.x / abs(character.velocity.x), 0)
	else:
		animation_tree["parameters/SandDash/blend_position"] = Vector2(0, character.velocity.y / abs(character.velocity.y))
	
	dash_timer.start(time)

func handle_physics(delta):
	if dash_timer.time_left < 0.3:
		character.velocity = character.velocity.move_toward(direction * dash_end_speed, 1500 * delta)
	elif dash_timer.time_left < 0.4:
		character.velocity = direction * dash_speed
	
	
	character.move_and_slide()

func _on_dash_timer_timeout():
	dash_timer.stop()
