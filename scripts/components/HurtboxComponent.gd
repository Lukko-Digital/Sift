class_name HurtboxComponent
extends Area2D

@export var health_component: HealthComponent
signal damage_taken

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
		var effects = attack.effects if not attack.effects.is_empty() else null
		emit_signal("damage_taken", attack)
