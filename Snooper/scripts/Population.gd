extends Node2D

export var spawnLocation = Vector2()

var currentPopulation = 0
var population = []
onready var label = get_node("Canvas/PopulationCounter")
onready var village = get_node('../Village')
onready var miss = preload('res://people/miss.tscn')

var hungryness = 0
var diligence = 0
var productivity = 0
var speed = 0
var lives = 0

func _ready():
	_setText()

#func _process(delta):
#	pass
		
func _on_citizen_death():
	for i in range(len(population)-1, -1, -1):
		if population[i] == null or population[i].dead:
			if population[i]:
				var N = len(self.population)
				self.hungryness = ((self.hungryness * N) - population[i].hungryness)/max(1, N-1)
				self.diligence = ((self.diligence * N) - population[i].diligence)/max(1, N-1)
				self.productivity = ((self.productivity * N) - population[i].productivity)/max(1, N-1)
				self.speed = ((self.speed * N) - population[i].base_movement_speed)/max(1, N-1)
				self.lives = ((self.lives * N) - population[i].lives)/max(1, N-1)
				
			population.remove(i)
			i += 1
			
	_setText()

func findPeople(position):
	var idx = -1
	var ret = []
	
	for person in population:
		var sprite = person.get_node('Sprite')
		var size = sprite.texture.get_size()
		var width = size[0] / sprite.hframes
		var height = size[1] / sprite.vframes
		idx += 1
		
		if \
		  person.position[0] - width/2.0 < position[0] and position[0] < person.position[0] + width/2.0 and \
		  person.position[1] - height/2.0 < position[1] and position[1] < person.position[1] + height/2.0:
			ret.append(idx)
			
	return ret

func _killCitizens(position):
	var peopleToKill = findPeople(position)
	
	if len(peopleToKill) == 0:
		var d = miss.instance()
		d.init(position)
		add_child(d)
		d.play()
		return
	
	while len(peopleToKill):
		var idx = peopleToKill.pop_back()
		var personToKill = population[idx]
		personToKill._kill()

func add_to_population(citizen):
	var N = len(self.population)
	self.hungryness = ((self.hungryness * N) + citizen.hungryness)/max(1, N+1)
	self.diligence = ((self.diligence * N) + citizen.diligence)/max(1, N+1)
	self.productivity = ((self.productivity * N) + citizen.productivity)/max(1, N+1)
	self.speed = ((self.speed * N) + citizen.base_movement_speed)/max(1, N+1)
	self.lives = ((self.lives * N) + citizen.lives)/max(1, N+1)
	
	currentPopulation += 1
	citizen.connect('death', self, '_on_citizen_death')
	population.append(citizen)
	_setText()

func spawn_citizen(occupation, movement, hungryness, diligence, productivity):
	village.spawnCitizen(occupation, hungryness, diligence, movement, productivity)

func _spawnCitizen(occupation=null):
	var citizen = village.spawnCitizen(occupation)

func _setText():
	label.text = ""
	label.push_color(Color(1.0, 0.0, 0.0, 1.0))
	label.add_text("Population: " + str(currentPopulation))
	label.pop()