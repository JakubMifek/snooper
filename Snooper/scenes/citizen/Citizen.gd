extends Sprite

enum DIRECTION {
	left, right, top, bottom
}

var _currentDirection = DIRECTION.left
var _timeSinceDirectionChange = 1.0

const speed = 55.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	_timeSinceDirectionChange += delta
	if _timeSinceDirectionChange >= 1.0:
		_timeSinceDirectionChange = 0.0
		_changeDirection()
		
	_moveAccordingToDirection(delta)

func _changeDirection():
	var rnd = randi() % 4
	print(rnd)
	if rnd == 0:
		_currentDirection = DIRECTION.left
	elif rnd == 1:
		self._currentDirection = DIRECTION.right
	elif rnd == 2:
		self._currentDirection = DIRECTION.bottom
	elif rnd == 3:
		self._currentDirection = DIRECTION.top
	
func _moveAccordingToDirection(delta): 
	var moveVector = Vector2()
	if _currentDirection == DIRECTION.left:
		moveVector = Vector2(-1.0, 0.0)
	elif self._currentDirection == DIRECTION.right:
		moveVector = Vector2(1.0, 0.0)
	elif self._currentDirection == DIRECTION.top:
		moveVector = Vector2(0.0, -1.0)
	elif self._currentDirection == DIRECTION.bottom:
		moveVector = Vector2(0.0, 1.0)
		
	moveVector *= delta * speed
	self.position += moveVector