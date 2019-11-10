extends Node2D

export var spawnLocation = Vector2()

var village
var timeSinceLastSpawn = 4.5
var increatePopulationEveryXSeconds = 5
var currentPopulation = 0
var population = []
onready var label = get_node("Canvas/PopulationCounter")

func _ready():
	village = get_node("../Village")
	_setText()

func _process(delta):
	timeSinceLastSpawn += delta
	if timeSinceLastSpawn >= increatePopulationEveryXSeconds:
		_spawnCitizen()
		timeSinceLastSpawn = timeSinceLastSpawn - increatePopulationEveryXSeconds
		
func _killCitizens(position):
	var peopleToKill = []
	var idx = -1
	
	for person in population:
		var sprite = person.get_node('Sprite')
		var size = sprite.texture.get_size()
		var width = size[0] / sprite.hframes
		var height = size[1] / sprite.vframes
		idx += 1
		
		if \
		  person.position[0] - width/2.0 < position[0] and position[0] < person.position[0] + width/2.0 and \
		  person.position[1] - height/2.0 < position[1] and position[1] < person.position[1] + height/2.0:
			peopleToKill.append(idx)
	
	while len(peopleToKill):
		idx = peopleToKill.pop_back()
		var personToKill = population[idx]
		personToKill._kill()
		population.remove(idx)
		currentPopulation -= 1
		
	_setText()

func _spawnCitizen():
	population.append(village.spawnCitizen())
	currentPopulation += 1
	_setText()

func _setText():
	label.text = ""
	label.push_color(Color(1.0, 0.0, 0.0, 1.0))
	label.add_text("Population: " + str(currentPopulation))
	label.pop()