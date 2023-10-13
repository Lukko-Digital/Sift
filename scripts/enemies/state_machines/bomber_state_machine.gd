extends StateMachine

@export var animation_player: AnimationPlayer

@onready var aggro_radius: Area2D = $Track/AggroRadius
@onready var tracking_radius: Area2D = $Track/TrackingRadius
@onready var attack_radius: Area2D = $Attack/AttackRadius
@onready var health_component: HealthComponent = get_node("../HealthComponent")
@onready var hurtbox_component: HurtboxComponent = get_node("../HurtboxComponent")

var facing_direction: Vector2 = Vector2(0, 1)

func _ready():
	super._ready()
	health_component.damage_taken.connect(_on_damage_taken)
	animation_player.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	if (
		not attack_radius.get_overlapping_bodies().is_empty() or 
		animation_player.current_animation in [
			"Attack_down_right", "Attack_down_left", "Attack_up_right", "Attack_up_left", "Attack_insta"
		]
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

func _on_animation_finished(anim_name):
	match anim_name:
		"knocked_up":
			transition_to("Idle")
		"Getup_down_right", "Getup_down_left", "Getup_up_right", "Getup_up_left":
			transition_to("Track")

func _on_damage_taken(attack: Attack):
	transition_to("Attack", true)
