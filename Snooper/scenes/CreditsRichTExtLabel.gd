extends RichTextLabel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	rect_position.x = 20
	rect_position.y = 20
	rect_size.x = OS.window_size.x - 40
	rect_size.y = OS.window_size.y - 40

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
