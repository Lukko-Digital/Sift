extends State

@onready var dash_speed: float = character.RUN_SPEED * 2.5
@onready var dash_end_decel: float = character.RUN_ACCEL / 2

@onready var dash_timer: Timer = $DashTimer

@export var particles: GPUParticles2D

@export var water_mask: Sprite2D

var stopping: bool = false
var time = 0.6

func enter():
	var tween = get_tree().create_tween()
	tween.tween_property(character.sprite, "offset", Vector2.ZERO, 0.25)
	
	water_mask.offset.y = -50
	
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
	
	dash_timer.start(time)
	
	particles.process_material.color = Color.WHITE;

func handle_physics(delta):
	
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
	if character.velocity.length() < character.RUN_SPEED * 1.2 and dash_timer.time_left <= 0.6:
		end_animation()
	
	#Rejump if player presses dash
	if Input.is_action_just_pressed("dash") and dash_timer.time_left <= 0.5 and character.on_water and not animation_tree["parameters/WaterDash/playback"].get_current_node() == "Jump":
		character.velocity = direction*dash_speed
		animation_tree["parameters/WaterDash/playback"].start("Jump")
		if abs(character.velocity.x) > abs(character.velocity.y):
			animation_tree["parameters/WaterDash/Jump/blend_position"] = Vector2(character.velocity.x / abs(character.velocity.x), 0)
		else:
			animation_tree["parameters/WaterDash/Jump/blend_position"] = Vector2(0, character.velocity.y / abs(character.velocity.y))
	
	#Move to end state if on sand, running into the shore, or drowning
	if (not character.on_water or character.check_drown()) and not animation_tree["parameters/WaterDash/playback"].get_current_node() == "Jump":
		end_animation()
	
	#If in end state decelerate and check drowning
	if stopping:
		var speed = min(character.RUN_SPEED, character.velocity.length()) if direction.is_zero_approx() else character.RUN_SPEED
		character.velocity = character.velocity.move_toward(direction.normalized() * speed, character.RUN_ACCEL*delta)
		character.drown()
	#Otherwise restart loop timer and set dash speed
	elif dash_timer.time_left < 0.5:
		dash_timer.start(0.5)
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
	
func _on_dash_timer_timeout():
	dash_timer.stop()
