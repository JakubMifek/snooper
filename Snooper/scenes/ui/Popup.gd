extends Control

func _ready():
	get_node("PopupDialog").PopUpOn(rect_position.x, rect_position.y, rect_size.x, rect_size.y)

