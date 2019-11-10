extends Node2D

signal target_reached

func _ready():
	pass

var type = null
var amount = null
var expectedAmount = null
var capacity = null
var target = null
var _upgrades = []
var _upgrade_index = 0

func _init(type, amount, capacity, target):
	self.type = type
	self.amount = amount
	self.expectedAmount = amount
	self.capacity = capacity
	self.target = target
	
func set_amount(value):
	self.amount = value
	if self.amount >= self.target:
		 emit_signal("target_reached")
		
func upgrade():
	if self._upgrade_index < len(self._upgrades):
		self.target = self._upgrades[self._upgrade_index]['target']
		self.capacity = self._upgrades[self._upgrade_index]['capacity']
		self._upgrade_index += 1