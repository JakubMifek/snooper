extends Panel

func _ready():
	PopUpOn(rect_position.x, rect_position.y, rect_size.x, rect_size.y)
	
func PopUpOn(pos_x, pos_y, size_x, size_y):
	visible = true #  popup(Rect2(pos_x, pos_y, size_x, size_y))
	
func _input(event):
	if event is InputEventKey and event.pressed and not(event is InputEventMouseButton):
		hide()
