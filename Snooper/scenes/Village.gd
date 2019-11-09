extends Node2D


onready var farmer = preload("res://people/farmer.tscn")
onready var lumberjack = preload("res://people/lumberjack.tscn")
# onready var stoneMiner = preload("res://people/stone_miner.tscn")

var houses

func _ready():
	houses = get_tree().get_nodes_in_group("houses")

func spawnCitizen():
	var rnd = randf()
	if rnd < 0.55:
		self._spawnFarmer()
	else:
		self._spawnLumberjack()
	#else:
	#	self._spawnStoneMiner()
	
func _spawnFarmer():
	var newCitizen = farmer.instance()
	self._spawnCitizen(newCitizen, $Farm)
	
func _spawnLumberjack():
	var newCitizen = lumberjack.instance()
	self._spawnCitizen(newCitizen, $Lumbermill)
	
#func _spawnStoneMiner():
#	var newCitizen = stoneMiner.instance()
#	self._spawnCitizen(newCitizen, $Quarry)
	
func _spawnCitizen(citizen, occupation):
	var house = houses[randi() % houses.size()]
	citizen.position = house.position
	citizen.houseLocation = house.position
	citizen.occupationLocation = occupation.position
	
	get_tree().get_root().add_child(citizen)