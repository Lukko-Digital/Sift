class_name Attack

var name: String
var damage: int
var effects: Array[Effect]

func _init(name: String, damage: int, effects: Array[Effect] = []):
	self.name = name
	self.damage = damage
	self.effects = effects
