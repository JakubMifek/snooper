extends RichTextLabel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

func _process(delta):
	var resourcesText = ""
	var wheatResource = Stats.resources[Stats.RESOURCES.wheat]
	var woodResource = Stats.resources[Stats.RESOURCES.wood]
	var stoneResource = Stats.resources[Stats.RESOURCES.stone]
	
	if wheatResource != null: 
		resourcesText += "Wheat: %3d (%3d)\n" % [wheatResource.amount, wheatResource.capacity]
		
	if woodResource != null:
		resourcesText += "Wood:  %3d (%3d)\n" % [woodResource.amount, woodResource.capacity]
		
	if stoneResource != null:
		resourcesText += "Stone: %3d (%3d)" % [stoneResource.amount, stoneResource.capacity]

	self.text = resourcesText