extends "res://scripts/Building.gd"

const StoneMinerClass = preload("res://scripts/people/StoneMiner.gd")
const LumberjackClass = preload("res://scripts/people/Lumberjack.gd")
const FarmerClass = preload("res://scripts/people/Farmer.gd")

func interactWith(citizen):
	if citizen is StoneMinerClass:
		print("colliding with miner")
	elif citizen is LumberjackClass:
		print("colliding with lumberjack")
	elif citizen is FarmerClass:
		print("colliding with farmer")
