extends Node

func _process(delta):
	if Input.is_action_just_pressed("fire"):
		print("Left-click detected!")

	if Input.is_action_just_pressed("split_shot"):
		print("Right-click detected!")
