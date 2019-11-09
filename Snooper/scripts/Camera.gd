extends Camera2D

export var full_hd_x = 1920
export var full_hd_y = 1080

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	

func _input(event):
	if event is InputEventMouseMotion:
		self.position += event.relative
		
		if self.position.x <= self.limit_left:
			self.position.x = self.limit_left
		if self.position.x >= self.limit_right:
			self.position.x = self.limit_right
		if self.position.y <= self.limit_top:
			self.position.y = self.limit_top
		if self.position.y >= self.limit_bottom:
			self.position.y = self.limit_bottom
