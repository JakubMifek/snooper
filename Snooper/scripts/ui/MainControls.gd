extends Control

# Declare member variables here. Examples:
var Population
var Cam
var COOLDOWN_IN_MS = 5 * 1000
var shotat = OS.get_ticks_msec() - COOLDOWN_IN_MS

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if Population == null:
		Population = get_parent().get_parent().get_node('Population')
	if Cam == null:
		Cam = get_parent().get_parent().get_node('Camera').get_node('Camera2D')
	
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
	if event is InputEventMouseButton and event.pressed and OS.get_ticks_msec() - shotat >= COOLDOWN_IN_MS:
		match (event.button_index):
			BUTTON_LEFT:
				Population._killCitizens(Cam.position)
				shotat = OS.get_ticks_msec()
			BUTTON_RIGHT:
				print_debug("BUTTON_RIGHT")
			_:
				print_debug("No")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
