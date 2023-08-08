extends State

@export var animation_player: AnimationPlayer
@export var color_animation_player: AnimationPlayer

const NUM_DEAD_ANIMATIONS = 2

func enter():
	disable_hitboxes()
	play_animations()

func disable_hitboxes():
	var hit_box: CollisionShape2D = character.get_node("HitBox")
	var hurtbox: HurtboxComponent = character.get_node("HurtboxComponent")
	hit_box.disabled = true
	hurtbox.monitorable = false

func play_animations():
	var anim_idx = randi() % NUM_DEAD_ANIMATIONS + 1
	animation_player.play("Dead_%s" % anim_idx)
	color_animation_player.play("On_hit_white")
	color_animation_player.queue("Dead_transparent")
