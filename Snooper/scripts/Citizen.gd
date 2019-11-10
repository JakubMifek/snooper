extends Node2D

var Building = preload('Building.gd')
var NavigationMap

onready var animation = get_node("AnimationPlayer")

const MAX_HUNGRY_RATIO = 0.50
const MIN_HUNGRY_RATIO = 0.25
const SPEED = 64.0
const ACCELERATION = 3.2

var current_speed = SPEED
var born_speed = SPEED

var hungry = 0 # 0-10
var fatness = 5 # 0-10

var goal = Building.Goal.GIVE
var path = []

# TODO: this can be private most probably
var death_sounds

var houseBuilding
var occupationBuilding
var warehouseBuilding
var foodBuilding

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

func _ready():
	NavigationMap = get_parent().get_parent().get_node('NavigationMap')

func _process(delta):
	_moveAccordingToDirection(delta)

func _onBuildingReached():
	self._currentTargetBuilding.interactWith(self, self.goal)
	self.current_speed = min(born_speed, SPEED)
	
	var rnd = randf()
	match self._currentTargetBuilding: 
		occupationBuilding:
			self._currentTargetBuilding = warehouseBuilding
			self.goal = Building.Goal.GIVE
		foodBuilding:
			self._currentTargetBuilding = occupationBuilding if rnd < 0.5 else houseBuilding
		houseBuilding:
			self._currentTargetBuilding = foodBuilding if rnd < self._hungryRatio else occupationBuilding
			if self._currentTargetBuilding == foodBuilding:
				self.goal = Building.Goal.TAKE
		warehouseBuilding:
			self._currentTargetBuilding = foodBuilding if rnd < self._hungryRatio else houseBuilding if rnd < (1.0 - self._hungryRatio) / 2 + self._hungryRatio else occupationBuilding
			if self._currentTargetBuilding == foodBuilding:
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
		sound.play()