extends Node2D

const SPEED = 200
const DESPAWN_TIME = 8

@onready var hitbox: Area2D = $HitBox
@onready var despawn_timer: Timer = $DespawnTimer

var projectile_attack: Attack = Attack.new("projectile attack", 1)
var direction: Vector2

func start(start_pos: Vector2, dir: Vector2):
	position = start_pos
	direction = dir

func _ready():
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
		despawn()

func despawn():
	queue_free()
