extends RichTextLabel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

func _process(delta):
	var resourcesText = "Current Goal:\n"
	var wheatResource = Stats.resources[Stats.RESOURCES.wheat]
	var woodResource = Stats.resources[Stats.RESOURCES.wood]
	var stoneResource = Stats.resources[Stats.RESOURCES.stone]
	
	if woodResource != null:
		resourcesText += "\tWood: \t%3d\n" % [woodResource.target]
		
	if stoneResource != null:
		resourcesText += "\tStone:\t%3d" % [stoneResource.target]

	self.text = resourcesText