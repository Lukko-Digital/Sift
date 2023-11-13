extends Node2D

const SPEED = 200

@onready var hitbox: Area2D = $HitBox

var projectile_attack: Attack = Attack.new("projectile attack", 1)
var direction: Vector2

func start(start_pos: Vector2, dir: Vector2):
	position = start_pos
	direction = dir

func _ready():
	hitbox.area_entered.connect(_on_hit)

func _process(delta):
	position += direction * SPEED * delta

func _on_hit(area):
	if area.is_in_group("player_hurtbox"):
		projectile_attack.effects = [
			KnockedBackEffect.new(0.1, 200, area.global_position-self.global_position),
			StunnedEffect.new(0.25),
		]
		area.damage(projectile_attack)
		queue_free()
