extends Node2D

enum DIRECTION {
	house, occupation
}

const speed = 3.0

var houseLocation = Vector2()
var occupationLocation = Vector2()

var _currentDirection = DIRECTION.occupation

func _process(delta):
	_moveAccordingToDirection(delta)

func _changeDirection():
	self._currentDirection = DIRECTION.occupation if _currentDirection == DIRECTION.house else DIRECTION.house
	
func _moveAccordingToDirection(delta): 
	var goingToLocation = houseLocation if _currentDirection == DIRECTION.house else occupationLocation
	var direction = goingToLocation - self.position
	if (direction.length() < 3.0):
		self._changeDirection()
	else:
		self._moveToDirection(direction, delta)
	
func _moveToDirection(direction, delta):
	var normalizedDirection = direction.normalized()
	var moveVector = normalizedDirection * speed

	self.position += moveVector