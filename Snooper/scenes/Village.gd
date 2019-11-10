extends Node2D

onready var Citizen = preload("res://scripts/Citizen.gd")
onready var farmer = preload("res://people/farmer.tscn")
onready var lumberjack = preload("res://people/lumberjack.tscn")
onready var stoneMiner = preload("res://people/stone_miner.tscn")

var houses

func _ready():
	houses = get_tree().get_nodes_in_group("houses")

func spawnCitizen(occupation=null, hungryness = 3, diligence = 2, movement = int(rand_range(52, 77)), productivity = 1):
	var occ = occupation if occupation != null else int(3*randf())
	
	if occ == Citizen.Occupation.FARMER:
		return self._spawnFarmer(hungryness, diligence, movement, productivity)
	elif occ == Citizen.Occupation.LUMBERJACK:
		return self._spawnLumberjack(hungryness, diligence, movement, productivity)
	else:
		return self._spawnStoneMiner(hungryness, diligence, movement, productivity)
	
func _spawnFarmer(hungryness = 3, diligence = 2, movement = int(rand_range(52, 77)), productivity = 1):
	var newCitizen = farmer.instance()
	newCitizen.resourceProduced = Stats.RESOURCES.wheat
	return self._spawnCitizen(newCitizen, Citizen.Occupation.FARMER, $Farm, $Granary, hungryness, diligence, movement, productivity)
	
func _spawnLumberjack(hungryness = 3, diligence = 2, movement = int(rand_range(52, 77)), productivity = 1):
	var newCitizen = lumberjack.instance()
	newCitizen.resourceProduced = Stats.RESOURCES.wood
	return self._spawnCitizen(newCitizen, Citizen.Occupation.LUMBERJACK, $Lumbermill, $Storage, hungryness, diligence, movement, productivity)
	
func _spawnStoneMiner(hungryness = 3, diligence = 2, movement = int(rand_range(52, 77)), productivity = 1):
	var newCitizen = stoneMiner.instance()
	newCitizen.resourceProduced = Stats.RESOURCES.stone
	return self._spawnCitizen(newCitizen, Citizen.Occupation.STONE_MINER, $Quarry, $Storage, hungryness, diligence, movement, productivity)
	
func _spawnCitizen(citizen, occupation, occupation_place, storage_place, hungryness = 3, diligence = 2, movement = int(rand_range(52, 77)), productivity = 1):
	var house = houses[randi() % houses.size()]
	get_node('Citizens').add_child(citizen)
	citizen.initialize(occupation, hungryness, diligence, movement, productivity, house, occupation_place, storage_place, $Granary)
	return citizen