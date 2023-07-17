extends State

@onready var dash_timer: Timer = $DashTimer

const DASH_TIME: float = 0.1
const DASH_DIST: float = 200

func enter():
	dash_timer.start(DASH_TIME)
	character.velocity = character.velocity.normalized() * DASH_DIST / DASH_TIME
	
func exit():
	character.velocity = Vector2.ZERO

func handle_physics(delta):
	character.move_and_slide()

func _on_dash_timer_timeout():
	dash_timer.stop()
