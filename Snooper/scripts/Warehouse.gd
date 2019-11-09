extends "res://scripts/Building.gd"

const StoneMinerClass = preload("res://scripts/people/StoneMiner.gd")
const LumberjackClass = preload("res://scripts/people/Lumberjack.gd")
const FarmerClass = preload("res://scripts/people/Farmer.gd")

func interactWith(citizen):
	if citizen is StoneMinerClass:
		Stats.add_resource(Stats.RESOURCES.stone, +1)
	elif citizen is LumberjackClass:
		Stats.add_resource(Stats.RESOURCES.wood, +1)
	elif citizen is FarmerClass:
		Stats.add_resource(Stats.RESOURCES.wheat, +1)
