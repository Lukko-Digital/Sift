extends ModeState

@onready var dash_speed: float = character.RUN_SPEED * 3
@onready var dash_end_decel: float = character.RUN_ACCEL * 2/3

#const DASH_SIDE_ACCEL = 120
const START_LAG = 0
const END_LAG = 0.35
#const END_FRAMES = 0

@export var shore_checker: RayCast2D

#var dig_direction: int

func enter():
	time = 0.4
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
#			dig_direction = 2

func handle_physics(delta):
	shore_checker.target_position = character.velocity.normalized() * 10
	
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	
	if parent_state.dash_timer.time_left <= END_LAG:
		if abs(direction.x) > abs(direction.y):
			animation_tree["parameters/Walk/blend_position"] = Vector2(direction.x / abs(direction.x), 0)
		else:
			animation_tree["parameters/Walk/blend_position"] = Vector2(0, direction.y / abs(direction.y))
		
		character.velocity = character.velocity.move_toward(direction*character.RUN_SPEED, dash_end_decel*delta)
		
	elif parent_state.dash_timer.time_left < time - START_LAG:
		character.velocity = direction * dash_speed
	
	if shore_checker.is_colliding():
		character.velocity = character.velocity.normalized() * character.RUN_SPEED / 1.5
		parent_state.dash_timer.stop()
		
	character.move_and_slide()
