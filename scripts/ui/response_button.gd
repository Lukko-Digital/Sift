class_name ResponseButton
extends Button

const UNPRESSABLE_DURATION = 1

signal response_pressed(destination_branch)

@onready var spawn_timer: Timer = $SpawnTimer

var destination_branch: String

func _ready():
	spawn_timer.start(UNPRESSABLE_DURATION)
	await spawn_timer.timeout
	self.disabled = false

func _pressed():
	emit_signal("response_pressed", destination_branch)
