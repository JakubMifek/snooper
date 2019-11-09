extends RichTextLabel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.rect_position = Vector2(OS.window_size[0]-self.rect_size[0], 0)

func _process(delta):
	var resourcesText = ""
	var wheatResource = Stats.get_resource(Stats.RESOURCES.wheat)
	var woodResource = Stats.get_resource(Stats.RESOURCES.wood)
	var stoneResource = Stats.get_resource(Stats.RESOURCES.stone)
	
	if wheatResource != null: 
		resourcesText += "Wheat: " + str(wheatResource.amount) + "\n"
		
	if woodResource != null:
		resourcesText += "Wood: " + str(woodResource.amount) + "\n"
		
	if stoneResource != null:
		resourcesText += "Stone: " + str(stoneResource.amount) + "\n"

	self.text = resourcesText