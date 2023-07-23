extends StateMachine

@onready var aggro_raidus: Area2D = get_node("../AggroRadius")
@onready var tracking_radius: Area2D = get_node("../TrackingRadius")
@onready var attack_raidus: Area2D = get_node("../AttackRadius")

func _physics_process(delta: float) -> void:
	if not attack_raidus.get_overlapping_bodies().is_empty():
		transition_to("Attack")
	elif not aggro_raidus.get_overlapping_bodies().is_empty() or (
		state.name == "Track" and not tracking_radius.get_overlapping_bodies().is_empty()
	):
		transition_to("Track")
	else:
		transition_to("Idle")

	state.handle_physics(delta)	
