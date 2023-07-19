extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	Events.alert_dialogue.connect(_on_alert_dialogue())
#	Events.idle_dialogue.connect(_on_idle_dialogue())
#	Events.connect("alert_dialogue", _on_alert_dialogue())
#	Events.connect("idle_dialogue", _on_idle_dialogue())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_alert_dialogue():
	print('alert')

func _on_idle_dialogue():
	print('idle')
