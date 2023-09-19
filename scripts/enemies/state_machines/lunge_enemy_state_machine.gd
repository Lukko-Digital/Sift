extends StateMachine

@export var animation_player: AnimationPlayer
@export var color_animation_player: AnimationPlayer

@onready var aggro_radius: Area2D = $Track/AggroRadius
@onready var tracking_radius: Area2D = $Track/TrackingRadius
@onready var attack_radius: Area2D = $Attack/AttackRadius
@onready var end_lag_timer: Timer = $Attack/EndLag
@onready var health_component: HealthComponent = get_node("../HealthComponent")
@onready var hurtbox_component: HurtboxComponent = get_node("../HurtboxComponent")
@onready var knockback_timer: Timer = $KnockedBack/KnockBackTimer
@onready var stun_timer: Timer = $StunTimer

var facing_direction: Vector2 = Vector2(0, 1)
var is_dead = false

func _ready():
	super._ready()
	end_lag_timer.timeout.connect(_attack_end)
	health_component.died.connect(_on_death)
	health_component.damage_taken.connect(_on_damage_taken)
	animation_player.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	print(animation_player.current_animation)
	if not knockback_timer.is_stopped():
		transition_to("KnockedBack")
	elif is_dead:
		transition_to("Dead")
	elif not stun_timer.is_stopped():
		transition_to("Idle")
	elif (
		not attack_radius.get_overlapping_bodies().is_empty() or 
		animation_player.current_animation in ["Attack_windup_right", "Attack_windup_left", "Attack_right", "Attack_left"] or
		not end_lag_timer.is_stopped()
	):
		transition_to("Attack")
	elif (
		not aggro_radius.get_overlapping_bodies().is_empty() or (
			state.name in ["Track", "Attack"] and
			not tracking_radius.get_overlapping_bodies().is_empty()
		)
	):
		transition_to("Track")
	else:
		transition_to("Idle")

	state.handle_physics(delta)

func _attack_end():
	transition_to("Track")

func _on_death():
	is_dead = true

func _on_animation_finished(anim_name):
	if anim_name == "knocked_up":
		transition_to("Idle")

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
