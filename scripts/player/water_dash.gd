extends ModeState

@onready var dash_speed: float = character.RUN_SPEED * 2.5
@onready var dash_end_decel: float = character.RUN_ACCEL / 2

@export var particles: GPUParticles2D
@export var shore_checker: RayCast2D

var stopping: bool = false

#var dig_direction: int

func enter():
	character.sprite.offset.y = 0
	time = 0.6
	stopping = false
	
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	if direction.is_zero_approx():
		direction = animation_tree["parameters/Idle/blend_position"]
		
	character.velocity = direction.normalized() * dash_speed
	print(character.velocity)
	
	animation_tree["parameters/playback"].travel("WaterDash")
	
	if abs(character.velocity.x) > abs(character.velocity.y):
		animation_tree["parameters/WaterDash/Jump/blend_position"] = Vector2(character.velocity.x / abs(character.velocity.x), 0)
	else:
		animation_tree["parameters/WaterDash/Jump/blend_position"] = Vector2(0, character.velocity.y / abs(character.velocity.y) + 0.1)


func handle_physics(delta):
	shore_checker.target_position = character.velocity.normalized() * 10
	
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	
	if abs(character.velocity.x) > abs(character.velocity.y):
		animation_tree["parameters/WaterDash/Loop/blend_position"] = Vector2(character.velocity.x / abs(character.velocity.x), 0)
	else:
		animation_tree["parameters/WaterDash/Loop/blend_position"] = Vector2(0, character.velocity.y / abs(character.velocity.y) + 0.1)
	
	if character.velocity.length() < character.RUN_SPEED and parent_state.dash_timer.time_left <= 0.6:
		end_animation()
	
	if Input.is_action_just_pressed("dash") and parent_state.dash_timer.time_left <= 0.5:
		character.velocity = direction*dash_speed
		animation_tree["parameters/WaterDash/playback"].start("Jump")
		if abs(character.velocity.x) > abs(character.velocity.y):
			animation_tree["parameters/WaterDash/Jump/blend_position"] = Vector2(character.velocity.x / abs(character.velocity.x), 0)
		else:
			animation_tree["parameters/WaterDash/Jump/blend_position"] = Vector2(0, character.velocity.y / abs(character.velocity.y) + 0.1)
	
	if shore_checker.is_colliding():
		character.velocity = character.velocity.normalized() * character.RUN_SPEED / 1.5
		end_animation()
		parent_state.dash_timer.start(0.6)
		parent_state.dash_timer.stop()
	
	if stopping:
		character.velocity = character.velocity.move_toward(direction*character.RUN_SPEED, character.RUN_ACCEL*delta)
	elif parent_state.dash_timer.time_left < 0.5:
		parent_state.dash_timer.start(0.5)
		character.velocity = character.velocity.move_toward(direction*dash_speed, dash_end_decel*delta)
	
	character.move_and_slide()

func end_animation():
	stopping = true
	animation_tree["parameters/WaterDash/playback"].start("Trip")
	if abs(character.velocity.x) > abs(character.velocity.y):
		animation_tree["parameters/WaterDash/Trip/blend_position"] = Vector2(character.velocity.x / abs(character.velocity.x), 0)
	else:
		animation_tree["parameters/WaterDash/Trip/blend_position"] = Vector2(0, character.velocity.y / abs(character.velocity.y) + 0.1)
