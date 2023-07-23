class_name SandAttack
extends State

@onready var timer: Timer = get_node("../Timer")

var time = 0.8

func enter():
	timer.start(time)
	
