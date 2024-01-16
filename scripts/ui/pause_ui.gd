extends CanvasLayer

var paused = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		paused = not paused
	
	if paused:
		self.visible = true
		get_tree().paused = true
	else:
		self.visible = false
		get_tree().paused = false
