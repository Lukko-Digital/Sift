extends StateMachine

@onready var dash_timer: Timer = $Dash/DashTimer

var in_dialogue: bool = false
var buffer_dash: bool = false

func _ready():
	transition_to("Idle")
	Events.idle_dialogue.connect(_on_exit_dialogue)
	Events.dialogue_complete.connect(_on_exit_dialogue)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("escape") and in_dialogue:
		Events.emit_signal("idle_dialogue")
		
	if Input.is_action_just_pressed("interact"):
		if not in_dialogue:
			for area in get_parent().get_node("NPCDialogueCollider").get_overlapping_areas():
				if area.is_in_group("npc"):
					Events.emit_signal("enter_dialogue", area)
					in_dialogue = true
		else:
			Events.emit_signal("advance_dialogue")
	elif Input.is_action_just_pressed("dash"):# and not in_dialogue:
		if dash_timer.time_left < 0.15:
			buffer_dash = true
		transition_to("Dash")
	elif not dash_timer.is_stopped() or (buffer_dash and not state == get_node("Dash")):
		if dash_timer.time_left > 0.15:
			buffer_dash = false
		transition_to("Dash")
	elif (
		(
			Input.is_action_pressed("up") or
			Input.is_action_pressed("down") or
			Input.is_action_pressed("left") or
			Input.is_action_pressed("right")
		) and
		not in_dialogue
	):
		var direction = Vector2(
			Input.get_axis("left", "right"), Input.get_axis("up", "down")
		)
		if direction.length() > 0.1:
			transition_to("Run")
		else:
			transition_to("Idle")
	else:
		transition_to("Idle")
		
	state.handle_physics(delta)

func _on_exit_dialogue():
	in_dialogue = false
