extends Sprite

func _ready():
	var texture_size_x = 600
	var texture_size_y = 600
	position.x = OS.window_size.x / 2
	position.y = OS.window_size.y / 2
	var scale_x = OS.window_size.x / texture_size_x
	var scale_y = OS.window_size.y / texture_size_y
	
	var min_scale = min(scale_x, scale_y)
	
	scale.x = min_scale
	scale.y = min_scale
