extends Node2D

onready var farmer = preload("res://people/farmer.tscn")
onready var lumberjack = preload("res://people/lumberjack.tscn")
onready var stoneMiner = preload("res://people/stone_miner.tscn")

var houses

func _ready():
	houses = get_tree().get_nodes_in_group("houses")
	
	var wheat = Stats.resources[Stats.RESOURCES.wheat]
	var stone = Stats.resources[Stats.RESOURCES.stone]
	var wood = Stats.resources[Stats.RESOURCES.wood]
	
	wheat.capacity = 30
	stone.capacity = 50
	wood.capacity = 50

func spawnCitizen():
	var rnd = randf()
	if rnd < 0.33:
		return self._spawnFarmer()
	elif rnd < 0.66:
		return self._spawnLumberjack()
	else:
		return self._spawnStoneMiner()
	
func _spawnFarmer():
	var newCitizen = farmer.instance()
	newCitizen.resourceProduced = Stats.RESOURCES.wheat
	return self._spawnCitizen(newCitizen, $Farm, $Granary)
	
func _spawnLumberjack():
	var newCitizen = lumberjack.instance()
	newCitizen.resourceProduced = Stats.RESOURCES.wood
	return self._spawnCitizen(newCitizen, $Lumbermill, $Storage)
	
func _spawnStoneMiner():
	var newCitizen = stoneMiner.instance()
	newCitizen.resourceProduced = Stats.RESOURCES.stone
	return self._spawnCitizen(newCitizen, $Quarry, $Storage)
	
func _spawnCitizen(citizen, occupation, storage):
	var house = houses[randi() % houses.size()]
	get_node('Citizens').add_child(citizen)
	citizen.initialize(house, occupation, storage, $Granary)
	return citizen