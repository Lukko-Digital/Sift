extends ModeState

@onready var dash_speed: float = character.RUN_SPEED * 2.5
@onready var dash_end_decel: float = character.RUN_ACCEL / 2

@export var shore_checker: RayCast2D

var stopping: bool = false

#var dig_direction: int

func enter():
	time = 0.3
	stopping = false
	
	character.velocity = character.velocity.normalized() * dash_speed
	
	if character.velocity.is_zero_approx():
		character.velocity = animation_tree["parameters/Walk/blend_position"]
#	animation_tree["parameters/playback"].travel("WaterDash")

#	if abs(character.velocity.x) > abs(character.velocity.y):
#		animation_tree["parameters/WaterDash/blend_position"] = Vector2(character.velocity.x / abs(character.velocity.x), 0)
#		if character.velocity.x > 0:
#			dig_direction = 3
#		else:
#			dig_direction = 0
#	else:
#		animation_tree["parameters/WaterDash/blend_position"] = Vector2(0, character.velocity.y / abs(character.velocity.y) + 0.1)
#		if character.velocity.y > 0:
#			dig_direction = 1
#		else:
#			dig_direction- = 2

func handle_physics(delta):
	shore_checker.target_position = character.velocity.normalized() * 10
	
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	
	if abs(direction.x) > abs(direction.y):
		animation_tree["parameters/Walk/blend_position"] = Vector2(direction.x / abs(direction.x), 0)
	else:
		animation_tree["parameters/Walk/blend_position"] = Vector2(0, direction.y / abs(direction.y))
	
	if character.velocity.length() < character.RUN_SPEED and parent_state.dash_timer.time_left <= 0.2:
		stopping = true
	
	if Input.is_action_just_pressed("dash") and parent_state.dash_timer.time_left <= 0.2:
		character.velocity = direction*dash_speed
	
	if shore_checker.is_colliding():
		character.velocity = character.velocity.normalized() * character.RUN_SPEED / 1.5
		stopping = true
		parent_state.dash_timer.start(0.3)
		parent_state.dash_timer.stop()
	
	if stopping:
		character.velocity = character.velocity.move_toward(direction*character.RUN_SPEED, character.RUN_ACCEL*delta)
	elif parent_state.dash_timer.time_left < 0.2:
		parent_state.dash_timer.start(0.2)
		character.velocity = character.velocity.move_toward(direction*dash_speed, dash_end_decel*delta)
	
	character.move_and_slide()
