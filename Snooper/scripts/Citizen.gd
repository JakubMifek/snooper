extends Node2D

enum DIRECTION {
	house, occupation, food
}

const MAX_HUNGRY_RATIO = 0.50
const MIN_HUNGRY_RATIO = 0.25
const SPEED = 3.0

var houseLocation = Vector2()
var occupationLocation = Vector2()
var foodLocation =  Vector2()

var _hungryRatio = randf() * (MAX_HUNGRY_RATIO - MIN_HUNGRY_RATIO) + MIN_HUNGRY_RATIO
var _currentDirection = DIRECTION.occupation

func _process(delta):
	_moveAccordingToDirection(delta)

func _changeDirection():
	var rnd = randf()
	if self._currentDirection == DIRECTION.occupation:
		self._currentDirection = DIRECTION.food if rnd < 0.5 else DIRECTION.house
	elif self._currentDirection == DIRECTION.food:
		self._currentDirection = DIRECTION.occupation if rnd < 0.5 else DIRECTION.house
	elif self._currentDirection == DIRECTION.house:
		self._currentDirection = DIRECTION.occupation if rnd < 0.5 else DIRECTION.food
	
func _moveAccordingToDirection(delta): 
	var goingToLocation = Vector2()
	if _currentDirection == DIRECTION.house:
		goingToLocation = self.houseLocation
	elif _currentDirection == DIRECTION.occupation:
		goingToLocation = self.occupationLocation
	elif _currentDirection == DIRECTION.food:
		goingToLocation = self.foodLocation
	
	var direction = goingToLocation - self.position
	if (direction.length() < 3.0):
		self._changeDirection()
	else:
		self._moveToDirection(direction, delta)
	
func _moveToDirection(direction, delta):
	var normalizedDirection = direction.normalized()
	var moveVector = normalizedDirection * SPEED

	self.position += moveVector