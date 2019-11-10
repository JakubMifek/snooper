extends Node2D

var resource = preload("res://scripts/autoload/Resource.gd")

enum RESOURCES {
	population = 0,
	wheat = 1,
	stone = 2,
	wood = 3,
	farmers = 4,
	stone_miners = 5,
	lumberjacks = 6
}

var _resources = {
	RESOURCES.population: resource.new("population", 0, INF),
	RESOURCES.wheat: resource.new("wheat", 20, INF),
	RESOURCES.stone: resource.new("stone", 0, INF),
	RESOURCES.wood: resource.new("wood", 0, INF),
	RESOURCES.farmers: resource.new("farmers", 0, INF),
	RESOURCES.stone_miners: resource.new("stone_miners", 0, INF),
	RESOURCES.lumberjacks: resource.new("lumberjacks", 0, INF)
}

var resources = []

func _init():
	self.resources = [
		 _resources[RESOURCES.population],
		 _resources[RESOURCES.wheat],
		 _resources[RESOURCES.stone],
		 _resources[RESOURCES.wood],
		 _resources[RESOURCES.farmers],
		 _resources[RESOURCES.stone_miners],
		 _resources[RESOURCES.lumberjacks]
	]
	
func add_resource(resourceType, value):
	var resource = self.resources[resourceType]
	resource.amount += value
	if resource.amount > resource.capacity:
		resource.amount = resource.capacity
	elif resource.amount < 0:
		# TODO: Go to menu! Game over!
		resource.amount = 0
		
func get_resource(resourceType):
	return self.resources[resourceType]
