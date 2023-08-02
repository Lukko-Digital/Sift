class_name Effect

enum EffectName {
	KNOCKED_BACK,
	KNOCKED_UP
}

var effect_name: EffectName
var value: float

func _init(effect_name: EffectName, value: float = 0):
	self.effect_name = effect_name
	self.value = value
