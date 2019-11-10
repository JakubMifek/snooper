extends AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.position.x = OS.window_size.x/2
	self.position.y = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
