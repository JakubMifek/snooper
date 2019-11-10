extends Button

func _ready():
	rect_position.x = OS.window_size.x/2 - rect_size.x/2
	rect_position.y = OS.window_size.y - rect_size.y - 40

