extends ModeState

@onready var dash_speed: float = character.RUN_SPEED * 1.2
@onready var dash_end_speed: float = character.RUN_SPEED

const DASH_SIDE_ACCEL = 120
const START_LAG = 0.15
const END_LAG = 0.2
const END_FRAMES = 0.5

var stopped: bool = false

var dig_direction: int

func enter():
	stopped = false
	time = 1.5
	animation_tree["parameters/playback"].travel("SandDash")
	
	if abs(character.velocity.x) > abs(character.velocity.y):
		animation_tree["parameters/SandDash/blend_position"] = Vector2(character.velocity.x / abs(character.velocity.x), 0)
		if character.velocity.x > 0:
			dig_direction = 3
		else:
			dig_direction = 0
	else:
		animation_tree["parameters/SandDash/blend_position"] = Vector2(0, character.velocity.y / abs(character.velocity.y) + 0.1)
		if character.velocity.y > 0:
			dig_direction = 1
		else:
			dig_direction = 2

func handle_physics(delta):
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	
	if parent_state.dash_timer.time_left < time - START_LAG and not stopped:
		character.velocity = character.velocity.normalized() * dash_speed
		
		if Input.is_action_just_pressed("dash") and parent_state.dash_timer.time_left > END_FRAMES:
			animation_tree["parameters/SandDash/" + str(dig_direction) + "/playback"].travel("end")
			parent_state.dash_timer.start(END_FRAMES)
		elif abs(parent_state.dash_timer.time_left - END_FRAMES) <= 0.01:
			animation_tree["parameters/SandDash/" + str(dig_direction) + "/playback"].travel("end")
		
		character.velocity = character.velocity.move_toward(direction * character.RUN_SPEED, DASH_SIDE_ACCEL*delta)
	
	if parent_state.dash_timer.time_left <= END_LAG and not stopped:
		character.velocity = character.velocity.normalized() * dash_end_speed
		character.velocity = character.velocity.move_toward(direction * dash_end_speed, character.RUN_ACCEL*delta)
	
	character.move_and_slide()


func _on_player_mode_switch(_mode):
	if _mode == "Water" and not parent_state.dash_timer.is_stopped():
		stopped = true
		character.velocity = character.velocity.normalized() * dash_end_speed / 10
		animation_tree["parameters/SandDash/" + str(dig_direction) + "/playback"].travel("end")
		parent_state.dash_timer.start(END_FRAMES)
