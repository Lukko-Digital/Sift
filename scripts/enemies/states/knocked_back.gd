class_name KnockedBack
extends State

var duration: float
var direction: Vector2

@onready var knockback_timer = $KnockBackTimer

func recieve_args(effect):
	self.duration = effect.duration
	self.direction = effect.direction

func enter():
	knockback_timer.start(duration)

func handle_physics(delta: float):
	character.velocity = KnockedBackEffect.KNOCK_BACK_SPEED * direction.normalized()
	character.move_and_slide()
