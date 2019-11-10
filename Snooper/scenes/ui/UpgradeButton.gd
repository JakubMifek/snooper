extends Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = texture.get_size()[0] / 2 + 4
	position.y = OS.window_size.y - texture.get_size()[1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
