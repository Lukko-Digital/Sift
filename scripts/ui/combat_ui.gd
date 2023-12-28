extends CanvasLayer

@export var main_scene: Node2D
@onready var player: CharacterBody2D = main_scene.find_child("player")

const HIT_STOP_DELAY = 0.0
const HIT_STOP_DURATION = 0.07

var player_max_hp: int
var player_current_hp: int
var heart_container_default_pos: Vector2
var shake_amount: int

@onready var hearts_container: MarginContainer = $HeartsContainer
@onready var empty_hearts: TextureRect = $HeartsContainer/Hearts/EmptyHearts
@onready var half_hearts: TextureRect = $HeartsContainer/Hearts/HalfHearts
@onready var full_hearts: TextureRect = $HeartsContainer/Hearts/FullHearts
@onready var shake_timer: Timer = $HeartsContainer/Hearts/ShakeTimer
@onready var heart_width: int = full_hearts.texture.get_size().x
@onready var screen_color_animation_player: AnimationPlayer = $ScreenColor/ScreenColorAnimationPlayer


func _ready():
	Events.enter_scene.connect(_enter_scene)
	Events.player_damaged.connect(_on_player_damaged)
	Events.enemy_damaged.connect(_on_enemy_damaged)
	Events.player_dead.connect(_on_player_death)
	heart_container_default_pos = hearts_container.position
	shake_timer.timeout.connect(_shake_end)
	initialize_health()

func _process(delta):
	if not shake_timer.is_stopped():
		hearts_container.position = heart_container_default_pos + Vector2(
			randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount
		)

func shake(time: float, amount: float):
	shake_amount = amount
	shake_timer.start(time)

func initialize_health():
	player_max_hp = player.max_hp()
	player_current_hp = player_max_hp
	empty_hearts.size.x = heart_width * (floor(player_max_hp / 2) + player_max_hp % 2)
	half_hearts.size.x = heart_width * (floor(player_max_hp / 2) + player_max_hp % 2)
	full_hearts.size.x = heart_width * floor(player_max_hp / 2)

func hit_stop():
	# delay a bit to allow hit animations to play
	await get_tree().create_timer(HIT_STOP_DELAY).timeout
	get_tree().paused = true
	await get_tree().create_timer(HIT_STOP_DURATION).timeout
	get_tree().paused = false

func _enter_scene():
	screen_color_animation_player.play_backwards("fade_to_black")

func _on_player_damaged(damage):
	player_current_hp -= damage
	half_hearts.size.x = heart_width * (floor(player_current_hp / 2) + player_current_hp % 2)
	full_hearts.size.x = heart_width * floor(player_current_hp / 2)
	screen_color_animation_player.play("on_hit_red")
	shake(0.1, 15)
	hit_stop()

func _on_enemy_damaged():
	shake(0.1, 15)
	hit_stop()

func _on_player_death():
	screen_color_animation_player.play("fade_to_black")
	await screen_color_animation_player.animation_finished
	Events.emit_signal("respawn")

func _shake_end():
	hearts_container.position = heart_container_default_pos
