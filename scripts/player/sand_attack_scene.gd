extends Sprite2D

@export var animation_player: AnimationPlayer

@onready var hit_box: Area2D = $HitBox

var sand_attack: Attack = Attack.new("Sand Attack", 1)

func _ready():
	hit_box.area_entered.connect(_on_hit)
	

func start(start_position: Vector2, anim_name: String):
	global_position = start_position
	animation_player.play(anim_name)

func _on_animation_player_animation_finished(anim_name):
	queue_free()

func _on_hit(area):
	if area.is_in_group("enemy_hurtbox"):
		area.damage(sand_attack)
