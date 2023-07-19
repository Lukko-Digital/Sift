extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.alert_dialogue.connect(_on_alert_dialogue)
	Events.idle_dialogue.connect(_on_idle_dialogue)
	Events.enter_dialogue.connect(_on_enter_dialogue)
	Events.advance_dialogue.connect(_on_advance_dialogue)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_alert_dialogue():
	pass

func _on_idle_dialogue():
	pass

func _on_enter_dialogue(npc_node):
	pass

func _on_advance_dialogue():
	pass
