class_name Player
extends CharacterBody2D

var mode: String = "Water"

var RUN_SPEED = 100
const RUN_ACCEL = 1000

@onready var sprite: Sprite2D = $WaterMask/Sprite2D
@onready var depth_checker = $DepthShoreChecker
@onready var deep_water_checker: Area2D = $DeepWaterChecker
@onready var sinking_timer: Timer = $DeepWaterSinkTimer
@onready var particles: CPUParticles2D = $WaterParticles
@onready var health_component: HealthComponent = $HealthComponent

@onready var splash_scene = preload("res://scenes/player/splash.tscn")

signal mode_switch(_mode: String)

# Getter method for max/starting health
func max_hp():
	return $HealthComponent.max_health

func _on_mode_checker_body_entered(body):
	mode = "Sand"
	sprite.offset.y = 0
	emit_signal("mode_switch", mode)

func _on_mode_checker_body_exited(body):
	mode = "Water" 
	emit_signal("mode_switch", mode)
	
func check_drown():
	return deep_water_checker.has_overlapping_bodies()
	
func drown():
	if check_drown():
		if sinking_timer.is_stopped() and sprite.offset.y > 15:
			sinking_timer.start(0.5)
		if sprite.offset.y < 0:
			sprite.offset.y -= 2
		elif sprite.offset.y < 40:
			sprite.offset.y += 0.5
	
func sink_in_water():
	if mode == "Water":
		drown()
		if not check_drown() and sinking_timer.is_stopped():
			var distance = 32.0
			for raycast in depth_checker.get_children():
				if (raycast.get_collision_point() - raycast.global_position).length() < distance:
					distance = (raycast.get_collision_point() - raycast.global_position).length()
		
			sprite.offset.y = distance / 4 + 1
		
	else:
		sprite.offset.y = 0
		
	return sprite.offset.y

func _on_npc_dialogue_collider_area_entered(area):
	if area.is_in_group("npc"):
		Events.emit_signal("alert_dialogue")

func _on_npc_dialogue_collider_area_exited(area):
	if area.is_in_group("npc"):
		Events.emit_signal("idle_dialogue")


func _on_splash_timer_timeout():
	if not velocity.is_zero_approx():
		var instance = splash_scene.instantiate()
		get_parent().add_child(instance)
		instance.start(velocity, mode, position + Vector2(0, -5))
		

func _on_deep_water_sink_timer_timeout():
	if check_drown():
		var drown: Attack = Attack.new("drown", 1)
		health_component.damage(drown)
		sinking_timer.stop()


func _on_deep_water_checker_body_exited(body):
	sinking_timer.start(0.5)
	var tween = get_tree().create_tween()
	
	tween.tween_property(sprite, "offset", Vector2(0, 9), 0.5)
