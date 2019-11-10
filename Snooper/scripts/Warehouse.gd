extends "res://scripts/Building.gd"

const StoneMinerClass = preload("res://scripts/people/StoneMiner.gd")
const LumberjackClass = preload("res://scripts/people/Lumberjack.gd")
const FarmerClass = preload("res://scripts/people/Farmer.gd")

func interactWith(citizen, goal):
	.interactWith(citizen, goal)
	
	var value = 0
	if goal == Goal.GIVE:
		value = +citizen.productivity
	elif goal == Goal.TAKE:
		value = -citizen.eatability # TODO: Different constant?
	
	Stats.add_resource(citizen.resourceProduced, value)