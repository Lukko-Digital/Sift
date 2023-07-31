class_name Attack

var name: String
var damage: int
var effect: String

func _init(name: String, damage: int, effect: String = ""):
	self.name = name
	self.damage = damage
	self.effect = effect
