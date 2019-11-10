extends Node2D

var wheat
var stone
var wood

func _show_upgrade():
	pass

func _check_if_all_reached():
	if stone.amount >= stone.target and wood.amount >= wood.target:
		self._show_upgrade()

func _ready():
	for i in range(40):
		get_parent().get_node("Population")._spawnCitizen()
		
	wheat = Stats.resources[Stats.RESOURCES.wheat]
	stone = Stats.resources[Stats.RESOURCES.stone]
	wood = Stats.resources[Stats.RESOURCES.wood]
	
	wheat.capacity = 10
	stone.capacity = 5
	wood.capacity = 5
	
	wheat.amount = 10
	stone.amount = 0
	wood.amount = 0
	
	stone.target = 4
	wood.target = 4
	
	stone.connect('target_reached', self, '_check_if_all_reached')