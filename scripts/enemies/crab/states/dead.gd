extends State

func enter():
	character.modulate = Color(Color.BLACK)
	var hit_box: CollisionShape2D = character.get_node("HitBox")
	hit_box.disabled = true
