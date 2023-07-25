extends CharacterBody2D

var mode: String = "Sand"

const RUN_SPEED = 100
const RUN_ACCEL = 1000

signal mode_switch(_mode: String)

func _on_mode_checker_body_entered(body):
	mode = "Sand"
	emit_signal("mode_switch", mode)

func _on_mode_checker_body_exited(body):
	mode = "Water" 
	emit_signal("mode_switch", mode)

func _on_npc_dialogue_collider_area_entered(area):
	if area.is_in_group("npc"):
		Events.emit_signal("alert_dialogue")


func _on_npc_dialogue_collider_area_exited(area):
	if area.is_in_group("npc"):
		Events.emit_signal("idle_dialogue")
