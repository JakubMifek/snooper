extends Control

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
			

func _on_CancelButton_button_down():
	get_tree().change_scene("res://scenes/Menu.tscn")