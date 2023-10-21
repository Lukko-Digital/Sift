extends Node

var world_vars = {
	"A" = 0,
	"B" = 2
}

func _ready():
	Events.set_world_var.connect(_set_world_var)
	Events.increment_world_var.connect(_increment_world_var)

func _set_world_var(key, val):
	world_vars[key] = val

func _increment_world_var(key, val):
	world_vars[key] += val
