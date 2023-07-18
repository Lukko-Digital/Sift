extends ModeState

const DASH_SPEED = 180
const START_LAG = 0.15
const END_LAG = 0.15

func enter():
	time = 1.5
	animation_tree["parameters/playback"].travel("SandDash")
	character.velocity = character.velocity.normalized() / 1000
	
	if abs(character.velocity.x) > abs(character.velocity.y):
		animation_tree["parameters/SandDash/blend_position"] = Vector2(character.velocity.x / abs(character.velocity.x), 0)
	else:
		animation_tree["parameters/SandDash/blend_position"] = Vector2(0, character.velocity.y / abs(character.velocity.y))

func handle_physics(delta):
	if parent_state.dash_timer.time_left < time - START_LAG:
		print(1)
		character.velocity = character.velocity.normalized() * DASH_SPEED
	if parent_state.dash_timer.time_left < END_LAG:
		var direction = Vector2(
			Input.get_axis("left", "right"), Input.get_axis("up", "down")
		).normalized()
		character.velocity = direction * 60
	character.move_and_slide()
