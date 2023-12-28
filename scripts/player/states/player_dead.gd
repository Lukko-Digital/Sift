extends State

@export var animation_player: AnimationPlayer
@onready var collision_box: CollisionShape2D = character.get_node("CollisionBox")

func enter():
	animation_tree["parameters/playback"].travel("Die")
	animation_tree["parameters/Die/blend_position"] = 1
	collision_box.disabled = true
	await get_tree().create_timer(animation_player.get_animation("die_left").length).timeout
	get_tree().reload_current_scene()
