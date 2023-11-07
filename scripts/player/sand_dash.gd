extends ModeState

@onready var dash_speed: float = character.RUN_SPEED * 4
@onready var dash_end_speed: float = character.RUN_SPEED

@export var shore_checker: RayCast2D

const DASH_SIDE_ACCEL = 500
const START_LAG = 0.15
const START_FRAMES = 0.25
const END_FRAMES = 0.1

var dig_direction: int
var stopped: bool = false
var buffer_stop: bool = false
var dash_velocity: Vector2

var popup_attack: Attack = Attack.new("Pop Up Attack", 1, [KnockedUpEffect.new(0.5)])

func enter():
	stopped = false
	buffer_stop = false
	
	time = 0.5
	
	dash_velocity = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	
	animation_tree["parameters/playback"].travel("SandDash")
	if dash_velocity.is_zero_approx():
		dash_velocity = animation_tree["parameters/Walk/blend_position"]
	
	if abs(dash_velocity.x) > abs(dash_velocity.y):
		animation_tree["parameters/SandDash/blend_position"] = Vector2(dash_velocity.x / abs(dash_velocity.x), 0)
		if character.velocity.x > 0:
			dig_direction = 3
		else:
			dig_direction = 0
	else:
		animation_tree["parameters/SandDash/blend_position"] = Vector2(0, dash_velocity.y / abs(dash_velocity.y) + 0.1)
		if dash_velocity.y > 0:
			dig_direction = 1
		else:
			dig_direction = 2
			
	dash_velocity = dash_velocity.normalized() * dash_speed

func handle_physics(delta):
	shore_checker.target_position = dash_velocity.normalized() * 30
	
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	
	#Recast dash
	if (Input.is_action_just_pressed("dash") or buffer_stop) and parent_state.dash_timer.time_left > END_FRAMES:
		if parent_state.dash_timer.time_left < time - START_FRAMES:
			end_animation()
			parent_state.dash_timer.start(END_FRAMES)
			
		elif parent_state.dash_timer.time_left < time - START_LAG:
			buffer_stop = true
	
	#Entering shore
	elif shore_checker.is_colliding() and parent_state.dash_timer.time_left > END_FRAMES:
#		dash_velocity = (shore_checker.get_collision_point() - shore_checker.global_position) * 2.5
		
		stopped = true
		end_animation()
		parent_state.dash_timer.start(END_FRAMES)
	
	#Entering end frames
	elif abs(parent_state.dash_timer.time_left - END_FRAMES) <= 0.01:
		end_animation()
	
	#End of start frames
	elif abs(time - START_FRAMES - parent_state.dash_timer.time_left) <= 0.01:
		animation_tree["parameters/SandDash/" + str(dig_direction) + "/playback"].travel("dig")
	
	
	if parent_state.dash_timer.time_left <= END_FRAMES:# and not stopped:
		dash_velocity = direction.normalized() * character.RUN_SPEED * 1.5
		
	elif parent_state.dash_timer.time_left < time:# and not stopped:
		dash_velocity = dash_velocity.move_toward(direction * dash_speed, DASH_SIDE_ACCEL*delta)
	
	
	
	character.velocity = dash_velocity
	
	character.move_and_slide()

func end_animation():
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	
	if not direction.is_zero_approx():
		if abs(direction.x) > abs(direction.y):
			animation_tree["parameters/SandDash/blend_position"] = Vector2(direction.x / abs(direction.x), 0)
			if direction.x > 0:
				dig_direction = 3
			else:
				dig_direction = 0
		else:
			animation_tree["parameters/SandDash/blend_position"] = Vector2(0, direction.y / abs(direction.y))
			if direction.y > 0:
				dig_direction = 1
			else:
				dig_direction = 2
	
	animation_tree["parameters/SandDash/" + str(dig_direction) + "/playback"].start("dig")
	
#	animation_tree["parameters/SandDash/" + str(dig_direction) + "/playback"].travel("end")
	animation_tree["parameters/SandDash/" + str(dig_direction) + "/playback"].start("end")
	
	animation_tree["parameters/Idle/blend_position"] = animation_tree["parameters/SandDash/blend_position"]

func _on_pop_up_hitbox_area_entered(area):
	if area.is_in_group("enemy_hurtbox"):
		Global.camera.shake(0.1, 3)
		area.damage(popup_attack)

