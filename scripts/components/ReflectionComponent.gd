extends Sprite2D

@export var sprite_to_reflect: Sprite2D

func _process(delta):
	frame = sprite_to_reflect.frame
	offset.y = -sprite_to_reflect.offset.y if flip_v else sprite_to_reflect.offset.y
