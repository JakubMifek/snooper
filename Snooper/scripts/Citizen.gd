extends Node2D

onready var animation = get_node("AnimationPlayer")

const MAX_HUNGRY_RATIO = 0.50
const MIN_HUNGRY_RATIO = 0.25
const SPEED = 2.0

# TODO: this can be private most probably
var death_sounds

var houseBuilding
var occupationBuilding
var warehouseBuilding
var foodBuilding

var _hungryRatio = randf() * (MAX_HUNGRY_RATIO - MIN_HUNGRY_RATIO) + MIN_HUNGRY_RATIO
var _currentTargetBuilding
var _previousTargetLocation

func initialize(houseBuilding, occupationBuilding, warehouseBuilding, foodBuilding):
	self.houseBuilding = houseBuilding
	self.occupationBuilding = occupationBuilding
	self.warehouseBuilding = warehouseBuilding
	self.foodBuilding = foodBuilding
	self._currentTargetBuilding = houseBuilding
	self.position = houseBuilding.position

func _process(delta):
	_moveAccordingToDirection(delta)

func _onBuildingReached():
	self._currentTargetBuilding.interactWith(self)
	
	var rnd = randf()
	if self._currentTargetBuilding == occupationBuilding:
		self._currentTargetBuilding = warehouseBuilding
	elif self._currentTargetBuilding == foodBuilding:
		self._currentTargetBuilding = occupationBuilding if rnd < 0.5 else houseBuilding
	elif self._currentTargetBuilding == houseBuilding:
		self._currentTargetBuilding = foodBuilding if rnd < self._hungryRatio else occupationBuilding
	elif self._currentTargetBuilding == warehouseBuilding:
		self._currentTargetBuilding = foodBuilding if rnd < self._hungryRatio else houseBuilding if rnd < (1.0 - self._hungryRatio) / 2 + self._hungryRatio else occupationBuilding
	
func _moveAccordingToDirection(delta): 
	var goingToLocation = self._currentTargetBuilding.position
		
	var updateAnimation = self._previousTargetLocation != goingToLocation
	self._previousTargetLocation = goingToLocation
	
	var direction = goingToLocation - self.position
	if (direction.length() < 3.0):
		self._onBuildingReached()
	else:
		self._moveToDirection(direction, delta, updateAnimation)
	
func _moveToDirection(direction, delta, updateAnimation):
	var normalizedDirection = direction.normalized()
	var moveVector = normalizedDirection * SPEED
	if updateAnimation:
		self._updateAnimation(normalizedDirection)
	self.position += moveVector
	
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