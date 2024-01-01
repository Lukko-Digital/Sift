extends Camera2D

@export var main_scene: Node2D
@onready var player: CharacterBody2D = main_scene.find_child("player")
@onready var resolution = get_viewport().get_visible_rect().size

var shake_amount: float
var default_offset: Vector2 = offset
@onready var player_camera: Camera2D = player.find_child("Camera2D")
var shaking: bool = false



var last_dir: Vector2 = Vector2.ZERO

func _ready():
	player_camera.find_child("ShakeTimer").timeout.connect(_on_timer_timeout)
	player_camera.shaking.connect(shake)

func _process(delta):
	offset = lerp(Vector2.ZERO, (player.position - floor(player.position)) * 4, 0.6)
	
	if not player.velocity.is_zero_approx():
		last_dir = player.velocity.normalized() * 100
	
	var mouse_offset = lerp(Vector2.ZERO, get_viewport().get_mouse_position() - position - resolution/2, 0.1)
	
	var shake_offset = Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)
	
	position = last_dir + mouse_offset
	if (shaking):
		position += shake_offset

func shake(time: float, amount: float):
	shake_amount = amount
	shaking = true
	

func _on_timer_timeout():
	shaking = false
