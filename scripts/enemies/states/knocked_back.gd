class_name KnockedBack
extends State

var effect: KnockedBackEffect

@onready var knockback_timer = $KnockBackTimer

func recieve_args(effect):
	self.effect = effect

func enter():
	knockback_timer.start(effect.duration)

func handle_physics(delta: float):
	character.velocity = effect.speed * effect.direction.normalized()
	character.move_and_slide()
