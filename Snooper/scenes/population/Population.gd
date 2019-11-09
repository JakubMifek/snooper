extends Node2D

onready var citizen = preload("res://scenes/citizen/Citizen.tscn")

export var spawnLocation = Vector2()

var timeSinceLastSpawn = 4.5
var increatePopulationEveryXSeconds = 5
var currentPopulation = 0

func _ready():
	_setText()

func _process(delta):
	timeSinceLastSpawn += delta
	if timeSinceLastSpawn >= increatePopulationEveryXSeconds:
		_spawnCitizen()
		timeSinceLastSpawn = timeSinceLastSpawn - increatePopulationEveryXSeconds
		
func _spawnCitizen():
	var newCitizen = citizen.instance()
	newCitizen.position = spawnLocation
	get_tree().get_root().add_child(newCitizen)
	currentPopulation += 1
	_setText()

func _setText():
	var label = get_node("Canvas/PopulationCounter")
	label.text = ""
	label.push_color(Color(1.0, 0.0, 0.0, 1.0))
	label.add_text("Population: " + str(currentPopulation))
	label.pop()