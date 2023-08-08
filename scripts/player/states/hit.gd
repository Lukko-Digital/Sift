class_name Hit
extends State

@onready var effect_timer: Timer = $EffectTimer

var effects: Array[Effect] = []
var animation_direction: Vector2
var current_effect: int = 0
signal return_to_idle

func enter():
	current_effect = 0
	effect_timer.start(effects[current_effect].duration)
	
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
	if effects[current_effect].effect_name == Effect.EffectName.KNOCKED_BACK:
		character.velocity = KnockedBackEffect.KNOCK_BACK_SPEED * effects[current_effect].direction.normalized()
	elif effects[current_effect].effect_name == Effect.EffectName.KNOCKED_UP:
		pass
	elif effects[current_effect].effect_name == Effect.EffectName.STUNNED:
		character.velocity = character.velocity.move_toward(Vector2.ZERO, 25)
	character.move_and_slide()

func _on_effect_timer_timeout():
	if current_effect < effects.size() - 1:
		current_effect += 1
		effect_timer.start(effects[current_effect].duration)
	else:
		emit_signal("return_to_idle")

func exit():
	animation_tree["parameters/Idle/blend_position"] = animation_tree["parameters/Hit/blend_position"]
