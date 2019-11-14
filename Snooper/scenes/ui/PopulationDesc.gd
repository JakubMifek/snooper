extends RichTextLabel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Population = get_node('/root/Root/Population')

# Called when the node enters the scene tree for the first time.
func _process(delta):
	self.text = 'Population (avg):\n'
	self.text += '\tAppetite:\t  %3d - %3d\t(%3d)\n' % [Population.min_hungryness, Population.max_hungryness, Population.hungryness]
	self.text += '\tDiligence:\t  %3d - %3d\t(%3d)\n' % [Population.min_diligence, Population.max_diligence, Population.diligence]
	self.text += '\tProductivity: %3d - %3d\t(%3d)\n' % [Population.min_productivity, Population.max_productivity, Population.productivity]
	self.text += '\tSpeed:\t\t %3d - %3d\t(%3d)\n' % [Population.min_speed, Population.max_speed, Population.speed]
	self.text += '\tLives:\t\t %3d - %3d\t(%3d)\n' % [Population.min_lives, Population.max_lives, Population.lives]