extends Sprite2D

@export var animation_player: AnimationPlayer

func start(start_position: Vector2, anim_name: String):
	global_position = start_position
	animation_player.play(anim_name)

func _on_animation_player_animation_finished(anim_name):
	queue_free()
