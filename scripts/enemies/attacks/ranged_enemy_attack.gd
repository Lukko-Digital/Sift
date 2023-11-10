extends State

@export var animation_player: AnimationPlayer

@onready var attack_radius: Area2D = $AttackRadius
@onready var attack_collider: CollisionShape2D = $AttackBox/CollisionShape2D
@onready var slide_timer: Timer = $SlideTimer

var player: CharacterBody2D
var attack_dir: Directions.Direction

func _ready():
	animation_player.animation_finished.connect(_on_animation_end)

func enter():
	find_player()
	
func handle_physics(delta: float):
	pass

func exit():
	pass

func _on_animation_end(anim_name: StringName):
	pass

func find_player():
	for body in attack_radius.get_overlapping_bodies():
		if body.name == "player":
			player = body

func direction_to_player():
	return(player.global_position - character.global_position).normalized()
