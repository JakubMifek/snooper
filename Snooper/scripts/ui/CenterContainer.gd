extends CenterContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	rect_size.x = OS.window_size.x
	rect_size.y = OS.window_size.y

