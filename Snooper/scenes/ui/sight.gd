extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var texture_size_x = 600 # texture.get_size().x
	var texture_size_y = 600 # texture.get_size().y
	position.x = OS.window_size.x / 2
	position.y = OS.window_size.y / 2
	var scale_x = OS.window_size.x / texture_size_x
	var scale_y = OS.window_size.y / texture_size_y
	
	var min_scale = min(scale_x, scale_y)
	
	scale.x = min_scale
	scale.y = min_scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
