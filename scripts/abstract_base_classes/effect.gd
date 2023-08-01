class_name Effect

enum EffectName {
	KNOCKED_BACK,
	KNOCKED_UP
}

var name: EffectName
var value: float

func _init(name: EffectName, value: float = 0):
	self.name = name
	self.value = value
