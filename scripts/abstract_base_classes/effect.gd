class_name Effect

enum EffectName {
	KNOCKED_BACK,
	KNOCKED_UP,
	STUNNED
}

var effect_name: EffectName

func _init(effect_name: EffectName):
	self.effect_name = effect_name
