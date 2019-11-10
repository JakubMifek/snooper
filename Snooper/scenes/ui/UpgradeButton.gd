extends RichTextLabel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.rect_position = Vector2(0, OS.window_size[1]-self.rect_size[1])
