extends State

@export var animation_player: AnimationPlayer

const NUM_DEAD_ANIMATIONS = 2

func enter():
	var hit_box: CollisionShape2D = character.get_node("HitBox")
	hit_box.disabled = true
	var anim_idx = randi() % NUM_DEAD_ANIMATIONS + 1
	animation_player.play("Dead_%s" % anim_idx)
