extends Camera2D

@export var main_scene: Node2D
@onready var player: CharacterBody2D = main_scene.find_child("player")
@onready var resolution = get_viewport().get_visible_rect().size

var last_dir: Vector2 = Vector2.ZERO

func _process(delta):
	offset = lerp(Vector2.ZERO, (player.position - floor(player.position)) * 4, 0.6)
	
	if not player.velocity.is_zero_approx():
		last_dir = player.velocity.normalized() * 50
	
	var mouse_offset = lerp(Vector2.ZERO, get_viewport().get_mouse_position() - position - resolution/2, 0.1)
	
	position = last_dir + mouse_offset
