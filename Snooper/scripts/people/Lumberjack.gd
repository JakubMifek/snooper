extends "res://scripts/Citizen.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.death_sounds = get_node('/root/Root/Village/Sounds/Man').get_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
