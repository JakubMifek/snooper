extends Node2D

onready var animation = get_node("AnimationPlayer")

enum DIRECTION {
	house, occupation, food
}

const MAX_HUNGRY_RATIO = 0.50
const MIN_HUNGRY_RATIO = 0.25
const SPEED = 2.0

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
	self._updateAnimation(normalizedDirection)
	self.position += moveVector
	
func _updateAnimation(normalizedDirection):
	var animationToPlay = self._getAnimationToPlay(normalizedDirection)
	print(animation.assigned_animation + " : " + animationToPlay)
	if (animation.assigned_animation != animationToPlay):
    	animation.play(animationToPlay)
		
func _getAnimationToPlay(normalizedDirection):
	var radians = normalizedDirection.angle()
	print(radians)
	print((3.0/4)*PI)
	
	if PI/4 >= radians and radians >= -PI/4:
		return "move_right"
	elif ((-PI/4) > radians) and (radians > ((-3.0/4)*PI)):
		return "move_up"
	elif (3.0/4)*PI > radians and radians > PI/4:
		return "move_down"
	else:
		return "move_left"
	