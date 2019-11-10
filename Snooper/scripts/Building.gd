extends Node2D

enum Goal {
	TAKE,
	GIVE
}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func interactWith(citizen, goal):
	citizen.speed = 0
	citizen.delay = 0.5
