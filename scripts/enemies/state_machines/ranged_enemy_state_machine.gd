extends StateMachine

@export var animation_player: AnimationPlayer
@export var color_animation_player: AnimationPlayer

@onready var attack_radius: Area2D = $Attack/AttackRadius
@onready var end_lag_timer: Timer = $Attack/EndLag
@onready var health_component: HealthComponent = get_node("../HealthComponent")
@onready var hurtbox_component: HurtboxComponent = get_node("../HurtboxComponent")
@onready var knockback_timer: Timer = $KnockedBack/KnockBackTimer
@onready var stun_timer: Timer = $StunTimer

var is_dead = false

func _ready():
	super._ready()
	health_component.died.connect(_on_death)
	health_component.damage_taken.connect(_on_damage_taken)
	animation_player.animation_finished.connect(_on_animation_finished)
	end_lag_timer.timeout.connect(_attack_end)

func _physics_process(delta: float) -> void:
	if not knockback_timer.is_stopped():
		transition_to("KnockedBack")
	elif is_dead:
		transition_to("Dead")
	elif not stun_timer.is_stopped():
		transition_to("Idle")
	elif (
		not attack_radius.get_overlapping_bodies().is_empty() or 
		animation_player.current_animation in []
	):
		transition_to("Attack")
	else:
		transition_to("Idle")

	state.handle_physics(delta)

func _attack_end():
	transition_to("Track")

func _on_death():
	is_dead = true

func _on_animation_finished(anim_name):
	match anim_name:
		"knocked_up":
			transition_to("Idle")
		"Getup_down_right", "Getup_down_left", "Getup_up_right", "Getup_up_left":
			transition_to("Track")

func _on_damage_taken(attack: Attack):
	if not is_dead:
		on_hit_animation()

	for effect in attack.effects:
		match effect.effect_name:
			Effect.EffectName.KNOCKED_BACK:
				transition_to("KnockedBack", effect)
			Effect.EffectName.STUNNED:
				stun_timer.start(effect.duration)

func on_hit_animation():
	color_animation_player.queue("On_hit_white")
	for i in range(5):
		color_animation_player.queue("On_hit_red_flash")
