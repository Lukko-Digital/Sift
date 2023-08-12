extends StateMachine

@onready var timer: Timer = $Timer
@onready var player: Player = get_parent()
@onready var hurtbox_component: HurtboxComponent = get_node("../HurtboxComponent")

var in_dialogue: bool = false
var buffer_dash: bool = false
var buffer_attack: bool = false

func _ready():
	transition_to("Idle")
	Events.idle_dialogue.connect(exit_dialogue)
	Events.dialogue_complete.connect(exit_dialogue)
	hurtbox_component.damage_taken.connect(_on_damage_taken)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("escape") and in_dialogue:
		Events.emit_signal("alert_dialogue")
		exit_dialogue()
	
	if state.name == "Hit":
		transition_to("Hit")
	elif Input.is_action_just_pressed("interact"):
		if not in_dialogue:
			for area in get_parent().get_node("NPCDialogueCollider").get_overlapping_areas():
				if area.is_in_group("npc"):
					Events.emit_signal("enter_dialogue", area)
					in_dialogue = true
		else:
			Events.emit_signal("advance_dialogue")
	elif Input.is_action_just_pressed("dash"):# and not in_dialogue:
		if timer.time_left < 0.15 and state == get_node("Dash"):
			buffer_dash = true
		transition_to("Dash")
	elif (state == get_node("Dash") and not timer.is_stopped()) or (buffer_dash and not state == get_node("Dash")):
		if timer.time_left > 0.15:
			buffer_dash = false
		transition_to("Dash")
	elif (Input.is_action_just_pressed("attack") and player.mode == "Sand"):
		if timer.time_left < 0.15 and state == get_node("SandAttack"):
			buffer_attack = true
		transition_to("SandAttack")
	elif (state == get_node("SandAttack") and not timer.is_stopped()) or (buffer_attack and not state == get_node("SandAttack")):
		if timer.time_left > 0.15:
			buffer_attack = false
		transition_to("SandAttack")
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

func exit_dialogue():
	in_dialogue = false
	
func _on_damage_taken(attack: Attack):
	Global.camera.shake(0.1, 5)
	Events.emit_signal("player_damaged", attack.damage)
	transition_to("Hit", attack.effects)

func _on_hit_return_to_idle():
	transition_to("Idle")
