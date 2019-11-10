extends RichTextLabel

export var Padding = 20

func _ready():
	self.rect_position.x = Padding
	self.rect_position.y = Padding
	
	self.rect_size.x = get_parent().rect_size.x - Padding * 2
	self.rect_size.y = 280
	