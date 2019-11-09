extends Node2D

export var spawnLocation = Vector2()
export var village: NodePath

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
	pass
	# get_node(village).spawnCitizen()
	# currentPopulation += 1
	# _setText()

func _setText():
	var label = get_node("Canvas/PopulationCounter")
	label.text = ""
	label.push_color(Color(1.0, 0.0, 0.0, 1.0))
	label.add_text("Population: " + str(currentPopulation))
	label.pop()