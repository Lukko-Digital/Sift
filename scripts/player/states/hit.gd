class_name Hit
extends State

@onready var effect_timer: Timer = $EffectTimer

var effects: Array[Effect] = []
var animation_direction: Vector2
var current_effect_id: int = 0
signal return_to_idle

func enter():
	current_effect_id = 0
	effect_timer.start(effects[current_effect_id].duration)
	
	animation_tree["parameters/playback"].travel("Hit")
	
	for effect in effects:
		if effect.effect_name == Effect.EffectName.KNOCKED_BACK:
			animation_direction = effect.direction
	
	if abs(animation_direction.x) > abs(animation_direction.y):
		animation_tree["parameters/Hit/blend_position"] = - Vector2(animation_direction.x / abs(animation_direction.x), 0)
	else:
		animation_tree["parameters/Hit/blend_position"] = - Vector2(0, animation_direction.y / abs(animation_direction.y))

func recieve_args(effects):
	self.effects = effects

func handle_physics(delta: float):
	var current_effect = effects[current_effect_id]
	
	match current_effect.effect_name:
		Effect.EffectName.KNOCKED_BACK:
			character.velocity = KnockedBackEffect.KNOCK_BACK_SPEED * current_effect.direction.normalized()
		Effect.EffectName.KNOCKED_UP:
			pass
		Effect.EffectName.STUNNED:
			character.velocity = character.velocity.move_toward(Vector2.ZERO, 25)

	character.move_and_slide()

func _on_effect_timer_timeout():
	if current_effect_id < effects.size() - 1:
		current_effect_id += 1
		effect_timer.start(effects[current_effect_id].duration)
	else:
		emit_signal("return_to_idle")

func exit():
	animation_tree["parameters/Idle/blend_position"] = animation_tree["parameters/Hit/blend_position"]
