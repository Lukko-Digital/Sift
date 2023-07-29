extends StateMachine

@onready var aggro_radius: Area2D = get_node("../AggroRadius")
@onready var tracking_radius: Area2D = get_node("../TrackingRadius")
@onready var attack_radius: Area2D = get_node("../AttackRadius")
@onready var attack_timer: Timer = $Attack/AttackTimer

func _ready():
	super._ready()
	attack_timer.connect("timeout", _on_attack_finished)

func _physics_process(delta: float) -> void:
	if (
		not attack_radius.get_overlapping_bodies().is_empty() or 
		not attack_timer.is_stopped()
	):
		transition_to("Attack")
	elif (
		not aggro_radius.get_overlapping_bodies().is_empty() or (
			state.name in ["Track", "Attack"] and
			not tracking_radius.get_overlapping_bodies().is_empty()
		)
	):
		transition_to("Track")
	else:
		transition_to("Idle")

	state.handle_physics(delta)	

func _on_attack_finished():
	transition_to("Idle")
