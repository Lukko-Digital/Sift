class_name AnimatedMenuButton
extends TextureButton

@export var texture: Texture
@onready var button_sprite: Sprite2D = $ButtonSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	button_sprite.texture = texture


func _process(delta):
	pass


func _on_mouse_entered():
	animation_player.play("hover")


func _on_mouse_exited():
	animation_player.stop()


func _on_button_down():
	animation_player.play("pressed")


func _on_button_up():
	animation_player.play("released")
