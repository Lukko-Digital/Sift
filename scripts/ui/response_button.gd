class_name ResponseButton
extends Button

signal response_pressed(destination_branch)

var destination_branch: String

func _pressed():
	emit_signal("response_pressed", destination_branch)
