extends StateMachine

@onready var dash_timer: Timer = $WaterDash/DashTimer
@onready var sand_attack_timer: Timer = $SandAttack/Timer
@onready var sand_attack_cooldown_timer: Timer = $SandAttack/CooldownTimer

@onready var player: Player = get_parent()
@onready var health_component: HealthComponent = get_node("../HealthComponent")

var in_dialogue: bool = false
var buffer_dash: bool = false
var buffer_attack: bool = false

func _ready():
	transition_to("Idle")
	Events.idle_dialogue.connect(exit_dialogue)
	Events.dialogue_complete.connect(exit_dialogue)
	health_component.damage_taken.connect(_on_damage_taken)

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
	elif in_dialogue:
		transition_to("Idle")
	elif Input.is_action_just_pressed("dash") and player.on_water:# and not in_dialogue:
		if dash_timer.time_left < 0.15 and state.name == "WaterDash":
			buffer_dash = true
		transition_to("WaterDash")
#	elif (Input.is_action_just_pressed("attack") and player.mode == "Sand" and state.name == "Dash" and dash_timer.time_left < 0.3 and sand_attack_cooldown_timer.is_stopped()):
#		if sand_attack_timer.time_left < 0.15 and state == get_node("SandAttack"):
#			buffer_attack = true
#		transition_to("SandAttack")
	elif ((state.name == "WaterDash" and not dash_timer.is_stopped()) or (buffer_dash and not state.name == "WaterDash")):
		if dash_timer.time_left > 0.15:
			buffer_dash = false
		transition_to("WaterDash")
	elif (Input.is_action_just_pressed("attack") and player.on_sand and sand_attack_cooldown_timer.is_stopped()):
		if sand_attack_timer.time_left < 0.15 and state == get_node("SandAttack"):
			buffer_attack = true
		transition_to("SandAttack")
	elif ((state == get_node("SandAttack") and not sand_attack_timer.is_stopped()) or (buffer_attack and not state == get_node("SandAttack"))) and sand_attack_cooldown_timer.is_stopped():
		if sand_attack_timer.time_left > 0.15:
			buffer_attack = false
		transition_to("SandAttack")
	elif (
		(
			Input.is_action_pressed("up") or
			Input.is_action_pressed("down") or
			Input.is_action_pressed("left") or
			Input.is_action_pressed("right")
		)
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
	if attack.effects:
		transition_to("Hit", attack.effects)

func _on_hit_return_to_idle():
	transition_to("Idle")
