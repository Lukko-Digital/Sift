extends CanvasLayer

@export var player: CharacterBody2D

const PLAYER_MAX_HP = 3
var player_hp = PLAYER_MAX_HP

@onready var empty_hearts: TextureRect = $MarginContainer/Hearts/EmptyHearts
@onready var full_hearts: TextureRect = $MarginContainer/Hearts/FullHearts
@onready var heart_width: int = full_hearts.texture.get_size().x

func _ready():
	Events.player_damaged.connect(_on_player_damaged)
	empty_hearts.size.x = heart_width * PLAYER_MAX_HP
	full_hearts.size.x = heart_width * PLAYER_MAX_HP
	
func _on_player_damaged(damage):
	player_hp -= damage
	full_hearts.size.x = heart_width * player_hp
