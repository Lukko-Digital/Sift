class_name KnockedBackEffect
extends Effect

const KNOCK_BACK_SPEED = 200

var duration: float
var direction: Vector2

func _init(duration: float, direction: Vector2):
	self.duration = duration
	self.direction = direction
	effect_name = Effect.EffectName.KNOCKED_BACK
