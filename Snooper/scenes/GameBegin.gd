extends Node2D

var wheat
var stone
var wood
onready var UpgradeButton = get_node('/root/Root/UI/CanvasLayer2/UpgradeButton')

func _show_upgrade():
	UpgradeButton.visible = true

func _check_if_all_reached():
	if Stats.can_upgrade():
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
	
	stone.target = 0
	wood.target = 0
	
	stone.connect('target_reached', self, '_check_if_all_reached')
	wood.connect('target_reached', self, '_check_if_all_reached')
	
	wheat.set_amount(10)
	stone.set_amount(0)
	wood.set_amount(0)
	
	stone._upgrades = [{'target': 16, 'capacity': 20}, {'target': 64, 'capacity': 70}]
	wood._upgrades = [{'target': 12, 'capacity': 15}, {'target': 72, 'capacity': 80}]
	