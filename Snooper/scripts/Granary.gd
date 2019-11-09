extends "res://scripts/Building.gd"


func interactWith(citizen):
	Stats.add_resource(Stats.RESOURCES.wheat, -1)
