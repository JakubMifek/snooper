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
	RESOURCES.population: resource.new("population", 0, INF, INF),
	RESOURCES.wheat: resource.new("wheat", 0, INF, INF),
	RESOURCES.stone: resource.new("stone", 0, INF, INF),
	RESOURCES.wood: resource.new("wood", 0, INF, INF),
	RESOURCES.farmers: resource.new("farmers", 0, INF, INF),
	RESOURCES.stone_miners: resource.new("stone_miners", 0, INF, INF),
	RESOURCES.lumberjacks: resource.new("lumberjacks", 0, INF, INF)
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
	var un = get_node("/root/Root/UI")
	un.showDeath()
		
	var resource = self.resources[resourceType]
	resource.amount += value
	if resource.amount > resource.capacity:
		resource.set_amount(resource.capacity)
	elif resource.amount < 0:
		resource.set_amount(0)
		
	if resourceType == RESOURCES.population and resource.amount <= 1:
		var uiNode = get_node("/root/Root/UI")
		uiNode.showDeath()
		
func get_resource(resourceType):
	return self.resources[resourceType]

func can_upgrade():
	return \
		self.resources[RESOURCES.wood].amount >= self.resources[RESOURCES.wood].target and \
		self.resources[RESOURCES.stone].amount >= self.resources[RESOURCES.stone].target

func upgrade():
	for resource in self.resources:
		resource.upgrade()