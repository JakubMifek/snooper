extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func showDeath():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var endNode = $CanvasLayer2/EndGame
	endNode.visible=true
	endNode.modulate.a = 1.0
