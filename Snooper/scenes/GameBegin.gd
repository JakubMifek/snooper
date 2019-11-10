extends Node2D

func _ready():
	for i in range(10):
		get_parent().get_node("Population")._spawnCitizen()
		
	Stats.resources[Stats.RESOURCES.wheat] = 20