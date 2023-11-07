extends Sprite2D

@export var animation_player: AnimationPlayer

@onready var hit_box: Area2D = $HitBox

var sand_attack: Attack = Attack.new("Sand Attack", 1)
	
func start(start_position: Vector2, direction: Vector2, multi_attack: int):
	global_position = start_position
	animation_player.play("down")
	
	look_at(direction)
	rotate(-PI/2)
	
	if multi_attack == 1:
		set_modulate(Color(0,1,1))
	if multi_attack == 2:
		set_modulate(Color(1,0,1))

func _on_animation_player_animation_finished(anim_name):
	queue_free()

func _on_hit(area):
	if area.is_in_group("enemy_hurtbox"):
		sand_attack.effects = [
			KnockedBackEffect.new(0.05, 200, area.global_position-self.global_position),
			StunnedEffect.new(0.2)
		]
		area.damage(sand_attack)
