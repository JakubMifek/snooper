extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var isInit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func showDeath():
	if not isInit:
		isInit = true
		return
		
	get_tree().change_scene("res://scenes/menu/Menu.tscn")
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#var endNode = $CanvasLayer2/EndGame
	#endNode.visible=true
	#endNode.modulate.a = 1.0
