extends Node2D

const SPEED = 200

var direction: Vector2

func start(start_pos: Vector2, dir: Vector2):
	position = start_pos
	direction = dir

func _ready():
	pass

func _process(delta):
	position += direction * SPEED * delta
