extends StateMachine

@onready var aggro_raidus: Area2D = get_parent().get_node("AggroRadius")
@onready var attack_raidus: Area2D = get_parent().get_node("AttackRadius")

func _physics_process(delta: float) -> void:
	if not attack_raidus.get_overlapping_bodies().is_empty():
		transition_to("Attack")
	elif not aggro_raidus.get_overlapping_bodies().is_empty():
		transition_to("Track")
	else:
		transition_to("Idle")
