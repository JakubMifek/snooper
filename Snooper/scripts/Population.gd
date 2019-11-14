extends Node2D

export var spawnLocation = Vector2()

var population = []
onready var label = get_node("Canvas/PopulationCounter")
onready var village = get_node('../Village')
onready var miss = preload('res://people/miss.tscn')

var hungryness = 0
var diligence = 0
var productivity = 0
var speed = 0
var lives = 0

var min_hungryness = 0
var min_diligence = 0
var min_productivity = 0
var min_speed = 0
var min_lives = 0

var max_hungryness = 0
var max_diligence = 0
var max_productivity = 0
var max_speed = 0
var max_lives = 0

func _ready():
	_setText()

#func _process(delta):
#	pass
		
func compute_average(pop):
	self.hungryness = 0
	self.diligence = 0
	self.productivity = 0
	self.speed = 0
	self.lives = 0
	
	self.max_hungryness = 0
	self.max_diligence = 0
	self.max_productivity = 0
	self.max_speed = 0
	self.max_lives = 0
	
	self.min_hungryness = INF
	self.min_diligence = INF
	self.min_productivity = INF
	self.min_speed = INF
	self.min_lives = INF
	
	for person in pop:
		if self.min_hungryness > person.hungryness:
			self.min_hungryness = person.hungryness
		if self.max_hungryness < person.hungryness:
			self.max_hungryness = person.hungryness
		self.hungryness += person.hungryness
		
		if self.min_diligence > person.diligence:
			self.min_diligence = person.diligence
		if self.max_diligence < person.diligence:
			self.max_diligence = person.diligence
		self.diligence += person.diligence
		
		if self.min_productivity > person.productivity:
			self.min_productivity = person.productivity
		if self.max_productivity < person.productivity:
			self.max_productivity = person.productivity
		self.productivity += person.productivity
		
		if self.min_speed > person.base_movement_speed:
			self.min_speed = person.base_movement_speed
		if self.max_speed < person.base_movement_speed:
			self.max_speed = person.base_movement_speed
		self.speed += person.base_movement_speed
		
		if self.min_lives > person.lives:
			self.min_lives = person.lives
		if self.max_lives < person.lives:
			self.max_lives = person.lives
		self.lives += person.lives
	
	var N = len(pop)
	if N == 0:
		return
		
	self.hungryness /= N
	self.diligence /= N
	self.productivity /= N
	self.speed /= N
	self.lives /= N
	
func _on_citizen_death():
	Stats.add_resource(Stats.RESOURCES.population, -1)
	for i in range(len(population)-1, -1, -1):
		if population[i] == null or population[i].dead:
			population.remove(i)
			i += 1
			
	compute_average(population)
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
	Stats.add_resource(Stats.RESOURCES.population, 1)
	citizen.connect('death', self, '_on_citizen_death')
	population.append(citizen)
	compute_average(population)
	_setText()

func spawn_citizen(occupation, movement, hungryness, diligence, productivity):
	village.spawnCitizen(occupation, hungryness, diligence, movement, productivity)

func _spawnCitizen(occupation=null):
	var citizen = village.spawnCitizen(occupation)

func _setText():
	var currentPopulation = Stats.get_resource(Stats.RESOURCES.population).amount
	label.text = ""
	label.push_color(Color(1.0, 0.0, 0.0, 1.0))
	label.add_text("Population: " + str(currentPopulation))
	label.pop()