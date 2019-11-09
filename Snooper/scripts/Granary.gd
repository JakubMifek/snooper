extends "res://scripts/Building.gd"

func interactWith(citizen, goal):
	if goal == Goal.GIVE:
		Stats.add_resource(Stats.RESOURCES.wheat, +1)
	elif goal == Goal.TAKE:
		Stats.add_resource(Stats.RESOURCES.wheat, -1)
