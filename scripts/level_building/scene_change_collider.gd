extends Area2D

@export_file var scene_file

func _ready():
	self.body_entered.connect(_change_scene)

func _change_scene(body):
	get_tree().change_scene_to_file(scene_file)
	print(scene_file)
