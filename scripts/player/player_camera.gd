extends Camera2D

var shake_amount: float
var default_offset: Vector2 = offset

@onready var shake_timer: Timer = $ShakeTimer

signal shaking(time: float, amount: float)

func _ready():
	shake_timer.timeout.connect(_on_timer_timeout)
	set_process(true)
	Global.camera = self
	randomize()

func _process(delta):
	offset = Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)

func shake(time: float, amount: float):
	shake_amount = amount
	set_process(true)
	shake_timer.start(time)
	shaking.emit(time, amount)

func _on_timer_timeout():
	set_process(false)
	offset = default_offset
