extends RichTextLabel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Population = get_node('/root/Root/Population')

# Called when the node enters the scene tree for the first time.
func _process(delta):
	self.text = 'Population (Avg):\n'
	self.text += '\tAppetite:\t %3d\n' % Population.hungryness
	self.text += '\tDiligence:\t %3d\n' % Population.diligence
	self.text += '\tProductivity: %3d\n' % Population.productivity
	self.text += '\tSpeed:\t\t %3d\n' % Population.speed
	self.text += '\tLives:\t\t %3d\n' % Population.lives