class_name HealthComponent
extends Node

@export var max_health: float
var current_health: float

signal died

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health

func damage(attack: Attack):
	current_health -= attack.damage
	
	if current_health <= 0:
		emit_signal("died")
