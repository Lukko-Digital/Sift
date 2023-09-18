extends ModeState

@onready var dash_speed: float = character.RUN_SPEED * 2.5
@onready var dash_end_decel: float = character.RUN_ACCEL / 2

@export var particles: GPUParticles2D
@export var shore_checker: RayCast2D

@export var water_mask: Sprite2D

var stopping: bool = false

#var dig_direction: int

func enter():
	var tween = get_tree().create_tween()
	tween.tween_property(character.sprite, "offset", Vector2.ZERO, 0.25)
	
	water_mask.offset.y = -50
	
	time = 0.6
	stopping = false
	
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	if direction.is_zero_approx():
		direction = animation_tree["parameters/Idle/blend_position"]
		
	character.velocity = direction.normalized() * dash_speed
	
	animation_tree["parameters/playback"].travel("WaterDash")
	
	if abs(character.velocity.x) > abs(character.velocity.y):
		animation_tree["parameters/WaterDash/Jump/blend_position"] = Vector2(character.velocity.x / abs(character.velocity.x), 0)
	else:
		animation_tree["parameters/WaterDash/Jump/blend_position"] = Vector2(0, character.velocity.y / abs(character.velocity.y))
	
	

func handle_physics(delta):
	#Set direction of the raycast that checks for running into the shore
	shore_checker.target_position = character.velocity.normalized() * 10
	
	#Get player input
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	
	#Set blend position for loop animation based on direction
	if abs(character.velocity.x) > abs(character.velocity.y):
		animation_tree["parameters/WaterDash/Loop/blend_position"] = Vector2(character.velocity.x / abs(character.velocity.x), 0)
	else:
		animation_tree["parameters/WaterDash/Loop/blend_position"] = Vector2(0, character.velocity.y / abs(character.velocity.y))
	
	#Move to end state if speed slows
	if character.velocity.length() < character.RUN_SPEED * 1.2 and parent_state.dash_timer.time_left <= 0.6:
		end_animation()
	
	#Rejump if player presses dash
	if Input.is_action_just_pressed("dash") and parent_state.dash_timer.time_left <= 0.5 and not character.mode == "Sand" and not animation_tree["parameters/WaterDash/playback"].get_current_node() == "Jump":
		character.velocity = direction*dash_speed
		animation_tree["parameters/WaterDash/playback"].start("Jump")
		if abs(character.velocity.x) > abs(character.velocity.y):
			animation_tree["parameters/WaterDash/Jump/blend_position"] = Vector2(character.velocity.x / abs(character.velocity.x), 0)
		else:
			animation_tree["parameters/WaterDash/Jump/blend_position"] = Vector2(0, character.velocity.y / abs(character.velocity.y))
	
	#Move to end state if on sand, running into the shore, or drowning
	if (shore_checker.is_colliding() or character.mode == "Sand" or character.check_drown()) and not animation_tree["parameters/WaterDash/playback"].get_current_node() == "Jump":
		end_animation()
	
	#If in end state decelerate and check drowning
	if stopping:
		var speed = min(character.RUN_SPEED, character.velocity.length()) if direction.is_zero_approx() else character.RUN_SPEED
		character.velocity = character.velocity.move_toward(direction.normalized() * speed, character.RUN_ACCEL*delta)
		character.drown()
	#Otherwise restart loop timer and set dash speed
	elif parent_state.dash_timer.time_left < 0.5:
		parent_state.dash_timer.start(0.5)
		character.velocity = character.velocity.move_toward(direction*dash_speed, dash_end_decel*delta)
	
	character.move_and_slide()

func end_animation():
	stopping = true
	
	#If not drowning sink back into water
	if not character.check_drown():
		var tween = get_tree().create_tween()
		var depth = character.sink_in_water()
		
		character.sprite.offset.y = 0
		tween.tween_property(character.sprite, "offset", Vector2(0, depth), 0.25)
	#Otherwise reset water mask so drowning looks good
	else:
		water_mask.offset.y = -60
	
	#Play end animation and set blend position
	animation_tree["parameters/WaterDash/playback"].travel("Trip")
	if not character.velocity.is_zero_approx():
		if abs(character.velocity.x) > abs(character.velocity.y):
			animation_tree["parameters/WaterDash/Trip/blend_position"] = Vector2(character.velocity.x / abs(character.velocity.x), 0)
		else:
			animation_tree["parameters/WaterDash/Trip/blend_position"] = Vector2(0, character.velocity.y / abs(character.velocity.y))
			
		animation_tree["parameters/Idle/blend_position"] = animation_tree["parameters/WaterDash/Trip/blend_position"]

func exit():
	#Reset water mask
	water_mask.offset.y = -60
