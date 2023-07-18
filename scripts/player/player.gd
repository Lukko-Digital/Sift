extends CharacterBody2D

@onready var mode: String = "Sand"

func _on_mode_checker_body_entered(body):
	mode = "Sand" 

func _on_mode_checker_body_exited(body):
	mode = "Water" 
