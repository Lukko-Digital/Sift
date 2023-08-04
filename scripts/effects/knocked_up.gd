class_name KnockedUpEffect
extends Effect

var duration: float

func _init(duration: float):
	self.duration = duration
	effect_name = Effect.EffectName.KNOCKED_UP
