extends Node2D

export var spawnLocation = Vector2()

var currentPopulation = 0
var population = []
onready var label = get_node("Canvas/PopulationCounter")
onready var village = get_node('../Village')
onready var miss = preload('res://people/miss.tscn')

func _ready():
	_setText()

#func _process(delta):
#	pass
		
func _on_citizen_death():
	currentPopulation -= 1
	
	for i in range(len(population)-1, -1, -1):
		if population[i] == null or population[i].dead:
			population.remove(i)
			i += 1
			
	_setText()

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
	
	if len(peopleToKill) == 0:
		var d = miss.instance()
		d.init(position)
		add_child(d)
		d.play()
		return
	
	while len(peopleToKill):
		idx = peopleToKill.pop_back()
		var personToKill = population[idx]
		personToKill._kill()

func add_to_population(citizen):
	citizen.connect('death', self, '_on_citizen_death')
	population.append(citizen)
	currentPopulation += 1
	_setText()

func spawn_citizen(occupation, movement, hungryness, diligence, productivity):
	village.spawnCitizen(occupation, movement, hungryness, diligence, productivity)

func _spawnCitizen(occupation=null):
	var citizen = village.spawnCitizen(occupation)

func _setText():
	label.text = ""
	label.push_color(Color(1.0, 0.0, 0.0, 1.0))
	label.add_text("Population: " + str(currentPopulation))
	label.pop()