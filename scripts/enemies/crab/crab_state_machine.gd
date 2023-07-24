extends StateMachine

@onready var aggro_radius: Area2D = get_node("../AggroRadius")
@onready var tracking_radius: Area2D = get_node("../TrackingRadius")
@onready var attack_radius: Area2D = get_node("../AttackRadius")
@onready var attack_timer: Timer = $Attack/AttackTimer

func _physics_process(delta: float) -> void:
	if (
		not attack_radius.get_overlapping_bodies().is_empty() or 
		not attack_timer.is_stopped()
	):
		transition_to("Attack")
	elif not aggro_radius.get_overlapping_bodies().is_empty() or (
		state.name == "Track" and not tracking_radius.get_overlapping_bodies().is_empty()
	):
		transition_to("Track")
	else:
		transition_to("Idle")

	state.handle_physics(delta)	
