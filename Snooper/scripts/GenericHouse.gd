extends "res://scripts/Building.gd"

export var house_spawn_population = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func interactWith(citizen):
	print("Interacting with citizen")
