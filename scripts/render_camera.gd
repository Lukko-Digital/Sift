extends Camera2D

@export var main_scene: Node2D
@onready var player: CharacterBody2D = main_scene.find_child("player")

func _ready():
	pass 

func _process(delta):
	offset = lerp(Vector2.ZERO, (player.position - floor(player.position)) * 4, 0.6)
#	print(offset)
	
#	main_scene.position = -player.position + Vector2(246, 141)
	
	if not player.velocity.is_zero_approx():
		position = player.velocity.normalized() * 50
