extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
	if event is InputEventMouseButton and event.pressed:
		match (event.button_index):
			BUTTON_LEFT:
				print_debug("BUTTON_LEFT")
			BUTTON_RIGHT:
				print_debug("BUTTON_RIGHT")
			_:
				print_debug("No")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
