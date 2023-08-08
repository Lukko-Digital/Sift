extends StateMachine

func _ready():
	state.enter()
	Events.alert_dialogue.connect(_on_alert_dialogue)
	Events.idle_dialogue.connect(_on_idle_dialogue)
	Events.enter_dialogue.connect(_on_enter_dialogue)

func _on_alert_dialogue():
	transition_to("Alert")

func _on_idle_dialogue():
	transition_to("Idle")

func _on_enter_dialogue(npc_node):
	transition_to("Dialogue", npc_node)
