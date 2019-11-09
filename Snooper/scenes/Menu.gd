extends Control

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()

func _on_StartButton_button_down():
	get_tree().change_scene("res://scenes/Game.tscn")

func _on_CreaditsButton_button_down():
	get_tree().change_scene("res://scenes/Credits.tscn")

func _on_ExitButton_button_down():
	get_tree().quit()