class_name Player
extends CharacterBody2D

var mode: String = "Sand"

const RUN_SPEED = 100
const RUN_ACCEL = 1000

@onready var sprite: Sprite2D = $Sprite2D
@onready var depth_checker = $DepthShoreChecker
@onready var water: Sprite2D = $Sprite2D/Water
@onready var particles: CPUParticles2D = $CPUParticles2D

signal mode_switch(_mode: String)

# Getter method for max/starting health
func max_hp():
	return $HealthComponent.max_health

func _on_mode_checker_body_entered(body):
	mode = "Sand"
	sprite.offset.y = 0
	water.visible = false
#	particles.z_index = -5
	emit_signal("mode_switch", mode)

func _on_mode_checker_body_exited(body):
	mode = "Water" 
	water.visible = true
#	particles.z_index = 0
	emit_signal("mode_switch", mode)
	
func _physics_process(delta):
	if mode == "Water":
		var distance = 32.0
		for raycast in depth_checker.get_children():
			if (raycast.get_collision_point() - raycast.global_position).length() < distance:
				distance = (raycast.get_collision_point() - raycast.global_position).length()
	
		sprite.offset.y = distance / 4

func _on_npc_dialogue_collider_area_entered(area):
	if area.is_in_group("npc"):
		Events.emit_signal("alert_dialogue")

func _on_npc_dialogue_collider_area_exited(area):
	if area.is_in_group("npc"):
		Events.emit_signal("idle_dialogue")
