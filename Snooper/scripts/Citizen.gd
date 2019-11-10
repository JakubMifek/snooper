extends Node2D

var Building = preload('Building.gd')
var NavigationMap

onready var death = preload('res://people/death.tscn')
onready var animation = get_node("AnimationPlayer")
var Population

const MAX_HUNGRY_RATIO = 0.50
const MIN_HUNGRY_RATIO = 0.25
const SPEED = 64.0
const ACCELERATION = 3.2
const MAX_LIVES = 3

signal death
signal spawned

var current_speed = SPEED
var born_speed = SPEED

var hungry = 0 # 0-10
var fatness = 5 # 0-10

var productivity = 1 # How much do i produce?
var eatability = 1 # How much do i eat?
var max_lives = int(rand_range(1, MAX_LIVES)) # How many lives can I have
var lives = max_lives # How many lives do I have

var goal = Building.Goal.TAKE
var dead
var path = []

# TODO: this can be private most probably
var death_sounds

var houseBuilding
var occupationBuilding
var warehouseBuilding
var foodBuilding
var resourceProduced

var _hungryRatio = randf() * (MAX_HUNGRY_RATIO - MIN_HUNGRY_RATIO) + MIN_HUNGRY_RATIO
var _currentTargetBuilding
var _prevDirection

func initialize(houseBuilding, occupationBuilding, warehouseBuilding, foodBuilding):
	self.born_speed = SPEED + randf()*SPEED - SPEED/2.0
	self.houseBuilding = houseBuilding
	self.occupationBuilding = occupationBuilding
	self.warehouseBuilding = warehouseBuilding
	self.foodBuilding = foodBuilding
	self._currentTargetBuilding = houseBuilding
	self.position = houseBuilding.position + houseBuilding.get_node('Target').position
	emit_signal('spawned')
	Population.add_to_population(self)

func _ready():
	self.dead = false
	NavigationMap = get_parent().get_parent().get_node('NavigationMap')
	Population = get_node('/root/Root/Population')
	
func _process(delta):
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
	self.current_speed = min(born_speed, SPEED)
	
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
				self._choose_building([occupationBuilding, houseBuilding], [0.5, 0.5])
			self.goal = Building.Goal.TAKE
		houseBuilding:
			if res.expectedAmount >= res.capacity:
				self._currentTargetBuilding = foodBuilding
			else:
				self._choose_building([foodBuilding, occupationBuilding], [self._hungryRatio, 1 - self._hungryRatio])
			self.goal = Building.Goal.TAKE
		warehouseBuilding:
			var probs = [self._hungryRatio, ((1.0 - self._hungryRatio)*(1.0 - self._hungryRatio)) / 2 + self._hungryRatio, 1-((1.0 - self._hungryRatio)*(1.0 - self._hungryRatio)) / 2 + self._hungryRatio]
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
	if self.path and len(self.path) > 0:
		var target = path[0]
		var direction = (target-position).normalized()
		self._updateAnimation(direction)
		self._prevDirection = direction
		position += direction * self.current_speed * delta
		
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