extends CharacterBody2D

@onready var mode: String = "Sand"

func _on_mode_checker_body_entered(body):
	mode = "Sand" 

func _on_mode_checker_body_exited(body):
	mode = "Water" 


func _on_npc_dialogue_collider_area_entered(area):
	if area.is_in_group("npc"):
		Events.emit_signal("alert_dialogue")


func _on_npc_dialogue_collider_area_exited(area):
	if area.is_in_group("npc"):
		Events.emit_signal("idle_dialogue")
