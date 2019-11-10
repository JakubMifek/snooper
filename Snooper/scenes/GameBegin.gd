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
	randomize()
	
	for i in range(4):
		get_parent().get_node("Population").spawn_citizen(0, 64, 1, 1, 1)	 # farmer
	for i in range(2):
		get_parent().get_node("Population").spawn_citizen(1, 64, 1, 1, 1)	 # lumberjack
		get_parent().get_node("Population").spawn_citizen(2, 64, 1, 1, 1)	 # stone-miner
		
	wheat = Stats.resources[Stats.RESOURCES.wheat]
	stone = Stats.resources[Stats.RESOURCES.stone]
	wood = Stats.resources[Stats.RESOURCES.wood]
	
	wheat.capacity = 32
	stone.capacity = 16
	wood.capacity = 16
	
	stone.target = 12
	wood.target = 12
	
	stone.connect('target_reached', self, '_check_if_all_reached')
	wood.connect('target_reached', self, '_check_if_all_reached')
	
	wheat.set_amount(0)
	stone.set_amount(0)
	wood.set_amount(0)
	
	wheat._upgrades = [{'target': INF, 'capacity': 64}, {'target': INF, 'capacity': 128}]
	stone._upgrades = [{'target': 60, 'capacity': 72}, {'target': 240, 'capacity': 300}]
	wood._upgrades = [{'target': 96, 'capacity': 120}, {'target': 180, 'capacity': 216}]
	