extends StateMachine

@export var animation_player: AnimationPlayer

@onready var aggro_radius: Area2D = $Track/AggroRadius
@onready var tracking_radius: Area2D = $Track/TrackingRadius
@onready var attack_radius: Area2D = $Attack/AttackRadius
@onready var attack_timer: Timer = $Attack/AttackTimer
@onready var health_component: HealthComponent = get_node("../HealthComponent")
@onready var hurtbox_component: HurtboxComponent = get_node("../HurtboxComponent")
@onready var knockback_timer: Timer = $KnockedBack/KnockBackTimer

var facing_direction: Vector2 = Vector2(0, 1)
var is_dead = false

func _ready():
	super._ready()
	attack_timer.timeout.connect(_return_to_idle)
	health_component.died.connect(_on_death)
	hurtbox_component.effect_applied.connect(_on_effect_applied)
	animation_player.animation_finished.connect(_on_animation_finished)
	knockback_timer.timeout.connect(_return_to_idle)

func _physics_process(delta: float) -> void:
	if is_dead:
		transition_to("Dead")
	elif state.name == "KnockedUp":
		transition_to("KnockedUp")
	elif state.name == "KnockedBack":
		transition_to("KnockedBack")
	elif (
		not attack_radius.get_overlapping_bodies().is_empty() or 
		animation_player.current_animation == "Attack_front" or
		not attack_timer.is_stopped()
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

func _return_to_idle():
	transition_to("Idle")

func _on_death():
	is_dead = true

func _on_animation_finished(anim_name):
	if anim_name == "knocked_up":
		transition_to("Idle")

func _on_effect_applied(effects):
	for effect in effects:
		if effect.effect_name == Effect.EffectName.KNOCKED_UP:
			transition_to("KnockedUp")
		elif effect.effect_name == Effect.EffectName.KNOCKED_BACK:
			transition_to("KnockedBack", effect)
