extends RichTextLabel

func _ready():
	rect_position.x = 40
	rect_position.y = 60
	rect_size.x = OS.window_size.x - 80
	rect_size.y = OS.window_size.y - 80
