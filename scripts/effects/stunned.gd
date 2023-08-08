class_name StunnedEffect
extends Effect

var duration: float

func _init(duration: float):
	self.duration = duration
	effect_name = Effect.EffectName.STUNNED
