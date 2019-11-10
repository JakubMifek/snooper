extends RichTextLabel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Population = get_node('/root/Root/Population')
onready var Cam = get_node('/root/Root/Camera/Camera2D')

# Called when the node enters the scene tree for the first time.
func _input(event):
	if event is InputEventMouseMotion:
		var found = Population.findPeople(Cam.position)
		if len(found) == 0:
			self.text = ''
			return
			
		var idx = found.pop_back()
		var person = Population.population[idx]
		
		self.text = 'Individual:\n'
		self.text += '\tOccupation:\n\t%s\n\n' % ('Farmer' if person.occupation == 0 else 'Lumberjack' if person.occupation == 2 else 'Stone Miner')
		self.text += '\tAppetite:\t  %3d\n' % person.hungryness
		self.text += '\tDiligence:\t %3d\n' % person.diligence
		self.text += '\tProductivity: %3d\n' % person.productivity
		self.text += '\tSpeed:\t\t %3d\n' % person.base_movement_speed
		self.text += '\tLives:\t\t %3d\n' % person.lives