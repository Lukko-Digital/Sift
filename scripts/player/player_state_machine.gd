extends StateMachine

@onready var dash_timer: Timer = $Dash/DashTimer

signal enter_dialogue(npc_node)
signal advance_dialogue

var in_dialogue = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		print('a')
		if not in_dialogue:
			for area in get_parent().get_node("NPCDialogueCollider").get_overlapping_area():
				if area.is_in_group("npc"):
					emit_signal("enter_dialogue", area)
					print(area.name)
		else:
			emit_signal("advance_dialogue")
	elif Input.is_action_just_pressed("dash") or not dash_timer.is_stopped():
		transition_to("Dash")
	elif (
		Input.is_action_pressed("up") or
		Input.is_action_pressed("down") or
		Input.is_action_pressed("left") or
		Input.is_action_pressed("right")
	):
		transition_to("Run")
	else:
		transition_to("Idle")
		
	state.handle_physics(delta)
