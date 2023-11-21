extends Node2D

const SPEED = 200
const DESPAWN_TIME = 8

@export var animation_player: AnimationPlayer

@onready var hitbox: Area2D = $HitBox
@onready var despawn_timer: Timer = $DespawnTimer

var projectile_attack: Attack = Attack.new("projectile attack", 1)
var direction: Vector2

func start(start_pos: Vector2, dir: Vector2):
	position = start_pos
	direction = dir
	look_at(direction)
	animation_player.play("fly")

func _ready():
	animation_player.animation_finished.connect(_on_animation_finished)
	hitbox.area_entered.connect(_on_hit)
	despawn_timer.timeout.connect(despawn)
	despawn_timer.start(DESPAWN_TIME)

func _process(delta):
	position += direction * SPEED * delta

func _on_hit(area):
	if area.is_in_group("player_hurtbox"):
		projectile_attack.effects = [
			KnockedBackEffect.new(0.1, 200, area.global_position-self.global_position),
			StunnedEffect.new(0.25),
		]
		area.damage(projectile_attack)
		animation_player.play("pop")

func _on_animation_finished(anim_name):
	match anim_name:
		"pop": despawn()

func despawn():
	queue_free()
