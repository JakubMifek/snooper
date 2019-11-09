extends Node2D


onready var farmer = preload("res://people/farmer.tscn")
onready var lumberjack = preload("res://people/lumberjack.tscn")
onready var stoneMiner = preload("res://people/stone_miner.tscn")

var houses

func _ready():
	houses = get_tree().get_nodes_in_group("houses")

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
	return self._spawnCitizen(newCitizen, $Farm)
	
func _spawnLumberjack():
	var newCitizen = lumberjack.instance()
	return self._spawnCitizen(newCitizen, $Lumbermill)
	
func _spawnStoneMiner():
	var newCitizen = stoneMiner.instance()
	return self._spawnCitizen(newCitizen, $Quarry)
	
func _spawnCitizen(citizen, occupation):
	var house = houses[randi() % houses.size()]
	citizen.initialize(house, occupation, $Storage, $Granary)
	get_node('Citizens').add_child(citizen)
	return citizen