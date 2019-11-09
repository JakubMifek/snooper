extends "res://scripts/Building.gd"

const StoneMinerClass = preload("res://scripts/people/StoneMiner.gd")
const LumberjackClass = preload("res://scripts/people/Lumberjack.gd")
const FarmerClass = preload("res://scripts/people/Farmer.gd")

func interactWith(citizen, goal):
	var value = 0
	if goal == Goal.GIVE:
		value = +1
	elif goal == Goal.TAKE:
		value = -1
		
	if citizen is StoneMinerClass:
		Stats.add_resource(Stats.RESOURCES.stone, value)
	elif citizen is LumberjackClass:
		Stats.add_resource(Stats.RESOURCES.wood, value)
	elif citizen is FarmerClass:
		Stats.add_resource(Stats.RESOURCES.wheat, value)
