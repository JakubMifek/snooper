extends Node2D

enum Occupation {
	FARMER = 0,
	STONE_MINER = 1,
	LUMBERJACK = 2
}

# Signals 
signal death
signal spawned

# Hyperparameters
const MUTATION_PROBABILITY = 0.2
const MATING_PROBABILITY = 0.2

const MIN_OCCUPATION = 0
const MAX_OCCUPATION = 2
const OCCUPATION_DELTA = null

const MIN_BASE_MOVEMENT = 32
const MAX_BASE_MOVEMENT = 128
const MOVEMENT_DELTA = 12

const MIN_PRODUCTIVITY = 1
const MAX_PRODUCTIVITY = 10
const PRODUCTIVITY_DELTA = 1

const MIN_HUNGRYNESS = 1
const MAX_HUNGRYNESS = 10
const HUNGRYNESS_DELTA = 1

const MIN_DILIGENCE = 1
const MAX_DILIGENCE = 10
const DILIGENCE_DELTA = 1

var occupation # Type of my work (1-3)
var base_movement_speed # Speed of movement (32-128 with step of 12)
var productivity # Scale from 1 to 10 (how many items do i harvest?)
var hungryness # Probability of going for food (1-9 ... translates to probs 0.1-0.45 ... + diminish)
var diligence # Probability of going to work (1-9 ... translates to probs 0.1-0.45 ... + diminish)

# Other parameters
var Building = preload('Building.gd')
var NavigationMap
onready var death = preload('res://people/death.tscn')
onready var animation = get_node("AnimationPlayer")
var Population
var death_sounds

# Constants
const ACCELERATION_FACTOR = 6

# Locals
var goal = Building.Goal.TAKE
var dead = false
var path = []

var houseBuilding
var occupationBuilding
var warehouseBuilding
var foodBuilding
var resourceProduced

var _currentTargetBuilding
var _prevDirection

var delay = 0.5

var speed = 0
var lives = 0
var max_lives = 0

var hun = 0 # hungryness as prb
var dil = 0 # diligence as prb

func initialize(occupation, hungryness, diligence, movement, productivity, houseBuilding, occupationBuilding, warehouseBuilding, foodBuilding):
	var delta = 0
	
	if randf() < MUTATION_PROBABILITY:
		occupation = int(rand_range(MIN_OCCUPATION, MAX_OCCUPATION+1))
	self.occupation = occupation
	
	if randf() < MUTATION_PROBABILITY:
		delta = sign(randf()-0.2) * HUNGRYNESS_DELTA # with probability of 4/5 the delta will be bad
	self.hungryness = min(MAX_HUNGRYNESS, max(MIN_HUNGRYNESS, hungryness + delta))
	
	delta = 0
	if randf() < MUTATION_PROBABILITY:
		delta = sign(randf()-0.8) * DILIGENCE_DELTA # with probability of 4/5 the delta will be bad
	self.diligence = min(MAX_DILIGENCE, max(MIN_DILIGENCE, diligence + delta))
	
	delta = 0
	if randf() < MUTATION_PROBABILITY:
		delta = sign(randf()-0.8) * MOVEMENT_DELTA # with probability of 4/5 the delta will be bad
	self.base_movement_speed = min(MAX_BASE_MOVEMENT, max(MIN_BASE_MOVEMENT, movement + delta))
	
	delta = 0
	if randf() < MUTATION_PROBABILITY:
		delta = sign(randf()-0.8) * PRODUCTIVITY_DELTA # with probability of 4/5 the delta will be bad
	self.productivity = min(MAX_PRODUCTIVITY, max(MIN_PRODUCTIVITY, productivity + delta))
	
	self.houseBuilding = houseBuilding
	self.occupationBuilding = occupationBuilding
	self.warehouseBuilding = warehouseBuilding
	self.foodBuilding = foodBuilding
	self._currentTargetBuilding = houseBuilding
	
	self.position = houseBuilding.position + houseBuilding.get_node('Target').position
	self.max_lives = max(int(self.hungryness/2), 1)
	self.lives = self.max_lives
	
	self.hun = 0.1 * pow(2, (0.241103 * self.hungryness))
	self.dil = 0.1 * pow(2, (0.241103 * self.diligence))
	
	emit_signal('spawned')
	Population.add_to_population(self)

func cross_occupation(a, b):
	if a == b:
		return a if randf() < 0.9 else max(int(3*randf()), 2)
	
	var v = randf()
	return a if v < 0.4 else b if v < 0.8 else max(int(3*randf()), 2)

func linear_cross(a, b):
	var v = randf()
	# No check for min/max since it is a linear combination
	return int(v*a + (1-v)*b)

func cross(a, b):
	var occupation = self.cross_occupation(a.occupation, b.occupation)
	var movement = self.linear_cross(a.base_movement_speed, b.base_movement_speed)
	var hungryness = self.linear_cross(a.hungryness, b.hungryness)
	var diligence = self.linear_cross(a.diligence, b.diligence)
	var productivity = self.linear_cross(a.productivity, b.productivity)

	Population.spawn_citizen(occupation, movement, hungryness, diligence, productivity)

func mate():
	if randf() > self.MATING_PROBABILITY or len(Population.population) <= 1:
		return
	
	var friend = null
	while friend == null:
		var idx = int(rand_range(0, len(Population.population)))
		friend = Population.population[idx]
		if friend == self:
			friend = null
		
	var individual = self.cross(self, friend)
	
func _ready():
	NavigationMap = get_parent().get_parent().get_node('NavigationMap')
	Population = get_node('/root/Root/Population')

func _process(delta):
	if delay > 0:
		delay -= delta
		if delay <= 0:
			self.speed = 24
	else:
		_moveAccordingToDirection(delta)

func _choose_building(options, probabilities):
	var val = randf()
	var sum = 0
	var idx = 0
	while sum <= val and idx < len(probabilities):
		sum += probabilities[idx]
		idx += 1
		
	idx -= 1
	
	self._currentTargetBuilding = options[idx]
	if self._currentTargetBuilding == occupationBuilding:
		Stats.resources[resourceProduced].expectedAmount += productivity

func _onBuildingReached():
	self._currentTargetBuilding.interactWith(self, self.goal)
	
	var rnd = randf()
	var res = Stats.resources[resourceProduced]
	
	match self._currentTargetBuilding: 
		occupationBuilding:
			self._currentTargetBuilding = warehouseBuilding
			self.goal = Building.Goal.GIVE
		foodBuilding:
			if res.expectedAmount >= res.capacity:
				self._currentTargetBuilding = houseBuilding
			else:
				var S = 1 - self.hun
				self._choose_building([occupationBuilding, houseBuilding], [self.dil/S, (1-self.dil-self.hun)/S])
			self.goal = Building.Goal.TAKE
		houseBuilding:
			if res.expectedAmount >= res.capacity:
				self._currentTargetBuilding = foodBuilding
			else:
				var S = 1 - self.dil
				self._choose_building([foodBuilding, occupationBuilding], [self.hun/S, (1-self.dil-self.hun)/S])
			self.goal = Building.Goal.TAKE
		warehouseBuilding:
			var probs = [self.hun, 1-self.hun-self.dil, self.dil]
			var S = 0
			
			if res.expectedAmount >= res.capacity:
				for i in range(2):
					S += probs[i]
				self._choose_building([foodBuilding, houseBuilding, occupationBuilding], [probs[0]/S, probs[1]/S])
			else:
				for i in range(3):
					S += probs[i]
				self._choose_building([foodBuilding, houseBuilding, occupationBuilding], [probs[0]/S, probs[1]/S, probs[2]/S])
			self.goal = Building.Goal.TAKE
	
func _moveAccordingToDirection(delta):
	if self.speed < self.base_movement_speed:
		self.speed += ACCELERATION_FACTOR * delta
	
	if self.path and len(self.path) > 0:
		var target = path[0]
		var direction = (target-position).normalized()
		self._updateAnimation(direction)
		self._prevDirection = direction
		position += direction * self.speed * delta
		
		if position.distance_to(target) < 3.0:
			path.remove(0)
			if len(path) == 0:
				path = null
				self._onBuildingReached()
	else:
		self.path = NavigationMap.get_path(self.position, self._currentTargetBuilding.position + self._currentTargetBuilding.get_node('Target').position)
		
func _updateAnimation(normalizedDirection):
	var animationToPlay = self._getAnimationToPlay(normalizedDirection)
	if (animation.assigned_animation != animationToPlay):
    	animation.play(animationToPlay)
		
func _getAnimationToPlay(normalizedDirection):
	var radians = normalizedDirection.angle()
	
	if PI/4 >= radians and radians >= -PI/4:
		return "move_right"
	elif ((-PI/4) > radians) and (radians > ((-3.0/4)*PI)):
		return "move_up"
	elif (3.0/4)*PI > radians and radians > PI/4:
		return "move_down"
	else:
		return "move_left"
	
func _kill():
	if death_sounds != null and len(death_sounds):
		var sound = death_sounds[int(rand_range(0, len(death_sounds)))]
		sound.position = self.position
		if self.goal == Building.Goal.GIVE:
			Stats.resources[resourceProduced].expectedAmount -= self.productivity
		var d = death.instance()
		d.init(self.position)
		get_parent().add_child(d)
		self.dead=true
		d.play()
		get_parent().remove_child(self)
		sound.play()
		emit_signal("death")