class_name AnimatedMenuButton
extends TextureButton

@export var texture: Texture
@onready var button_sprite: Sprite2D = $ButtonSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	button_sprite.texture = texture
	animation_player.play("enter")


func _process(delta):
	pass
