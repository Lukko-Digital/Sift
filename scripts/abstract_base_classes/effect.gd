class_name Effect

enum EffectNames {
	KNOCKED_BACK,
	KNOCKED_UP
}

var name: EffectNames
var value: float

func _init(name: EffectNames, value: float = 0):
	self.name = name
	self.value = value
