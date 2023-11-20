extends State

const END_LAG = 2.0

@export var animation_player: AnimationPlayer

@onready var projectile_scene = preload("res://scenes/enemies/projectile.tscn")

@onready var attack_radius: Area2D = $AttackRadius
@onready var end_lag_timer: Timer = $EndLag
@onready var attack_collider: CollisionShape2D = $AttackBox/CollisionShape2D
@onready var slide_timer: Timer = $SlideTimer

var player: CharacterBody2D
var attack_dir: Directions.Direction

func _ready():
	animation_player.animation_finished.connect(_on_animation_end)

func enter():
	find_player()
	match Directions.direction_horizontal(direction_to_player()):
		Directions.Direction.RIGHT: animation_player.play("Attack_windup_down_right")
		Directions.Direction.LEFT: animation_player.play("Attack_windup_down_left")
	
#	shoot()
#	end_lag_timer.start(END_LAG)

func exit():
	pass

func _on_animation_end(anim_name: StringName):
	match anim_name:
		"Attack_windup_down_right", "Attack_windup_down_left":
			attack_dir = Directions.direction_horizontal(direction_to_player())
			match attack_dir:
				Directions.Direction.RIGHT: animation_player.play("Attack_down_right")
				Directions.Direction.LEFT: animation_player.play("Attack_down_left")
			shoot()
			end_lag_timer.start(END_LAG)

func shoot():
	var instance = projectile_scene.instantiate()
	instance.start(character.position, direction_to_player())
	character.get_parent().add_child(instance)

func find_player():
	for body in attack_radius.get_overlapping_bodies():
		if body.name == "player":
			player = body

func direction_to_player():
	return(player.global_position - character.global_position).normalized()
