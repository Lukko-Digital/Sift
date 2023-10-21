extends Node

signal set_world_var(key, val)
signal increment_world_var(key, val)

var world_vars = {
	"A" = 0,
	"B" = 2
}

func _ready():
	self.set_world_var.connect(_set_world_var)
	self.increment_world_var.connect(_increment_world_var)
#
	var e = Expression.new()
	e.parse("""emit_signal("set_world_var","A",10)""")
	e.execute([], self)
	
	var f = Expression.new()
	f.parse("""emit_signal("increment_world_var","B",3)""")
	f.execute([], self)

func _set_world_var(key, val):
	world_vars[key] = val

func _increment_world_var(key, val):
	world_vars[key] += val
